import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../lib/src/pdf.dart';

import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as io;

import '../lib/src/app.dart';
import '../lib/src/database.dart';
import '../lib/src/store.dart';
import 'workflows_test.dart' show Installation;

String route(String resource, Map row, [String suffix = '']) =>
    resource + '/' + row['id'] + suffix;
void main() {
  late Installation app;
  late Map course,
      group,
      p,
      other,
      teacher,
      pupil,
      coordinator,
      journal,
      secondEnrollment;
  setUp(() async {
    app = Installation();
    await app.start();
    course = await app.course();
    group = await app.group(course);
    p = await app.student(group, name: 'Pessoa da matrícula A');
    other = await app.student(group, name: 'Pessoa da matrícula B');
    await app.activate(p);
    secondEnrollment = await app.activate(other);
    teacher = await app.account('professor-teste', 'professor');
    pupil = await app.account('estudante-teste', 'aluno', students: [p['id']]);
    coordinator = await app.account('coordenacao-teste', 'coordenacao');
    final subject = await app.send(
      'POST',
      'subjects',
      data: {'name': 'Disciplina cadastrada'},
      status: 201,
    );
    final component = await app.send(
      'POST',
      'components',
      data: {
        'course': course['id'],
        'subject': subject['id'],
        'phase': 'Fase 1',
        'hours': 40,
        'lesson_minutes': 45,
      },
      status: 201,
    );
    journal = await app.send(
      'POST',
      'journals',
      data: {
        'class_group': group['id'],
        'component': component['id'],
        'teacher': teacher['id'],
      },
      status: 201,
    );
  });
  tearDown(() async => app.close());

  test('notas: lista, limites, concorrência, publicação privada, devolução e persistência', () async {
    final roster =
        (await app.send(
              'GET',
              route('journals', journal),
              token: teacher['token'],
            ))['roster']
            as List;
    await app.send(
      'PATCH',
      route('teachers', teacher),
      token: teacher['token'],
      data: {'revision': 0, 'qualification': 'Formação registrada'},
      status: 403,
    );
    await app.send(
      'PATCH',
      route('teachers', teacher),
      token: coordinator['token'],
      data: {
        'revision': 0,
        'staff_code': 'DOC-01',
        'qualification': 'Formação registrada',
        'phone': 'Contato profissional',
        'email': 'docente@example.invalid',
      },
    );
    final catalog = await app.send(
      'GET',
      'academic/catalog',
      token: coordinator['token'],
    );
    expect(catalog['teachers'].single['staff_code'], 'DOC-01');
    expect(catalog['teachers'].single['qualification'], 'Formação registrada');
    await app.send(
      'PATCH',
      route('teachers', teacher),
      data: {'revision': 0},
      status: 409,
    );
    await app.send(
      'PATCH',
      route('students', p),
      data: {'revision': p['revision'], 'sex': 'Inválido'},
      status: 400,
    );
    final updated = await app.send(
      'PATCH',
      route('students', p),
      data: {
        'revision': p['revision'],
        'sex': 'Feminino',
        'social_name': 'Nome informado',
        'birthplace': 'Município de teste / PA',
        'nationality': 'Brasileira',
        'parentage': 'Filiação informada',
        'address': 'Endereço de teste',
      },
    );
    expect(updated['sex'], 'Feminino');
    expect(updated['address'], 'Endereço de teste');
    final body = <String, dynamic>{
      'label': 'Avaliação prática',
      'stage': 'Unidade 1',
      'held_on': DateTime.now().toIso8601String().substring(0, 10),
      'max_score': 20,
      'weight': 2,
      'grades': [
        for (final r in roster)
          {'enrollment': r['id'], 'status': 'Pendente', 'score': null},
      ],
    };
    await app.send(
      'POST',
      route('journals', journal, '/assessments'),
      data: {...body, 'grades': []},
      status: 400,
    );
    await app.send(
      'POST',
      route('journals', journal, '/assessments'),
      data: {
        ...body,
        'grades': [
          for (final r in roster)
            {'enrollment': r['id'], 'status': 'Lançada', 'score': 21},
        ],
      },
      status: 400,
    );
    final sec = await app.account('secretaria-teste', 'secretaria');
    await app.send(
      'POST',
      route('journals', journal, '/assessments'),
      data: body,
      token: sec['token'],
      status: 403,
    );
    var a = await app.send(
      'POST',
      route('journals', journal, '/assessments'),
      data: body,
      token: teacher['token'],
      status: 201,
    );
    await app.send(
      'POST',
      route('assessments', a, '/actions'),
      data: {'action': 'submit', 'revision': a['revision']},
      token: teacher['token'],
      status: 409,
    );
    expect(
      (await app.send(
        'GET',
        route('students', p, '/report'),
        token: pupil['token'],
      ))['grades'],
      isEmpty,
    );
    await app.send(
      'PATCH',
      route('assessments', a),
      data: {...body, 'revision': 99},
      token: teacher['token'],
      status: 409,
    );
    a = await app.send(
      'PATCH',
      route('assessments', a),
      token: teacher['token'],
      data: {
        ...body,
        'revision': a['revision'],
        'grades': [
          for (final r in roster)
            {
              'enrollment': r['id'],
              'status': r['student'] == p['id'] ? 'Lançada' : 'Ausente',
              'score': r['student'] == p['id'] ? 16 : null,
            },
        ],
      },
    );
    a = await app.send(
      'POST',
      route('assessments', a, '/actions'),
      data: {'action': 'submit', 'revision': a['revision']},
      token: teacher['token'],
    );
    await app.send(
      'POST',
      route('assessments', a, '/actions'),
      data: {'action': 'publish', 'revision': a['revision']},
      token: teacher['token'],
      status: 403,
    );
    a = await app.send(
      'POST',
      route('assessments', a, '/actions'),
      data: {'action': 'publish', 'revision': a['revision']},
      token: coordinator['token'],
    );
    final own = await app.send(
      'GET',
      route('journals', journal, '/assessments'),
      token: pupil['token'],
    );
    expect(own.single['grades'], hasLength(1));
    expect(own.single['grades'].single['student'], p['id']);
    await app.send(
      'GET',
      route('students', other, '/report'),
      token: pupil['token'],
      status: 403,
    );
    final pdf = await app.call(
      'GET',
      route('students', p, '/report.pdf'),
      token: pupil['token'],
    );
    expect(pdf.statusCode, 200);
    expect(pdf.bodyBytes.take(4), [37, 80, 68, 70]);
    expect(
      (await app.call(
        'GET',
        route('students', p, '/report.pdf'),
        authenticated: false,
      )).statusCode,
      401,
    );
    a = await app.send(
      'POST',
      route('assessments', a, '/actions'),
      data: {
        'action': 'return',
        'revision': a['revision'],
        'note': 'Conferir registro da avaliação',
      },
      token: coordinator['token'],
    );
    expect(
      (await app.send(
        'GET',
        route('students', p, '/report'),
        token: pupil['token'],
      ))['grades'],
      isEmpty,
    );
    expect(a['state'], 'Rascunho');
    await app.server.close(force: true);
    await app.db.close();
    app.db = Database(File(app.dir.path + '/database.sqlite'));
    app.store = Store(app.db, Directory(app.dir.path + '/files'));
    app.server = await io.serve(buildHandler(app.store), '127.0.0.1', 0);
    app.base = 'http://127.0.0.1:' + app.server.port.toString() + '/api/v1';
    final persisted = await app.send(
      'GET',
      route('journals', journal, '/assessments'),
      token: teacher['token'],
    );
    expect(persisted.single['grades'], hasLength(2));
    expect(persisted.single['events'], hasLength(5));
    expect(
      persisted.single['grades'].firstWhere(
        (g) => g['student'] == p['id'],
      )['score'],
      16,
    );
  }, timeout: const Timeout(Duration(minutes: 2)));

  test(
    'horários: curso/fase, conflito docente, vigência e edição concorrente',
    () async {
      final year = DateTime.now().year;
      final slot = <String, dynamic>{
        'journal': journal['id'],
        'weekday': 1,
        'start_minute': 435,
        'end_minute': 480,
        'valid_from': '$year-01-01',
        'valid_to': '$year-06-30',
        'room': 'Sala 2',
      };
      final first = await app.send('POST', 'schedule', data: slot, status: 201);
      await app.send('POST', 'schedule', data: slot, status: 409);
      final anotherGroup = await app.group(course, name: 'Outra turma'),
          wrongCourse = await app.course(name: 'Outro curso');
      final subject = await app.send(
        'POST',
        'subjects',
        data: {'name': 'Outro componente'},
        status: 201,
      );
      final component = await app.send(
        'POST',
        'components',
        data: {
          'course': course['id'],
          'subject': subject['id'],
          'phase': 'Fase 2',
          'hours': 60,
          'lesson_minutes': 45,
        },
        status: 201,
      );
      final otherJournal = await app.send(
        'POST',
        'journals',
        data: {
          'class_group': anotherGroup['id'],
          'component': component['id'],
          'teacher': teacher['id'],
        },
        status: 201,
      );
      final wrongGroup = await app.group(wrongCourse);
      await app.send(
        'POST',
        'journals',
        data: {
          'class_group': wrongGroup['id'],
          'component': component['id'],
          'teacher': teacher['id'],
        },
        status: 400,
      );
      await app.send(
        'PATCH',
        route('components', component),
        data: {...component, 'hours': 80},
        status: 409,
      );
      await app.send(
        'POST',
        'schedule',
        data: {...slot, 'journal': otherJournal['id'], 'room': 'Sala 9'},
        status: 409,
      );
      final next = await app.send(
        'POST',
        'schedule',
        data: {
          ...slot,
          'journal': otherJournal['id'],
          'valid_from': '$year-07-01',
          'valid_to': '$year-12-31',
        },
        status: 201,
      );
      await app.send(
        'POST',
        'schedule',
        data: {...slot, 'start_minute': 480, 'end_minute': 525},
        status: 201,
      );
      await app.send(
        'PATCH',
        route('schedule', first),
        data: {...slot, 'revision': 9},
        status: 409,
      );
      await app.send(
        'POST',
        route('schedule', next, '/delete'),
        data: {'revision': next['revision']},
      );
      expect(
        await app.send(
          'GET',
          route('classes', group, '/schedule'),
          token: pupil['token'],
        ),
        hasLength(2),
      );
      await app.send(
        'GET',
        route('classes', anotherGroup, '/schedule'),
        token: pupil['token'],
        status: 403,
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'justificativa preserva falta, isola aluno e impede apagar decisão',
    () async {
      final detail = await app.send(
            'GET',
            route('journals', journal),
            token: teacher['token'],
          ),
          roster = detail['roster'] as List;
      var lesson = await app.send(
        'POST',
        route('journals', journal, '/lessons'),
        token: teacher['token'],
        status: 201,
        data: {
          'date': DateTime.now().toIso8601String().substring(0, 10),
          'units': 2,
          'content': 'Registro do conteúdo',
          'attendance': [
            for (final r in roster)
              {'enrollment': r['id'], 'status': 'Ausente'},
          ],
        },
      );
      lesson = await app.send(
        'POST',
        route('lessons', lesson, '/actions'),
        token: teacher['token'],
        data: {'action': 'submit', 'revision': lesson['revision']},
      );
      lesson = await app.send(
        'POST',
        route('lessons', lesson, '/actions'),
        token: coordinator['token'],
        data: {'action': 'publish', 'revision': lesson['revision']},
      );
      final enrollment = roster.firstWhere(
        (r) => r['student'] == p['id'],
      )['id'];
      await app.send(
        'POST',
        'justifications',
        token: pupil['token'],
        data: {
          'lesson': lesson['id'],
          'enrollment': secondEnrollment['id'],
          'reason': 'Motivo',
        },
        status: 403,
      );
      final proof = await requestPdf(
        'Pessoa da matrícula A',
        'Comprovante',
        'Documento de teste, sem dados reais.',
      );
      final upload =
          http.MultipartRequest(
              'POST',
              Uri.parse(app.base + '/documents').replace(
                queryParameters: {
                  'name': 'comprovante.pdf',
                  'folder': p['folder'],
                  'type': 'Comprovante',
                },
              ),
            )
            ..headers['Authorization'] = 'Bearer ' + pupil['token']
            ..files.add(
              http.MultipartFile.fromBytes(
                'file',
                proof,
                filename: 'comprovante.pdf',
              ),
            );
      final uploaded = await http.Response.fromStream(await upload.send());
      expect(uploaded.statusCode, 201);
      final document = jsonDecode(uploaded.body);
      final j = await app.send(
        'POST',
        'justifications',
        token: pupil['token'],
        data: {
          'lesson': lesson['id'],
          'enrollment': enrollment,
          'reason': 'Necessidade de acompanhamento familiar',
          'document': document['id'],
        },
        status: 201,
      );
      await app.send(
        'POST',
        route('justifications', j, '/review'),
        token: pupil['token'],
        data: {
          'revision': j['revision'],
          'state': 'Deferida',
          'response': 'Texto',
        },
        status: 403,
      );
      await app.send(
        'POST',
        route('justifications', j, '/review'),
        token: coordinator['token'],
        data: {
          'revision': j['revision'],
          'state': 'Deferida',
          'response': 'Recebido e conferido pela coordenação.',
        },
      );
      final received = await app.call(
        'GET',
        route('documents', document, '/content'),
        token: coordinator['token'],
      );
      expect(received.statusCode, 200);
      expect(received.bodyBytes, proof);
      await app.send(
        'GET',
        route('documents', document),
        token: teacher['token'],
        status: 403,
      );
      await app.send('DELETE', route('documents', document), status: 409);
      final report = await app.send(
        'GET',
        route('students', p, '/report'),
        token: pupil['token'],
      );
      expect(report['attendance'].single['status'], 'Justificada');
      expect(report['attendance'].single['units'], 2);
      final otherPupil = await app.account(
        'outro-estudante',
        'aluno',
        students: [other['id']],
      );
      await app.send(
        'GET',
        'justifications?student=' + p['id'],
        token: otherPupil['token'],
        status: 403,
      );
      expect(
        await app.send(
          'GET',
          'justifications?student=' + p['id'],
          token: pupil['token'],
        ),
        hasLength(1),
      );
      final teacherDetail = await app.send(
        'GET',
        route('journals', journal),
        token: teacher['token'],
      );
      expect(
        jsonEncode(teacherDetail),
        isNot(contains('Necessidade de acompanhamento familiar')),
      );
      final published = teacherDetail['lessons'].single;
      final returned = await app.send(
        'POST',
        route('lessons', lesson, '/actions'),
        token: coordinator['token'],
        data: {
          'action': 'return',
          'revision': published['revision'],
          'note': 'Correção do conteúdo',
        },
      );
      await app.send(
        'PATCH',
        route('lessons', lesson),
        token: teacher['token'],
        data: {
          'revision': returned['revision'],
          'date': returned['date'],
          'units': 2,
          'content': 'Conteúdo corrigido',
          'attendance': [
            for (final r in roster)
              {'enrollment': r['id'], 'status': 'Presente'},
          ],
        },
        status: 409,
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
