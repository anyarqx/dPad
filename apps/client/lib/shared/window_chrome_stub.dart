import 'package:flutter/widgets.dart';

Future<void> configureWindow() async {}

class WindowFrame extends StatelessWidget {
  final Widget child;
  const WindowFrame({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}
