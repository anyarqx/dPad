import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf_io.dart' as io;
import 'package:test/test.dart';

import '../lib/src/app.dart';
import '../lib/src/database.dart';
import '../lib/src/store.dart';
import '../lib/src/pdf.dart';

class Installation {
  late Directory dir;
  late Database db;
  late Store store;
  late HttpServer server;
  late String base, admin;
  final password = 'senha de teste longa e privada';
  Future<void> start() async {
    dir = await Directory.systemTemp.createTemp('dpad-workflows-');
    db = Database(File('${dir.path}/database.sqlite'));
    final files = Directory('${dir.path}/files');
    await files.create();
    store = Store(db, files);
    await store.seed();
    server = await io.serve(buildHandler(store), '127.0.0.1', 0);
    base = 'http://127.0.0.1:${server.port}/api/v1';
    final setup = await send(
      'POST',
      'auth/setup',
      data: {
        'name': 'Administração do teste',
        'login': 'administrador',
        'password': password,
      },
      authenticated: false,
      status: 201,
    );
    admin = setup['token'];
  }

  Future<void> close() async {
    await server.close(force: true);
    await db.close();
    await dir.delete(recursive: true);
  }

  Future<http.Response> call(
    String method,
    String path, {
    Map<String, dynamic>? data,
    String? token,
    bool authenticated = true,
    Map<String, String> extra = const {},
  }) async {
    final request = http.Request(method, Uri.parse('$base/$path'))
      ..headers.addAll({
        'Content-Type': 'application/json',
        if (authenticated) 'Authorization': 'Bearer ${token ?? admin}',
        ...extra,
      });
    if (data != null) request.body = jsonEncode(data);
    return http.Response.fromStream(await request.send());
  }

  Future<dynamic> send(
    String method,
    String path, {
    Map<String, dynamic>? data,
    String? token,
    bool authenticated = true,
    int status = 200,
  }) async {
    final response = await call(
      method,
      path,
      data: data,
      token: token,
      authenticated: authenticated,
    );
    expect(response.statusCode, status, reason: response.body);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> account(
    String login,
    String role, {
    List<String> students = const [],
  }) async {
    final user = await send(
      'POST',
      'accounts',
      data: {
        'name': 'Pessoa $login',
        'login': login,
        'role': role,
        'password': password,
        'students': students,
      },
      status: 201,
    );
    final session = await send(
      'POST',
      'auth/login',
      data: {'login': login, 'password': password},
      authenticated: false,
    );
    return {...Map<String, dynamic>.from(user), 'token': session['token']};
  }

  Future<Map<String, dynamic>> course({
    String name = 'Curso de teste',
    String modality = 'Formação regular',
    String? template,
  }) async => Map<String, dynamic>.from(
    await send(
      'POST',
      'courses',
      data: {'name': name, 'modality': modality, 'template': template},
      status: 201,
    ),
  );
  Future<Map<String, dynamic>> group(
    Map course, {
    String name = 'Turma de teste',
    String period = 'Anual',
    int capacity = 40,
  }) async => Map<String, dynamic>.from(
    await send(
      'POST',
      'classes',
      data: {
        'course': course['id'],
        'name': name,
        'school_year': DateTime.now().year,
        'period_label': period,
        'grade': 'Etapa inicial',
        'shift': 'Matutino',
        'capacity': capacity,
      },
      status: 201,
    ),
  );
  Future<Map<String, dynamic>> student(
    Map group, {
    String name = 'Pessoa cadastrada',
    String? registration,
  }) async => Map<String, dynamic>.from(
    await send(
      'POST',
      'students',
      data: {
        'name': name,
        'registration': registration ?? 'REG-$name',
        'class_group': group['id'],
      },
      status: 201,
    ),
  );
  Future<Map<String, dynamic>> enrollment(Map student) async =>
      Map<String, dynamic>.from(
        (await send(
          'GET',
          'students/${student['id']}/enrollments',
        ))['items'].first,
      );
  Future<Map<String, dynamic>> activate(Map student, {String note = ''}) async {
    final e = await enrollment(student);
    return Map<String, dynamic>.from(
      await send(
        'POST',
        'enrollments/${e['id']}/actions',
        data: {'revision': e['revision'], 'action': 'activate', 'note': note},
      ),
    );
  }

  Future<Map<String, dynamic>> upload(Map student, {String? token}) async {
    final bytes = await requestPdf(
      'Pessoa de teste',
      'Documento para teste',
      'Arquivo temporário de teste.',
    );
    final uri = Uri.parse('$base/documents').replace(
      queryParameters: {
        'folder': student['folder'],
        'type': 'CPF',
        'name': 'documento.pdf',
      },
    );
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${token ?? admin}'
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: 'documento.pdf'),
      );
    final response = await http.Response.fromStream(await request.send());
    expect(response.statusCode, 201, reason: response.body);
    return jsonDecode(response.body);
  }
}

