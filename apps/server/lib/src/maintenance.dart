import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:shelf/shelf.dart';
import 'package:path/path.dart' as path;

import 'store.dart';

class Maintenance {
  final Store s;
  Maintenance(this.s);
  bool busy = false;
  int active = 0;
  Directory get directory => Directory('${s.files.parent.path}/backups');
  void authorize(Map u) {
    if (!s.admin(u)) throw ApiError(403, 'Manutenção exige administração.');
  }

  Future<Response> guard(
    Request request,
    Future<Response> Function() action,
  ) async {
    if (request.url.path.startsWith('api/v1/maintenance/')) return action();
    if (busy)
      return Response(
        503,
        body: jsonEncode({
          'error': 'Manutenção em andamento. Tente novamente em instantes.',
        }),
        headers: {'content-type': 'application/json', 'retry-after': '3'},
      );
    active++;
    try {
      return await action();
    } finally {
      active--;
    }
  }

  Future<T> exclusive<T>(Future<T> Function() action) async {
    if (busy) throw ApiError(409, 'Já existe uma manutenção em andamento.');
    busy = true;
    try {
      while (active > 0) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      return await action();
    } finally {
      busy = false;
    }
  }

  String validId(String id) {
    if (!RegExp(r'^[0-9a-f-]{36}$').hasMatch(id))
      throw ApiError(400, 'Identificador inválido.');
    return id;
  }

