import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

import '../lib/src/database.dart' show Database;
import '../lib/src/store.dart';
import '../lib/src/app.dart';

Future<void> main(List<String> args) async {
  String option(String key, String fallback) {
    final i = args.indexOf('--$key');
    return i >= 0 && i + 1 < args.length ? args[i + 1] : fallback;
  }

  final dir = Directory(
    option('data', Platform.environment['DPAD_DATA'] ?? 'data'),
  ).absolute;
  await dir.create(recursive: true);
  final lock = await File('${dir.path}/server.lock')
      .open(mode: FileMode.append);
  try {
    await lock.lock(FileLock.exclusive);
  } catch (_) {
    stderr.writeln('Outra instância utiliza este diretório de dados.');
    await lock.close();
    exitCode = 1;
    return;
  }
  final db = Database(File('${dir.path}/database.sqlite'));
  HttpServer? server;
  try {
    if (args.contains('--reset-data')) {
      if (option('reset-data', '') != 'RECRIAR')
        throw ArgumentError(
          'Use --reset-data RECRIAR para apagar banco e arquivos desta instalação de desenvolvimento.',
        );
      for (final name in [
        'database.sqlite',
        'database.sqlite-wal',
        'database.sqlite-shm',
      ]) {
        final file = File('${dir.path}/$name');
        if (await file.exists()) await file.delete();
      }
      final oldFiles = Directory('${dir.path}/files');
      if (await oldFiles.exists()) await oldFiles.delete(recursive: true);
      stdout.writeln(
        'Dados de desenvolvimento recriados por solicitação explícita.',
      );
    }
    final files = Directory('${dir.path}/files');
    await files.create();
    await for (final f in files.list()) {
      if (f is File && f.path.endsWith('.part')) await f.delete();
    }
    final store = Store(db, files);
    await store.seed(demo: args.contains('--demo'));
    final api = buildHandler(
      store,
      instance: option('instance', ''),
      allowedOrigin: option('cors-origin', ''),
    );
    final web = option('web', '');
    final staticFiles = web.isEmpty
        ? null
        : createStaticHandler(web, defaultDocument: 'index.html');
    Future<Response> handler(Request r) async {
      if (r.url.path == 'health' ||
          r.url.path.startsWith('api/') ||
          staticFiles == null)
        return api(r);
      final response = await staticFiles(r);
      if (response.statusCode == 404 && r.method == 'GET')
        return staticFiles(
          Request('GET', r.requestedUri.replace(path: '/index.html')),
        );
      return response;
    }

    server = await io.serve(
      handler,
      option('host', '127.0.0.1'),
      int.parse(option('port', '8080')),
    );
    stdout.writeln(
      'Do Papel ao Digital: http://${server.address.host}:${server.port} | ${dir.path}',
    );
    var closing = false;
    Future<void> stop() async {
      if (closing) return;
      closing = true;
      await server?.close(force: false);
      await db.close();
      await lock.unlock();
      await lock.close();
      exit(0);
    }

    ProcessSignal.sigint.watch().listen((_) {
      stop();
    });
    if (!Platform.isWindows)
      ProcessSignal.sigterm.watch().listen((_) {
        stop();
      });
    if (args.contains('--controlled'))
      stdin.transform(utf8.decoder).transform(const LineSplitter()).listen((
        line,
      ) {
        if (line == 'shutdown') stop();
      }, onDone: stop);
  } catch (e) {
    stderr.writeln('Falha ao iniciar: $e');
    await server?.close(force: true);
    await db.close();
    await lock.close();
    exitCode = 1;
  }
}
