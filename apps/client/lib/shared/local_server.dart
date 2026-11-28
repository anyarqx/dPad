import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class LocalServer {
  final String executable;
  final String dataDirectory;
  final int port;
  final Duration startupTimeout;
  Process? _process;
  bool get running => _process != null;
  Future<void>? _starting;
  bool _cancelled = false;
  String? _instance;

  LocalServer({
    required this.executable,
    required this.dataDirectory,
    this.port = 8080,
    this.startupTimeout = const Duration(seconds: 15),
  });

  Uri get address => Uri.parse('http://127.0.0.1:$port');

  Future<void> start() =>
      _starting ??= _start().whenComplete(() => _starting = null);

  Future<void> _start() async {
    if (_process != null) return;
    _cancelled = false;
    if (!await File(executable).exists()) {
      throw Exception(
        'Executável do servidor ausente. Execute o script de build ou conecte a um servidor existente.',
      );
    }
    _instance = const Uuid().v4();
    final process = await Process.start(executable, [
      '--data',
      dataDirectory,
      '--port',
      '$port',
      '--controlled',
      '--instance',
      _instance!,
    ]);
    _process = process;
    String errors = '';
    final stderrDone = process.stderr.transform(utf8.decoder).listen((s) {
      errors += s;
      if (errors.length > 8192) errors = errors.substring(errors.length - 8192);
    }).asFuture<void>();
    process.stdout.drain<void>();
    int? exit;
    process.exitCode.then((code) {
      exit = code;
      if (identical(_process, process)) _process = null;
    });
    final client = http.Client();
    final timer = Stopwatch()..start();
    try {
      while (timer.elapsed < startupTimeout && !_cancelled) {
        if (exit != null) {
          await stderrDone;
          throw Exception('Não foi possível hospedar: ${errors.trim()}');
        }
        try {
          final response = await client
              .get(address.resolve('/health'))
              .timeout(const Duration(milliseconds: 500));
          if (response.statusCode == 200) {
            final health = jsonDecode(response.body);
            if (health['application'] == 'papel-digital' &&
                health['instance'] == _instance) {
              return;
            }
            throw const SocketException(
              'A porta selecionada está ocupada por outro servidor.',
            );
          }
        } on SocketException catch (e) {
          if (e.message.contains('ocupada')) rethrow;
        } on FormatException {
          throw const SocketException(
            'A porta selecionada está ocupada por outro serviço.',
          );
        } catch (_) {
          if (exit != null) continue;
        }
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      throw Exception(
        _cancelled
            ? 'Hospedagem cancelada.'
            : 'O servidor não respondeu no prazo esperado. ${errors.trim()}',
      );
    } catch (_) {
      await _terminate(process);
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<void> stop() async {
    _cancelled = true;
    try {
      await _starting;
    } catch (_) {
      /* A inicialização já apresentou o erro ao chamador. */
    }
    final process = _process;
    if (process != null) await _terminate(process);
  }

  Future<void> _terminate(Process process) async {
    try {
      process.stdin.writeln('shutdown');
      await process.stdin.flush();
      await process.exitCode.timeout(const Duration(seconds: 5));
    } catch (_) {
      process.kill();
      await process.exitCode.timeout(const Duration(seconds: 5));
    } finally {
      if (identical(_process, process)) _process = null;
    }
  }
}

class LocalHost {
  LocalServer? _server;
  Future<void> _queue = Future.value();
  bool get running => _server?.running ?? false;
  Uri? get address => running ? _server!.address : null;
  Future<Uri> start({
    required String executable,
    required String dataDirectory,
    required int port,
  }) {
    if (port < 1 || port > 65535) {
      throw const FormatException('Informe uma porta entre 1 e 65535.');
    }
    final result = _queue.then((_) async {
      final previous = _server;
      if (previous != null &&
          previous.port == port &&
          previous.executable == executable &&
          previous.dataDirectory == dataDirectory) {
        await previous.start();
        return previous.address;
      }
      final wasRunning = previous?.running ?? false;
      if (previous != null) await previous.stop();
      final next = LocalServer(
        executable: executable,
        dataDirectory: dataDirectory,
        port: port,
      );
      try {
        await next.start();
        _server = next;
        return next.address;
      } catch (_) {
        if (wasRunning) {
          try {
            await previous!.start();
            _server = previous;
          } catch (_) {
            _server = null;
          }
        }
        rethrow;
      }
    });
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  Future<void> stop() {
    final result = _queue.then((_) async {
      await _server?.stop();
    });
    _queue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }
}