void main() {
  late Installation app;
  setUp(() async {
    app = Installation();
    await app.start();
  });
  tearDown(() async => app.close());
  test('login limita tentativas e não permite contornar o bloqueio com a senha correta', () async {
    for (var i = 0; i < 5; i++) {
      await app.send(
        'POST',
        'auth/login',
        authenticated: false,
        data: {
          'login': 'administrador',
          'password': 'senha incorreta de teste',
        },
        status: 401,
      );
    }
    await app.send(
      'POST',
      'auth/login',
      authenticated: false,
      data: {'login': 'administrador', 'password': app.password},
      status: 429,
    );
    expect((await app.send('GET', 'session'))['user']['id'], 'local');
  }, timeout: Timeout(const Duration(minutes: 2)));
  test('contas reais: senha, autorização, revogação, expiração, último administrador e origem', () async {
    expect(
      (await app.call(
        'GET',
        'students',
        authenticated: false,
        extra: {'X-Profile': 'local'},
      )).statusCode,
      401,
    );
    await app.send(
      'POST',
      'auth/setup',
      authenticated: false,
      data: {
        'name': 'Outra pessoa',
        'login': 'outra',
        'password': app.password,
      },
      status: 409,
    );
    final teacher = await app.account('professor', 'professor');
    await app.send('GET', 'accounts', token: teacher['token'], status: 403);
    expect(
      jsonDecode(
        (await app.call(
          'GET',
          'students',
          token: teacher['token'],
          extra: {'X-Profile': 'local'},
        )).body,
      ),
      isEmpty,
    );
    final stored = (await app.db.rows(
      'SELECT * FROM credentials WHERE user=?',
      [teacher['id']],
    )).single;
    expect(stored['password_hash'], isNot(app.password));
    expect(stored['salt'], isNotEmpty);
    final session = (await app.db.rows(
      'SELECT token_hash FROM sessions WHERE user=?',
      [teacher['id']],
    )).single;
    expect(session['token_hash'], isNot(teacher['token']));
    await app.send(
      'PATCH',
      'accounts/local',
      data: {'revision': 1, 'role': 'professor', 'enabled': 1},
      status: 409,
    );
    await app.send(
      'PATCH',
      'accounts/${teacher['id']}',
      data: {'revision': 1, 'password': 'outra senha longa para teste'},
    );
    await app.send('GET', 'session', token: teacher['token'], status: 401);
    await app.send(
      'POST',
      'auth/login',
      authenticated: false,
      data: {'login': 'professor', 'password': app.password},
      status: 401,
    );
    final next = await app.send(
      'POST',
      'auth/login',
      authenticated: false,
      data: {'login': 'professor', 'password': 'outra senha longa para teste'},
    );
    await app.send('POST', 'auth/logout', token: next['token']);
    await app.send('GET', 'session', token: next['token'], status: 401);
    await app.db.exec(
      "UPDATE sessions SET expires='2000-01-01T00:00:00Z' WHERE user='local'",
    );
    await app.send('GET', 'session', status: 401);
    expect(
      (await app.call(
        'POST',
        'auth/login',
        authenticated: false,
        data: {'login': 'administrador', 'password': app.password},
        extra: {'Origin': 'https://origem-invasora.invalid'},
      )).statusCode,
      403,
    );
  }, timeout: Timeout(const Duration(minutes: 3)));
  test('modelo configurável e ciclo por curso, período e turma; pendências, vagas e histórico', () async {
    final template = await app.send(
      'POST',
      'templates',
      data: {
        'name': 'Modelo do teste',
        'documents': ['CPF'],
        'extra_fields': ['Contato de emergência'],
        'required_identity': ['birth_date'],
      },
      status: 201,
    );
    final course = await app.course(template: template['id']);
    final group = await app.group(course, capacity: 1);
    final target = await app.group(course, name: 'Outra turma');
    final later = await app.group(course, period: 'Segundo período');
    final p = await app.student(group, name: 'Pessoa A');
    final other = await app.student(group, name: 'Pessoa B');
    expect(p['requirements'], hasLength(1));
    final e = await app.enrollment(p);
    await app.send(
      'POST',
      'enrollments/${e['id']}/actions',
      data: {'revision': 1, 'action': 'activate'},
      status: 409,
    );
    final pending = await app.send('GET', 'students/${p['id']}/enrollments');
    expect(pending['pending'], hasLength(3));
    final doc = await app.upload(p);
    await app.send(
      'POST',
      'documents/${doc['id']}/review',
      data: {'revision': 1, 'status': 'Conferido'},
    );
    await app.send(
      'PATCH',
      'students/${p['id']}',
      data: {
        'revision': 1,
        'birth_date': '2010-01-01',
        'extra': {'Contato de emergência': 'Contato preenchido'},
      },
    );
    expect(
      (await app.send('GET', 'students/${p['id']}/enrollments'))['pending'],
      isEmpty,
    );
    final active = await app.activate(p);
    expect(active['state'], 'Ativa');
    final oe = await app.enrollment(other);
    await app.send(
      'POST',
      'enrollments/${oe['id']}/actions',
      data: {
        'revision': 1,
        'action': 'activate',
        'note': 'Conferência excepcional documentada',
      },
      status: 409,
    );
    await app.send(
      'POST',
      'enrollments/${active['id']}/actions',
      data: {'revision': 1, 'action': 'finish', 'note': 'Fim do período'},
      status: 409,
    );
    await app.send(
      'POST',
      'enrollments/${active['id']}/actions',
      data: {
        'revision': 2,
        'action': 'move',
        'class_group': later['id'],
        'note': 'Mudança de turma',
      },
      status: 409,
    );
    final moved = await app.send(
      'POST',
      'enrollments/${active['id']}/actions',
      data: {
        'revision': 2,
        'action': 'move',
        'class_group': target['id'],
        'note': 'Mudança autorizada de turma',
      },
    );
    await app.activate(other, note: 'Pendências acompanhadas pela secretaria');
    await app.send(
      'POST',
      'enrollments/${moved['id']}/actions',
      data: {
        'revision': 3,
        'action': 'finish',
        'note': 'Período local encerrado',
      },
    );
    await app.send(
      'POST',
      'enrollments',
      data: {'student': p['id'], 'class_group': later['id']},
      status: 201,
    );
    await app.send(
      'POST',
      'enrollments',
      data: {'student': p['id'], 'class_group': later['id']},
      status: 409,
    );
    final history = await app.send('GET', 'students/${p['id']}/enrollments');
    expect(history['items'], hasLength(2));
    expect(
      (history['items'] as List)
          .where((v) => v['state'] == 'Encerrada')
          .single['events'],
      hasLength(4),
    );
    await app.send(
      'PATCH',
      'templates/${template['id']}',
      data: {
        'revision': 1,
        'name': 'Modelo revisado',
        'documents': ['RG'],
        'extra_fields': [],
        'required_identity': [],
      },
    );
    expect(
      (await app.send(
        'GET',
        'students/${p['id']}',
      ))['requirements'].single['type'],
      'CPF',
    );
    final next = await app.student(target, name: 'Pessoa C');
    expect(next['requirements'].single['type'], 'RG');
    expect(
      (await app.send('GET', 'students/${p['id']}'))['folder'],
      p['folder'],
    );
    await app.send(
      'PATCH',
      'classes/${group['id']}',
      data: {'revision': 1, 'archived': 1},
      status: 409,
    );
    expect((await app.db.rows('PRAGMA user_version')).single.values.single, 1);
  }, timeout: Timeout(const Duration(minutes: 3)));
  test('diário real: atribuição docente, frequência completa, revisão e publicação individual', () async {
    final course = await app.course();
    final group = await app.group(course);
    final p = await app.student(group, name: 'Pessoa A'),
        other = await app.student(group, name: 'Pessoa B');
    final first = await app.activate(p), second = await app.activate(other);
    final teacher = await app.account('docente', 'professor'),
        outsider = await app.account('outro-docente', 'professor');
    final pupil = await app.account('estudante', 'aluno', students: [p['id']]);
    final guardian = await app.account(
      'responsavel',
      'responsavel',
      students: [p['id']],
    );
    final subject = await app.send(
      'POST',
      'subjects',
      data: {'name': 'Componente criado no cadastro'},
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
    final journal = await app.send(
      'POST',
      'journals',
      data: {
        'class_group': group['id'],
        'component': component['id'],
        'teacher': teacher['id'],
      },
      status: 201,
    );
    await app.send(
      'GET',
      'journals/${journal['id']}',
      token: outsider['token'],
      status: 403,
    );
    await app.send(
      'GET',
      'students/${p['id']}',
      token: teacher['token'],
      status: 403,
    );
    await app.send(
      'GET',
      'students/${other['id']}',
      token: pupil['token'],
      status: 403,
    );
    final selected = await app.send(
      'GET',
      'journals/${journal['id']}',
      token: teacher['token'],
    );
    expect(selected['roster'], hasLength(2));
    final body = {
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'units': 2,
      'content': 'Atividades registradas no diário.',
      'attendance': [
        {'enrollment': first['id'], 'status': 'Presente'},
        {'enrollment': second['id'], 'status': 'Ausente'},
      ],
    };
    await app.send(
      'POST',
      'journals/${journal['id']}/lessons',
      token: teacher['token'],
      data: {
        ...body,
        'attendance': [
          {'enrollment': first['id'], 'status': 'Presente'},
        ],
      },
      status: 400,
    );
    final lesson = await app.send(
      'POST',
      'journals/${journal['id']}/lessons',
      token: teacher['token'],
      data: body,
      status: 201,
    );
    expect(
      (await app.send(
        'GET',
        'journals/${journal['id']}',
        token: pupil['token'],
      ))['lessons'],
      isEmpty,
    );
    await app.send(
      'POST',
      'lessons/${lesson['id']}/actions',
      token: teacher['token'],
      data: {'revision': 1, 'action': 'submit'},
    );
    await app.send(
      'PATCH',
      'lessons/${lesson['id']}',
      token: teacher['token'],
      data: {...body, 'revision': 2},
      status: 409,
    );
    await app.send(
      'POST',
      'lessons/${lesson['id']}/actions',
      token: teacher['token'],
      data: {'revision': 2, 'action': 'publish'},
      status: 403,
    );
    await app.send(
      'POST',
      'lessons/${lesson['id']}/actions',
      data: {'revision': 2, 'action': 'publish'},
    );
    for (final account in [pupil, guardian]) {
      final visible = await app.send(
        'GET',
        'journals/${journal['id']}',
        token: account['token'],
      );
      expect(visible['lessons'], hasLength(1));
      expect(visible['lessons'].single['attendance'], hasLength(1));
      expect(
        visible['lessons'].single['attendance'].single['student'],
        p['id'],
      );
      expect(visible['roster'], hasLength(1));
    }
    await app.send(
      'POST',
      'enrollments/${first['id']}/actions',
      data: {
        'revision': 2,
        'action': 'transfer',
        'note': 'Transferência registrada no atendimento.',
      },
    );
    final later = await app.send(
      'POST',
      'journals/${journal['id']}/lessons',
      token: teacher['token'],
      data: {
        ...body,
        'content': 'Aula após a transferência.',
        'attendance': [
          {'enrollment': second['id'], 'status': 'Presente'},
        ],
      },
      status: 201,
    );
    await app.send(
      'POST',
      'lessons/${later['id']}/actions',
      token: teacher['token'],
      data: {'revision': 1, 'action': 'submit'},
    );
    await app.send(
      'POST',
      'lessons/${later['id']}/actions',
      data: {'revision': 2, 'action': 'publish'},
    );
    final historical = await app.send(
      'GET',
      'journals/${journal['id']}',
      token: pupil['token'],
    );
    expect(historical['lessons'], hasLength(1));
    expect(historical['lessons'].single['id'], lesson['id']);
    await app.send(
      'POST',
      'lessons/${lesson['id']}/actions',
      data: {
        'revision': 3,
        'action': 'return',
        'note': 'Ajustar o registro de conteúdo',
      },
    );
    expect(
      (await app.send(
        'GET',
        'journals/${journal['id']}',
        token: pupil['token'],
      ))['lessons'],
      isEmpty,
    );
    final audit = (await app.send(
      'GET',
      'journals/${journal['id']}',
    ))['lessons'].singleWhere((l) => l['id'] == lesson['id']);
    expect(audit['events'], hasLength(4));
    await app.send(
      'PATCH',
      'lessons/${lesson['id']}',
      token: teacher['token'],
      data: {
        ...body,
        'content': 'Conteúdo corrigido e conferido.',
        'revision': 4,
      },
    );
    await app.send(
      'PATCH',
      'accounts/${teacher['id']}',
      data: {
        'revision': 1,
        'role': 'aluno',
        'students': [p['id']],
      },
    );
    await app.send('GET', 'session', token: teacher['token'], status: 401);
    final reassigned = await app.send(
      'POST',
      'auth/login',
      authenticated: false,
      data: {'login': 'docente', 'password': app.password},
    );
    final ownClass = await app.send(
      'GET',
      'classes/${group['id']}',
      token: reassigned['token'],
    );
    expect(ownClass['enrollments'], hasLength(1));
    expect(ownClass['enrollments'].single['student'], p['id']);
    expect(
      (await app.send(
        'GET',
        'journals/${journal['id']}',
        token: reassigned['token'],
      ))['canEdit'],
      false,
    );
  }, timeout: Timeout(const Duration(minutes: 3)));
  test('solicitação com contas reais: aluno, secretaria, complemento, encaminhamento e conclusão', () async {
    final course = await app.course();
    final group = await app.group(course);
    final p = await app.student(group);
    final pupil = await app.account(
      'solicitante',
      'aluno',
      students: [p['id']],
    );
    final secretary = await app.account('atendente', 'secretaria'),
        coord = await app.account('coordenador', 'coordenacao');
    final document = await app.upload(p, token: pupil['token']);
    final body = {
      'operation': 'chave-da-operacao-repetida',
      'student': p['id'],
      'service': 'declaracao',
      'subject': 'Declaração solicitada',
      'description': 'Pedido administrativo registrado pelo aluno.',
      'documents': [document['id']],
    };
    final request = await app.send(
      'POST',
      'requests',
      token: pupil['token'],
      data: body,
      status: 201,
    );
    final duplicate = await app.send(
      'POST',
      'requests',
      token: pupil['token'],
      data: body,
      status: 201,
    );
    expect(duplicate['id'], request['id']);
    final path = 'requests/${request['id']}/actions';
    await app.send(
      'POST',
      path,
      token: pupil['token'],
      data: {'revision': 1, 'action': 'start'},
      status: 403,
    );
    await app.send(
      'POST',
      path,
      token: secretary['token'],
      data: {'revision': 1, 'action': 'start'},
    );
    await app.send(
      'POST',
      path,
      token: secretary['token'],
      data: {
        'revision': 2,
        'action': 'ask',
        'text': 'Confirme a finalidade do documento.',
      },
    );
    await app.send(
      'POST',
      path,
      token: pupil['token'],
      data: {
        'revision': 3,
        'action': 'complement',
        'text': 'Documento para comprovação de vínculo.',
      },
    );
    await app.send(
      'POST',
      path,
      token: secretary['token'],
      data: {
        'revision': 4,
        'action': 'forward',
        'department': 'coordenacao',
        'text': 'Conferência da coordenação solicitada.',
      },
    );
    await app.send(
      'GET',
      'requests/${request['id']}',
      token: secretary['token'],
      status: 403,
    );
    final attached = await app.call(
      'GET',
      'documents/${document['id']}/content',
      token: coord['token'],
    );
    expect(attached.bodyBytes.take(4), [37, 80, 68, 70]);
    await app.send(
      'POST',
      path,
      token: coord['token'],
      data: {'revision': 5, 'action': 'start'},
    );
    await app.send(
      'POST',
      path,
      token: coord['token'],
      data: {
        'revision': 6,
        'action': 'complete',
        'text': 'Atendimento concluído com conferência.',
      },
    );
    final history = await app.send(
      'GET',
      'requests/${request['id']}',
      token: pupil['token'],
    );
    expect(history['state'], 'Concluída');
    expect(history['requester_name'], pupil['name']);
    expect(history['student_name'], p['name']);
    expect(history['events'], hasLength(8));
    expect(history['documents'], hasLength(1));
  }, timeout: Timeout(const Duration(minutes: 3)));
}
