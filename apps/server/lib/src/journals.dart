import 'school.dart';
import 'store.dart';

class Journals {
  final Store s;
  final School school;
  Journals(this.s, this.school);
  bool reviewer(Map u) => s.admin(u) || u['department'] == 'coordenacao';
  bool editor(Map u, Map journal) =>
      reviewer(u) ||
      (u['role'] == 'professor' &&
          (journal['teachers'] as List).any((t) => t['teacher'] == u['id']));
  String teacherNames(Iterable teachers) {
    final names = teachers.map((t) => t['name'] as String).toSet();
    return names.isEmpty ? 'Não atribuído' : names.join(', ');
  }

  Future<Map<String, dynamic>> journal(Map u, String id) async {
    final j = await s.one('journals', id);
    j['teachers'] = await s.db.rows(
      'SELECT t.*,u.name FROM journal_teachers t JOIN users u ON u.id=t.teacher WHERE t.journal=? ORDER BY t.valid_from,u.name',
      [id],
    );
    if (!await school.canReadClass(
      u,
      await s.one('class_groups', j['class_group']),
    ))
      throw ApiError(403, 'Diário sem permissão.');
    if (u['role'] == 'professor' && !editor(u, j))
      throw ApiError(403, 'Este diário está atribuído a outro docente.');
    return j;
  }

  Future<List<Map<String, dynamic>>> list(Map u, String group) async {
    if (!await school.canReadClass(u, await s.one('class_groups', group)))
      throw ApiError(403, 'Turma sem permissão.');
    final rows = await s.db.rows(
      "SELECT j.*,c.phase,c.hours,c.lesson_minutes FROM journals j JOIN course_components c ON c.id=j.component WHERE j.class_group=? ORDER BY c.phase,j.subject COLLATE NOCASE",
      [group],
    );
    final assignments = await s.db.rows(
      'SELECT t.*,u.name FROM journal_teachers t JOIN users u ON u.id=t.teacher JOIN journals j ON j.id=t.journal WHERE j.class_group=?',
      [group],
    );
    final byJournal = <String, List<Map<String, dynamic>>>{};
    for (final assignment in assignments) {
      byJournal.putIfAbsent(assignment['journal'], () => []).add(assignment);
    }
    final visible = <Map<String, dynamic>>[];
    for (final j in rows) {
      final teachers = byJournal[j['id']] ?? [];
      if (u['role'] == 'professor' &&
          !teachers.any((t) => t['teacher'] == u['id'])) {
        continue;
      }
      visible.add({
        ...j,
        'teachers': teachers,
        'teacher_name': teacherNames(teachers),
      });
    }
    return visible;
  }

  Future<List<Map<String, dynamic>>> roster(Map j) => s.db.rows(
    "SELECT e.id,e.student,p.name AS student_name,p.registration FROM enrollments e JOIN students p ON p.id=e.student WHERE e.class_group=? AND e.state='Ativa' ORDER BY p.name COLLATE NOCASE",
    [j['class_group']],
  );
  Future<Map<String, dynamic>> detail(Map u, String id) async {
    final j = await journal(u, id);
    final staff = editor(u, j) || s.manageStudents(u);
    final linked = await s.linkedStudents(u);
    final lessons = await s.db.rows(
      'SELECT * FROM lessons WHERE journal=? ORDER BY date DESC,created DESC',
      [id],
    );
    final visible = <Map<String, dynamic>>[];
    for (final lesson in lessons) {
      if (!staff && lesson['state'] != 'Publicado') continue;
      final rows = await s.db.rows(
        'SELECT a.*,e.student,p.name AS student_name FROM attendance a JOIN enrollments e ON e.id=a.enrollment JOIN students p ON p.id=e.student WHERE a.lesson=? ORDER BY p.name COLLATE NOCASE',
        [lesson['id']],
      );
      if (!staff && !rows.any((r) => linked.contains(r['student']))) continue;
      visible.add({
        ...lesson,
        'attendance': rows
            .where((r) => staff || linked.contains(r['student']))
            .toList(),
        if (staff)
          'events': await s.db.rows(
            'SELECT h.*,u.name AS actor_name FROM lesson_events h JOIN users u ON u.id=h.actor WHERE h.lesson=? ORDER BY h.created,h.rowid',
            [lesson['id']],
          ),
      });
    }
    return {
      ...j,
      'teacher_name': teacherNames(j['teachers']),
      'class_name': (await s.one('class_groups', j['class_group']))['name'],
      'component_info': await s.one('course_components', j['component']),
      'published_units': (await s.db.rows(
        "SELECT coalesce(sum(units),0) AS n FROM lessons WHERE journal=? AND state='Publicado'",
        [id],
      )).single['n'],
      'canEdit': editor(u, j),
      'canReview': reviewer(u),
      'roster': (await roster(j))
          .where((e) => staff || linked.contains(e['student']))
          .toList(),
      'lessons': visible,
    };
  }

