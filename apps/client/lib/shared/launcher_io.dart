import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'local_server.dart';

LocalServer? _server;
bool get canHost => Platform.isLinux || Platform.isWindows;
Future<void> host() async {
  if (!Platform.isLinux && !Platform.isWindows) {
    throw UnsupportedError(
      'Neste dispositivo, conecte-se ao servidor da escola.',
    );
  }
  final data = await getApplicationSupportDirectory();
  final server = _server ??= LocalServer(
    executable: p.join(
      p.dirname(Platform.resolvedExecutable),
      'server',
      'bin',
      Platform.isWindows ? 'dPad_server.exe' : 'dPad_server',
    ),
    dataDirectory: p.join(data.path, 'papel-digital'),
  );
  await server.start();
}

Future<void> stopHost() async => _server?.stop();
