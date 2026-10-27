import 'store.dart';

import 'templates.dart';

class School {
  final Store s;
  School(this.s);
  void manage(Map u) {
    if (!s.manageStudents(u))
      throw ApiError(
        403,
        'Somente a secretaria pode alterar turmas e matrículas.',
      );
  }

  int integer(Map b, String key, int min, int max) {
    final value = b[key];
    if (value is! int || value < min || value > max)
      throw ApiError(400, 'Valor inválido: $key.');
    return value;
  }

  Future<String> saveCourse(Map u, Map b, {String? id}) async {
    manage(u);
    final name = s.text(b, 'name', max: 180),
        modality = s.text(b, 'modality', max: 100),
        duration = s.optional(b, 'duration_label', max: 80);
    final template = b['template'];
    if (template != null) {
      final t = await s.one('document_templates', template);
      if (t['archived'] == 1) throw ApiError(409, 'O modelo está arquivado.');
    }
    final archived = b['archived'] ?? 0;
    if (archived != 0 && archived != 1)
      throw ApiError(400, 'Situação de curso inválida.');
    return s.db.transaction(() async {
      if (id == null) {
        final created = uuid.v4();
        await s.db.exec(
          'INSERT INTO courses(id,name,modality,duration_label,template) VALUES(?,?,?,?,?)',
          [created, name, modality, duration, template],
        );
        return created;
      }
      final old = await s.one('courses', id);
      s.revision(b, old);
      if (archived == 1 &&
          (await s.db.rows(
            'SELECT id FROM class_groups WHERE course=? AND archived=0',
            [id],
          )).isNotEmpty)
        throw ApiError(409, 'Arquive as turmas antes de arquivar o curso.');
      await s.db.exec(
        'UPDATE courses SET name=?,modality=?,duration_label=?,template=?,archived=?,revision=revision+1 WHERE id=?',
        [name, modality, duration, template, archived, id],
      );
      return id;
    });
  }

  Future<bool> canReadClass(Map u, Map group) async {
    if (s.manageStudents(u) ||
        u['department'] == 'coordenacao' ||
        (u['role'] == 'professor' &&
            (await s.db.rows(
              'SELECT id FROM journals WHERE class_group=? AND teacher=?',
              [group['id'], u['id']],
            )).isNotEmpty))
      return true;
    final linked = await s.linkedStudents(u);
    return (await s.db.rows(
      'SELECT student FROM enrollments WHERE class_group=?',
      [group['id']],
    )).any((e) => linked.contains(e['student']));
  }

  Future<List<Map<String, dynamic>>> classes(Map u) async {
    final groups = await s.db.rows(
      "SELECT g.*,c.name AS course_name,c.modality,(SELECT count(*) FROM enrollments e WHERE e.class_group=g.id AND e.state='Ativa') AS active_count,(SELECT count(*) FROM enrollments e WHERE e.class_group=g.id AND e.state='Em análise') AS pending_count FROM class_groups g JOIN courses c ON c.id=g.course ORDER BY g.school_year DESC,c.name COLLATE NOCASE,g.period_label,g.name COLLATE NOCASE",
    );
    final result = <Map<String, dynamic>>[];
    for (final g in groups) {
      if (await canReadClass(u, g)) result.add(g);
    }
    return result;
  }

  Future<String> createClass(Map u, Map b) async {
    manage(u);
    final id = uuid.v4();
    final fields = await classFields(b);
    await s.db.exec(
      'INSERT INTO class_groups(id,course,name,school_year,period_label,grade,shift,capacity,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?)',
      [
        id,
        fields['course'],
        fields['name'],
        fields['school_year'],
        fields['period_label'],
        fields['grade'],
        fields['shift'],
        fields['capacity'],
        now(),
        now(),
      ],
    );
    return id;
  }

  Future<Map<String, dynamic>> classFields(Map b) async {
    final course = await s.one('courses', s.text(b, 'course'));
    if (course['archived'] == 1) throw ApiError(409, 'O curso está arquivado.');
    final shift = s.text(b, 'shift', max: 30);
    if (!['Matutino', 'Vespertino', 'Noturno', 'Integral'].contains(shift))
      throw ApiError(400, 'Turno inválido.');
    return {
      'name': s.text(b, 'name', max: 100),
      'school_year': integer(b, 'school_year', 2000, 2200),
      'period_label': s.text(b, 'period_label', max: 80),
      'course': course['id'],
      'grade': s.text(b, 'grade', max: 100),
      'shift': shift,
      'capacity': integer(b, 'capacity', 1, 200),
    };
  }

