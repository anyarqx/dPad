import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import '../lib/src/pdf.dart';
import 'workflows_test.dart' show Installation;

void main() {
  test('pasta adotada pode ser usada pela secretaria e não libera acesso a professor', () async {
    final app = Installation();
    await app.start();
    try {
      final course = await app.course(), group = await app.group(course);
      final secretary = await app.account('secretaria-adocao', 'secretaria'),
          teacher = await app.account('professor-adocao', 'professor');
      final folder = await app.send(
        'POST',
        'folders',
        token: teacher['token'],
        status: 201,
        data: {'name': 'Documentos recebidos'},
      );
      final student = await app.send(
        'POST',
        'students',
        status: 201,
        data: {
          'name': 'Pessoa da pasta adotada',
          'class_group': group['id'],
          'folder': folder['id'],
        },
      );
      expect(
        (await app.send(
          'GET',
          'folders',
          token: teacher['token'],
        )).any((f) => f['id'] == folder['id']),
        isFalse,
      );
      await app.send(
        'PATCH',
        'folders/${folder['id']}',
        token: teacher['token'],
        status: 403,
        data: {'name': 'Alteração indevida', 'revision': folder['revision']},
      );
      final visible = await app.send(
        'GET',
        'folders',
        token: secretary['token'],
      );
      expect(visible.any((f) => f['id'] == folder['id']), isTrue);
      await app.send(
        'POST',
        'folders',
        token: secretary['token'],
        status: 409,
        data: {'name': 'Subpasta escondida', 'parent': folder['id']},
      );
      await app.send(
        'DELETE',
        'folders/${folder['id']}',
        token: secretary['token'],
        status: 409,
      );
      final administrative = await app.send(
        'POST',
        'folders',
        status: 201,
        data: {'name': 'Arquivo administrativo'},
      );
      await app.send(
        'PATCH',
        'folders/${folder['id']}',
        status: 409,
        data: {'parent': administrative['id'], 'revision': folder['revision']},
      );
      await app.send(
        'PATCH',
        'folders/${administrative['id']}',
        status: 409,
        data: {'parent': folder['id'], 'revision': administrative['revision']},
      );
      expect(
        visible.firstWhere((f) => f['id'] == folder['id'])['area_name'],
        teacher['name'],
      );
      final bytes = await requestPdf(
        'Pessoa da pasta adotada',
        'Documento',
        'Arquivo real de teste.',
      );
      final request =
          http.MultipartRequest(
              'POST',
              Uri.parse(app.base + '/documents').replace(
                queryParameters: {
                  'folder': folder['id'],
                  'type': 'Declaração',
                  'name': 'declaracao.pdf',
                },
              ),
            )
            ..headers['Authorization'] = 'Bearer ' + secretary['token']
            ..files.add(
              http.MultipartFile.fromBytes(
                'file',
                bytes,
                filename: 'declaracao.pdf',
              ),
            );
      final uploaded = await http.Response.fromStream(await request.send());
      expect(uploaded.statusCode, 201, reason: uploaded.body);
      final document = jsonDecode(uploaded.body);
      expect(
        (await app.send(
          'GET',
          'documents',
          token: secretary['token'],
        )).any((d) => d['id'] == document['id']),
        isTrue,
      );
      final downloaded = await app.call(
        'GET',
        'documents/${document['id']}/content',
        token: secretary['token'],
      );
      expect(downloaded.bodyBytes, bytes);
      await app.send(
        'GET',
        'documents/${document['id']}',
        token: teacher['token'],
        status: 403,
      );
      await app.send(
        'POST',
        'students',
        data: {
          'name': 'Duplicação indevida',
          'class_group': group['id'],
          'folder': folder['id'],
        },
        status: 409,
      );
      final parent = await app.send(
        'POST',
        'folders',
        status: 201,
        data: {'name': 'Pasta com subpastas'},
      );
      await app.send(
        'POST',
        'folders',
        status: 201,
        data: {'name': 'Subpasta', 'parent': parent['id']},
      );
      await app.send(
        'POST',
        'students',
        data: {
          'name': 'Cadastro com hierarquia ambígua',
          'class_group': group['id'],
          'folder': parent['id'],
        },
        status: 409,
      );
      expect((await app.send('GET', 'students')).single['id'], student['id']);
    } finally {
      await app.close();
    }
  }, timeout: const Timeout(Duration(minutes: 2)));
}
