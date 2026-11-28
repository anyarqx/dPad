import 'dart:convert';
import 'dart:io';

import 'store.dart';
import 'school.dart';
import 'templates.dart';
import 'journals.dart';
import 'academics.dart';

class Operations {
  final Store s;
  late final school = School(s);
  late final journals = Journals(s, school);
  late final academic = Academics(s, school, journals);
  Operations(this.s);
  Future<Map<String, dynamic>> institution() async =>
      (await s.db.rows('SELECT * FROM institution_settings WHERE id=1')).single;
  Future<void> saveInstitution(Map u, Map b) async {
    if (!s.admin(u))
      throw ApiError(403, 'Somente a administração configura a instituição.');
    await s.db.transaction(() async {
      s.revision(b, await institution());
      if (b['document_template'] != null)
        await s.one('document_templates', s.text(b, 'document_template'));
      await s.db.exec(
        'UPDATE institution_settings SET name=?,document_template=?,revision=revision+1 WHERE id=1',
        [s.text(b, 'name', max: 180), b['document_template']],
      );
    });
  }

  Future<List<Map<String, dynamic>>> models(Map u) async {
    academic.requireConfiguration(u);
    return [
      for (final m in await s.db.rows(
        'SELECT * FROM period_models ORDER BY valid_from DESC,name',
      ))
        {...m, 'periods': jsonDecode(m['periods_json'])}
          ..remove('periods_json'),
    ];
  }

  Future<String> saveModel(Map u, Map b, {String? id}) async {
    academic.requireConfiguration(u);
    final from = academic.isoDate(b, 'valid_from'),
        to = academic.isoDate(b, 'valid_to');
    final periods = b['periods'];
    if (to.compareTo(from) < 0 ||
        periods is! List ||
        periods.isEmpty ||
        periods.length > 30)
      throw ApiError(400, 'Confira a vigência e os períodos.');
    var end = -1;
    for (final p in periods) {
      if (p is! Map) throw ApiError(400, 'Período inválido.');
      s.text(p, 'label', max: 80);
      final start = school.integer(p, 'start_minute', 0, 1439),
          finish = school.integer(p, 'end_minute', 1, 1440);
      if (start < end || finish <= start)
        throw ApiError(400, 'Períodos não podem se sobrepor.');
      end = finish;
    }
    return s.db.transaction(() async {
      if (id != null) {
        s.revision(b, await s.one('period_models', id));
        if ((await s.db.rows(
          'SELECT id FROM class_groups WHERE period_model=?',
          [id],
        )).isNotEmpty)
          throw ApiError(
            409,
            'Modelo em uso. Crie outra vigência para preservar os horários anteriores.',
          );
        await s.db.exec(
          'UPDATE period_models SET name=?,valid_from=?,valid_to=?,periods_json=?,revision=revision+1 WHERE id=?',
          [s.text(b, 'name', max: 120), from, to, jsonEncode(periods), id],
        );
        return id;
      }
      final created = uuid.v4();
      await s.db.exec(
        'INSERT INTO period_models(id,name,valid_from,valid_to,periods_json) VALUES(?,?,?,?,?)',
        [created, s.text(b, 'name', max: 120), from, to, jsonEncode(periods)],
      );
      return created;
    });
  }

  Future<void> assign(Map u, String id, Map b) async {
    academic.requireConfiguration(u);
    final rows = b['teachers'];
    if (rows is! List || rows.length > 12)
      throw ApiError(400, 'Informe até 12 atribuições.');
    await s.db.transaction(() async {
      final j = await journals.journal(u, id),
          group = await s.one('class_groups', j['class_group']);
      s.revision(b, j);
      final old = await s.db.rows(
        'SELECT * FROM journal_teachers WHERE journal=?',
        [id],
      );
      for (final t in rows) {
        if (t is! Map) throw ApiError(400, 'Atribuição inválida.');
        final teacher = await s.one('users', s.text(t, 'teacher'));
        if (teacher['role'] != 'professor' ||
            (await s.db.rows(
              'SELECT u.id FROM users u LEFT JOIN credentials c ON c.user=u.id WHERE u.id=? AND coalesce(c.enabled,?)=1',
              [teacher['id'], s.testMode ? 1 : 0],
            )).isEmpty)
          throw ApiError(400, 'Selecione professores ativos.');
        final from = academic.isoDate(t, 'valid_from'),
            to = academic.isoDate(t, 'valid_to');
        if (to.compareTo(from) < 0 ||
            DateTime.parse(from).year != group['school_year'] ||
            DateTime.parse(to).year != group['school_year'])
          throw ApiError(400, 'A vigência deve estar dentro do ano letivo.');
      }
      for (final previous in old) {
        if (!rows.any(
              (t) =>
                  t['teacher'] == previous['teacher'] &&
                  t['valid_from'] == previous['valid_from'] &&
                  t['valid_to'] == previous['valid_to'],
            ) &&
            (await s.db.rows(
              "SELECT id FROM lessons WHERE journal=? AND state<>'Rascunho' AND date BETWEEN ? AND ?",
              [id, previous['valid_from'], previous['valid_to']],
            )).isNotEmpty)
          throw ApiError(
            409,
            'A atribuição possui aulas enviadas ou publicadas. Preserve sua vigência.',
          );
      }
      await s.db.exec('DELETE FROM journal_teachers WHERE journal=?', [id]);
      for (final t in rows) {
        await s.db.exec('INSERT INTO journal_teachers VALUES(?,?,?,?,?)', [
          id,
          t['teacher'],
          t['valid_from'],
          t['valid_to'],
          s.optional(t, 'assignment', max: 80).isEmpty
              ? 'Docência'
              : t['assignment'],
        ]);
      }
      await s.db.exec('UPDATE journals SET revision=revision+1 WHERE id=?', [
        id,
      ]);
      for (final slot in await s.db.rows(
        'SELECT * FROM timetable_slots WHERE journal=?',
        [id],
      )) {
        await academic.saveSlot(u, slot, id: slot['id']);
      }
    });
  }

