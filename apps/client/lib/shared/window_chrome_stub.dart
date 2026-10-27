import 'package:material_ui/material_ui.dart';

import 'software_menu.dart';

bool get windowChromeEnabled => false;

Future<void> configureWindow() async {}

class WindowFrame extends StatelessWidget {
  final Widget child;
  const WindowFrame({super.key, required this.child});
  @override
  Widget build(BuildContext c) => Column(
    children: [
      if (MediaQuery.sizeOf(c).width >= 1050) const SoftwareToolbar(),
      Expanded(key: const ValueKey('window-content'), child: child),
    ],
  );
}
