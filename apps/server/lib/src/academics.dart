import 'journals.dart';
import 'academic_report.dart';
import 'school.dart';
import 'store.dart';

class Academics {
  final Store s;
  final School school;
  final Journals journals;
  Academics(this.s, this.school, this.journals);
  bool configure(Map u) => s.manageStudents(u) || journals.reviewer(u);
  void requireConfiguration(Map u) {
    if (!configure(u))
      throw ApiError(
        403,
        'A configuração acadêmica exige secretaria ou coordenação.',
      );
  }

  String isoDate(Map b, String key) {
    final value = s.text(b, key, max: 10);
    final parsed = DateTime.tryParse(value);
    if (parsed == null || parsed.toIso8601String().substring(0, 10) != value) {
      throw ApiError(400, 'Data inválida: $key. Use AAAA-MM-DD.');
    }
    return value;
  }

  double number(Map b, String key, double max) {
    final value = b[key];
    if (value is! num || !value.isFinite || value <= 0 || value > max) {
      throw ApiError(400, 'Informe um valor positivo válido para $key.');
    }
    return value.toDouble();
  }

  Future<Map<String, dynamic>> catalog(Map u) async {
    requireConfiguration(u);
    return {
      'subjects': await s.db.rows(
        'SELECT * FROM subjects ORDER BY name COLLATE NOCASE',
      ),
      'components': await s.db.rows(
        'SELECT c.*,s.name AS subject_name,s.code,k.name AS course_name FROM course_components c JOIN subjects s ON s.id=c.subject JOIN courses k ON k.id=c.course ORDER BY k.name,c.phase,s.name COLLATE NOCASE',
      ),
      'teachers': await s.db.rows(
        "SELECT u.id,u.name,p.staff_code,p.qualification,p.phone,p.email,coalesce(p.revision,0) AS revision,(SELECT count(*) FROM journals j WHERE j.teacher=u.id) AS journals FROM users u JOIN credentials c ON c.user=u.id AND c.enabled=1 LEFT JOIN teacher_profiles p ON p.user=u.id WHERE u.role='professor' ORDER BY u.name COLLATE NOCASE",
      ),
    };
  }

  Future<String> saveSubject(Map u, Map b, {String? id}) async {
    requireConfiguration(u);
    final name = s.text(b, 'name', max: 160),
        code = s.optional(b, 'code', max: 40);
    return s.db.transaction(() async {
      if (id == null) {
        final created = uuid.v4();
        await s.db.exec('INSERT INTO subjects(id,name,code) VALUES(?,?,?)', [
          created,
          name,
          code,
        ]);
        return created;
      }
      final old = await s.one('subjects', id);
      s.revision(b, old);
      await s.db.exec(
        'UPDATE subjects SET name=?,code=?,revision=revision+1 WHERE id=?',
        [name, code, id],
      );
      return id;
    });
  }

  Future<String> saveComponent(Map u, Map b, {String? id}) async {
    requireConfiguration(u);
    final course = await s.one('courses', s.text(b, 'course'));
    if (course['archived'] == 1) throw ApiError(409, 'O curso está arquivado.');
    final subject = await s.one('subjects', s.text(b, 'subject'));
    final phase = s.text(b, 'phase', max: 100),
        hours = school.integer(b, 'hours', 1, 5000),
        minutes = school.integer(b, 'lesson_minutes', 15, 120);
    return s.db.transaction(() async {
      if (id == null) {
        final created = uuid.v4();
        await s.db.exec(
          'INSERT INTO course_components(id,course,phase,subject,hours,lesson_minutes) VALUES(?,?,?,?,?,?)',
          [created, course['id'], phase, subject['id'], hours, minutes],
        );
        return created;
      }
      final old = await s.one('course_components', id);
      s.revision(b, old);
      if ((await s.db.rows('SELECT id FROM journals WHERE component=?', [
        id,
      ])).isNotEmpty) {
        throw ApiError(
          409,
          'Esta oferta já possui diário. Cadastre outra fase ou oferta para preservar seu histórico.',
        );
      }
      await s.db.exec(
        'UPDATE course_components SET course=?,phase=?,subject=?,hours=?,lesson_minutes=?,revision=revision+1 WHERE id=?',
        [course['id'], phase, subject['id'], hours, minutes, id],
      );
      return id;
    });
  }

