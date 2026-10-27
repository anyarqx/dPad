import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf_io.dart' as io;
import 'package:test/test.dart';

import '../lib/src/database.dart';
import '../lib/src/store.dart';
import '../lib/src/app.dart';

void main() {
  late Directory dir;
  late Database db;
  late Store store;
  late HttpServer server;
  late String base;
  setUp(() async {
    dir = await Directory.systemTemp.createTemp('dpad-test-');
    db = Database(File('${dir.path}/db.sqlite'));
    final files = Directory('${dir.path}/files');
    await files.create();
    store = Store(db, files);
    await store.seed(demo: true);
    server = await io.serve(buildHandler(store), '127.0.0.1', 0);
    base = 'http://127.0.0.1:${server.port}/api/v1';
  });
  tearDown(() async {
    await server.close(force: true);
    await db.close();
    await dir.delete(recursive: true);
  });
  Future<http.Response> call(
    String method,
    String path, {
    String user = 'aluno',
    Map<String, dynamic>? data,
  }) async {
    final r = http.Request(method, Uri.parse('$base/$path'))
      ..headers.addAll({'X-Profile': user, 'Content-Type': 'application/json'});
    if (data != null) r.body = jsonEncode(data);
    return http.Response.fromStream(await r.send());
  }

  Future<Map<String, dynamic>> create(String name, {String? parent}) async {
    final r = await call(
      'POST',
      'folders',
      data: {'name': name, 'parent': parent},
    );
    expect(r.statusCode, 201);
    return jsonDecode(r.body);
  }

  test(
    'pastas: criação, conflito, mover, ciclo, excluir vazia e revisão',
    () async {
      final a = await create('Pasta A');
      final b = await create('Filha', parent: a['id']);
      final c = await create('Destino');
      expect(
        (await call('POST', 'folders', data: {'name': 'Pasta A'})).statusCode,
        409,
      );
      expect(
        (await call(
          'PATCH',
          'folders/${a['id']}',
          data: {'parent': b['id'], 'revision': 1},
        )).statusCode,
        409,
      );
      expect((await call('DELETE', 'folders/${a['id']}')).statusCode, 409);
      expect(
        (await call(
          'PATCH',
          'folders/${b['id']}',
          data: {'name': 'Movida', 'parent': c['id'], 'revision': 1},
        )).statusCode,
        200,
      );
      expect(
        (await call(
          'PATCH',
          'folders/${b['id']}',
          data: {'name': 'Obsoleta', 'revision': 1},
        )).statusCode,
        409,
      );
      expect((await call('DELETE', 'folders/${a['id']}')).statusCode, 200);
    },
  );
  test('isolamento, anexos autorizados e arquivo físico persistente', () async {
    final docs = jsonDecode((await call('GET', 'documents')).body) as List;
    final d = docs.first;
    final r = await call('GET', 'documents/${d['id']}/content');
    expect(r.statusCode, 200);
    expect(ascii.decode(r.bodyBytes.take(4).toList()), '%PDF');
    expect(
      (await call(
        'GET',
        'documents/${d['id']}/content',
        user: 'professor',
      )).statusCode,
      403,
    );
    expect(
      (await call(
        'GET',
        'documents/${d['id']}/content',
        user: 'secretaria',
      )).statusCode,
      200,
    );
    expect(
      (jsonDecode(
        (await call('GET', 'documents', user: 'secretaria')).body,
      ) as List).every((v) => v['uploader'] == 'admin'),
      true,
    );
    expect(
      (await call(
        'PATCH',
        'documents/${d['id']}',
        user: 'secretaria',
        data: {'revision': 1, 'name': 'Inválido'},
      )).statusCode,
      403,
    );
    expect((await call('DELETE', 'documents/${d['id']}')).statusCode, 409);
    expect(await File('${store.files.path}/${d['storage']}').exists(), true);
    await server.close(force: true);
    await db.close();
    db = Database(File('${dir.path}/db.sqlite'));
    store = Store(db, store.files);
    await store.seed(demo: true);
    server = await io.serve(buildHandler(store), '127.0.0.1', 0);
    base = 'http://127.0.0.1:${server.port}/api/v1';
    expect(
      (jsonDecode((await call('GET', 'documents')).body) as List).length,
      1,
    );
    expect(
      (await call('GET', 'documents/${d['id']}/content')).bodyBytes,
      r.bodyBytes,
    );
  });
  test('upload multipart transfere bytes e rejeita arquivo inválido', () async {
    final f = await create('Importação');
    final original = (await call('GET', 'documents')).body;
    final d = (jsonDecode(original) as List).first;
    final bytes = (await call('GET', 'documents/${d['id']}/content')).bodyBytes;
    Future<http.Response> upload(List<int> b) async {
      final r =
          http.MultipartRequest(
              'POST',
              Uri.parse('$base/documents').replace(
                queryParameters: {
                  'name': 'Importado.pdf',
                  'folder': f['id'],
                  'type': 'Histórico',
                },
              ),
            )
            ..headers['X-Profile'] = 'aluno'
            ..files.add(
              http.MultipartFile.fromBytes('file', b, filename: 'original.pdf'),
            );
      return http.Response.fromStream(await r.send());
    }

    final r = await upload(bytes);
    expect(r.statusCode, 201);
    final saved = jsonDecode(r.body);
    expect(
      (await call('GET', 'documents/${saved['id']}/content')).bodyBytes,
      bytes,
    );
    expect((await upload([1, 2, 3])).statusCode, 400);
    expect(
      store.files.listSync().where((f) => f.path.endsWith('.part')),
      isEmpty,
    );
  });
  test('solicitação completa, idempotência, histórico e transições', () async {
    final data = {
      'operation': 'envio-1',
      'service': 'declaracao',
      'subject': 'Declaração teste',
      'description': 'Informações fictícias.',
    };
    final created = await call('POST', 'requests', data: data);
    expect(created.statusCode, 201);
    final id = jsonDecode(created.body)['id'];
    expect(
      jsonDecode((await call('POST', 'requests', data: data)).body)['id'],
      id,
    );
    Future<http.Response> action(
      String action,
      int revision, {
      String user = 'secretaria',
    }) => call(
      'POST',
      'requests/$id/actions',
      user: user,
      data: {
        'action': action,
        'revision': revision,
        'text': 'Resposta fictícia',
      },
    );
    expect((await action('complete', 1)).statusCode, 409);
    expect((await action('start', 1, user: 'professor')).statusCode, 403);
    expect((await action('start', 1)).statusCode, 200);
    expect((await action('ask', 2)).statusCode, 200);
    expect((await action('complement', 3, user: 'aluno')).statusCode, 200);
    expect((await action('complete', 4)).statusCode, 200);
    final detail = jsonDecode((await call('GET', 'requests/$id')).body);
    expect(detail['state'], 'Concluída');
    expect((detail['events'] as List).length, 5);
    expect((await action('start', 5)).statusCode, 409);
  });
  test('grêmio, encaminhamento e permissão por setor', () async {
    final r = await call(
      'POST',
      'requests',
      user: 'gremio',
      data: {
        'operation': 'atividade-1',
        'service': 'atividade',
        'subject': 'Feira',
        'description': 'Uso do auditório',
      },
    );
    expect(r.statusCode, 201);
    final id = jsonDecode(r.body)['id'];
    expect(
      (await call('GET', 'requests/$id', user: 'secretaria')).statusCode,
      403,
    );
    expect(
      (await call(
        'POST',
        'requests/$id/actions',
        user: 'coordenacao',
        data: {
          'action': 'forward',
          'revision': 1,
          'department': 'secretaria',
          'text': 'Preparar autorização',
        },
      )).statusCode,
      200,
    );
    expect(
      (await call('GET', 'requests/$id', user: 'coordenacao')).statusCode,
      403,
    );
    expect(
      (await call('GET', 'requests/$id', user: 'secretaria')).statusCode,
      200,
    );
  });
  test('template de aluno, dados inválidos, saúde e reset explícito', () async {
    expect(
      (await http.get(Uri.parse('${base.split('/api/').first}/health')))
          .statusCode,
      200,
    );
    expect(
      (await call('POST', 'folders', data: {'name': ' '})).statusCode,
      400,
    );
    final model = jsonDecode(
      await File('../../assets/templates/pasta-escolar.json').readAsString(),
    ) as Map<String, dynamic>;
    final template = jsonDecode(
      (await call('POST', 'templates', user: 'secretaria', data: model)).body,
    );
    final course = jsonDecode(
      (await call(
        'POST',
        'courses',
        user: 'secretaria',
        data: {
          'name': 'Curso do teste',
          'modality': 'Regular',
          'template': template['id'],
        },
      )).body,
    );
    final group = jsonDecode(
      (await call(
        'POST',
        'classes',
        user: 'secretaria',
        data: {
          'course': course['id'],
          'name': 'Turma do teste',
          'school_year': 2026,
          'period_label': 'Anual',
          'grade': 'Etapa',
          'shift': 'Matutino',
          'capacity': 40,
        },
      )).body,
    );
    final registered = await call(
      'POST',
      'students',
      user: 'secretaria',
      data: {'name': 'Pessoa do teste', 'class_group': group['id']},
    );
    expect(registered.statusCode, 201, reason: registered.body);
    final list = jsonDecode(
      (await call('GET', 'students', user: 'secretaria')).body,
    ) as List;
    final detail = jsonDecode(
      (await call(
        'GET',
        'students/${list.single['id']}',
        user: 'secretaria',
      )).body,
    );
    expect(
      (detail['requirements'] as List).any(
        (r) => r['type'] == 'Carteira de vacinação',
      ),
      true,
    );
    expect(
      (await call(
        'POST',
        'reset',
        data: {'confirmation': 'RESTAURAR'},
      )).statusCode,
      403,
    );
    expect(
      (await call('POST', 'reset', user: 'admin', data: {})).statusCode,
      400,
    );
    final parentA = await create('Raiz A');
    final parentB = await create('Raiz B');
    await create('Mesmo nome', parent: parentA['id']);
    await create('Mesmo nome', parent: parentB['id']);
    expect(
      (await call(
        'POST',
        'reset',
        user: 'admin',
        data: {'confirmation': 'RESTAURAR'},
      )).statusCode,
      200,
    );
    expect(
      (jsonDecode((await call('GET', 'documents')).body) as List).length,
      1,
    );
  });
  test('conferência de anexo exige atendente e revisão atual', () async {
    final d = (jsonDecode((await call('GET', 'documents')).body) as List).first;
    expect(
      (await call(
        'POST',
        'documents/${d['id']}/review',
        data: {'revision': 1, 'status': 'Conferido'},
      )).statusCode,
      403,
    );
    expect(
      (await call(
        'POST',
        'documents/${d['id']}/review',
        user: 'secretaria',
        data: {
          'revision': 1,
          'status': 'Precisa de correção',
          'note': 'Imagem ilegível',
        },
      )).statusCode,
      200,
    );
    expect(
      (await call(
        'POST',
        'documents/${d['id']}/review',
        user: 'secretaria',
        data: {'revision': 1, 'status': 'Conferido'},
      )).statusCode,
      409,
    );
    expect(
      (await call('GET', 'documents/${d['id']}', user: 'professor')).statusCode,
      403,
    );
  });
}
