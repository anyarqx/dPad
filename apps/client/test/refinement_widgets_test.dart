import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:dPad/shared/widgets.dart';
import 'package:dPad/shared/localities.dart';
import 'package:dPad/shared/folders.dart';
import 'package:dPad/shared/api.dart';

Widget frame(Widget child) {
  final theme = FTheme.neutral.light.desktop;
  return MaterialApp(
    theme: theme.toApproximateMaterialTheme(),
    builder: (c, child) => FTheme(data: theme, child: child!),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [child],
        ),
      ),
    ),
  );
}

Future<void> search(WidgetTester tester, String text) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 30)),
  );
  await tester.pumpAndSettle();
  await tester.enterText(
    find.descendant(
      of: find.byKey(const ValueKey('picker-query')),
      matching: find.byType(EditableText),
    ),
    text,
  );
  await tester.pumpAndSettle();
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
    await BrazilianLocalities.catalog;
  });
  test(
    'pastas de áreas diferentes e nomes iguais são identificáveis no destino',
    () {
      final folders = <JsonMap>[
        {'id': 'a', 'name': 'Documentos pessoais', 'area_name': 'Conta A'},
        {'id': 'b', 'name': 'Documentos pessoais', 'area_name': 'Conta B'},
        {'id': 'c', 'name': 'Anexos', 'parent': 'b'},
        {
          'id': 'd',
          'name': 'pasta-interna',
          'student_name': 'Pessoa cadastrada',
        },
      ];
      expect(folderLocation('a', folders), 'Documentos pessoais · Conta A');
      expect(
        folderLocation('c', folders),
        'Documentos pessoais · Conta B / Anexos',
      );
      expect(folderLocation('d', folders), 'Pessoa cadastrada');
    },
  );
  testWidgets('ajuda fica oculta e abre por clique sem deslocar o campo', (
    tester,
  ) async {
    final controller = TextEditingController();
    await tester.pumpWidget(frame(field('E-mail', controller)));
    final before = tester.getTopLeft(
      find.byKey(const ValueKey('field:E-mail')),
    );
    expect(
      find.text('Endereço usado para contato; não cria uma conta de acesso.'),
      findsNothing,
    );
    expect(find.text('nome@dominio.com'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('help:E-mail')));
    await tester.pumpAndSettle();
    expect(
      find.text('Endereço usado para contato; não cria uma conta de acesso.'),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('field:E-mail'))),
      before,
    );
    Tooltip.dismissAllToolTips();
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets(
    'município e UF são pesquisáveis sem acentos no catálogo oficial',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final catalog = (await tester.runAsync(
        () => BrazilianLocalities.catalog,
      ))!;
      expect(catalog.states, hasLength(27));
      expect(catalog.cities.length, greaterThan(5500));
      final controller = TextEditingController();
      await tester.pumpWidget(frame(LocalityField(controller: controller)));
      await tester.tap(find.byKey(const ValueKey('picker:Naturalidade')));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await search(tester, 'santarem para');
      expect(find.text('Santarém / PA'), findsOneWidget);
      expect(controller.text, isEmpty);
      await tester.tap(find.text('Santarém / PA'));
      await tester.pumpAndSettle();
      expect(controller.text, 'Santarém / PA');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets(
    'localidade não listada exige escolha explícita e cancelamento preserva o valor',
    (tester) async {
      final controller = TextEditingController(text: 'Localidade anterior');
      await tester.pumpWidget(frame(LocalityField(controller: controller)));
      await tester.tap(find.byKey(const ValueKey('picker:Naturalidade')));
      await tester.pumpAndSettle();
      await search(tester, 'Lisboa, Portugal');
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(controller.text, 'Localidade anterior');
      await tester.tap(find.byKey(const ValueKey('picker:Naturalidade')));
      await tester.pumpAndSettle();
      await search(tester, 'Lisboa, Portugal');
      await tester.tap(find.text('Usar “Lisboa, Portugal”'));
      await tester.pumpAndSettle();
      expect(controller.text, 'Lisboa, Portugal');
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets(
    'endereço antigo é preservado e município selecionado pode ser reaberto',
    (tester) async {
      final controller = TextEditingController(
        text: 'Rua antiga, 10, bairro Centro',
      );
      await tester.pumpWidget(frame(AddressField(controller: controller)));
      expect(controller.text, 'Rua antiga, 10, bairro Centro');
      await tester.tap(
        find.byKey(const ValueKey('picker:Município de residência')),
      );
      await tester.pumpAndSettle();
      await search(tester, 'santarem pa');
      await tester.tap(find.text('Santarém / PA'));
      await tester.pumpAndSettle();
      expect(
        controller.text,
        'Rua antiga, 10, bairro Centro\nMunicípio: Santarém / PA',
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(frame(AddressField(controller: controller)));
      final street = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const ValueKey('field:Endereço de residência')),
          matching: find.byType(EditableText),
        ),
      );
      expect(street.controller.text, 'Rua antiga, 10, bairro Centro');
      expect(find.text('Santarém / PA'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
}
