import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 28});
  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/logo.svg',
    width: size,
    height: size,
    semanticsLabel: 'Do Papel ao Digital',
  );
}
