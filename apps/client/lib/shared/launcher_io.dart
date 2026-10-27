import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'local_server.dart';

LocalServer? _server;
bool get isHosting => _server?.running ?? false;
bool get canHost => Platform.isLinux || Platform.isWindows;
Future<void> host() async {
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
  if (_server == null ||
      (!_server!.running && _server!.executable != executable)) {
    _server = LocalServer(
      executable: executable,
      dataDirectory: p.join(data.path, 'papel-digital'),
    );
  }
  await _server!.start();
}

Future<void> stopHost() async => _server?.stop();