  Future<void> updateClass(Map u, String id, Map b) async {
    manage(u);
    await s.db.transaction(() async {
      final old = await s.one('class_groups', id);
      s.revision(b, old);
      final f = await classFields({...old, ...b});
      final enrollments = await s.db.rows(
        'SELECT state FROM enrollments WHERE class_group=?',
        [id],
      );
      if ((f['school_year'] != old['school_year'] ||
              f['period_label'] != old['period_label'] ||
              f['course'] != old['course']) &&
          enrollments.isNotEmpty)
        throw ApiError(
          409,
          'Uma turma com matrículas mantém curso, ano e período. Crie outra turma para uma nova oferta.',
        );
      if ((f['capacity'] as int) <
          enrollments.where((e) => e['state'] == 'Ativa').length)
        throw ApiError(
          409,
          'A capacidade não pode ser menor que as matrículas ativas.',
        );
      final archived = b['archived'] ?? old['archived'];
      if (archived != 0 && archived != 1)
        throw ApiError(400, 'Situação de turma inválida.');
      if (archived == 1 &&
          enrollments.any((e) => ['Ativa', 'Em análise'].contains(e['state'])))
        throw ApiError(
          409,
          'Encerre ou transfira as matrículas antes de arquivar a turma.',
        );
      await s.db.exec(
        'UPDATE class_groups SET course=?,name=?,school_year=?,period_label=?,grade=?,shift=?,capacity=?,archived=?,updated=?,revision=revision+1 WHERE id=?',
        [
          f['course'],
          f['name'],
          f['school_year'],
          f['period_label'],
          f['grade'],
          f['shift'],
          f['capacity'],
          archived,
          now(),
          id,
        ],
      );
    });
  }

  Future<Map<String, dynamic>> classDetail(Map u, String id) async {
    final group = await s.one('class_groups', id);
    if (!await canReadClass(u, group))
      throw ApiError(403, 'Turma sem permissão.');
    final roster = await s.db.rows(
      'SELECT e.*,p.name AS student_name,p.registration FROM enrollments e JOIN students p ON p.id=e.student WHERE e.class_group=? ORDER BY p.name COLLATE NOCASE',
      [id],
    );
    final staff =
        s.manageStudents(u) ||
        u['department'] == 'coordenacao' ||
        (u['role'] == 'professor' &&
            (await s.db.rows(
              'SELECT id FROM journals WHERE class_group=? AND teacher=?',
              [group['id'], u['id']],
            )).isNotEmpty);
    final linked = await s.linkedStudents(u);
    return {
      ...group,
      'course_name': (await s.one('courses', group['course']))['name'],
      'enrollments': roster
          .where((e) => staff || linked.contains(e['student']))
          .toList(),
    };
  }

  Future<List<Map<String, dynamic>>> enrollmentList(
    Map u,
    String student,
  ) async {
    await s.student(u, student);
    final rows = await s.db.rows(
      'SELECT e.*,g.name AS class_name,g.shift,c.name AS course_name FROM enrollments e JOIN class_groups g ON g.id=e.class_group JOIN courses c ON c.id=e.course WHERE e.student=? ORDER BY e.school_year DESC,e.period_label DESC',
      [student],
    );
    for (final e in rows) {
      e['events'] = await s.db.rows(
        'SELECT h.*,u.name AS actor_name FROM enrollment_events h JOIN users u ON u.id=h.actor WHERE h.enrollment=? ORDER BY h.created,h.rowid',
        [e['id']],
      );
    }
    return rows;
  }

  Future<List<String>> pendingItems(Map u, String id) async {
    final detail = await s.studentDetail(u, id);
    return [
      ...s.missingData(detail),
      for (final item in detail['requirements'] as List)
        if (item['status'] != 'Conferido') '${item['type']}: ${item['status']}',
    ];
  }

