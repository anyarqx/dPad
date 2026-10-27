import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf_io.dart' as io;
import 'package:test/test.dart';

import '../lib/src/database.dart';
import '../lib/src/store.dart';
import '../lib/src/app.dart';
import '../lib/src/pdf.dart';
import '../lib/src/auth.dart';

void main() {
  late Directory dir;
  late Database db;
  late Store store;
  late HttpServer server;
  late String base;
  final tokens = <String, String>{};
  String? groupId;
  Future<void> setupAuth() async {
    tokens.clear();
    groupId = null;
    final response = await http.post(
      Uri.parse('$base/auth/setup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': 'Administração do teste',
        'login': 'admin-teste',
        'password': 'senha longa de teste',
      }),
    );
    expect(response.statusCode, 201, reason: response.body);
    tokens['local'] = jsonDecode(response.body)['token'];
  }

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dpad-students-');
    db = Database(File('${dir.path}/db.sqlite'));
    final files = Directory('${dir.path}/files');
    await files.create();
    store = Store(db, files);
    await store.seed();
    server = await io.serve(buildHandler(store), '127.0.0.1', 0);
    base = 'http://127.0.0.1:${server.port}/api/v1';
    await setupAuth();
  });
  tearDown(() async {
    await server.close(force: true);
    await db.close();
    await dir.delete(recursive: true);
  });
  Future<http.Response> call(
    String method,
    String path, {
    Map<String, dynamic>? data,
    String user = 'local',
  }) async {
    if (!tokens.containsKey(user)) {
      final auth = Auth(store);
      final h = await auth.hashPassword('senha longa de teste');
      await db.exec(
        'INSERT INTO credentials(user,login,salt,password_hash) VALUES(?,?,?,?)',
        [user, user, h.salt, h.hash],
      );
      tokens[user] = (await auth.issue(user))['token'];
    }
    final r = http.Request(method, Uri.parse('$base/$path'))
      ..headers.addAll({
        'Authorization': 'Bearer ${tokens[user]}',
        'Content-Type': 'application/json',
      });
    if (data != null) r.body = jsonEncode(data);
    return http.Response.fromStream(await r.send());
  }

  Future<Map<String, dynamic>> create(
    String name, {
    String registration = '2026-01',
    String? folder,
    String? linked,
  }) async {
    if (groupId == null) {
      final model = jsonDecode(
        await File('../../assets/templates/pasta-escolar.json').readAsString(),
      ) as Map<String, dynamic>;
      final template = jsonDecode(
        (await call('POST', 'templates', data: model)).body,
      );
      final course = jsonDecode(
        (await call(
          'POST',
          'courses',
          data: {
            'name': 'Curso de teste',
            'modality': 'Modalidade de teste',
            'template': template['id'],
          },
        )).body,
      );
      final group = jsonDecode(
        (await call(
          'POST',
          'classes',
          data: {
            'course': course['id'],
            'name': 'Turma de teste',
            'school_year': 2026,
            'period_label': 'Anual',
            'grade': 'Etapa de teste',
            'shift': 'Matutino',
            'capacity': 40,
          },
        )).body,
      );
      groupId = group['id'];
    }
    final r = await call(
      'POST',
      'students',
      data: {
        'name': name,
        'registration': registration,
        'class_group': groupId,
        'guardian': 'Responsável de teste',
        'extra': {'Transporte': 'Escolar'},
        if (folder != null) 'folder': folder,
      },
    );
    expect(r.statusCode, 201, reason: r.body);
    final person = jsonDecode(r.body) as Map<String, dynamic>;
    if (linked != null)
      await db.exec('INSERT INTO student_access VALUES(?,?)', [
        person['id'],
        linked,
      ]);
    return person;
  }

  test(
    'instalação normal vazia e operador local, sem exemplos automáticos',
    () async {
      final session = jsonDecode((await call('GET', 'session')).body);
      expect(session['demo'], false);
      expect(session['user']['id'], 'local');
      expect((session['users'] as List).length, 1);
      for (final resource in ['students', 'documents', 'folders', 'requests']) {
        expect(jsonDecode((await call('GET', resource)).body), isEmpty);
      }
      expect(store.files.listSync(), isEmpty);
      expect(
        (await call(
          'POST',
          'reset',
          data: {'confirmation': 'RESTAURAR'},
        )).statusCode,
        403,
      );
    },
  );
  test('uma pasta reúne pessoa, dados adicionais e requisitos, sem subpastas por tipo', () async {
    final p = await create('Aluno cadastrado');
    expect(p['extra']['Transporte'], 'Escolar');
    expect(p['guardian'], 'Responsável de teste');
    expect(p['requirements'], hasLength(11));
    final folders = jsonDecode((await call('GET', 'folders')).body) as List;
    expect(folders, hasLength(1));
    expect(folders.single['id'], p['folder']);
    expect(folders.single['parent'], isNull);
    final list = jsonDecode((await call('GET', 'students')).body) as List;
    expect(list.single['required_count'], 11);
    expect(list.single['received_count'], 0);
    expect(
      (await call(
        'POST',
        'students',
        data: {
          'name': 'Outro aluno',
          'registration': '2026-01',
          'class_group': groupId,
        },
      )).statusCode,
      409,
    );
    expect(
      (await call(
        'PATCH',
        'students/${p['id']}',
        data: {
          'revision': 1,
          'name': 'Nome corrigido',
          'birth_date': '2020-02-30',
        },
      )).statusCode,
      400,
    );
    expect(
      (await call(
        'PATCH',
        'students/${p['id']}',
        data: {
          'revision': 1,
          'name': 'Nome corrigido',
          'extra': {'Transporte': 'Próprio', 'Informação': 'Valor'},
        },
      )).statusCode,
      200,
    );
    expect(
      (await call(
        'PATCH',
        'students/${p['id']}',
        data: {'revision': 1, 'name': 'Obsoleto'},
      )).statusCode,
      409,
    );
  });
  test('documento pertence ao aluno e atualiza pendências e conferência a partir dos registros', () async {
    final p = await create('Aluno com documento');
    final bytes = await requestPdf(
      'Pessoa de teste',
      'CPF',
      'Arquivo de teste sem identificadores reais.',
    );
    final upload =
        http.MultipartRequest(
            'POST',
            Uri.parse('$base/documents').replace(
              queryParameters: {
                'name': 'cpf.pdf',
                'folder': p['folder'],
                'type': 'CPF',
              },
            ),
          )
          ..headers['Authorization'] = 'Bearer ${tokens['local']}'
          ..files.add(
            http.MultipartFile.fromBytes('file', bytes, filename: 'cpf.pdf'),
          );
    final result = await http.Response.fromStream(await upload.send());
    expect(result.statusCode, 201);
    final d = jsonDecode(result.body);
    var detail = jsonDecode((await call('GET', 'students/${p['id']}')).body);
    var requirement = (detail['requirements'] as List).singleWhere(
      (r) => r['type'] == 'CPF',
    );
    expect(requirement['status'], 'Aguardando conferência');
    expect(requirement['documents'], hasLength(1));
    expect(detail['documents'].single['id'], d['id']);
    expect(
      (await call(
        'POST',
        'documents/${d['id']}/review',
        data: {'revision': 1, 'status': 'Conferido'},
      )).statusCode,
      200,
    );
    detail = jsonDecode((await call('GET', 'students/${p['id']}')).body);
    requirement = (detail['requirements'] as List).singleWhere(
      (r) => r['type'] == 'CPF',
    );
    expect(requirement['status'], 'Conferido');
    final list = jsonDecode((await call('GET', 'students')).body) as List;
    expect(list.single['received_count'], 1);
    expect(list.single['verified_count'], 1);
    expect(
      (await call(
        'POST',
        'students/${p['id']}/requirements',
        data: {'type': 'Autorização de saída'},
      )).statusCode,
      201,
    );
    expect(
      (await call(
        'DELETE',
        'students/${p['id']}/requirements/${requirement['id']}',
      )).statusCode,
      200,
    );
    expect(
      (await call('GET', 'documents/${d['id']}/content')).bodyBytes,
      bytes,
    );
  });
  test('associa documentos antigos sem duplicar bytes e vincula solicitação explicitamente', () async {
    final folder = jsonDecode(
      (await call('POST', 'folders', data: {'name': 'Arquivo anterior'})).body,
    );
    final p = await create('Aluno vinculado', folder: folder['id']);
    expect(p['folder'], folder['id']);
    expect(
      (await call(
        'POST',
        'students',
        data: {
          'name': 'Vínculo duplicado',
          'folder': folder['id'],
          'class_group': groupId,
        },
      )).statusCode,
      409,
    );
    final request = await call(
      'POST',
      'requests',
      data: {
        'student': p['id'],
        'operation': 'student-request',
        'service': 'declaracao',
        'subject': 'Declaração',
        'description': 'Solicitação ligada ao aluno.',
      },
    );
    expect(request.statusCode, 201);
    final detail = jsonDecode((await call('GET', 'students/${p['id']}')).body);
    expect(detail['requests'].single['id'], jsonDecode(request.body)['id']);
  });
  test('isolamento por perfil e acesso vinculado ao aluno', () async {
    await db.exec(
      "INSERT INTO users VALUES('estudante','Conta do aluno','aluno',NULL)",
    );
    await db.exec(
      "INSERT INTO users VALUES('outro','Outra conta','aluno',NULL)",
    );
    final p = await create('Pessoa associada', linked: 'estudante');
    expect(
      (await call('GET', 'students/${p['id']}', user: 'estudante')).statusCode,
      200,
    );
    expect(
      (await call('GET', 'students/${p['id']}', user: 'outro')).statusCode,
      403,
    );
    expect(
      jsonDecode((await call('GET', 'students', user: 'outro')).body),
      isEmpty,
    );
    expect(
      (await call(
        'PATCH',
        'students/${p['id']}',
        user: 'estudante',
        data: {'revision': 1, 'name': 'Alterar'},
      )).statusCode,
      403,
    );
    expect(
      (jsonDecode(
        (await call('GET', 'folders', user: 'estudante')).body,
      ) as List).single['id'],
      p['folder'],
    );
  });
  test(
    'reinício preserva aluno, turma, requisitos e sessão sem avançar versão',
    () async {
      final p = await create('Pessoa persistente');
      await server.close(force: true);
      await db.close();
      db = Database(File('${dir.path}/db.sqlite'));
      store = Store(db, store.files);
      await store.seed();
      server = await io.serve(buildHandler(store), '127.0.0.1', 0);
      base = 'http://127.0.0.1:${server.port}/api/v1';
      final detail = jsonDecode(
        (await call('GET', 'students/${p['id']}')).body,
      );
      expect(detail['requirements'], hasLength(11));
      expect(
        (await call('GET', 'students/${p['id']}/enrollments')).statusCode,
        200,
      );
      expect((await db.rows('PRAGMA user_version')).single.values.single, 1);
    },
  );
}
