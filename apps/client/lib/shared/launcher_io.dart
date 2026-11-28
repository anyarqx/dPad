import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'local_server.dart';

final _host = LocalHost();
bool get isHosting => _host.running;
Uri? get hostedAddress => _host.address;
bool get canHost => Platform.isLinux || Platform.isWindows;
Future<Uri> host({int port = 8080}) async {
  if (!Platform.isLinux && !Platform.isWindows) {
    throw UnsupportedError(
      'Neste dispositivo, conecte-se ao servidor da escola.',
    );
  }
  final data = await getApplicationSupportDirectory();
  final candidates = [
    p.join(
      p.dirname(Platform.resolvedExecutable),
      'server',
      'bin',
      Platform.isWindows ? 'dPad_server.exe' : 'dPad_server',
    ),
    p.join(
      Directory.current.path,
      '..',
      'server',
      'build',
      'server',
      'bundle',
      'bin',
      Platform.isWindows ? 'dPad_server.exe' : 'dPad_server',
    ),
    p.join(
      Directory.current.path,
      'apps',
      'server',
      'build',
      'server',
      'bundle',
      'bin',
      Platform.isWindows ? 'dPad_server.exe' : 'dPad_server',
    ),
  ];
  String executable = candidates.first;
  for (final candidate in candidates) {
    if (await File(candidate).exists()) {
      executable = candidate;
      break;
    }
  }
  return _host.start(
    executable: executable,
    dataDirectory: p.join(data.path, 'papel-digital'),
    port: port,
  );
}

Future<void> stopHost() => _host.stop();