  Future<void> saveTeacher(Map u, String id, Map b) async {
    requireConfiguration(u);
    final teacher = await s.one('users', id);
    if (teacher['role'] != 'professor')
      throw ApiError(400, 'Selecione uma conta de professor.');
    await s.db.transaction(() async {
      final old = await s.db.rows(
        'SELECT * FROM teacher_profiles WHERE user=?',
        [id],
      );
      if (old.isEmpty) {
        if (b['revision'] != 0)
          throw ApiError(409, 'Atualize a lista de professores.');
        await s.db.exec('INSERT INTO teacher_profiles(user) VALUES(?)', [id]);
      } else {
        s.revision(b, old.single);
      }
      final code = s.optional(b, 'staff_code', max: 80);
      await s.db.exec(
        'UPDATE teacher_profiles SET staff_code=?,qualification=?,phone=?,email=?,revision=revision+1 WHERE user=?',
        [
          code.isEmpty ? null : code,
          s.optional(b, 'qualification', max: 1000),
          s.optional(b, 'phone', max: 80),
          s.optional(b, 'email', max: 180),
          id,
        ],
      );
    });
  }

  Future<List<Map<String, dynamic>>> schedule(Map u, String group) async {
    if (!await school.canReadClass(u, await s.one('class_groups', group)))
      throw ApiError(403, 'Turma sem permissão.');
    return s.db.rows(
      'SELECT t.*,j.subject,j.class_group,j.teacher,u.name AS teacher_name,c.phase FROM timetable_slots t JOIN journals j ON j.id=t.journal JOIN users u ON u.id=j.teacher LEFT JOIN course_components c ON c.id=j.component WHERE j.class_group=? ORDER BY t.weekday,t.start_minute,t.valid_from',
      [group],
    );
  }

  Future<String> saveSlot(Map u, Map b, {String? id}) async {
    requireConfiguration(u);
    final j = await journals.journal(u, s.text(b, 'journal')),
        group = await s.one(
          'class_groups',
          (await s.one('journals', s.text(b, 'journal')))['class_group'],
        );
    if (group['archived'] == 1) throw ApiError(409, 'A turma está arquivada.');
    final weekday = school.integer(b, 'weekday', 1, 7),
        start = school.integer(b, 'start_minute', 0, 1439),
        end = school.integer(b, 'end_minute', 1, 1440);
    final from = isoDate(b, 'valid_from'),
        to = isoDate(b, 'valid_to'),
        room = s.optional(b, 'room', max: 80);
    if (end <= start ||
        to.compareTo(from) < 0 ||
        DateTime.parse(from).year != group['school_year'] ||
        DateTime.parse(to).year != group['school_year'])
      throw ApiError(400, 'Confira horário e vigência dentro do ano letivo.');
    final first = DateTime.parse(from),
        offset = (weekday - first.weekday + 7) % 7;
    if (first.add(Duration(days: offset)).isAfter(DateTime.parse(to)))
      throw ApiError(400, 'A vigência não contém esse dia da semana.');
    return s.db.transaction(() async {
      if (id != null) {
        final old = await s.one('timetable_slots', id);
        s.revision(b, old);
        if (old['journal'] != j['id'])
          throw ApiError(400, 'O horário pertence a outro diário.');
      }
      final overlaps = await s.db.rows(
        'SELECT t.id FROM timetable_slots t JOIN journals j ON j.id=t.journal WHERE t.id<>? AND t.weekday=? AND t.start_minute<? AND t.end_minute>? AND t.valid_from<=? AND t.valid_to>=? AND (j.class_group=? OR j.teacher=? OR (?<>? AND t.room=? COLLATE NOCASE))',
        [
          id ?? '',
          weekday,
          end,
          start,
          to,
          from,
          group['id'],
          j['teacher'],
          room,
          '',
          room,
        ],
      );
      for (final hit in overlaps) {
        final other = await s.one('timetable_slots', hit['id']);
        final lo = from.compareTo(other['valid_from']) > 0
            ? from
            : other['valid_from'] as String;
        final hi = to.compareTo(other['valid_to']) < 0
            ? to
            : other['valid_to'] as String;
        final d = DateTime.parse(lo);
        if (!d
            .add(Duration(days: (weekday - d.weekday + 7) % 7))
            .isAfter(DateTime.parse(hi))) {
          throw ApiError(
            409,
            'Conflito de horário: turma, professor ou sala já ocupados nessa vigência.',
          );
        }
      }
      final created = id ?? uuid.v4();
      if (id == null) {
        await s.db.exec(
          'INSERT INTO timetable_slots(id,journal,weekday,start_minute,end_minute,valid_from,valid_to,room) VALUES(?,?,?,?,?,?,?,?)',
          [created, j['id'], weekday, start, end, from, to, room],
        );
      } else {
        await s.db.exec(
          'UPDATE timetable_slots SET weekday=?,start_minute=?,end_minute=?,valid_from=?,valid_to=?,room=?,revision=revision+1 WHERE id=?',
          [weekday, start, end, from, to, room, id],
        );
      }
      return created;
    });
  }