  Future<void> event(String lesson, String actor, String message) => s.db.exec(
    'INSERT INTO lesson_events VALUES(?,?,?,?,?)',
    [uuid.v4(), lesson, actor, message, now()],
  );
  Future<String> saveLesson(
    Map u,
    String journalId,
    Map b, {
    String? id,
  }) async {
    final j = await journal(u, journalId);
    if (!editor(u, j))
      throw ApiError(
        403,
        'Somente o docente do diário ou a coordenação pode lançar aulas.',
      );
    final group = await s.one('class_groups', j['class_group']);
    if (group['archived'] == 1) throw ApiError(409, 'A turma está arquivada.');
    final date = s.text(b, 'date', max: 10),
        parsed = DateTime.tryParse(s.text(b, 'date', max: 10));
    if (parsed == null ||
        parsed.toIso8601String().substring(0, 10) != date ||
        parsed.year != group['school_year'] ||
        date.compareTo(DateTime.now().toIso8601String().substring(0, 10)) > 0)
      throw ApiError(
        400,
        'Use uma data válida, já ocorrida e dentro do ano letivo.',
      );
    if (u['role'] == 'professor' &&
        !(j['teachers'] as List).any(
          (t) =>
              t['teacher'] == u['id'] &&
              t['valid_from'].compareTo(date) <= 0 &&
              t['valid_to'].compareTo(date) >= 0,
        ))
      throw ApiError(403, 'A data está fora da sua atribuição neste diário.');
    final units = school.integer(b, 'units', 1, 20),
        content = s.text(b, 'content', max: 5000);
    final attendance = b['attendance'];
    if (attendance is! List ||
        attendance.any(
          (a) =>
              a is! Map ||
              a['enrollment'] is! String ||
              !['Presente', 'Ausente', 'Justificada'].contains(a['status']),
        ))
      throw ApiError(400, 'Frequência inválida.');
    return s.db.transaction(() async {
      final old = id == null ? null : await s.one('lessons', id);
      if (old != null) {
        if (old['journal'] != journalId)
          throw ApiError(400, 'A aula pertence a outro diário.');
        s.revision(b, old);
        if (old['state'] != 'Rascunho')
          throw ApiError(
            409,
            'A aula foi enviada. A coordenação precisa devolvê-la antes de uma correção.',
          );
      }
      final expected = old == null
          ? (await roster(j)).map((e) => e['id']).toSet()
          : (await s.db.rows(
              'SELECT enrollment FROM attendance WHERE lesson=?',
              [id!],
            )).map((a) => a['enrollment']).toSet();
      final actual = attendance.map((a) => a['enrollment']).toSet();
      if (expected.isEmpty)
        throw ApiError(
          409,
          'Ative as matrículas antes de registrar a primeira aula.',
        );
      if (actual.length != attendance.length ||
          expected.length != actual.length ||
          !expected.containsAll(actual))
        throw ApiError(
          400,
          'Informe a frequência de todos os alunos da lista, sem incluir alunos de outra turma.',
        );
      final mode = old?['attendance_mode'] ?? group['attendance_mode'];
      final maximum = mode == 'day' ? 1 : units;
      for (final a in attendance) {
        final count = a.containsKey('absences') && a['absences'] != null
            ? a['absences']
            : (a['status'] == 'Presente' ? 0 : maximum);
        if (count is! int ||
            count < 0 ||
            count > maximum ||
            (a['status'] == 'Presente' && count != 0) ||
            (a['status'] != 'Presente' && count == 0))
          throw ApiError(400, 'Quantidade de faltas inválida para a aula.');
        a['absences'] = count;
      }
      final created = id ?? uuid.v4();
      if (old == null) {
        await s.db.exec(
          'INSERT INTO lessons(id,journal,date,units,content,state,created,updated) VALUES(?,?,?,?,?,?,?,?)',
          [created, journalId, date, units, content, 'Rascunho', now(), now()],
        );
      } else {
        await s.db.exec(
          'UPDATE lessons SET date=?,units=?,content=?,updated=?,revision=revision+1 WHERE id=?',
          [date, units, content, now(), id],
        );
      }
      await s.db.exec('UPDATE lessons SET attendance_mode=? WHERE id=?', [
        mode,
        created,
      ]);
      for (final a in attendance) {
        final accepted = await s.db.rows(
          "SELECT id FROM absence_justifications WHERE lesson=? AND enrollment=? AND state='Deferida'",
          [created, a['enrollment']],
        );
        if (accepted.isNotEmpty &&
            (a['status'] != 'Justificada' ||
                (old != null &&
                    (await s.db.rows(
                      'SELECT absences,status FROM attendance WHERE lesson=? AND enrollment=?',
                      [created, a['enrollment']],
                    )).any(
                      (previous) =>
                          (previous['absences'] ??
                              (old['attendance_mode'] == 'day'
                                  ? 1
                                  : old['units'])) !=
                          a['absences'],
                    ))))
          throw ApiError(
            409,
            'Uma justificativa deferida impede apagar esta falta justificada.',
          );
        await s.db.exec(
          'INSERT INTO attendance(lesson,enrollment,status,absences) VALUES(?,?,?,?) ON CONFLICT(lesson,enrollment) DO UPDATE SET status=excluded.status,absences=excluded.absences',
          [created, a['enrollment'], a['status'], a['absences']],
        );
      }
      await event(
        created,
        u['id'],
        old == null
            ? 'Aula e frequência registradas em rascunho.'
            : 'Rascunho da aula corrigido.',
      );
      return created;
    });
  }