  Future<List<String>> applySchedule(
    Map u,
    Map b,
  ) => s.db.transaction(() async {
    academic.requireConfiguration(u);
    final groups = b['classes'], slots = b['slots'];
    if (groups is! List ||
        groups.isEmpty ||
        groups.length > 30 ||
        groups.toSet().length != groups.length ||
        slots is! List ||
        slots.length > 150)
      throw ApiError(400, 'Selecione turmas e horários válidos.');
    final result = <String>[];
    for (final gid in groups) {
      await s.one('class_groups', gid);
      if (b['period_model'] != null) {
        final model = await s.one('period_models', b['period_model']);
        if (model['archived'] == 1) throw ApiError(409, 'Modelo arquivado.');
        await s.db.exec(
          'UPDATE class_groups SET period_model=?,revision=revision+1 WHERE id=?',
          [model['id'], gid],
        );
      }
      await school.syncMatrix(gid);
      for (final item in slots) {
        if (item is! Map) throw ApiError(400, 'Horário inválido.');
        final js = await s.db.rows(
          'SELECT * FROM journals WHERE class_group=? AND component=?',
          [gid, s.text(item, 'component')],
        );
        if (js.isEmpty)
          throw ApiError(400, 'O componente não pertence à fase desta turma.');
        final journal = js.single;
        if (item['teachers'] != null)
          await assign(u, journal['id'], {
            'revision': journal['revision'],
            'teachers': item['teachers'],
          });
        final previous = item['id'] == null
            ? null
            : await s.one('timetable_slots', item['id']);
        if (previous != null &&
            (groups.length != 1 || previous['journal'] != journal['id']))
          throw ApiError(
            400,
            'Edite um horário existente apenas na sua turma.',
          );
        result.add(
          await academic.saveSlot(u, {
            ...item,
            'journal': journal['id'],
          }, id: previous?['id']),
        );
      }
    }
    return result;
  });
  Future<void> attendance(
    Map u,
    String id,
    Map b,
  ) => s.db.transaction(() async {
    final list = b['lessons'];
    if (list is! List || list.isEmpty || list.length > 62)
      throw ApiError(400, 'Selecione aulas válidas.');
    for (final entry in list) {
      if (entry is! Map) throw ApiError(400, 'Aula inválida.');
      final old = await s.one('lessons', s.text(entry, 'id'));
      if (old['journal'] != id) throw ApiError(400, 'Aula de outro diário.');
      s.revision(entry, old);
      final current = await s.db.rows(
        'SELECT * FROM attendance WHERE lesson=?',
        [old['id']],
      );
      final cells = entry['cells'];
      if (cells is! List ||
          cells.isEmpty ||
          cells.any(
            (c) =>
                c is! Map ||
                !current.any((r) => r['enrollment'] == c['enrollment']),
          ) ||
          cells.map((c) => c['enrollment']).toSet().length != cells.length)
        throw ApiError(400, 'Células de frequência inválidas.');
      await journals.saveLesson(u, id, {
        ...old,
        'attendance': [
          for (final a in current)
            if (cells.any((c) => c['enrollment'] == a['enrollment']))
              {
                ...a,
                ...cells.firstWhere((c) => c['enrollment'] == a['enrollment']),
              }
            else
              a,
        ],
      }, id: old['id']);
    }
  });
  Future<void> grades(Map u, String id, Map b) => s.db.transaction(() async {
    final list = b['assessments'];
    if (list is! List || list.isEmpty || list.length > 62)
      throw ApiError(400, 'Selecione avaliações válidas.');
    for (final entry in list) {
      if (entry is! Map) throw ApiError(400, 'Avaliação inválida.');
      final old = await s.one('assessments', s.text(entry, 'id'));
      if (old['journal'] != id)
        throw ApiError(400, 'Avaliação de outro diário.');
      s.revision(entry, old);
      final current = await s.db.rows(
        'SELECT * FROM grades WHERE assessment=?',
        [old['id']],
      );
      final cells = entry['cells'];
      if (cells is! List ||
          cells.isEmpty ||
          cells.any(
            (c) =>
                c is! Map ||
                !current.any((r) => r['enrollment'] == c['enrollment']),
          ) ||
          cells.map((c) => c['enrollment']).toSet().length != cells.length)
        throw ApiError(400, 'Células de notas inválidas.');
      await academic.saveAssessment(u, id, {
        ...old,
        'grades': [
          for (final g in current)
            if (cells.any((c) => c['enrollment'] == g['enrollment']))
              {
                ...g,
                ...cells.firstWhere((c) => c['enrollment'] == g['enrollment']),
              }
            else
              g,
        ],
      }, id: old['id']);
    }
  });
  Future<Map<String, dynamic>> bulk(Map u, Map b) async {
    final resource = s.text(b, 'resource'),
        action = s.text(b, 'action'),
        items = b['items'];
    if (items is! List ||
        items.isEmpty ||
        items.length > 200 ||
        items.any((e) => e is! Map || e['id'] is! String) ||
        items.map((e) => e['id']).toSet().length != items.length)
      throw ApiError(400, 'Selecione de 1 a 200 registros diferentes.');
    final fields = b['fields'] is Map
        ? b['fields'] as Map
        : <String, dynamic>{};
    final deleted = <String>[];
    await s.db.transaction(() async {
      for (final entry in items) {
        final id = entry['id'];
        if (resource == 'documents') {
          final d = await s.document(u, id, edit: true);
          s.revision(entry, d);
          if (action == 'delete') {
            if (b['confirmation'] != 'EXCLUIR')
              throw ApiError(400, 'Confirme a exclusão.');
            // Foreign keys also protect attachments and absence evidence.
            await s.db.exec('DELETE FROM documents WHERE id=?', [id]);
            deleted.add(d['storage']);
          } else if (action == 'move') {
            final f = await s.folder(u, s.text(fields, 'folder'));
            final source = await s.one('folders', d['folder']);
            if (source['area'] != f['area'] && !s.manageStudents(u))
              throw ApiError(403, 'Movimentação entre áreas exige secretaria.');
            await s.db.exec(
              'UPDATE documents SET folder=?,type=?,revision=revision+1,updated=? WHERE id=?',
              [f['id'], await s.documentType(f['id'], d['type']), now(), id],
            );
          } else if (action == 'review') {
            if (u['department'] == null && !s.admin(u))
              throw ApiError(403, 'Conferência exige atendimento.');
            final status = s.text(fields, 'status');
            if (![
              'Conferido',
              'Precisa de correção',
              'Aguardando conferência',
            ].contains(status))
              throw ApiError(400, 'Situação inválida.');
            await s.db.exec(
              'UPDATE documents SET status=?,note=?,revision=revision+1,updated=? WHERE id=?',
              [status, s.optional(fields, 'note', max: 1000), now(), id],
            );
          } else if (action == 'attach') {
            final r = await s.request(u, s.text(fields, 'request'));
            if (r['state'] == 'Concluída')
              throw ApiError(409, 'Solicitação concluída.');
            await s.attach(u, r['id'], id);
          } else {
            throw ApiError(400, 'Ação documental inválida.');
          }
        } else if (resource == 'students') {
          final p = await s.student(u, id);
          s.revision(entry, p);
          if (action == 'enroll') {
            await school.enroll(u, {
              'student': id,
              'class_group': s.text(fields, 'class_group'),
            });
          } else if (action == 'template') {
            await Templates(s).applyToStudent(u, id, {
              'revision': p['revision'],
              'template': s.text(fields, 'template'),
            });
          } else {
            throw ApiError(400, 'Ação de aluno inválida.');
          }
        } else if (resource == 'enrollments') {
          await school.changeEnrollment(u, id, {
            ...fields,
            'revision': entry['revision'],
            'action': action,
          });
        } else {
          throw ApiError(400, 'Tipo de registro inválido.');
        }
      }
    });
    for (final name in deleted) {
      final f = File('${s.files.path}/$name');
      try {
        if (await f.exists()) await f.delete();
      } on FileSystemException {
        /* Unreferenced file can be collected later; database operation is committed. */
      }
    }
    return {'updated': items.length};
  }
}
