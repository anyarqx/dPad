import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:dPad/shared/app_theme.dart';
import 'package:dPad/shared/widgets.dart';
import 'package:dPad/shared/section_tabs.dart';
import 'package:dPad/shared/folder_breadcrumbs.dart';
import 'package:dPad/shared/software_menu.dart';
import 'package:dPad/shared/operation_status.dart';
import 'package:dPad/shared/date_input.dart';
import 'package:dPad/shared/page_header.dart';
import 'package:dPad/shared/window_overlay.dart';

Widget shell(Widget child, {bool dark = false, double scale = 1}) {
  final theme = appTheme(dark: dark, touch: false);
  return MaterialApp(
    theme: materialTheme(theme, dark: dark),
    builder: (c, page) => FTheme(
      data: theme,
      child: MediaQuery(
        data: MediaQuery.of(c).copyWith(textScaler: TextScaler.linear(scale)),
        child: page!,
      ),
    ),
    home: Scaffold(body: child),
  );
}

double contrast(Color a, Color b) {
  final x = a.computeLuminance(), y = b.computeLuminance();
  return ((x > y ? x : y) + .05) / ((x > y ? y : x) + .05);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final entry in {
      'packages/forui/Inter': 'packages/forui/assets/fonts/inter/Inter.ttf',
      'packages/forui_lucide/ForuiLucideIcons':
          'packages/forui_lucide/assets/lucide.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(
        entry.key,
      )..addFont(rootBundle.load(entry.value))).load();
    }
  });

  test(
    'texto e ações têm contraste legível em todas as regiões dos dois temas',
    () {
      for (final dark in [false, true]) {
        final colors = appTheme(dark: dark, touch: false).colors;
        final surfaces = dark ? AppSurfaces.dark : AppSurfaces.light;
        for (final surface in [
          colors.background,
          colors.card,
          surfaces.chrome,
          surfaces.sidebar,
          surfaces.footer,
          surfaces.header,
          surfaces.detail,
        ]) {
          expect(
            contrast(colors.foreground, surface),
            greaterThanOrEqualTo(4.5),
          );
          expect(
            contrast(colors.mutedForeground, surface),
            greaterThanOrEqualTo(4.5),
          );
        }
        expect(
          contrast(colors.primaryForeground, colors.primary),
          greaterThanOrEqualTo(4.5),
        );
        expect(contrast(colors.border, colors.card), greaterThanOrEqualTo(3));
        expect(
          contrast(colors.errorForeground, colors.error),
          greaterThanOrEqualTo(4.5),
        );
        expect(surfaces.chrome, isNot(colors.background));
        expect(surfaces.sidebar, isNot(colors.background));
        expect(surfaces.footer, isNot(surfaces.sidebar));
      }
    },
  );

  testWidgets('divisor pinta uma única linha física em escalas fracionárias', (
    tester,
  ) async {
    for (final dpr in [1.0, 1.25, 1.5, 2.0]) {
      tester.view.physicalSize = Size(800 * dpr, 600 * dpr);
      tester.view.devicePixelRatio = dpr;
      final boundary = GlobalKey();
      final theme = FThemeData(
        touch: false,
        colors: FColors.neutralLight.copyWith(border: const Color(0xFF000000)),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: FTheme(
            data: theme,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(7),
                child: RepaintBoundary(
                  key: boundary,
                  child: const SizedBox(
                    width: 160,
                    height: 40,
                    child: ColoredBox(
                      color: Color(0xFFFFFFFF),
                      child: Column(
                        children: [SizedBox(height: 17), PixelDivider()],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final picture = await tester.runAsync(
        () =>
            (boundary.currentContext!.findRenderObject()
                    as RenderRepaintBoundary)
                .toImage(pixelRatio: dpr),
      );
      final data = (await tester.runAsync(
        () => picture!.toByteData(format: ui.ImageByteFormat.rawRgba),
      ))!;
      final bytes = data.buffer.asUint8List();
      final x = picture!.width ~/ 2;
      final rows = <int>[];
      for (var y = 0; y < picture.height; y++) {
        final offset = (y * picture.width + x) * 4;
        if (bytes[offset] != 255 ||
            bytes[offset + 1] != 255 ||
            bytes[offset + 2] != 255) {
          rows.add(y);
        }
      }
      expect(rows, hasLength(1), reason: 'Escala $dpr');
      picture.dispose();
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets(
    'abas mantêm os rótulos inteiros e a seleção em uma largura reduzida',
    (tester) async {
      var value = 'Matrículas';
      await tester.pumpWidget(
        shell(
          StatefulBuilder(
            builder: (c, set) => Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 330,
                child: SectionTabs(
                  items: const [
                    'Matrículas',
                    'Diários',
                    'Horários',
                    'Justificativas',
                  ],
                  value: value,
                  onChanged: (v) => set(() => value = v),
                ),
              ),
            ),
          ),
          scale: 1.3,
        ),
      );
      await tester.ensureVisible(find.text('Horários'));
      await tester.tap(find.text('Horários'));
      await tester.pumpAndSettle();
      expect(value, 'Horários');
      expect(find.byType(ChoiceChip), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'rótulo longo fica acima da borda e seleção dependente acompanha o valor',
    (tester) async {
      const label = 'Período de ingresso (anual, semestre ou ciclo)';
      var value = '2026.1';
      late StateSetter update;
      await tester.pumpWidget(
        shell(
          StatefulBuilder(
            builder: (c, set) {
              update = set;
              return Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 285,
                  child: selector(label, value, const [
                    DropdownMenuItem(value: '2026.1', child: Text('2026.1')),
                    DropdownMenuItem(value: '2026.2', child: Text('2026.2')),
                  ], (v) => set(() => value = v!)),
                ),
              );
            },
          ),
          scale: 1.3,
        ),
      );
      expect(
        tester.getBottomLeft(find.text(label)).dy,
        lessThan(tester.getTopLeft(find.byType(InputDecorator)).dy),
      );
      update(() => value = '2026.2');
      await tester.pumpAndSettle();
      expect(find.text('2026.2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('menus do topo separam aparência e comandos do servidor', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: softwareNavigatorKey,
        navigatorObservers: [softwareMenuObserver],
        builder: (c, page) => FTheme(
          data: appTheme(dark: false, touch: false),
          child: WindowOverlay(
            child: Column(
              children: [
                const Material(child: SoftwareMenus()),
                Expanded(child: page!),
              ],
            ),
          ),
        ),
        home: const Scaffold(body: SizedBox()),
      ),
    );
    await tester.tap(find.text('Configurações'));
    await tester.pumpAndSettle();
    expect(find.text('Aparência'), findsOneWidget);
    await tester.tap(find.text('Servidor'));
    await tester.pumpAndSettle();
    expect(find.text('Aparência'), findsNothing);
    expect(find.text('Conectar a um servidor…'), findsOneWidget);
    await tester.tap(find.text('Configurações'));
    await tester.pumpAndSettle();
    expect(find.text('Conectar a um servidor…'), findsNothing);
    await tester.tap(find.text('Aparência'));
    await tester.pumpAndSettle();
    expect(softwareAction.value, SoftwareAction.appearance);
    await tester.tap(find.text('Servidor'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verificar conexão'));
    await tester.pumpAndSettle();
    expect(softwareAction.value, SoftwareAction.status);
    softwareAction.value = null;
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'avisos não criam snackbar nem deslocam o corpo; botão ocupado preserva o tamanho',
    (tester) async {
      late BuildContext context;
      var busy = false;
      late StateSetter update;
      await tester.pumpWidget(
        shell(
          StatefulBuilder(
            builder: (c, set) {
              context = c;
              update = set;
              return Column(
                children: [
                  OperationNoticeButton(
                    onPressed: () => showOperationNotice(c),
                  ),
                  button('Salvar rascunho', () {}, loading: busy),
                  const SizedBox(key: ValueKey('body-anchor'), height: 100),
                ],
              );
            },
          ),
        ),
      );
      final rect = tester.getRect(find.byKey(const ValueKey('body-anchor')));
      feedback(context, 'Operação concluída.');
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      expect(tester.getRect(find.byKey(const ValueKey('body-anchor'))), rect);
      update(() => busy = true);
      await tester.pump();
      expect(tester.getRect(find.byKey(const ValueKey('body-anchor'))), rect);
      update(() => busy = false);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Atividade'));
      await tester.pumpAndSettle();
      expect(find.text('Operação concluída.'), findsOneWidget);
      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(const ValueKey('body-anchor'))), rect);
      expect(operationNotice.value, isNull);
      expect(tester.takeException(), isNull);
    },
  );
  test('datas inserem barras e posicionam o cursor no próximo trecho', () {
    const mask = SchoolDateMask();
    var value = TextEditingValue.empty;
    value = mask.formatEditUpdate(
      value,
      const TextEditingValue(
        text: '13',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    expect(value.text, '13/');
    expect(value.selection.baseOffset, 3);
    value = mask.formatEditUpdate(
      value,
      const TextEditingValue(
        text: '13/04',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    expect(value.text, '13/04/');
    expect(value.selection.baseOffset, 6);
    value = mask.formatEditUpdate(
      value,
      const TextEditingValue(
        text: '13/04/2026',
        selection: TextSelection.collapsed(offset: 10),
      ),
    );
    expect(schoolDate(value.text), DateTime(2026, 4, 13));
    expect(schoolDate('31/02/2026'), isNull);
    expect(schoolDate('13/04/26'), isNull);
    expect(
      mask
          .formatEditUpdate(
            TextEditingValue.empty,
            const TextEditingValue(text: '2026-04-13'),
          )
          .text,
      '13/04/2026',
    );
    expect(
      mask
          .formatEditUpdate(
            const TextEditingValue(text: '13/'),
            const TextEditingValue(text: '13'),
          )
          .text,
      '1',
    );
  });
  testWidgets(
    'data é digitada sem menus e mantém o formato ISO no contrato da API',
    (tester) async {
      final raw = TextEditingController(text: '2026-04-13');
      await tester.pumpWidget(shell(field('Data (AAAA-MM-DD)', raw)));
      final input = find.byType(EditableText);
      expect(tester.widget<EditableText>(input).controller.text, '13/04/2026');
      await tester.enterText(input, '20112026');
      await tester.pump();
      expect(tester.widget<EditableText>(input).controller.text, '20/11/2026');
      expect(raw.text, '2026-11-20');
      expect(find.byType(DatePickerDialog), findsNothing);
      await tester.pumpWidget(const SizedBox());
      raw.dispose();
    },
  );
  testWidgets(
    'uma única opção já definida é informação e não um seletor redundante',
    (tester) async {
      await tester.pumpWidget(
        shell(
          selector('Curso', 'a', const [
            DropdownMenuItem(value: 'a', child: Text('Curso da turma')),
          ], (_) => fail('Não há outra opção para selecionar.')),
        ),
      );
      expect(find.text('Curso da turma'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    },
  );
  testWidgets(
    'cabeçalho preenche a região enquanto o espaçamento fica no corpo',
    (tester) async {
      await tester.pumpWidget(
        shell(
          const SizedBox(
            width: 800,
            height: 600,
            child: PageLayout(
              header: PageHeader(title: 'Área de trabalho'),
              children: [SizedBox(key: ValueKey('content-edge'), height: 20)],
            ),
          ),
        ),
      );
      expect(tester.getTopLeft(find.byType(PageHeader)).dx, 0);
      expect(tester.getSize(find.byType(PageHeader)).width, 800);
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('content-edge'))).dx,
        24,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('status em uma linha de lista ocupa somente sua largura', (
    tester,
  ) async {
    await tester.pumpWidget(
      shell(
        SizedBox(
          width: 400,
          child: ListTile(
            title: const Text('Documento da pasta'),
            trailing: badge('Conferido'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.text('Conferido')).width, lessThan(150));
  });
  testWidgets(
    'caminho mantém subir acessível e abre ancestral pelo identificador',
    (tester) async {
      String? destination;
      await tester.pumpWidget(
        shell(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 290,
              child: FolderBreadcrumbs(
                folders: const [
                  {'id': 'a', 'name': 'Arquivo do setor'},
                  {
                    'id': 'b',
                    'name': 'Reuniões e atas do período letivo',
                    'parent': 'a',
                  },
                ],
                current: 'b',
                rootLabel: 'Arquivo administrativo',
                open: (id) => destination = id,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Subir uma pasta'));
      expect(destination, 'a');
      await tester.ensureVisible(find.text('Arquivo do setor'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arquivo do setor'));
      expect(destination, 'a');
      await tester.pumpWidget(
        shell(
          SizedBox(
            width: 800,
            child: FolderBreadcrumbs(
              folders: const [
                {'id': 'a', 'name': 'Pasta'},
              ],
              current: 'a',
              rootLabel: 'Arquivo',
              open: (_) {},
            ),
          ),
        ),
      );
      expect(tester.getTopLeft(find.text('Arquivo')).dx, lessThan(100));
      expect(tester.takeException(), isNull);
    },
  );
}
