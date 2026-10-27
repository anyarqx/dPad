import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/workspace.dart';
import 'shared/window_chrome.dart';
import 'shared/window_overlay.dart';

final themeMode = ValueNotifier(ThemeMode.system);
late SharedPreferences preferences;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  themeMode.value =
      ThemeMode.values[(preferences.getInt('theme') ?? 0).clamp(
        0,
        ThemeMode.values.length - 1,
      )];
  await configureWindow();
  runApp(const ProviderScope(child: PapelApp()));
}

class PapelApp extends StatefulWidget {
  const PapelApp({super.key});
  @override
  State<PapelApp> createState() => _PapelAppState();
}

class _PapelAppState extends State<PapelApp> {
  late final router = GoRouter(
    initialLocation: '/students',
    routes: [
      GoRoute(
        path: '/:section',
        builder: (_, s) => Workspace(
          section: s.pathParameters['section']!,
          folder: s.uri.queryParameters['folder'],
          student: s.uri.queryParameters['student'],
          classId: s.uri.queryParameters['class'],
        ),
      ),
    ],
  );
  @override
  Widget build(BuildContext c) => ValueListenableBuilder(
    valueListenable: themeMode,
    builder: (c, mode, _) {
      final touch = MediaQueryData.fromView(View.of(c)).size.width < 600;
      final light = FThemeData(
        touch: touch,
        colors: FColors.neutralLight.copyWith(
          background: const Color(0xFFF8FAFC),
          foreground: const Color(0xFF172B3A),
          primary: const Color(0xFF126C78),
          primaryForeground: const Color(0xFFFFFFFF),
          card: const Color(0xFFFFFFFF),
          secondary: const Color(0xFFE9F2F4),
          secondaryForeground: const Color(0xFF164C57),
          muted: const Color(0xFFF0F4F7),
          mutedForeground: const Color(0xFF526579),
          border: const Color(0xFFD8E1E8),
        ),
      );
      final dark = FThemeData(
        touch: touch,
        colors: FColors.neutralDark.copyWith(
          background: const Color(0xFF131C26),
          foreground: const Color(0xFFE5EDF4),
          primary: const Color(0xFF78D5D2),
          primaryForeground: const Color(0xFF092E35),
          card: const Color(0xFF1A2633),
          secondary: const Color(0xFF243C48),
          secondaryForeground: const Color(0xFFD0E8ED),
          muted: const Color(0xFF202E3C),
          mutedForeground: const Color(0xFFADBECE),
          border: const Color(0xFF354858),
          error: const Color(0xFFFFB4AB),
          destructive: const Color(0xFFA9403D),
          destructiveForeground: const Color(0xFFFFFFFF),
        ),
      );
      ThemeData material(FThemeData data) {
        final base = data.toApproximateMaterialTheme();
        final border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: data.colors.border),
        );
        return base.copyWith(
          visualDensity: VisualDensity.compact,
          dividerColor: data.colors.border,
          inputDecorationTheme: InputDecorationThemeData(
            filled: true,
            fillColor: data.colors.card,
            enabledBorder: border,
            border: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: data.colors.primary, width: 1.5),
            ),
            labelStyle: base.textTheme.bodySmall!.copyWith(
              color: data.colors.mutedForeground,
            ),
            helperStyle: base.textTheme.bodySmall!.copyWith(
              color: data.colors.mutedForeground,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          chipTheme: base.chipTheme.copyWith(
            side: BorderSide(color: data.colors.border),
            backgroundColor: data.colors.card,
            selectedColor: data.colors.secondary,
            labelStyle: base.textTheme.labelLarge!.copyWith(
              color: data.colors.foreground,
              fontSize: 13,
            ),
            secondaryLabelStyle: base.textTheme.labelLarge!.copyWith(
              color: data.colors.foreground,
              fontSize: 13,
            ),
          ),
        );
      }

      return MaterialApp.router(
        title: 'Do Papel ao Digital',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: material(light),
        darkTheme: material(dark),
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: FLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('pt', 'BR')],
        routerConfig: router,
        builder: (c, child) => FTheme(
          data: Theme.of(c).brightness == Brightness.dark ? dark : light,
          child: WindowOverlay(child: WindowFrame(child: child!)),
        ),
      );
    },
  );
}
