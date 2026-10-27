import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as img;
import 'package:pdfrx/pdfrx.dart';
import 'package:crop_your_image/crop_your_image.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';
import 'package:dPad/main.dart' as application;
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:dPad/features/scanner.dart';
import 'package:dPad/features/viewer.dart';
import 'package:dPad/features/forms.dart';
import 'package:dPad/shared/api.dart';

void main() {
  final uiEnabled =
      Platform.isLinux && Platform.environment['DPAD_UI_TESTS'] == '1';
  late Process server;
  late Directory directory;
  final api = Api()..profile = 'aluno';
  final workflowApi = Api();
  late JsonMap data;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await (FontLoader('packages/forui/Inter')..addFont(
          rootBundle.load('packages/forui/assets/fonts/inter/Inter.ttf'),
        ))
        .load();
    await (FontLoader('packages/forui_lucide/ForuiLucideIcons')
          ..addFont(rootBundle.load('packages/forui_lucide/assets/lucide.ttf')))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    directory = await Directory.systemTemp.createTemp('dpad-client-test-');
    Pdfrx.pdfiumModulePath = File(
      Platform.isWindows
          ? 'build/native_assets/windows/pdfium.dll'
          : 'build/native_assets/linux/libpdfium.so',
    ).absolute.path;
    Pdfrx.cacheDirectoryPath = directory.path;
    await pdfrxFlutterInitialize();

    final socket = await ServerSocket.bind('127.0.0.1', 0);
    final port = socket.port;
    await socket.close();
    api.base = 'http://127.0.0.1:$port';
    workflowApi.base = api.base;
    server = await Process.start('dart', [
      'run',
      'bin/dPad_server.dart',
      '--data',
      directory.path,
      '--port',
      '$port',
      '--demo',
      '--controlled',
    ], workingDirectory: '../server');
    server.stdout.listen((_) {});
    server.stderr.listen((_) {});
    var connected = false;
    for (var i = 0; i < 100; i++) {
      try {
        await api.health(api.base);
        connected = true;
        break;
      } catch (_) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }
    if (!connected) throw Exception('Servidor real do teste não iniciou.');
    if (uiEnabled) {
      SharedPreferencesLinux.registerWith();
      application.preferences = await SharedPreferences.getInstance();
      await application.preferences.setString('api', api.base);
      await application.preferences.setString('profile', 'aluno');
    }
    data = {
      'session': await api.get('session'),
      'folders': await api.get('folders'),
      'documents': await api.get('documents'),
    };
  });
  tearDownAll(() async {
    server.stdin.writeln('shutdown');
    await server.stdin.flush();
    await server.exitCode.timeout(const Duration(seconds: 10));
    await directory.delete(recursive: true);
  });
  Widget frame(Widget child, {bool dark = false}) {
    final theme = dark
        ? FTheme.neutral.dark.desktop
        : FTheme.neutral.light.desktop;
    return MaterialApp(
      theme: theme.toApproximateMaterialTheme(),
      builder: (context, body) => FTheme(data: theme, child: body!),
      home: Scaffold(body: child),
    );
  }

  testWidgets(
    'digitalização apresenta seleção real de imagens nos dois temas',
    (tester) async {
      await tester.pumpWidget(frame(const Scanner()));
      expect(find.text('Selecionar imagens'), findsOneWidget);
      expect(find.text('Digitalizar documento'), findsOneWidget);
      await tester.pumpWidget(frame(const Scanner(), dark: true));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('formulário exige assunto e descrição e preserva rascunho', (
    tester,
  ) async {
    final draft = RequestDraft();
    await tester.pumpWidget(
      frame(RequestForm(api: api, data: data, draft: draft)),
    );
    await tester.tap(find.text('Enviar solicitação'));
    await tester.pump();
    expect(find.text('Preencha assunto e descrição.'), findsOneWidget);
    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'Declaração para feira');
    await tester.enterText(fields.at(1), 'Dados fictícios para avaliação.');
    await tester.pumpWidget(const SizedBox());
    expect(draft.subject, 'Declaração para feira');
    expect(draft.description, 'Dados fictícios para avaliação.');
    await tester.pump(const Duration(seconds: 6));
  });
  test('API real retorna erro autorizado e documentos reais', () async {
    final docs = List<JsonMap>.from(await api.get('documents'));
    expect(docs, isNotEmpty);
    final bytes = await api.bytes(docs.first['id']);
    expect(bytes.take(4), [37, 80, 68, 70]);
    await expectLater(
      api.send('POST', 'folders', {'name': ''}),
      throwsException,
    );
  });
  test(
    'PDF de digitalização tem duas páginas renderizáveis pelo pdfrx',
    () async {
      final original = img.Image(width: 240, height: 320);
      img.fill(original, color: img.ColorRgb8(240, 240, 240));
      final cropped = img.copyCrop(
        original,
        x: 10,
        y: 20,
        width: 200,
        height: 280,
      );
      final rotated = img.copyRotate(original, angle: 90);
      final bytes = await generateScanPdf([
        Uint8List.fromList(img.encodePng(cropped)),
        Uint8List.fromList(img.encodePng(rotated)),
      ]);
      final pdf = await PdfDocument.openData(bytes);
      expect(pdf.pages.length, 2);
      for (final page in pdf.pages) {
        final rendered = await page.render(fullWidth: 200, fullHeight: 280);
        expect(rendered, isNotNull);
        rendered?.dispose();
      }
      await pdf.dispose();
    },
  );
  testWidgets('visualizador abre PDF real, navega, amplia e ajusta página', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scannedPdf = await tester.runAsync(
      () => generateScanPdf([
        Uint8List.fromList(img.encodePng(img.Image(width: 240, height: 320))),
        Uint8List.fromList(img.encodePng(img.Image(width: 320, height: 240))),
      ]),
    );
    await tester.pumpWidget(
      frame(
        Viewer(
          bytes: scannedPdf!,
          name: 'Digitalização de teste.pdf',
          pdf: true,
        ),
      ),
    );
    final viewer = tester.widget<PdfViewer>(find.byType(PdfViewer));
    final controller = viewer.controller!;
    for (var i = 0; i < 30 && !controller.isReady; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(controller.isReady, true);
    expect(controller.pageCount, 2);
    await tester.tap(find.byTooltip('Próxima página'));
    await tester.pumpAndSettle();
    expect(controller.pageNumber, 2);
    final zoom = controller.currentZoom;
    await tester.tap(find.byTooltip('Ampliar'));
    await tester.pumpAndSettle();
    expect(controller.currentZoom, greaterThan(zoom));
    await tester.tap(find.text('Ajustar página'));
    await tester.pumpAndSettle();
    expect(controller.currentZoom, lessThanOrEqualTo(zoom + .01));
    await tester.tap(find.byTooltip('Página anterior'));
    await tester.pumpAndSettle();
    expect(controller.pageNumber, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 20));
  });
  testWidgets(
    'scanner permite girar, reordenar, remover e abrir recorte real',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final one = Uint8List.fromList(
        img.encodePng(img.Image(width: 120, height: 160)),
      );
      final two = Uint8List.fromList(
        img.encodePng(img.Image(width: 160, height: 120)),
      );
      await tester.pumpWidget(frame(Scanner(initialImages: [one, two])));
      await tester.pumpAndSettle();
      expect(find.text('Página 2'), findsOneWidget);
      await tester.tap(find.text('Girar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seguinte'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Anterior'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Recortar'));
      await tester.pumpAndSettle();
      expect(find.byType(Crop), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(seconds: 1));
      });
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await tester.tap(find.text('Aplicar recorte'));
        await Future<void>.delayed(const Duration(milliseconds: 700));
      });
      await tester.pumpAndSettle();
      expect(find.byType(Crop), findsNothing);
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();
      expect(find.text('Página 2'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'solicitante e setores completam declaração e atividade pela interface',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      workflowApi.profile = 'aluno';
      await tester.runAsync(() async {
        await application.preferences.setString('profile', 'aluno');
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [apiProvider.overrideWithValue(workflowApi)],
          child: const application.PapelApp(),
        ),
      );
      Future<void> load() async {
        await tester.pump();
        for (var i = 0; i < 60; i++) {
          await tester.runAsync(() async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
          });
          await tester.pump(const Duration(milliseconds: 32));
          if (i >= 8 &&
              find.byType(CircularProgressIndicator).evaluate().isEmpty &&
              find.byType(LinearProgressIndicator).evaluate().isEmpty &&
              find
                  .textContaining(RegExp('Enviando…|Salvando…'))
                  .evaluate()
                  .isEmpty) {
            break;
          }
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      Future<void> tap(String label) async {
        final finder = find.text(label).first;
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await load();
      }

      Future<void> profile(String label) async {
        await tester.tap(find.byKey(const ValueKey('demo-profile')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).last);
        await load();
      }

      Future<void> open(String section, String subject) async {
        await tap(section);
        await tap(subject);
      }

      Future<void> message(String action, String text) async {
        await tap(action);
        final input = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(EditableText),
        );
        await tester.enterText(input, text);
        await tap('Confirmar');
        expect(find.byType(AlertDialog), findsNothing);
      }

      Future<void> create(
        String subject,
        String description, {
        bool activity = false,
        bool attach = false,
      }) async {
        await tap('Solicitações');
        await tap('Nova solicitação');
        if (activity) {
          await tap('Declaração escolar');
          await tap('Atividade escolar');
        }
        final fields = find.descendant(
          of: find.byType(RequestForm),
          matching: find.byType(EditableText),
        );
        await tester.enterText(fields.at(0), subject);
        await tester.enterText(fields.at(1), description);
        if (attach) {
          await tester.tap(
            find
                .descendant(
                  of: find.byType(RequestForm),
                  matching: find.byType(FCheckbox),
                )
                .first,
          );
        }
        await tap('Enviar solicitação');
        expect(find.byType(RequestForm), findsNothing);
        expect(find.text(subject), findsOneWidget);
      }

      await load();
      expect(
        find.text('Solicitações'),
        findsWidgets,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data)
            .join(' | '),
      );
      const declaration = 'Declaração para apresentação da feira';
      await create(
        declaration,
        'Declaração com dados fictícios para a feira.',
        attach: true,
      );
      await profile('Marina Costa · secretaria');
      await open('Atendimento', declaration);
      await tap('Iniciar atendimento');
      await message('Pedir complemento', 'Informe a finalidade da declaração.');
      await profile('Ana Oliveira · aluno');
      await open('Solicitações', declaration);
      await message(
        'Responder pendência',
        'Finalidade: apresentação científica.',
      );
      await profile('Marina Costa · secretaria');
      await open('Atendimento', declaration);
      await message('Concluir', 'Declaração preparada para demonstração.');
      await profile('Ana Oliveira · aluno');
      await open('Solicitações', declaration);
      expect(
        find.text('Declaração preparada para demonstração.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Complemento do solicitante: Finalidade:'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Concluída: Declaração preparada'),
        findsOneWidget,
      );
      final declared = await tester.runAsync(
        () async => List<JsonMap>.from(await workflowApi.get('requests')),
      );
      expect(
        declared!.singleWhere((r) => r['subject'] == declaration)['state'],
        'Concluída',
      );

      await profile('Júlia Santos · gremio');
      const activity = 'Atividade do grêmio na feira';
      await create(
        activity,
        'Solicitamos o auditório para uma atividade fictícia.',
        activity: true,
      );
      await profile('Paulo Alves · coordenacao');
      await open('Atendimento', activity);
      await tap('Iniciar atendimento');
      await message('Concluir', 'Atividade demonstrativa autorizada.');
      await profile('Júlia Santos · gremio');
      await open('Solicitações', activity);
      expect(find.text('Atividade demonstrativa autorizada.'), findsOneWidget);
      expect(
        find.textContaining('Concluída: Atividade demonstrativa'),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      workflowApi.client.close();
      await tester.pump(const Duration(seconds: 20));
      await tester.runAsync(() async {
        await application.preferences.setString('profile', 'aluno');
      });
      expect(tester.takeException(), isNull);
    },
    skip: !uiEnabled,
  );
  testWidgets(
    'interface completa navega com API real e respeita largura e tema',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 960);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final captureKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: captureKey,
          child: ProviderScope(
            overrides: [apiProvider.overrideWithValue(api)],
            child: const application.PapelApp(),
          ),
        ),
      );
      Future<void> capture(String name) async {
        final directory = Platform.environment['DPAD_SCREENSHOT_DIR'];
        if (directory == null) return;
        await tester.runAsync(() async {
          final boundary =
              captureKey.currentContext!.findRenderObject()
                  as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 1);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(directory).create(recursive: true);
          await File('$directory/$name.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      Future<void> load() async {
        await tester.pump();
        for (var i = 0; i < 8; i++) {
          await tester.runAsync(() async {
            await Future<void>.delayed(const Duration(milliseconds: 150));
          });
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.pumpAndSettle();
      }

      await load();
      expect(
        find.text('Do Papel ao Digital'),
        findsOneWidget,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data)
            .join(' | '),
      );
      await tester.tap(find.text('Arquivo de documentos').first);
      await load();
      expect(find.text('Requerimento demonstrativo.pdf'), findsOneWidget);
      await tester.tap(find.text('Requerimento demonstrativo.pdf'));
      await tester.pumpAndSettle();
      expect(find.text('DETALHES'), findsOneWidget);
      await capture('desktop-light');
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Preferências'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sistema').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Escuro').last);
      await load();
      await tester.runAsync(() async {
        await application.preferences.reload();
      });
      expect(application.preferences.getInt('theme'), ThemeMode.dark.index);
      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.text('DETALHES'))).brightness,
        Brightness.dark,
      );
      await capture('desktop-dark');
      await tester.tap(find.byTooltip('Fechar detalhes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Solicitações').first);
      await load();
      expect(find.text('Declaração de vínculo'), findsOneWidget);
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AppBar), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Declaração de vínculo'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Declaração de vínculo'));
      await load();
      await tester.pumpAndSettle();
      expect(find.text('DETALHES'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await capture('narrow-detail');
      await tester.tap(
        find.byTooltip('Detalhes de Requerimento demonstrativo.pdf'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Formato / tamanho'), findsOneWidget);
      await tester.tap(find.byTooltip('Fechar detalhes'));
      await tester.pumpAndSettle();
      expect(find.text('DETALHES'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arquivo de documentos').last);
      await load();
      expect(find.text('Arquivo de documentos'), findsWidgets);
      expect(find.byKey(const ValueKey('demo-profile')), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 6));
      api.client.close();
      await tester.pump(const Duration(seconds: 16));
      application.themeMode.value = ThemeMode.system;
    },
    skip: !uiEnabled,
  );
}