  Future<void> deleteSlot(Map u, String id, Map b) async {
    requireConfiguration(u);
    await s.db.transaction(() async {
      s.revision(b, await s.one('timetable_slots', id));
      await s.db.exec('DELETE FROM timetable_slots WHERE id=?', [id]);
    });
  }

  Future<List<Map<String, dynamic>>> assessments(Map u, String journal) async {
    final j = await journals.journal(u, journal),
        linked = await s.linkedStudents(u);
    final staff = journals.editor(u, j) || s.manageStudents(u);
    final rows = await s.db.rows(
      'SELECT * FROM assessments WHERE journal=? ORDER BY held_on,updated',
      [journal],
    );
    final result = <Map<String, dynamic>>[];
    for (final row in rows) {
      if (!staff && row['state'] != 'Publicado') continue;
      final grades = await s.db.rows(
        'SELECT g.*,e.student,p.name AS student_name FROM grades g JOIN enrollments e ON e.id=g.enrollment JOIN students p ON p.id=e.student WHERE g.assessment=? ORDER BY p.name COLLATE NOCASE',
        [row['id']],
      );
      if (!staff && !grades.any((g) => linked.contains(g['student']))) continue;
      result.add({
        ...row,
        'canEdit': journals.editor(u, j),
        'canReview': journals.reviewer(u),
        'grades': grades
            .where((g) => staff || linked.contains(g['student']))
            .toList(),
        if (staff)
          'events': await s.db.rows(
            'SELECT h.*,u.name AS actor_name FROM assessment_events h JOIN users u ON u.id=h.actor WHERE h.assessment=? ORDER BY h.created,h.rowid',
            [row['id']],
          ),
      });
    }
    return result;
  }

  Future<void> assessmentEvent(String id, Map u, String message) => s.db.exec(
    'INSERT INTO assessment_events VALUES(?,?,?,?,?)',
    [uuid.v4(), id, u['id'], message, now()],
  );
  Future<String> saveAssessment(
    Map u,
    String journal,
    Map b, {
    String? id,
  }) async {
    final j = await journals.journal(u, journal);
    if (!journals.editor(u, j))
      throw ApiError(
        403,
        'Somente o docente responsável e a coordenação lançam notas.',
      );
    final group = await s.one('class_groups', j['class_group']);
    if (group['archived'] == 1) throw ApiError(409, 'A turma está arquivada.');
    final label = s.text(b, 'label', max: 160),
        stage = s.text(b, 'stage', max: 100),
        held = isoDate(b, 'held_on'),
        maxScore = number(b, 'max_score', 1000),
        weight = number(b, 'weight', 100);
    if (DateTime.parse(held).year != group['school_year'] ||
        held.compareTo(DateTime.now().toIso8601String().substring(0, 10)) > 0)
      throw ApiError(
        400,
        'A avaliação deve ter ocorrido dentro do ano letivo.',
      );
    final grades = b['grades'];
    if (grades is! List || grades.any((g) => g is! Map))
      throw ApiError(400, 'Lista de notas inválida.');
    return s.db.transaction(() async {
      final old = id == null ? null : await s.one('assessments', id);
      if (old != null) {
        s.revision(b, old);
        if (old['journal'] != journal || old['state'] != 'Rascunho')
          throw ApiError(
            409,
            'Devolva a avaliação para rascunho antes de corrigir.',
          );
      }
      final expected = old == null
          ? (await journals.roster(j)).map((r) => r['id']).toSet()
          : (await s.db.rows(
              'SELECT enrollment FROM grades WHERE assessment=?',
              [id!],
            )).map((r) => r['enrollment']).toSet();
      if (expected.isEmpty ||
          grades.length != expected.length ||
          grades.map((g) => g['enrollment']).toSet().length != grades.length ||
          !expected.containsAll(grades.map((g) => g['enrollment'])))
        throw ApiError(
          400,
          'Informe cada aluno da lista uma vez, sem matrículas de outra turma.',
        );
      for (final g in grades) {
        final status = g['status'], score = g['score'];
        if (!['Pendente', 'Lançada', 'Ausente', 'Dispensada'].contains(status))
          throw ApiError(400, 'Situação de nota inválida.');
        if (status == 'Lançada'
            ? score is! num || !score.isFinite || score < 0 || score > maxScore
            : score != null)
          throw ApiError(
            400,
            'A nota deve estar entre zero e o valor máximo. Ausência, dispensa e pendência não recebem nota.',
          );
        final note = s.optional(g, 'note', max: 500);
        if (status == 'Dispensada' && note.isEmpty)
          throw ApiError(400, 'Informe o motivo da dispensa.');
      }
      final created = id ?? uuid.v4();
      if (old == null) {
        await s.db.exec(
          'INSERT INTO assessments(id,journal,label,stage,held_on,max_score,weight,state,updated) VALUES(?,?,?,?,?,?,?,?,?)',
          [
            created,
            journal,
            label,
            stage,
            held,
            maxScore,
            weight,
            'Rascunho',
            now(),
          ],
        );
      } else {
        await s.db.exec(
          'UPDATE assessments SET label=?,stage=?,held_on=?,max_score=?,weight=?,revision=revision+1,updated=? WHERE id=?',
          [label, stage, held, maxScore, weight, now(), id],
        );
        await s.db.exec('DELETE FROM grades WHERE assessment=?', [id]);
      }
      for (final g in grades) {
        await s.db.exec('INSERT INTO grades VALUES(?,?,?,?,?)', [
          created,
          g['enrollment'],
          g['score'],
          g['status'],
          s.optional(g, 'note', max: 500),
        ]);
      }
      await assessmentEvent(
        created,
        u,
        old == null
            ? 'Avaliação e notas registradas em rascunho.'
            : 'Notas corrigidas em rascunho.',
      );
      return created;
    });
  }

