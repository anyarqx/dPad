import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:forui/forui.dart';
import 'package:dPad/main.dart' as application;
import 'package:dPad/shared/api.dart';
import 'package:dPad/shared/window_title_bar.dart';
import 'package:dPad/shared/window_overlay.dart';
import 'package:dPad/shared/widgets.dart';
import 'package:dPad/features/students/student_form.dart';
import 'package:dPad/features/students/students_page.dart';
import 'package:dPad/features/forms.dart';

void main() {
  final enabled =
      Platform.isLinux && Platform.environment['DPAD_UI_TESTS'] == '1';
  final api = Api();
  Process? server;
  Directory? temp;
  setUpAll(() async {
    if (!enabled) return;
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
    temp = await Directory.systemTemp.createTemp('dpad-student-ui-');
    final socket = await ServerSocket.bind('127.0.0.1', 0);
    final port = socket.port;
    await socket.close();
    api.base = 'http://127.0.0.1:$port';
    server = await Process.start('dart', [
      'run',
      'bin/dPad_server.dart',
      '--data',
      temp!.path,
      '--port',
      '$port',
      '--controlled',
    ], workingDirectory: '../server');
    final errors = StringBuffer();
    server!.stderr
        .transform(const SystemEncoding().decoder)
        .listen(errors.write);
    server!.stdout.listen((_) {});
    var ready = false;
    for (var i = 0; i < 120; i++) {
      try {
        await api.health(api.base);
        ready = true;
        break;
      } catch (_) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }
    if (!ready) throw Exception('Servidor real indisponível: $errors');
    await api.authenticate({
      'name': 'Administração do teste',
      'login': 'administrador',
      'password': 'senha longa de teste',
    }, setup: true);
    final template = jsonDecode(
      await File('../../assets/templates/pasta-escolar.json').readAsString(),
    ) as JsonMap;
    final savedTemplate = await api.send('POST', 'templates', template);
    final course = await api.send('POST', 'courses', {
      'name': 'Curso cadastrado para teste',
      'modality': 'Modalidade de teste',
      'template': savedTemplate['id'],
    });
    await api.send('POST', 'classes', {
      'course': course['id'],
      'name': 'Turma cadastrada para teste',
      'school_year': DateTime.now().year,
      'period_label': 'Anual',
      'grade': 'Etapa de teste',
      'shift': 'Matutino',
      'capacity': 40,
    });
    SharedPreferencesLinux.registerWith();
    application.preferences = await SharedPreferences.getInstance();
    await application.preferences.setString('api', api.base);
    await application.preferences.setString('profile', 'local');
    application.themeMode.value = ThemeMode.light;
  });
  tearDownAll(() async {
    api.client.close();
    if (server != null) {
      server!.stdin.writeln('shutdown');
      await server!.stdin.flush();
      await server!.exitCode.timeout(const Duration(seconds: 10));
    }
    await temp?.delete(recursive: true);
  });
  testWidgets(
    'pasta é uma pessoa: cadastro, dados, checklist real e renderização em escalas fracionárias',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 960);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: ProviderScope(
            overrides: [apiProvider.overrideWithValue(api)],
            child: const application.PapelApp(),
          ),
        ),
      );
      Future<void> load() async {
        await tester.pump();
        var quiet = 0;
        for (var i = 0; i < 100; i++) {
          await tester.runAsync(() async {
            await Future<void>.delayed(const Duration(milliseconds: 50));
          });
          await tester.pump(const Duration(milliseconds: 32));
          final loading =
              find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
              find.byType(LinearProgressIndicator).evaluate().isNotEmpty ||
              find
                  .textContaining(RegExp('Enviando…|Salvando…'))
                  .evaluate()
                  .isNotEmpty;
          quiet = loading ? 0 : quiet + 1;
          if (i >= 12 && quiet >= 4) break;
        }
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(LinearProgressIndicator), findsNothing);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      Future<void> tap(String label, {bool last = false}) async {
        final f = last ? find.text(label).last : find.text(label).first;
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump();
        await tester.ensureVisible(f);
        await tester.pumpAndSettle();
        await tester.tap(f);
        await load();
      }

      Future<void> capture(String name, double dpr) async {
        final path = Platform.environment['DPAD_SCREENSHOT_DIR'];
        if (path == null) return;
        await tester.runAsync(() async {
          final image =
              await (key.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage(pixelRatio: dpr);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(path).create(recursive: true);
          await File('$path/$name.png')
              .writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      await load();
      expect(find.text('Nenhum aluno cadastrado'), findsOneWidget);
      expect(find.byKey(const ValueKey('demo-profile')), findsNothing);
      expect(find.text('Requerimento demonstrativo.pdf'), findsNothing);
      expect(find.text('Ana Oliveira'), findsNothing);
      await tap('Cadastrar aluno');
      final form = find.byType(StudentForm);
      Future<void> fillStudent(String label, String value) async {
        final field = find.descendant(
          of: form,
          matching: find.byWidgetPredicate(
            (w) => w is FTextField && w.key == ValueKey('field:$label'),
          ),
        );
        final editable = find.descendant(
          of: field,
          matching: find.byType(EditableText),
        );
        await tester.ensureVisible(editable);
        await tester.enterText(editable, value);
        await tester.pumpAndSettle();
      }

      expect(
        find.text(
          'Use o nome conforme o documento de identificação, sem abreviações.',
        ),
        findsNothing,
      );
      await tapHelp(tester, 'Nome completo *');
      expect(
        find.text(
          'Use o nome conforme o documento de identificação, sem abreviações.',
        ),
        findsOneWidget,
      );
      Tooltip.dismissAllToolTips();
      await tester.pumpAndSettle();
      await fillStudent('Nome completo *', 'Estudante cadastrado pelo usuário');
      await fillStudent('Matrícula ou identificação', 'REG-UI-01');
      await fillStudent('Nascimento (DD/MM/AAAA)', '12/03/2010');
      await fillStudent('Responsável', 'Responsável informado');
      await fillStudent('Telefone de contato', 'Contato de teste');
      await fillStudent('E-mail', 'responsavel@example.invalid');
      await fillStudent('Observações', 'Observação cadastrada.');
      await tap('Adicionar informação');
      await fillStudent('Informação', 'Transporte');
      await fillStudent('Valor', 'Escolar');
      await tap('Criar pasta');
      expect(find.byType(StudentForm), findsNothing);
      final students = await tester.runAsync(
        () async => List<JsonMap>.from(await api.get('students')),
      );
      expect(students, hasLength(1));
      final student = students!.single;
      await tester.enterText(find.byType(EditableText).first, 'cadastrado');
      await tester.pumpAndSettle();
      await tap('Estudante cadastrado pelo usuário');
      expect(find.text('11 ainda não enviados'), findsOneWidget);
      expect(find.text('Comprovante de residência'), findsOneWidget);
      await tap('Dados do aluno');
      await tester.scrollUntilVisible(
        find.text('12/03/2010'),
        150,
        scrollable: find
            .descendant(
              of: find
                  .descendant(
                    of: find.byType(StudentsPage),
                    matching: find.byType(ListView),
                  )
                  .first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('12/03/2010'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Responsável informado'),
        150,
        scrollable: find
            .descendant(
              of: find
                  .descendant(
                    of: find.byType(StudentsPage),
                    matching: find.byType(ListView),
                  )
                  .first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Responsável informado'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Transporte'),
        200,
        scrollable: find
            .descendant(
              of: find
                  .descendant(
                    of: find.byType(StudentsPage),
                    matching: find.byType(ListView),
                  )
                  .first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Escolar'), findsOneWidget);
      final detail = await tester.runAsync(
        () async => JsonMap.from(await api.get('students/${student['id']}')),
      );
      expect(detail!['birth_date'], '2010-03-12');
      expect(detail['extra']['Transporte'], 'Escolar');
      final pdf = pw.Document()
        ..addPage(
          pw.Page(
            build: (_) =>
                pw.Text('Arquivo de teste para validar o vinculo ao aluno.'),
          ),
        );
      final bytes = await tester.runAsync(pdf.save);
      await tester.runAsync(() async {
        await api.upload(bytes!, 'cpf.pdf', student['folder'], 'CPF');
      });
      await tap('Documentos');
      // Reabrir o dossiê consulta novamente os documentos persistidos pelo servidor.
      await tap('Pastas de alunos');
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).first)
            .controller
            .text,
        'cadastrado',
      );
      await tap('Estudante cadastrado pelo usuário');
      expect(find.text('1 de 11 recebidos'), findsOneWidget);
      expect(find.text('cpf.pdf'), findsOneWidget);
      final folders = await tester.runAsync(
        () async => List<JsonMap>.from(await api.get('folders')),
      );
      expect(folders, hasLength(1));
      expect(folders!.single['parent'], isNull);
      await tap('Solicitações', last: true);
      await tap('Nova solicitação');
      final requestFields = find.descendant(
        of: find.byType(RequestForm),
        matching: find.byType(EditableText),
      );
      await tester.enterText(requestFields.at(0), 'Declaração para o aluno');
      await tester.enterText(
        requestFields.at(1),
        'Preciso da declaração de vínculo.',
      );
      await tap('Fechar');
      await tap('Dados do aluno');
      await tap('Solicitações', last: true);
      await tap('Nova solicitação');
      expect(
        tester.widget<EditableText>(requestFields.at(0)).controller.text,
        'Declaração para o aluno',
      );
      await tap('Enviar solicitação');
      expect(find.byType(RequestForm), findsNothing);
      final requests = await tester.runAsync(
        () async => List<JsonMap>.from(await api.get('requests')),
      );
      expect(requests, hasLength(1));
      expect(requests!.single['student'], student['id']);
      expect(find.text('Declaração para o aluno'), findsOneWidget);
      await tap('Nova solicitação');
      expect(
        tester.widget<EditableText>(requestFields.at(0)).controller.text,
        isEmpty,
      );
      await tap('Fechar');
      await tap('Documentos');
      for (final dpr in [1.0, 1.25, 1.5, 2.0]) {
        tester.view.devicePixelRatio = dpr;
        tester.view.physicalSize = Size(1440 * dpr, 960 * dpr);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final line = find
            .byWidgetPredicate(
              (w) => w is PixelDivider && w.axis == Axis.horizontal,
            )
            .first;
        expect(tester.getSize(line).height, closeTo(1 / dpr, .001));
        expect(find.text('1 de 11 recebidos'), findsOneWidget);
        await capture('pasta-aluno-${dpr}x', dpr);
      }
      application.themeMode.value = ThemeMode.dark;
      await tester.pumpAndSettle();
      await capture('pasta-aluno-dark-2x', 2);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('pasta-aluno-estreita', 1);
      await tester.pumpWidget(const SizedBox());
      api.client.close();
      await tester.pump(const Duration(seconds: 20));
      application.themeMode.value = ThemeMode.system;
    },
    skip: !enabled,
  );
  testWidgets(
    'barra de janela oferece controles acessíveis e gesto de maximizar',
    (tester) async {
      var minimized = 0, maximized = 0, closed = 0;
      final theme = FTheme.neutral.light.desktop;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme.toApproximateMaterialTheme(),
          home: Scaffold(
            body: WindowTitleBar(
              minimize: () => minimized++,
              maximize: () => maximized++,
              close: () => closed++,
              drag: () {},
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Minimizar'));
      await tester.tap(find.byTooltip('Maximizar'));
      await tester.tap(find.byTooltip('Fechar janela'));
      await tester.tap(find.text('Do Papel ao Digital'));
      await tester.pump(const Duration(milliseconds: 80));
      await tester.tap(find.text('Do Papel ao Digital'));
      await tester.pumpAndSettle();
      expect([minimized, maximized, closed], [1, 2, 1]);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'barra acima do Navigator possui Overlay e mostra tooltip sem erro',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (c, navigator) => WindowOverlay(
            child: Column(
              children: [
                WindowTitleBar(
                  minimize: () {},
                  maximize: () {},
                  close: () {},
                  drag: () {},
                ),
                Expanded(child: navigator!),
              ],
            ),
          ),
          home: const Scaffold(body: Text('Conteúdo da janela')),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final mouse = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byTooltip('Fechar janela')));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Fechar janela'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
    },
  );
  testWidgets('progresso mantém a posição do conteúdo', (tester) async {
    final loading = ValueNotifier(false);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: loading,
            builder: (c, value, _) => Column(
              children: [loadingLine(value), const Text('Conteúdo estável')],
            ),
          ),
        ),
      ),
    );
    final before = tester.getTopLeft(find.text('Conteúdo estável'));
    loading.value = true;
    await tester.pump();
    expect(tester.getTopLeft(find.text('Conteúdo estável')), before);
    loading.value = false;
    await tester.pump();
    expect(tester.getTopLeft(find.text('Conteúdo estável')), before);
    await tester.pumpWidget(const SizedBox());
    loading.dispose();
  });
}

Future<void> tapHelp(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(ValueKey('help:$label')));
  await tester.pumpAndSettle();
}
