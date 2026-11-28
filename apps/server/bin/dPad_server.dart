import 'dart:io';
import 'dart:convert';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

import '../lib/src/database.dart' show Database;
import '../lib/src/store.dart';
import '../lib/src/app.dart';
import '../lib/src/test_data.dart';

Future<void> main(List<String> args) async {
  String option(String key, String fallback) {
    final i = args.indexOf('--$key');
    return i >= 0 && i + 1 < args.length ? args[i + 1] : fallback;
  }

  final production = Directory(
    option('data', Platform.environment['DPAD_DATA'] ?? 'data'),
  ).absolute;
  final testMode = args.contains('--test');
  final dir = testMode ? Directory('${production.path}.test') : production;
  if (testMode &&
      await FileSystemEntity.type(dir.path, followLinks: false) ==
          FileSystemEntityType.link) {
    stderr.writeln('O diretório de testes não pode ser um link.');
    exitCode = 1;
    return;
  }
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
    final testProfiles = await db.rows(
      "SELECT id FROM users WHERE id IN ('admin','aluno')",
    );
    if (testMode &&
        testProfiles.length != 2 &&
        (await db.rows('SELECT user FROM credentials LIMIT 1')).isNotEmpty) {
      throw StateError(
        'Use um diretório de testes separado de contas institucionais.',
      );
    }
    if (!testMode && testProfiles.isNotEmpty) {
      throw StateError('Este diretório pertence a uma instalação de testes.');
    }
    await store.seed(test: testMode);
    if (testMode) await seedTestAcademics(store);
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
    );
    final virtual = RegExp(
      r'^(docker|br-|veth|virbr|vboxnet|vethernet|tun|tap|wg)',
      caseSensitive: false,
    );
    interfaces.sort(
      (a, b) => (virtual.hasMatch(a.name) ? 1 : 0).compareTo(
        virtual.hasMatch(b.name) ? 1 : 0,
      ),
    );
    final api = buildHandler(
      store,
      instance: option('instance', ''),
      allowedOrigin: option('cors-origin', ''),
      serverInfo: () => server == null
          ? {}
          : {
              'listen': server.address.address,
              'test': testMode,
              'port': server.port,
              'addresses': [
                if (server.address.isLoopback)
                  'http://${server.address.host}:${server.port}'
                else
                  for (final network in interfaces)
                    for (final address in network.addresses)
                      'http://${address.address}:${server.port}',
              ],
            },
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
      option(
        'host',
        Platform.environment['DPAD_HOST'] ??
            (testMode ? '127.0.0.1' : '0.0.0.0'),
      ),
      int.parse(option('port', '8080')),
    );
    stdout.writeln(
      'dPad em http://${server.address.host}:${server.port} | ${dir.path}',
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
    stderr.writeln('Falha ao iniciar: ${e is ApiError ? e.message : e}');
    await server?.close(force: true);
    await db.close();
    await lock.close();
    exitCode = 1;
  }
}
