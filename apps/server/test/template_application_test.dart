import 'dart:io';

import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as io;

import '../lib/src/app.dart';
import '../lib/src/database.dart';
import '../lib/src/store.dart';
import 'workflows_test.dart' show Installation;

void main() {
  test('modelos são aplicáveis a pasta existente, sem apagar valores nem duplicar exigências', () async {
    final app = Installation();
    await app.start();
    try {
      final course = await app.course(), group = await app.group(course);
      var student = await app.student(group);
      student = await app.send(
        'PATCH',
        'students/${student['id']}',
        data: {
          'revision': student['revision'],
          'extra': {'Contato adicional': 'Valor já preenchido'},
          'address': 'Endereço já cadastrado',
        },
      );
      final first = await app.send(
        'POST',
        'templates',
        status: 201,
        data: {
          'name': 'Modelo A',
          'documents': ['CPF'],
          'extra_fields': ['Contato adicional'],
          'required_identity': ['birthplace'],
        },
      );
      final second = await app.send(
        'POST',
        'templates',
        status: 201,
        data: {
          'name': 'Modelo B',
          'documents': ['cpf', 'Histórico'],
          'extra_fields': ['contato adicional', 'Transporte'],
          'required_identity': ['phone'],
        },
      );
      final pupil = await app.account(
        'aluno-modelos',
        'aluno',
        students: [student['id']],
      );
      await app.send(
        'POST',
        'students/${student['id']}/template',
        token: pupil['token'],
        status: 403,
        data: {'template': first['id'], 'revision': student['revision']},
      );
      student = await app.send(
        'POST',
        'students/${student['id']}/template',
        data: {'template': first['id'], 'revision': student['revision']},
      );
      final outdated = student['revision'];
      student = await app.send(
        'POST',
        'students/${student['id']}/template',
        data: {'template': second['id'], 'revision': student['revision']},
      );
      expect(student['requirements'], hasLength(2));
      expect(student['extra'], {
        'Contato adicional': 'Valor já preenchido',
        'Transporte': '',
      });
      expect(
        student['templateFields']['identity'],
        containsAll(['phone', 'birthplace']),
      );
      expect(student['address'], 'Endereço já cadastrado');
      await app.send(
        'POST',
        'students/${student['id']}/template',
        status: 409,
        data: {'template': second['id'], 'revision': outdated},
      );
      student = await app.send(
        'POST',
        'students/${student['id']}/template',
        data: {'template': second['id'], 'revision': student['revision']},
      );
      expect(student['requirements'], hasLength(2));
      final oversized = await app.send(
        'POST',
        'templates',
        status: 201,
        data: {
          'name': 'Modelo excedente',
          'documents': ['Não pode ser incluído'],
          'extra_fields': [for (var i = 0; i < 30; i++) 'Campo $i'],
        },
      );
      await app.send(
        'POST',
        'students/${student['id']}/template',
        status: 400,
        data: {'template': oversized['id'], 'revision': student['revision']},
      );
      expect(
        (await app.send('GET', 'students/${student['id']}'))['revision'],
        student['revision'],
      );
      final archived = await app.send(
        'PATCH',
        'templates/${first['id']}',
        data: {
          'revision': first['revision'],
          'name': first['name'],
          'documents': ['CPF'],
          'archived': 1,
        },
      );
      await app.send(
        'POST',
        'students/${student['id']}/template',
        status: 409,
        data: {'template': archived['id'], 'revision': student['revision']},
      );
      await app.server.close(force: true);
      await app.db.close();
      app.db = Database(File('${app.dir.path}/database.sqlite'));
      app.store = Store(app.db, Directory('${app.dir.path}/files'));
      app.server = await io.serve(buildHandler(app.store), '127.0.0.1', 0);
      app.base = 'http://127.0.0.1:${app.server.port}/api/v1';
      final saved = await app.send('GET', 'students/${student['id']}');
      expect(saved['extra']['Contato adicional'], 'Valor já preenchido');
      expect(saved['requirements'], hasLength(2));
    } finally {
      await app.close();
    }
  }, timeout: const Timeout(Duration(minutes: 2)));
}
