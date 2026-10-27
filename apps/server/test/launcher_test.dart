import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import '../../client/lib/shared/local_server.dart';

void main() {
  late Directory build;
  late String executable;
  late Directory data;
  final servers = <LocalServer>[];

  setUpAll(() async {
    build = await Directory.systemTemp.createTemp('dpad-launcher-build-');
    final result = await Process.run(Platform.resolvedExecutable, [
      'build',
      'cli',
      '--target',
      'bin/dPad_server.dart',
      '-o',
      build.path,
    ]);
    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    executable =
        '${build.path}/bundle/bin/dPad_server${Platform.isWindows ? '.exe' : ''}';
  });
  tearDownAll(() => build.delete(recursive: true));
  setUp(() async {
    data = await Directory.systemTemp.createTemp('dpad-launcher-data-');
  });
  tearDown(() async {
    for (final server in servers.reversed) {
      await server.stop();
    }
    servers.clear();
    await data.delete(recursive: true);
  });
  Future<int> freePort() async {
    final socket = await ServerSocket.bind('127.0.0.1', 0);
    final port = socket.port;
    await socket.close();
    return port;
  }

  LocalServer launcher(int port, {String? directory, String? binary}) {
    final server = LocalServer(
      executable: binary ?? executable,
      dataDirectory: directory ?? data.path,
      port: port,
    );
    servers.add(server);
    return server;
  }

  test('inicia, aguarda saúde própria, evita partida concorrente e persiste após reiniciar', () async {
    final port = await freePort();
    final server = launcher(port);
    await Future.wait([server.start(), server.start()]);
    final url = server.address;
    final health = jsonDecode((await http.get(url.resolve('/health'))).body);
    expect(health['instance'], isNotEmpty);
    final configured = await http.post(
      url.resolve('/api/v1/auth/setup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': 'Operador do teste',
        'login': 'operador',
        'password': 'senha longa de teste',
      }),
    );
    expect(configured.statusCode, 201, reason: configured.body);
    final token = jsonDecode(configured.body)['token'];
    final created = await http.post(
      url.resolve('/api/v1/folders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': 'Pasta do launcher'}),
    );
    expect(created.statusCode, 201);
    final id = jsonDecode(created.body)['id'];
    await server.stop();
    await expectLater(
      http.get(url.resolve('/health')),
      throwsA(isA<http.ClientException>()),
    );
    await server.start();
    final rows = jsonDecode(
      (await http.get(
        url.resolve('/api/v1/folders'),
        headers: {'Authorization': 'Bearer $token'},
      )).body,
    ) as List;
    expect(rows.any((f) => f['id'] == id), true);
  });
  test('porta ocupada não é confundida com o processo iniciado', () async {
    final port = await freePort();
    final first = launcher(port);
    await first.start();
    final other = Directory('${data.path}/outra-instalacao');
    await expectLater(
      launcher(port, directory: other.path).start(),
      throwsA(predicate((e) => e.toString().contains('ocupada'))),
    );
    expect((await http.get(first.address.resolve('/health'))).statusCode, 200);
  });
  test('trava de dados impede outra instância em outra porta', () async {
    final first = launcher(await freePort());
    await first.start();
    await expectLater(
      launcher(await freePort()).start(),
      throwsA(predicate((e) => e.toString().contains('Outra instância'))),
    );
    expect((await http.get(first.address.resolve('/health'))).statusCode, 200);
  });
  test(
    'executável ausente gera erro e permite encerrar sem processo',
    () async {
      final server = launcher(await freePort(), binary: '${data.path}/ausente');
      await expectLater(
        server.start(),
        throwsA(predicate((e) => e.toString().contains('ausente'))),
      );
      await server.stop();
    },
  );
}