  Future<void> event(String enrollment, String actor, String message) =>
      s.db.exec('INSERT INTO enrollment_events VALUES(?,?,?,?,?)', [
        uuid.v4(),
        enrollment,
        actor,
        message,
        now(),
      ]);
  Future<String> enroll(Map u, Map b, {bool applyCourseTemplate = true}) async {
    manage(u);
    return s.db.transaction(() async {
      final student = s.text(b, 'student');
      await s.student(u, student);
      final g = await s.one('class_groups', s.text(b, 'class_group'));
      if (g['archived'] == 1) throw ApiError(409, 'A turma está arquivada.');
      final course = await s.one('courses', g['course']);
      if (applyCourseTemplate && course['template'] != null) {
        final person = await s.student(u, student);
        await Templates(s).applyToStudent(u, student, {
          'template': course['template'],
          'revision': person['revision'],
        });
      }

      final id = uuid.v4();
      await s.db.exec(
        'INSERT INTO enrollments(id,student,class_group,course,school_year,period_label,state,created,updated) VALUES(?,?,?,?,?,?,?,?,?)',
        [
          id,
          student,
          g['id'],
          g['course'],
          g['school_year'],
          g['period_label'],
          'Em análise',
          now(),
          now(),
        ],
      );
      await event(
        id,
        u['id'],
        'Matrícula aberta em análise · ${g['name']} · ${g['school_year']}.',
      );
      return id;
    });
  }

  Future<void> seats(Map group) async {
    final active =
        (await s.db.rows(
              "SELECT count(*) AS n FROM enrollments WHERE class_group=? AND state='Ativa'",
              [group['id']],
            )).single['n']
            as int;
    if (active >= group['capacity'])
      throw ApiError(409, 'A turma atingiu a capacidade de matrículas ativas.');
  }

  Future<void> changeEnrollment(Map u, String id, Map b) async {
    manage(u);
    await s.db.transaction(() async {
      final e = await s.one('enrollments', id);
      s.revision(b, e);
      final action = s.text(b, 'action');
      var state = e['state'] as String, groupId = e['class_group'] as String;
      final group = await s.one('class_groups', groupId);
      final note = s.optional(b, 'note', max: 1000);
      String message;
      switch (action) {
        case 'activate':
          if (state != 'Em análise')
            throw ApiError(
              409,
              'Somente uma matrícula em análise pode ser ativada.',
            );
          if (group['archived'] == 1)
            throw ApiError(409, 'A turma está arquivada.');
          final pending = await pendingItems(u, e['student']);
          if (pending.isNotEmpty && note.length < 10)
            throw ApiError(
              409,
              'Há ${pending.length} pendências. Regularize os dados e documentos ou registre uma justificativa com ao menos 10 caracteres.',
            );
          await seats(group);
          state = 'Ativa';
          message =
              'Matrícula ativada${pending.isEmpty ? '' : ' com ${pending.length} pendências: ${pending.join('; ')}'}. ${note.isEmpty ? '' : 'Justificativa: $note'}';
        case 'move':
          if (!['Ativa', 'Em análise'].contains(state))
            throw ApiError(409, 'A matrícula já foi finalizada.');
          final target = await s.one('class_groups', s.text(b, 'class_group'));
          if (target['id'] == groupId)
            throw ApiError(400, 'Selecione outra turma.');
          if (target['school_year'] != e['school_year'] ||
              target['course'] != e['course'] ||
              target['period_label'] != e['period_label'] ||
              target['archived'] == 1)
            throw ApiError(
              409,
              'Selecione uma turma aberta do mesmo curso, ano e período.',
            );
          if (note.isEmpty)
            throw ApiError(400, 'Informe o motivo da mudança de turma.');
          if (state == 'Ativa') await seats(target);
          groupId = target['id'];
          message =
              'Mudança de ${group['name']} para ${target['name']}. Motivo: $note';
        case 'finish':
        case 'transfer':
        case 'cancel':
          if (!['Ativa', 'Em análise'].contains(state) ||
              (action == 'finish' && state != 'Ativa'))
            throw ApiError(409, 'Transição de matrícula inválida.');
          if (note.isEmpty)
            throw ApiError(
              400,
              'Informe o motivo ou resultado do encerramento.',
            );
          state = {
            'finish': 'Encerrada',
            'transfer': 'Transferida',
            'cancel': 'Cancelada',
          }[action]!;
          message = 'Matrícula ${state.toLowerCase()}. $note';
        default:
          throw ApiError(400, 'Ação de matrícula inválida.');
      }
      await s.db.exec(
        'UPDATE enrollments SET state=?,class_group=?,updated=?,revision=revision+1 WHERE id=?',
        [state, groupId, now(), id],
      );
      await event(id, u['id'], message);
    });
  }
}