  Future<void> assessmentAction(Map u, String id, Map b) async {
    await s.db.transaction(() async {
      final a = await s.one('assessments', id),
          j = await journals.journal(
            u,
            (await s.one('assessments', id))['journal'],
          );
      s.revision(b, a);
      final action = s.text(b, 'action');
      String state, message;
      if (action == 'submit' &&
          a['state'] == 'Rascunho' &&
          journals.editor(u, j)) {
        if ((await s.db.rows(
          "SELECT enrollment FROM grades WHERE assessment=? AND status='Pendente'",
          [id],
        )).isNotEmpty)
          throw ApiError(
            409,
            'Preencha todas as notas ou indique ausência/dispensa antes de enviar.',
          );
        state = 'Em revisão';
        message = 'Notas enviadas para conferência.';
      } else if (action == 'publish' &&
          a['state'] == 'Em revisão' &&
          journals.reviewer(u)) {
        state = 'Publicado';
        message =
            'Notas publicadas no boletim dos alunos e responsáveis vinculados.';
      } else if (action == 'return' &&
          a['state'] != 'Rascunho' &&
          journals.reviewer(u)) {
        state = 'Rascunho';
        message =
            'Avaliação devolvida para correção. ' +
            s.text(b, 'note', max: 1000);
      } else {
        throw ApiError(
          403,
          'Ação indisponível para este perfil ou estado da avaliação.',
        );
      }
      await s.db.exec(
        'UPDATE assessments SET state=?,updated=?,revision=revision+1 WHERE id=?',
        [state, now(), id],
      );
      await assessmentEvent(id, u, message);
    });
  }

  Future<Map<String, dynamic>> report(Map u, String student) async {
    await s.student(u, student);
    final p = await s.one('students', student);
    final grades = await s.db.rows(
      "SELECT g.*,a.label,a.stage,a.held_on,a.max_score,a.weight,a.updated,j.id AS journal,j.subject,e.school_year,e.period_label,c.name AS class_name,k.name AS course_name,cc.phase FROM grades g JOIN assessments a ON a.id=g.assessment JOIN journals j ON j.id=a.journal JOIN enrollments e ON e.id=g.enrollment JOIN class_groups c ON c.id=j.class_group JOIN courses k ON k.id=c.course LEFT JOIN course_components cc ON cc.id=j.component WHERE e.student=? AND a.state='Publicado' ORDER BY e.school_year DESC,k.name,cc.phase,j.subject,a.stage,a.held_on",
      [student],
    );
    final attendance = await s.db.rows(
      "SELECT j.id AS journal,j.subject,l.date,l.units,a.status,a.enrollment,l.id AS lesson,c.name AS class_name,e.school_year FROM attendance a JOIN lessons l ON l.id=a.lesson JOIN journals j ON j.id=l.journal JOIN enrollments e ON e.id=a.enrollment JOIN class_groups c ON c.id=j.class_group WHERE e.student=? AND l.state='Publicado' ORDER BY l.date DESC",
      [student],
    );
    return {
      'student': {
        'id': p['id'],
        'name': p['name'],
        'registration': p['registration'],
      },
      'grades': grades,
      'summaries': summarizeGrades(grades),
      'attendance': attendance,
      'issued': now(),
      'calculation': 'Média de acompanhamento: nota / valor máximo × 10, ponderada pelo peso, somente notas lançadas e publicadas. Ausências e pendências não equivalem a zero; não há decisão automática de aprovação. Faltas justificadas continuam registradas como faltas.',
    };
  }