  Future<void> action(Map u, String id, Map b) async {
    await s.db.transaction(() async {
      final lesson = await s.one('lessons', id),
          j = await journal(u, (await s.one('lessons', id))['journal']);
      s.revision(b, lesson);
      final action = s.text(b, 'action');
      String state, message;
      if (action == 'submit' && lesson['state'] == 'Rascunho' && editor(u, j)) {
        state = 'Em revisão';
        message = 'Aula enviada para conferência da coordenação.';
      } else if (action == 'publish' &&
          lesson['state'] == 'Em revisão' &&
          reviewer(u)) {
        state = 'Publicado';
        message = 'Aula e frequência publicadas aos alunos e responsáveis vinculados.';
      } else if (action == 'return' &&
          ['Em revisão', 'Publicado'].contains(lesson['state']) &&
          reviewer(u)) {
        state = 'Rascunho';
        message =
            'Aula devolvida para correção. ${s.text(b, 'note', max: 1000)}';
      } else {
        throw ApiError(
          403,
          'Ação indisponível para este perfil ou estado da aula.',
        );
      }
      await s.db.exec(
        'UPDATE lessons SET state=?,updated=?,revision=revision+1 WHERE id=?',
        [state, now(), id],
      );
      await event(id, u['id'], message);
    });
  }
}
