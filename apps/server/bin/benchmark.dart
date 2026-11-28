import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;

import '../lib/src/database.dart';
import '../lib/src/store.dart';
import '../lib/src/app.dart';

Future<void> main(List<String> args) async {
  final dir = await Directory.systemTemp.createTemp('dpad-benchmark-');
  final db = Database(File('${dir.path}/database.sqlite'));
  final files = await Directory('${dir.path}/files').create();
  final store = Store(db, files);
  HttpServer? server;
  final client = HttpClient();
  try {
    await store.seed(test: true);
    final count = args.isEmpty ? 1000 : int.parse(args.first);
    await db.transaction(() async {
      for (var i = 0; i < count; i++) {
        final id = 'benchmark-$i';
        await db.exec(
          'INSERT INTO folders(id,name,area,created,updated) VALUES(?,?,?,?,?)',
          [id, id, 'sector:secretaria', now(), now()],
        );
        await db.exec(
          'INSERT INTO students(id,name,folder,created,updated) VALUES(?,?,?,?,?)',
          [id, 'Pessoa de teste $i', id, now(), now()],
        );
      }
    });
    server = await io.serve(buildHandler(store), '127.0.0.1', 0);
    final root = 'http://127.0.0.1:${server.port}';
    for (final path in [
      'health',
      'api/v1/session',
      'api/v1/students',
      'api/v1/folders',
      'api/v1/documents',
      'api/v1/classes',
    ]) {
      final times = <double>[];
      for (var i = 0; i < 12; i++) {
        final timer = Stopwatch()..start();
        final request = await client.getUrl(Uri.parse('$root/$path'));
        request.headers.set('X-Profile', 'secretaria');
        final response = await request.close();
        await response.drain<void>();
        if (response.statusCode != 200)
          throw StateError('$path: ${response.statusCode}');
        if (i > 1) times.add(timer.elapsedMicroseconds / 1000);
      }
      times.sort();
      stdout.writeln(
        jsonEncode({
          'path': path,
          'students': count,
          'median_ms': times[times.length ~/ 2],
          'max_ms': times.last,
        }),
      );
    }
  } finally {
    client.close(force: true);
    await server?.close(force: true);
    await db.close();
    await dir.delete(recursive: true);
  }
}
