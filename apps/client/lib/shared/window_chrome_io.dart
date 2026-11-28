import 'dart:io';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;

import 'launcher.dart';
import 'window_title_bar.dart';
import 'software_menu.dart';

bool _enabled = false;
bool get windowChromeEnabled => _enabled;
final _lifecycle = _WindowLifecycle();

Future<void> toggleFullScreen() async {
  if (_enabled) {
    await windowManager.setFullScreen(!await windowManager.isFullScreen());
  }
}

class _WindowLifecycle extends WindowListener {
  bool closing = false;
  @override
  void onWindowClose() async {
    if (closing) return;
    closing = true;
    try {
      await stopHost();
    } catch (e) {
      stderr.writeln('Encerramento do servidor: $e');
    } finally {
      await windowManager.destroy();
    }
  }
}

Future<void> configureWindow() async {
  if (!Platform.isLinux && !Platform.isWindows) return;
  await windowManager.ensureInitialized();
  if (Platform.isLinux) {
    final icon = File(
      p.join(
        p.dirname(Platform.resolvedExecutable),
        'data',
        'flutter_assets',
        'assets',
        'app-icon.png',
      ),
    );
    if (await icon.exists()) await windowManager.setIcon(icon.path);
  }
  windowManager.addListener(_lifecycle);
  await windowManager.setPreventClose(true);
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      title: 'dPad',
      size: Size(1360, 860),
      minimumSize: Size(720, 540),
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Color(0xfffafafa),
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );
  _enabled = true;
}

class WindowFrame extends StatefulWidget {
  final Widget child;
  const WindowFrame({super.key, required this.child});
  @override
  State<WindowFrame> createState() => _WindowFrameState();
}

class _WindowFrameState extends State<WindowFrame> with WindowListener {
  bool maximized = false;
  @override
  void initState() {
    super.initState();
    if (_enabled) {
      windowManager.addListener(this);
      HardwareKeyboard.instance.addHandler(handleWindowKey);
    }
  }

  @override
  void dispose() {
    if (_enabled) {
      HardwareKeyboard.instance.removeHandler(handleWindowKey);
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  bool handleWindowKey(KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.f11) {
      return false;
    }
    toggleFullScreen();
    return true;
  }

  @override
  void onWindowMaximize() {
    if (mounted) setState(() => maximized = true);
  }

  @override
  void onWindowUnmaximize() {
    if (mounted) setState(() => maximized = false);
  }

  Future<void> maximize() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  @override
  Widget build(BuildContext c) => Column(
    children: [
      if (_enabled)
        WindowTitleBar(
          minimize: windowManager.minimize,
          maximize: maximize,
          close: windowManager.close,
          drag: windowManager.startDragging,
          maximized: maximized,
        )
      else if (MediaQuery.sizeOf(c).width >= 1050)
        const SoftwareToolbar(),
      Expanded(key: const ValueKey('window-content'), child: widget.child),
    ],
  );
}
