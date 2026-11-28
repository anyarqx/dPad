import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/workspace.dart';
import 'shared/window_chrome.dart';
import 'shared/app_theme.dart';
import 'shared/operation_status.dart';
import 'shared/software_menu.dart';
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
  @override
  void initState() {
    super.initState();
    operationNotice.value = null;
  }

  late final router = GoRouter(
    navigatorKey: softwareNavigatorKey,
    observers: [softwareMenuObserver],
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
      final light = appTheme(dark: false, touch: touch);
      final dark = appTheme(dark: true, touch: touch);
      return MaterialApp.router(
        title: 'dPad',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: materialTheme(light, dark: false),
        darkTheme: materialTheme(dark, dark: true),
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: FLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('pt', 'BR')],
        routerConfig: router,
        builder: (c, child) => FTheme(
          data: Theme.of(c).brightness == Brightness.dark ? dark : light,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.f1): () =>
                  openSoftwareAction(SoftwareAction.help),
              const SingleActivator(
                LogicalKeyboardKey.keyK,
                control: true,
                alt: true,
              ): () =>
                  openSoftwareAction(SoftwareAction.navigation),
              const SingleActivator(
                LogicalKeyboardKey.keyB,
                control: true,
                alt: true,
              ): () =>
                  openSoftwareAction(SoftwareAction.sidebar),
            },
            child: Focus(
              autofocus: true,
              child: WindowOverlay(child: WindowFrame(child: child!)),
            ),
          ),
        ),
      );
    },
  );
}
