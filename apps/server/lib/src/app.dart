import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

import 'store.dart';
import 'catalog.dart';
import 'pdf.dart';
import 'auth.dart';
import 'school.dart';
import 'templates.dart';
import 'journals.dart';
import 'academics.dart';

Response json(Object? value, {int status = 200}) => Response(
  status,
  body: jsonEncode(value),
  headers: {'content-type': 'application/json; charset=utf-8'},
);
Future<Map<String, dynamic>> body(Request r) async {
  var n = 0;
  final bytes = <int>[];
  await for (final c in r.read()) {
    n += c.length;
    if (n > 128 * 1024) throw ApiError(413, 'Formulário muito grande.');
    bytes.addAll(c);
  }
  final v = jsonDecode(utf8.decode(bytes));
  if (v is! Map<String, dynamic>) throw ApiError(400, 'JSON inválido.');
  return v;
}

Handler buildHandler(Store s, {String? instance, String? allowedOrigin}) {
  final router = Router();
  Map<String, dynamic> user(Request r) =>
      r.context['user'] as Map<String, dynamic>;
  final auth = Auth(s);
  final school = School(s);
  final templates = Templates(s);
  final journals = Journals(s, school);
  final academic = Academics(s, school, journals);
  router.get(
    '/api/v1/academic/catalog',
    (Request r) async => json(await academic.catalog(user(r))),
  );
  router.post('/api/v1/subjects', (Request r) async {
    final id = await academic.saveSubject(user(r), await body(r));
    return json(await s.one('subjects', id), status: 201);
  });
  router.patch('/api/v1/subjects/<id>', (Request r, String id) async {
    await academic.saveSubject(user(r), await body(r), id: id);
    return json(await s.one('subjects', id));
  });
  router.post('/api/v1/components', (Request r) async {
    final id = await academic.saveComponent(user(r), await body(r));
    return json(await s.one('course_components', id), status: 201);
  });
  router.patch('/api/v1/components/<id>', (Request r, String id) async {
    await academic.saveComponent(user(r), await body(r), id: id);
    return json(await s.one('course_components', id));
  });
  router.patch('/api/v1/teachers/<id>', (Request r, String id) async {
    await academic.saveTeacher(user(r), id, await body(r));
    return json({'updated': true});
  });
  router.get(
    '/api/v1/classes/<id>/schedule',
    (Request r, String id) async => json(await academic.schedule(user(r), id)),
  );
  router.post('/api/v1/schedule', (Request r) async {
    final id = await academic.saveSlot(user(r), await body(r));
    return json(await s.one('timetable_slots', id), status: 201);
  });
  router.patch('/api/v1/schedule/<id>', (Request r, String id) async {
    await academic.saveSlot(user(r), await body(r), id: id);
    return json(await s.one('timetable_slots', id));
  });
  router.post('/api/v1/schedule/<id>/delete', (Request r, String id) async {
    await academic.deleteSlot(user(r), id, await body(r));
    return json({'deleted': true});
  });
  router.get(
    '/api/v1/journals/<id>/assessments',
    (Request r, String id) async =>
        json(await academic.assessments(user(r), id)),
  );
  router.post('/api/v1/journals/<id>/assessments', (
    Request r,
    String id,
  ) async {
    final created = await academic.saveAssessment(user(r), id, await body(r));
    return json(await s.one('assessments', created), status: 201);
  });
  router.patch('/api/v1/assessments/<id>', (Request r, String id) async {
    final old = await s.one('assessments', id);
    await academic.saveAssessment(
      user(r),
      old['journal'],
      await body(r),
      id: id,
    );
    return json(await s.one('assessments', id));
  });
  router.post('/api/v1/assessments/<id>/actions', (Request r, String id) async {
    await academic.assessmentAction(user(r), id, await body(r));
    return json(await s.one('assessments', id));
  });
  router.get(
    '/api/v1/students/<id>/report',
    (Request r, String id) async => json(await academic.report(user(r), id)),
  );
  router.get(
    '/api/v1/students/<id>/report.pdf',
    (Request r, String id) async => Response.ok(
      await reportPdf(await academic.report(user(r), id)),
      headers: {'content-type': 'application/pdf'},
    ),
  );
  router.get(
    '/api/v1/justifications',
    (Request r) async => json(
      await academic.justifications(
        user(r),
        student: r.url.queryParameters['student'],
        group: r.url.queryParameters['class'],
      ),
    ),
  );
  router.post('/api/v1/justifications', (Request r) async {
    final id = await academic.justify(user(r), await body(r));
    return json(await s.one('absence_justifications', id), status: 201);
  });
  router.post('/api/v1/justifications/<id>/review', (
    Request r,
    String id,
  ) async {
    await academic.reviewJustification(user(r), id, await body(r));
    return json(await s.one('absence_justifications', id));
  });
  router.get(
    '/api/v1/courses',
    (Request r) async => json(
      await s.db.rows(
        'SELECT * FROM courses ORDER BY name COLLATE NOCASE,modality',
      ),
    ),
  );
  router.post('/api/v1/courses', (Request r) async {
    final id = await school.saveCourse(user(r), await body(r));
    return json(await s.one('courses', id), status: 201);
  });
  router.patch('/api/v1/courses/<id>', (Request r, String id) async {
    await school.saveCourse(user(r), await body(r), id: id);
    return json(await s.one('courses', id));
  });
  router.get(
    '/api/v1/classes/<id>/journals',
    (Request r, String id) async => json(await journals.list(user(r), id)),
  );
  router.post('/api/v1/journals', (Request r) async {
    final id = await journals.create(user(r), await body(r));
    return json(await s.one('journals', id), status: 201);
  });
  router.get(
    '/api/v1/journals/<id>',
    (Request r, String id) async => json(await journals.detail(user(r), id)),
  );
  router.post('/api/v1/journals/<id>/lessons', (Request r, String id) async {
    final created = await journals.saveLesson(user(r), id, await body(r));
    return json(await s.one('lessons', created), status: 201);
  });
  router.patch('/api/v1/lessons/<id>', (Request r, String id) async {
    final lesson = await s.one('lessons', id);
    await journals.saveLesson(
      user(r),
      lesson['journal'],
      await body(r),
      id: id,
    );
    return json(await s.one('lessons', id));
  });
  router.post('/api/v1/lessons/<id>/actions', (Request r, String id) async {
    await journals.action(user(r), id, await body(r));
    return json(await s.one('lessons', id));
  });
  router.get(
    '/api/v1/templates',
    (Request r) async => json(await templates.list(user(r))),
  );
  router.post('/api/v1/templates', (Request r) async {
    final id = await templates.save(user(r), await body(r));
    return json(
      templates.decode(await s.one('document_templates', id)),
      status: 201,
    );
  });
  router.patch('/api/v1/templates/<id>', (Request r, String id) async {
    await templates.save(user(r), await body(r), id: id);
    return json(templates.decode(await s.one('document_templates', id)));
  });
  router.get(
    '/api/v1/auth/status',
    (Request r) async => json({
      'demo': s.demo,
      'setupRequired': !s.demo && !await auth.configured(),
      'setupLocal':
          (r.context['shelf.io.connection_info'] as HttpConnectionInfo?)
              ?.remoteAddress
              .isLoopback ??
          false,
    }),
  );
  router.post('/api/v1/auth/setup', (Request r) async {
    if (s.demo)
      throw ApiError(
        403,
        'Saia do modo de demonstração para configurar contas.',
      );
    final connection =
        r.context['shelf.io.connection_info'] as HttpConnectionInfo?;
    if (connection == null || !connection.remoteAddress.isLoopback)
      throw ApiError(
        403,
        'Configure o primeiro administrador no computador do servidor.',
      );
    return json(await auth.setup(await body(r)), status: 201);
  });
  router.post('/api/v1/auth/login', (Request r) async {
    final connection =
        r.context['shelf.io.connection_info'] as HttpConnectionInfo?;
    return json(
      await auth.login(
        await body(r),
        connection?.remoteAddress.address ?? 'local',
      ),
    );
  });
  router.post('/api/v1/auth/logout', (Request r) async {
    if (!s.demo) await auth.logout(r.headers['authorization']!);
    return json({'loggedOut': true});
  });
  router.post('/api/v1/auth/password', (Request r) async {
    await auth.changePassword(user(r), await body(r));
    return json({'changed': true});
  });
  router.get(
    '/api/v1/accounts',
    (Request r) async => json(await auth.accounts(user(r))),
  );
  router.post('/api/v1/accounts', (Request r) async {
    final id = await auth.createAccount(user(r), await body(r));
    return json(
      (await auth.accounts(user(r))).firstWhere((a) => a['id'] == id),
      status: 201,
    );
  });
  router.patch('/api/v1/accounts/<id>', (Request r, String id) async {
    await auth.updateAccount(user(r), id, await body(r));
    return json({'updated': true});
  });
  router.get(
    '/api/v1/classes',
    (Request r) async => json(await school.classes(user(r))),
  );
  router.get('/api/v1/teachers', (Request r) async {
    if (!s.manageStudents(user(r)) && !journals.reviewer(user(r)))
      throw ApiError(403, 'Sem permissão para consultar docentes.');
    return json(
      await s.db.rows(
        "SELECT u.id,u.name FROM users u JOIN credentials c ON c.user=u.id WHERE u.role='professor' AND c.enabled=1 ORDER BY u.name COLLATE NOCASE",
      ),
    );
  });
  router.post('/api/v1/classes', (Request r) async {
    final id = await school.createClass(user(r), await body(r));
    return json(await school.classDetail(user(r), id), status: 201);
  });
  router.get(
    '/api/v1/classes/<id>',
    (Request r, String id) async => json(await school.classDetail(user(r), id)),
  );
  router.patch('/api/v1/classes/<id>', (Request r, String id) async {
    await school.updateClass(user(r), id, await body(r));
    return json(await school.classDetail(user(r), id));
  });
  router.get(
    '/api/v1/students/<id>/enrollments',
    (Request r, String id) async => json({
      'items': await school.enrollmentList(user(r), id),
      'pending': await school.pendingItems(user(r), id),
    }),
  );
  router.post('/api/v1/enrollments', (Request r) async {
    final id = await school.enroll(user(r), await body(r));
    return json(await s.one('enrollments', id), status: 201);
  });
  router.post('/api/v1/enrollments/<id>/actions', (Request r, String id) async {
    await school.changeEnrollment(user(r), id, await body(r));
    return json(await s.one('enrollments', id));
  });
  router.get(
    '/health',
    (Request r) => json({
      'status': 'ok',
      'application': 'papel-digital',
      'version': 1,
      if (instance != null) 'instance': instance,
    }),
  );
  router.get(
    '/api/v1/session',
    (Request r) async => json({
      'user': user(r),
      'users': await s.db.rows(
        s.demo ? 'SELECT * FROM users' : 'SELECT * FROM users WHERE id=?',
        s.demo ? [] : [user(r)['id']],
      ),
      'services': services,
      'demo': s.demo,
    }),
  );
  router.get('/api/v1/services', (Request r) => json(services));
  router.get('/api/v1/folders', (Request r) async {
    final linked = await s.linkedStudents(user(r));
    return json(
      (await s.db.rows(
            "SELECT f.*,p.name AS student_name,p.id AS student_id,coalesce(owner.name,CASE f.area WHEN 'sector:secretaria' THEN 'Secretaria' WHEN 'sector:coordenacao' THEN 'Coordenação' ELSE 'Arquivo administrativo' END) AS area_name FROM folders f LEFT JOIN students p ON p.folder=f.id LEFT JOIN users owner ON f.area='user:'||owner.id ORDER BY f.name COLLATE NOCASE",
          ))
          .where(
            (f) => f['student_id'] == null
                ? s.area(user(r), f['area'])
                : s.manageStudents(user(r)) || linked.contains(f['student_id']),
          )
          .toList(),
    );
  });
  router.post('/api/v1/folders', (Request r) async {
    final id = await s.createFolder(user(r), await body(r));
    return json(await s.one('folders', id), status: 201);
  });
  router.patch('/api/v1/folders/<id>', (Request r, String id) async {
    await s.updateFolder(user(r), id, await body(r));
    return json(await s.folder(user(r), id));
  });
  router.delete('/api/v1/folders/<id>', (Request r, String id) async {
    await s.deleteFolder(user(r), id);
    return json({'deleted': true});
  });
  router.get(
    '/api/v1/students',
    (Request r) async => json(await s.listStudents(user(r))),
  );
  router.post('/api/v1/students', (Request r) async {
    final b = await body(r);
    final id = await s.db.transaction(() async {
      final group = await s.one('class_groups', s.text(b, 'class_group'));
      final course = await s.one('courses', group['course']);
      final id = await s.createStudent(user(r), {
        ...b,
        'template': b.containsKey('template')
            ? b['template']
            : course['template'],
      });
      await school.enroll(user(r), {
        'student': id,
        'class_group': group['id'],
      }, applyCourseTemplate: false);
      return id;
    });
    return json(await s.studentDetail(user(r), id), status: 201);
  });
  router.get(
    '/api/v1/students/<id>',
    (Request r, String id) async => json(await s.studentDetail(user(r), id)),
  );
  router.patch('/api/v1/students/<id>', (Request r, String id) async {
    await s.updateStudent(user(r), id, await body(r));
    return json(await s.studentDetail(user(r), id));
  });
  router.post('/api/v1/students/<id>/template', (Request r, String id) async {
    await templates.applyToStudent(user(r), id, await body(r));
    return json(await s.studentDetail(user(r), id));
  });
  router.post('/api/v1/students/<id>/requirements', (
    Request r,
    String id,
  ) async {
    if (!s.manageStudents(user(r)))
      throw ApiError(
        403,
        'Somente a secretaria pode alterar a lista documental.',
      );
    await s.student(user(r), id);
    final type = s.text(await body(r), 'type', max: 120);
    await s.db.exec('INSERT INTO requirements VALUES(?,?,?)', [
      uuid.v4(),
      id,
      type,
    ]);
    return json(await s.studentDetail(user(r), id), status: 201);
  });
  router.delete('/api/v1/students/<id>/requirements/<requirement>', (
    Request r,
    String id,
    String requirement,
  ) async {
    if (!s.manageStudents(user(r)))
      throw ApiError(
        403,
        'Somente a secretaria pode alterar a lista documental.',
      );
    await s.student(user(r), id);
    await s.db.exec('DELETE FROM requirements WHERE id=? AND student=?', [
      requirement,
      id,
    ]);
    return json(await s.studentDetail(user(r), id));
  });
  router.get('/api/v1/documents', (Request r) async {
    final docs = await s.db.rows(
      'SELECT d.*,f.area,p.id AS student_id FROM documents d JOIN folders f ON f.id=d.folder LEFT JOIN students p ON p.folder=f.id ORDER BY d.name COLLATE NOCASE',
    );
    final linked = await s.db.rows(
      'SELECT p.folder FROM students p JOIN student_access a ON a.student=p.id WHERE a.user=?',
      [user(r)['id']],
    );
    return json(
      docs
          .where(
            (d) => d['student_id'] == null
                ? s.area(user(r), d['area'])
                : s.manageStudents(user(r)) ||
                      linked.any((p) => p['folder'] == d['folder']),
          )
          .toList(),
    );
  });
  router.post('/api/v1/documents', (Request r) async {
    final q = r.url.queryParameters;
    final folder = q['folder'] ?? '';
    await s.folder(user(r), folder);
    final name = s.text(q, 'name', max: 180);
    final type = await s.documentType(folder, s.text(q, 'type', max: 120));
    final form = r.formData();
    if (form == null) throw ApiError(400, 'Envie um arquivo multipart.');
    final id = uuid.v4();
    final temp = File('${s.files.path}/$id.part');
    final dest = File('${s.files.path}/$id');
    int size = 0;
    final head = <int>[];
    bool found = false;
    try {
      await for (final part in form.formData) {
        if (found || part.name != 'file')
          throw ApiError(400, 'Envie exatamente um arquivo.');
        found = true;
        final sink = temp.openWrite();
        try {
          await for (final chunk in part.part) {
            size += chunk.length;
            if (size > 30 * 1024 * 1024)
              throw ApiError(413, 'Limite de 30 MB por arquivo.');
            if (head.length < 16) head.addAll(chunk.take(16 - head.length));
            sink.add(chunk);
          }
        } finally {
          await sink.flush();
          await sink.close();
        }
      }
      final mime = detect(head);
      if (!found || mime == null)
        throw ApiError(400, 'Arquivo inválido. Use PDF, JPEG, PNG ou WebP.');
      await temp.rename(dest.path);
      await s.db.exec(
        'INSERT INTO documents(id,name,folder,type,mime,size,storage,uploader,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [id, name, folder, type, mime, size, id, user(r)['id'], now(), now()],
      );
      return json(await s.one('documents', id), status: 201);
    } catch (_) {
      if (await temp.exists()) await temp.delete();
      if (await dest.exists()) await dest.delete();
      rethrow;
    }
  });
  router.get('/api/v1/documents/<id>/content', (Request r, String id) async {
    final d = await s.document(user(r), id);
    final f = File('${s.files.path}/${d['storage']}');
    if (!await f.exists()) throw ApiError(410, 'Arquivo físico ausente.');
    return Response.ok(
      f.openRead(),
      headers: {
        'content-type': d['mime'],
        'content-length': '${await f.length()}',
        'content-disposition':
            "inline; filename*=UTF-8''${Uri.encodeComponent(d['name'])}",
      },
    );
  });
  router.get(
    '/api/v1/documents/<id>',
    (Request r, String id) async => json(await s.document(user(r), id)),
  );
  router.patch('/api/v1/documents/<id>', (Request r, String id) async {
    await s.db.transaction(() async {
      final d = await s.document(user(r), id, edit: true);
      final b = await body(r);
      s.revision(b, d);
      final folder = b['folder'] ?? d['folder'];
      final target = await s.folder(user(r), folder);
      final old = await s.folder(user(r), d['folder']);
      if (target['area'] != old['area'] && !s.manageStudents(user(r)))
        throw ApiError(400, 'Mova somente dentro da mesma área.');
      final status = b['status'] ?? d['status'];
      if (![
        'Aguardando conferência',
        'Conferido',
        'Precisa de correção',
      ].contains(status))
        throw ApiError(400, 'Situação inválida.');
      if (status != d['status'] &&
          user(r)['department'] == null &&
          !s.admin(user(r)))
        throw ApiError(403, 'Conferência exige perfil de atendimento.');
      await s.db.exec(
        'UPDATE documents SET name=?,folder=?,type=?,status=?,note=?,updated=?,revision=revision+1 WHERE id=?',
        [
          b.containsKey('name') ? s.text(b, 'name', max: 180) : d['name'],
          folder,
          await s.documentType(
            folder,
            b.containsKey('type') ? s.text(b, 'type', max: 120) : d['type'],
          ),
          status,
          b['note'] ?? d['note'],
          now(),
          id,
        ],
      );
    });
    return json(await s.one('documents', id));
  });
  router.post('/api/v1/documents/<id>/review', (Request r, String id) async {
    final u = user(r);
    if (u['department'] == null && !s.admin(u))
      throw ApiError(403, 'Conferência exige perfil de atendimento.');
    await s.db.transaction(() async {
      final d = await s.document(u, id);
      final b = await body(r);
      s.revision(b, d);
      final status = s.text(b, 'status');
      if (![
        'Aguardando conferência',
        'Conferido',
        'Precisa de correção',
      ].contains(status))
        throw ApiError(400, 'Situação inválida.');
      final note = b['note'] ?? '';
      if (note is! String || note.length > 1000)
        throw ApiError(400, 'Observação inválida.');
      await s.db.exec(
        'UPDATE documents SET status=?,note=?,updated=?,revision=revision+1 WHERE id=?',
        [status, note, now(), id],
      );
    });
    return json(await s.document(u, id));
  });
  router.delete('/api/v1/documents/<id>', (Request r, String id) async {
    final d = await s.document(user(r), id, edit: true);
    if ((await s.db.rows('SELECT * FROM attachments WHERE document=?', [
      id,
    ])).isNotEmpty)
      throw ApiError(409, 'Documento vinculado a uma solicitação.');
    await s.db.exec('DELETE FROM documents WHERE id=?', [id]);
    final f = File('${s.files.path}/${d['storage']}');
    if (await f.exists()) await f.delete();
    return json({'deleted': true});
  });
  router.get('/api/v1/requests', (Request r) async {
    final u = user(r);
    final linked = await s.linkedStudents(u);
    final queue = r.url.queryParameters['queue'] == 'true';
    return json(
      (await s.db.rows(
            'SELECT r.*,u.name AS requester_name,p.name AS student_name FROM requests r JOIN users u ON u.id=r.requester LEFT JOIN students p ON p.id=r.student ORDER BY r.updated DESC',
          ))
          .where(
            (v) => queue
                ? s.staff(u, v)
                : v['requester'] == u['id'] || linked.contains(v['student']),
          )
          .toList(),
    );
  });
  router.post('/api/v1/requests', (Request r) async {
    final id = await s.createRequest(user(r), await body(r));
    return json(await s.request(user(r), id), status: 201);
  });
  router.get('/api/v1/requests/<id>', (Request r, String id) async {
    final v = await s.request(user(r), id);
    return json({
      ...v,
      'events': await s.db.rows(
        'SELECT e.*,u.name AS actor_name FROM events e JOIN users u ON u.id=e.actor WHERE e.request=? ORDER BY e.created,e.rowid',
        [id],
      ),
      'documents': await s.db.rows(
        'SELECT d.* FROM documents d JOIN attachments a ON a.document=d.id WHERE a.request=?',
        [id],
      ),
    });
  });
  router.post('/api/v1/requests/<id>/actions', (Request r, String id) async {
    await s.action(user(r), id, await body(r));
    return json(await s.one('requests', id));
  });
  router.post('/api/v1/requests/<id>/documents', (Request r, String id) async {
    await s.db.transaction(() async {
      final v = await s.request(user(r), id);
      if (v['state'] == 'Concluída')
        throw ApiError(409, 'Solicitação concluída.');
      await s.attach(user(r), id, s.text(await body(r), 'document'));
    });
    return json({'attached': true});
  });
  router.post('/api/v1/requests/<id>/pdf', (Request r, String id) async {
    final v = await s.request(user(r), id);
    final u = await s.one('users', v['requester']);
    final name = v['student'] == null
        ? u['name']
        : (await s.one('students', v['student']))['name'];
    final bytes = await requestPdf(name, v['subject'], v['description']);
    return Response.ok(bytes, headers: {'content-type': 'application/pdf'});
  });
  router.post('/api/v1/reset', (Request r) async {
    if (!s.demo)
      throw ApiError(
        403,
        'Restauração disponível apenas quando o servidor é iniciado com --demo.',
      );
    if (!s.admin(user(r))) throw ApiError(403, 'Use o perfil Administração.');
    if ((await body(r))['confirmation'] != 'RESTAURAR')
      throw ApiError(400, 'Confirmação necessária.');
    final previous = await s.db.rows('SELECT storage FROM documents');
    await s.db.transaction(() async {
      for (final t in [
        'absence_justifications',
        'assessment_events',
        'grades',
        'assessments',
        'timetable_slots',
        'lesson_events',
        'attendance',
        'lessons',
        'journals',
        'teacher_profiles',
        'course_components',
        'subjects',
        'sessions',
        'credentials',
        'student_access',
        'enrollment_events',
        'enrollments',
        'class_groups',
        'courses',
        'attachments',
        'events',
        'requests',
        'documents',
        'requirements',
        'students',
        'document_templates',
      ]) {
        await s.db.exec('DELETE FROM $t');
      }
      while ((await s.db.rows('SELECT id FROM folders LIMIT 1')).isNotEmpty) {
        await s.db.exec(
          'DELETE FROM folders WHERE id NOT IN (SELECT parent FROM folders WHERE parent IS NOT NULL)',
        );
      }
      await s.db.exec('DELETE FROM users');
      await s.seed(demo: true);
    });
    for (final d in previous) {
      final f = File('${s.files.path}/${d['storage']}');
      if (await f.exists()) await f.delete();
    }
    return json({'restored': true});
  });
  return (r) async {
    final origin = r.headers['origin'];
    final originAllowed =
        origin == null ||
        origin == r.requestedUri.origin ||
        origin == allowedOrigin;
    final cors = {
      if (origin != null && originAllowed)
        'access-control-allow-origin': origin,
      'vary': 'Origin',
      'access-control-allow-headers': 'Content-Type, X-Profile, Authorization',
      'access-control-allow-methods': 'GET, POST, PATCH, DELETE, OPTIONS',
    };
    Response response;
    try {
      if (!originAllowed)
        throw ApiError(
          403,
          'Origem não autorizada. Use a interface da instalação.',
        );
      if (r.method == 'OPTIONS') return Response.ok('', headers: cors);
      if (r.url.path == 'health' ||
          [
            'api/v1/auth/status',
            'api/v1/auth/login',
            'api/v1/auth/setup',
          ].contains(r.url.path)) {
        response = await router(r);
      } else if (!s.demo) {
        final authenticated = await auth.authenticate(
          r.headers['authorization'],
        );
        response = await router(r.change(context: {'user': authenticated}));
      } else {
        final profile = r.headers['x-profile'] ?? '';
        var users = await s.db.rows('SELECT * FROM users WHERE id=?', [
          profile,
        ]);
        if (users.isEmpty && r.url.path == 'api/v1/session')
          users = await s.db.rows('SELECT * FROM users ORDER BY id LIMIT 1');
        if (users.isEmpty)
          throw ApiError(401, 'Selecione um perfil demonstrativo.');
        response = await router(r.change(context: {'user': users.first}));
      }
    } on ApiError catch (e) {
      response = json({'error': e.message}, status: e.status);
    } on FormatException {
      response = json({'error': 'Dados inválidos.'}, status: 400);
    } on TypeError {
      response = json({'error': 'Tipo de campo inválido.'}, status: 400);
    } catch (e, st) {
      final detail = e.toString();
      final unique = detail.contains('UNIQUE constraint');
      final constraint = unique || detail.contains('FOREIGN KEY constraint');
      String? problem;
      if (unique) {
        problem = detail.contains('absence_justifications.lesson')
            ? 'Esta falta já possui uma justificativa. Consulte seu andamento.'
            : detail.contains('course_components.course')
            ? 'Este componente já está cadastrado nesta fase do curso.'
            : detail.contains('subjects.name')
            ? 'Já existe uma disciplina com este nome.'
            : detail.contains('teacher_profiles.staff_code')
            ? 'Este registro funcional já pertence a outro professor.'
            : detail.contains('journals.class_group')
            ? 'A turma já possui um diário para este componente.'
            : detail.contains('enrollments.student')
            ? 'O aluno já possui matrícula neste curso, ano e período.'
            : detail.contains('credentials.login')
            ? 'Este usuário já existe.'
            : detail.contains('students.registration')
            ? 'Esta matrícula ou identificação já pertence a outro aluno.'
            : detail.contains('class_groups.course')
            ? 'Já existe uma turma com este nome no curso, ano e período.'
            : detail.contains('document_templates.name')
            ? 'Já existe um modelo com este nome.'
            : detail.contains('courses.name')
            ? 'Este curso e modalidade já estão cadastrados.'
            : 'Nome já existe neste local.';
      } else if (constraint) {
        problem = 'O registro possui vínculos que impedem esta operação.';
      }
      if (!constraint) stderr.writeln('$e\n$st');
      response = json({
        'error': problem ?? 'Não foi possível concluir a operação.',
      }, status: constraint ? 409 : 500);
    }
    return response.change(
      headers: {
        ...cors,
        'x-content-type-options': 'nosniff',
        'cache-control': 'no-store',
      },
    );
  };
}

String? detect(List<int> h) {
  if (h.length < 4) return null;
  if (ascii.decode(h.take(4).toList(), allowInvalid: true) == '%PDF')
    return 'application/pdf';
  if (h[0] == 137 && h[1] == 80 && h[2] == 78 && h[3] == 71) return 'image/png';
  if (h[0] == 255 && h[1] == 216 && h[2] == 255) return 'image/jpeg';
  if (h.length >= 12 &&
      ascii.decode(h.sublist(0, 4), allowInvalid: true) == 'RIFF' &&
      ascii.decode(h.sublist(8, 12), allowInvalid: true) == 'WEBP')
    return 'image/webp';
  return null;
}