  Future<String> hash(File file) async =>
      (await sha256.bind(file.openRead()).first).toString();
  String schema(sqlite.Database db) {
    final tables = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name",
    );
    final structures = <Object>[];
    for (final table in tables) {
      final name = table['name'] as String;
      if (!RegExp(r'^[a-z_]+$').hasMatch(name))
        throw ApiError(400, 'Estrutura de banco inválida.');
      final columns = db.select(
        'SELECT name,type,"notnull",dflt_value,pk FROM pragma_table_info(?) ORDER BY name',
        [name],
      );
      final references = db.select(
        'SELECT "table","from","to",on_update,on_delete FROM pragma_foreign_key_list(?) ORDER BY "table","from","to"',
        [name],
      );
      structures.add([
        name,
        [for (final c in columns) c.values.toList()],
        [for (final f in references) f.values.toList()],
      ]);
    }
    final extra = db.select(
      "SELECT type,name FROM sqlite_master WHERE type IN ('trigger','view') ORDER BY type,name",
    );
    return jsonEncode([
      structures,
      [for (final e in extra) e.values.toList()],
    ]);
  }

  Map<String, int> counts(sqlite.Database db) => {
    for (final t in [
      'students',
      'class_groups',
      'journals',
      'documents',
      'requests',
    ])
      t: db.select('SELECT count(*) AS n FROM $t').single['n'] as int,
  };
  Future<Map<String, dynamic>> create(Map u) {
    authorize(u);
    return exclusive(_create);
  }

  Future<Map<String, dynamic>> _create() async {
    await directory.create(recursive: true);
    final id = uuid.v4(),
        stage = await Directory('${directory.path}/work-$id').create();
    try {
      final database = File('${stage.path}/database.sqlite');
      await s.db.customStatement('VACUUM INTO ?', [database.path]);
      final snapshot = sqlite.sqlite3.open(
        database.path,
        mode: sqlite.OpenMode.readOnly,
      );
      late Map<String, dynamic> manifest;
      try {
        if (snapshot.select('PRAGMA integrity_check').single.values.single !=
                'ok' ||
            snapshot.select('PRAGMA foreign_key_check').isNotEmpty)
          throw ApiError(
            409,
            'O banco possui inconsistências; backup não concluído.',
          );
        final entries = <String, dynamic>{
          'database.sqlite': {
            'size': await database.length(),
            'sha256': await hash(database),
          },
        };
        await Directory('${stage.path}/files').create();
        for (final doc in snapshot.select(
          'SELECT storage,size FROM documents',
        )) {
          final name = doc['storage'] as String;
          if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(name))
            throw ApiError(409, 'Referência física inválida.');
          final source = File('${s.files.path}/$name');
          if (!await source.exists() || await source.length() != doc['size'])
            throw ApiError(409, 'Documento físico ausente ou incompleto.');
          final copy = await source.copy('${stage.path}/files/$name');
          entries['files/$name'] = {
            'size': await copy.length(),
            'sha256': await hash(copy),
          };
        }
        manifest = {
          'format': 'dpad-backup',
          'version': 1,
          'id': id,
          'created': now(),
          'test': s.testMode,
          'schema': schema(snapshot),
          'institution': snapshot
              .select('SELECT name FROM institution_settings WHERE id=1')
              .single['name'],
          'counts': counts(snapshot),
          'files': entries,
        };
      } finally {
        snapshot.close();
      }
      await File('${stage.path}/manifest.json')
          .writeAsString(jsonEncode(manifest), flush: true);
      final temp = '${directory.path}/$id.part';
      await ZipFileEncoder().zipDirectory(
        stage,
        filename: temp,
        followLinks: false,
      );
      await File(temp).rename('${directory.path}/$id.zip');
      final metadata = Map<String, dynamic>.from(manifest)
        ..remove('files')
        ..remove('schema');
      metadata['size'] = await File('${directory.path}/$id.zip').length();
      await File('${directory.path}/$id.json')
          .writeAsString(jsonEncode(metadata), flush: true);
      return metadata;
    } finally {
      if (await stage.exists()) await stage.delete(recursive: true);
    }
  }

  Future<List<Map<String, dynamic>>> list(Map u) async {
    authorize(u);
    await directory.create(recursive: true);
    final result = <Map<String, dynamic>>[];
    await for (final f in directory.list()) {
      if (f is File &&
          f.path.endsWith('.json') &&
          RegExp(r'^[0-9a-f-]{36}\.json$').hasMatch(path.basename(f.path)))
        result.add(
          Map<String, dynamic>.from(jsonDecode(await f.readAsString())),
        );
    }
    result.sort((a, b) => (b['created'] as String).compareTo(a['created']));
    return result;
  }

  Future<File> download(Map u, String id) async {
    authorize(u);
    final file = File('${directory.path}/${validId(id)}.zip');
    if (!await file.exists()) throw ApiError(404, 'Backup não encontrado.');
    return file;
  }

  Future<Map<String, dynamic>> inspect(Map u, Stream<List<int>> bytes) async {
    authorize(u);
    await directory.create(recursive: true);
    final id = uuid.v4(), zip = File('${directory.path}/$id.upload');
    final stage = await Directory('${directory.path}/incoming-$id').create();
    try {
      var length = 0;
      final sink = zip.openWrite();
      try {
        await for (final chunk in bytes) {
          length += chunk.length;
          if (length > 256 * 1024 * 1024)
            throw ApiError(413, 'Backup excede 256 MB.');
          sink.add(chunk);
        }
      } finally {
        await sink.flush();
        await sink.close();
      }
      final input = InputFileStream(zip.path);
      try {
        final archive = ZipDecoder().decodeStream(input);
        if (archive.length > 10002)
          throw ApiError(400, 'Backup contém arquivos demais.');
        var total = 0;
        final names = <String>{};
        for (final file in archive) {
          final name = file.name;
          if (file.isDirectory && (name == 'files/' || name == 'files'))
            continue;
          if (file.isSymbolicLink ||
              !file.isFile ||
              !RegExp(
                r'^(manifest\.json|database\.sqlite|files/[a-zA-Z0-9-]+)$',
              ).hasMatch(name) ||
              !names.add(name))
            throw ApiError(
              400,
              'Backup contém caminhos ou arquivos inválidos.',
            );
          total += file.size;
          if (total > 1024 * 1024 * 1024 ||
              (name == 'manifest.json' && file.size > 8 * 1024 * 1024))
            throw ApiError(413, 'Backup descompactado excede o limite.');
          await File('${stage.path}/$name').parent.create(recursive: true);
          final output = OutputFileStream('${stage.path}/$name');
          try {
            file.writeContent(output);
          } finally {
            await output.close();
          }
        }
        await archive.clear();
      } finally {
        await input.close();
      }
      final manifest = await validate(stage);
      return {
        'id': id,
        'backup': manifest
          ..remove('files')
          ..remove('schema'),
        'replaces': counts(await s.db.native),
      };
    } catch (e) {
      await stage.delete(recursive: true);
      if (e is ApiError) rethrow;
      throw ApiError(400, 'Backup inválido, truncado ou incompatível.');
    } finally {
      if (await zip.exists()) await zip.delete();
    }
  }

  Future<Map<String, dynamic>> validate(Directory stage) async {
    final manifest = Map<String, dynamic>.from(
      jsonDecode(await File('${stage.path}/manifest.json').readAsString()),
    );
    if (manifest['format'] != 'dpad-backup' ||
        manifest['version'] != 1 ||
        manifest['test'] != s.testMode ||
        manifest['files'] is! Map)
      throw ApiError(
        400,
        'Formato, versão ou ambiente do backup incompatível.',
      );
    for (final entry in (manifest['files'] as Map).entries) {
      if (entry.key is! String ||
          !RegExp(r'^(database\.sqlite|files/[a-zA-Z0-9-]+)$')
              .hasMatch(entry.key))
        throw ApiError(400, 'Referência de backup inválida.');
      final file = File('${stage.path}/${entry.key}');
      if (!await file.exists() ||
          await file.length() != entry.value['size'] ||
          await hash(file) != entry.value['sha256'])
        throw ApiError(400, 'Falha na integridade do backup.');
    }
    final snapshot = sqlite.sqlite3.open(
      '${stage.path}/database.sqlite',
      mode: sqlite.OpenMode.readOnly,
    );
    try {
      if (snapshot.userVersion != 1 ||
          snapshot.select('PRAGMA application_id').single.values.single !=
              1146102101 ||
          schema(snapshot) != manifest['schema'] ||
          schema(snapshot) != schema(await s.db.native) ||
          snapshot.select('PRAGMA integrity_check').single.values.single !=
              'ok' ||
          snapshot.select('PRAGMA foreign_key_check').isNotEmpty)
        throw ApiError(400, 'Banco inválido ou estrutura incompatível.');
      for (final doc in snapshot.select('SELECT storage,size FROM documents')) {
        final file = (manifest['files'] as Map)['files/${doc['storage']}'];
        if (file == null || file['size'] != doc['size'])
          throw ApiError(400, 'O backup não contém todos os documentos.');
      }
      if (!s.testMode &&
          snapshot
              .select(
                "SELECT c.user FROM credentials c JOIN users u ON u.id=c.user WHERE c.enabled=1 AND u.role='admin'",
              )
              .isEmpty)
        throw ApiError(400, 'O backup precisa manter um administrador ativo.');
    } finally {
      snapshot.close();
    }
    return manifest;
  }

  Future<Map<String, dynamic>> restore(Map u, String id, Map b) {
    authorize(u);
    if (b['confirmation'] != 'RESTAURAR')
      throw ApiError(400, 'Digite RESTAURAR para confirmar a substituição.');
    return exclusive(() async {
      final stage = Directory('${directory.path}/incoming-${validId(id)}');
      if (!await stage.exists())
        throw ApiError(404, 'Selecione e valide o backup novamente.');
      final manifest = await validate(stage);
      final recovery = await _create();
      for (final name in (manifest['files'] as Map).keys.where(
        (n) => n.startsWith('files/'),
      )) {
        final source = File('${stage.path}/$name'),
            target = File('${s.files.path}/${name.substring(6)}');
        if (await target.exists()) {
          if (await hash(target) != await hash(source))
            throw ApiError(
              409,
              'Há um conflito de conteúdo físico. A instalação anterior foi preservada.',
            );
        } else {
          final temp = File('${target.path}.part');
          await source.copy(temp.path);
          await temp.rename(target.path);
        }
      }
      final source = sqlite.sqlite3.open(
        '${stage.path}/database.sqlite',
        mode: sqlite.OpenMode.readOnly,
      );
      try {
        await source.backup(await s.db.native, nPage: -1).drain<void>();
      } finally {
        source.close();
      }
      await s.db.exec('DELETE FROM sessions');
      await stage.delete(recursive: true);
      return {
        'restored': true,
        'recovery': recovery['id'],
        'loginRequired': true,
      };
    });
  }
}