  Future<List<Map<String, dynamic>>> justifications(
    Map u, {
    String? student,
    String? group,
  }) async {
    final reviewer = journals.reviewer(u);
    if (student != null) await s.student(u, student);
    if (student == null && !reviewer)
      throw ApiError(
        403,
        'Consulte as justificativas na pasta do aluno vinculado.',
      );
    if (group != null &&
        !await school.canReadClass(u, await s.one('class_groups', group)))
      throw ApiError(403, 'Turma sem permissão.');
    return s.db.rows(
      'SELECT x.*,p.name AS student_name,e.student,j.subject,l.date,l.units,u.name AS requester_name,d.name AS document_name FROM absence_justifications x JOIN lessons l ON l.id=x.lesson JOIN journals j ON j.id=l.journal JOIN enrollments e ON e.id=x.enrollment JOIN students p ON p.id=e.student JOIN users u ON u.id=x.requester LEFT JOIN documents d ON d.id=x.document WHERE (?=? OR e.student=?) AND (?=? OR j.class_group=?) ORDER BY x.created DESC',
      [student ?? '', '', student ?? '', group ?? '', '', group ?? ''],
    );
  }

  Future<String> justify(Map u, Map b) => s.db.transaction(() async {
    final lesson = await s.one('lessons', s.text(b, 'lesson')),
        enrollment = await s.one('enrollments', s.text(b, 'enrollment'));
    await s.student(u, enrollment['student']);
    final attendance = await s.db.rows(
      "SELECT * FROM attendance WHERE lesson=? AND enrollment=? AND status='Ausente'",
      [lesson['id'], enrollment['id']],
    );
    if (lesson['state'] != 'Publicado' || attendance.isEmpty)
      throw ApiError(409, 'Selecione uma falta publicada do aluno.');
    final document = b['document'] == '' ? null : b['document'];
    if (document != null) {
      final d = await s.document(u, document);
      if (d['folder'] !=
          (await s.one('students', enrollment['student']))['folder'])
        throw ApiError(400, 'O comprovante deve estar na pasta deste aluno.');
    }
    final id = uuid.v4();
    await s.db.exec(
      'INSERT INTO absence_justifications(id,lesson,enrollment,requester,reason,document,state,created,updated) VALUES(?,?,?,?,?,?,?,?,?)',
      [
        id,
        lesson['id'],
        enrollment['id'],
        u['id'],
        s.text(b, 'reason', max: 2000),
        document,
        'Recebida',
        now(),
        now(),
      ],
    );
    return id;
  });

  Future<void> reviewJustification(Map u, String id, Map b) async {
    if (!journals.reviewer(u))
      throw ApiError(403, 'A coordenação analisa justificativas.');
    await s.db.transaction(() async {
      final x = await s.one('absence_justifications', id);
      s.revision(b, x);
      if (x['state'] != 'Recebida')
        throw ApiError(409, 'A justificativa já foi analisada.');
      final state = s.text(b, 'state'),
          response = s.text(b, 'response', max: 1000);
      if (!['Deferida', 'Indeferida'].contains(state))
        throw ApiError(400, 'Resultado inválido.');
      if ((await s.one('lessons', x['lesson']))['state'] != 'Publicado')
        throw ApiError(
          409,
          'A aula está em correção. Aguarde a republicação antes de analisar a justificativa.',
        );
      final a = await s.db.rows(
        'SELECT status FROM attendance WHERE lesson=? AND enrollment=?',
        [x['lesson'], x['enrollment']],
      );
      if (a.isEmpty || a.single['status'] != 'Ausente')
        throw ApiError(
          409,
          'A frequência foi alterada. Confira o diário antes de analisar.',
        );
      await s.db.exec(
        'UPDATE absence_justifications SET state=?,response=?,reviewer=?,updated=?,revision=revision+1 WHERE id=?',
        [state, response, u['id'], now(), id],
      );
      if (state == 'Deferida') {
        await s.db.exec(
          "UPDATE attendance SET status='Justificada' WHERE lesson=? AND enrollment=?",
          [x['lesson'], x['enrollment']],
        );
        await s.db.exec(
          'UPDATE lessons SET revision=revision+1,updated=? WHERE id=?',
          [now(), x['lesson']],
        );
        await journals.event(
          x['lesson'],
          u['id'],
          'Justificativa deferida para uma ausência. A falta permanece registrada; não constitui abono.',
        );
      }
    });
  }
}
