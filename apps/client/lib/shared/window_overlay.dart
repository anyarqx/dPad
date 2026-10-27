import 'package:flutter/widgets.dart';

class WindowOverlay extends StatelessWidget {
  final Widget child;
  const WindowOverlay({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Overlay.wrap(child: child);
}
