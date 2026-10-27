import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';
import 'package:dPad/main.dart' as app;
import 'package:dPad/shared/api.dart';
import 'package:dPad/features/accounts/accounts_page.dart';
import 'package:dPad/features/school/classes_page.dart';
import 'package:dPad/features/school/journal_panel.dart';
import 'package:dPad/features/students/student_form.dart';
import 'package:dPad/features/students/students_page.dart';

void main() {
  final enabled =
      Platform.isLinux && Platform.environment['DPAD_UI_TESTS'] == '1';
  final api = Api();
  Process? server;
  Directory? directory;
  setUpAll(() async {
    if (!enabled) return;
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
    directory = await Directory.systemTemp.createTemp('dpad-school-ui-');
    final socket = await ServerSocket.bind('127.0.0.1', 0);
    final port = socket.port;
    await socket.close();
    api.base = 'http://127.0.0.1:$port';
    server = await Process.start('dart', [
      'run',
      'bin/dPad_server.dart',
      '--data',
      directory!.path,
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
    for (var i = 0; i < 300; i++) {
      try {
        await api.health(api.base);
        ready = true;
        break;
      } catch (_) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }
    if (!ready) throw StateError('Servidor indisponível: $errors');
    SharedPreferencesLinux.registerWith();
    app.preferences = await SharedPreferences.getInstance();
    await app.preferences.setString('api', api.base);
    app.themeMode.value = ThemeMode.light;
  });
  tearDownAll(() async {
    api.client.close();
    if (server != null) {
      server!.stdin.writeln('shutdown');
      await server!.stdin.flush();
      await server!.exitCode.timeout(const Duration(seconds: 10));
    }
    await directory?.delete(recursive: true);
  });
  testWidgets(
    'instalação vazia: contas, curso, turma na rail, modelo, matrícula, diário e pedido do aluno',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: ProviderScope(
            overrides: [apiProvider.overrideWithValue(api)],
            child: const app.PapelApp(),
          ),
        ),
      );
      Future<void> load() async {
        await tester.pump();
        var quiet = 0;
        for (var i = 0; i < 300; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)),
          );
          await tester.pump(const Duration(milliseconds: 32));
          final busy =
              ProviderScope.containerOf(
                tester.element(find.byType(app.PapelApp)),
              ).read(dataProvider).isLoading ||
              find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
              find.byType(LinearProgressIndicator).evaluate().isNotEmpty ||
              find
                  .textContaining(RegExp('Aguarde…|Enviando…|Salvando…'))
                  .evaluate()
                  .isNotEmpty;
          quiet = busy ? 0 : quiet + 1;
          if (i >= 16 && quiet >= 4) break;
        }
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(LinearProgressIndicator), findsNothing);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      Future<void> click(Finder f) async {
        expect(f, findsWidgets);
        await tester.ensureVisible(f.first);
        await tester.pumpAndSettle();
        await tester.tap(f.first);
        await load();
      }

      Future<void> tap(String label, {bool last = false}) =>
          click(last ? find.text(label).last : find.text(label).first);
      Future<void> fill(Finder form, int index, String text) async {
        final input = find
            .descendant(of: form, matching: find.byType(EditableText))
            .at(index);
        await tester.ensureVisible(input);
        await tester.enterText(input, text);
        await tester.pump();
      }

      Future<void> capture(String name) async {
        final target = Platform.environment['DPAD_SCREENSHOT_DIR'];
        if (target == null) return;
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(target).create(recursive: true);
          await File('$target/$name.png')
              .writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }

      await load();
      expect(find.text('Configurar a instalação'), findsOneWidget);
      var form = find.byType(AlertDialog);
      final auth = find.byType(EditableText);
      await tester.enterText(auth.at(0), 'Administração cadastrada');
      await tester.enterText(auth.at(1), 'admin-escola');
      await tester.enterText(auth.at(2), 'senha longa de acesso teste');
      await tester.enterText(auth.at(3), 'senha longa de acesso teste');
      await tap('Criar administrador');
      expect(
        find.text('Nenhum aluno cadastrado'),
        findsOneWidget,
        reason: tester.allWidgets
            .whereType<Text>()
            .map((w) => w.data)
            .join(' | '),
      );
      await tap('Cursos e turmas');
      await tap('Cadastrar curso');
      form = find.byType(CourseForm);
      await fill(form, 0, 'Formação cadastrada');
      await fill(form, 1, 'Modalidade livre');
      await fill(form, 2, 'Organização semestral');
      await tap('Salvar curso');
      await tap('Cadastrar turma');
      form = find.byType(ClassForm);
      await fill(form, 0, 'GRP-01');
      await fill(form, 2, 'Período A');
      await fill(form, 3, 'Etapa inicial');
      await fill(form, 4, '20');
      await tap('Salvar turma');
      await tap('Formação cadastrada');
      await tap('Período A');
      expect(find.text('GRP-01'), findsNWidgets(2));
      await tap('GRP-01');
      expect(find.text('Diários'), findsOneWidget);
      await capture('turma-e-rail');
      await tap('Modelos de pasta');
      await tap('Criar modelo');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Modelo cadastrado');
      await fill(form, 1, 'CPF\nDeclaração');
      await fill(form, 2, 'Contato alternativo');
      await tap('Salvar modelo');
      await tap('Pastas de alunos');
      await tap('Cadastrar aluno');
      form = find.byType(StudentForm);
      await tap('Sem modelo');
      await tap('Modelo cadastrado', last: true);
      await fill(form, 0, 'Pessoa matriculada');
      await fill(form, 2, 'CAD-001');
      await fill(form, 3, '15/04/2010');
      await fill(form, 7, 'Responsável informado');
      await fill(form, 12, 'Contato informado');
      await tap('Criar pasta');
      await tap('Pessoa matriculada');
      expect(find.text('CPF'), findsOneWidget);
      expect(find.text('Declaração'), findsOneWidget);
      expect(find.text('Cartão SUS'), findsNothing);
      await tap('Matrículas');
      await tap('Ativar matrícula');
      await tap('Confirmar');
      expect(find.textContaining('Há 2 pendências'), findsOneWidget);
      await fill(
        find.byType(AlertDialog),
        0,
        'Documentação acompanhada pela secretaria.',
      );
      await tap('Confirmar');
      expect(find.text('Ativa'), findsOneWidget);
      await capture('pasta-matriculas');
      await tap('Contas e acessos');
      await tap('Cadastrar conta');
      form = find.byType(AccountForm);
      await fill(form, 0, 'Conta do aluno');
      await fill(form, 1, 'aluno-cadastrado');
      await fill(form, 2, 'senha do aluno para teste');
      await fill(form, 3, 'senha do aluno para teste');
      await tap('Professor');
      await tap('Aluno', last: true);
      await click(
        find.descendant(of: form, matching: find.text('Pessoa matriculada')),
      );
      await tap('Salvar conta');
      final accounts = await tester.runAsync(() => api.get('accounts'));
      expect(accounts, hasLength(2));
      await tester.runAsync(
        () => api.send('POST', 'accounts', {
          'name': 'Docente cadastrado',
          'login': 'docente-cadastrado',
          'role': 'professor',
          'password': 'senha longa do docente',
        }),
      );
      await tap('Cursos e turmas');
      await tap('GRP-01');
      await tap('Diários');
      await tap('Organização acadêmica');
      await tap('Disciplinas');
      await tap('Cadastrar disciplina');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Componente registrado');
      await fill(form, 1, 'CMP-01');
      await tap('Salvar');
      await tap('Matrizes');
      await tap('Adicionar componente');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Fase 1');
      await fill(form, 1, '40');
      await fill(form, 2, '45');
      await tap('Salvar');
      expect(find.text('Componente registrado'), findsOneWidget);
      await capture('matriz-por-fase');
      await tap('Cursos e turmas');
      await tap('GRP-01');
      await tap('Diários');
      await tap('Adicionar diário');
      form = find.byType(AlertDialog);
      await tap('Criar diário');
      await tap('Componente registrado');
      await tap('Registrar aula');
      form = find.byType(LessonForm);
      await fill(form, 2, 'Conteúdo e atividades registrados pelo docente.');
      await tap('Marcar todos presentes');
      await tap('Presente');
      await tap('Ausente', last: true);
      await tap('Salvar rascunho');
      await tap('Enviar para revisão');
      await tap('Confirmar');
      await tap('Publicar aula');
      await tap('Confirmar');
      expect(find.text('Publicado'), findsOneWidget);
      await capture('diario-publicado');
      await tap('Avaliações e notas');
      await tap('Lançar avaliação');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Avaliação prática');
      await fill(form, 1, 'Unidade 1');
      await fill(form, 3, '10');
      await fill(form, 4, '1');
      await tap('Pendente');
      await tap('Lançada', last: true);
      await fill(form, 5, '8,5');
      await tap('Salvar rascunho');
      await tap('Avaliação prática');
      await tap('Enviar notas');
      await tap('Confirmar');
      await tap('Publicar notas');
      await tap('Confirmar');
      await capture('notas-publicadas');
      await tap('Horários');
      await tap('Adicionar horário');
      form = find.byType(AlertDialog);
      await fill(form, 0, '07:15');
      await fill(form, 1, '08:00');
      await fill(form, 2, '${DateTime.now().year}-01-01');
      await fill(form, 3, '${DateTime.now().year}-12-31');
      await fill(form, 4, 'Sala 2');
      await tap('Salvar horário');
      expect(
        find.byType(AlertDialog),
        findsNothing,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((w) => w.data)
            .join(' | '),
      );
      expect(
        find.textContaining(RegExp(r'^Segunda')),
        findsOneWidget,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((w) => w.data)
            .join(' | '),
      );
      await capture('horario-por-dia');

      await click(find.byTooltip('Sair da conta'));
      expect(find.text('Entrar na escola'), findsOneWidget);
      await tester.enterText(
        find.byType(EditableText).at(0),
        'aluno-cadastrado',
      );
      await tester.enterText(
        find.byType(EditableText).at(1),
        'senha do aluno para teste',
      );
      await tap('Entrar');
      expect(find.text('Contas e acessos'), findsNothing);
      expect(find.text('Atendimento'), findsNothing);
      expect(find.text('Modelos de pasta'), findsNothing);
      await tap('Pessoa matriculada');
      await tap('Boletim e frequência');
      expect(find.text('Média de acompanhamento: 8.50 / 10'), findsOneWidget);
      final chipFont = Theme.of(tester.element(find.byType(StudentsPage)))
          .chipTheme
          .labelStyle
          ?.fontFamily;
      expect(chipFont, contains('Inter'));
      await capture('boletim-aluno');
      await tap('Frequência');
      await tap('Justificar falta');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Ausência por necessidade familiar.');
      await tap('Salvar');
      await tap('Justificativas');
      await tap('Pessoa matriculada · Componente registrado');
      expect(find.text('Ausência por necessidade familiar.'), findsOneWidget);
      await click(
        find.descendant(
          of: find.byType(StudentsPage),
          matching: find.text('Solicitações'),
        ),
      );
      await tap('Nova solicitação');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Pedido pelo aplicativo');
      await fill(
        form,
        1,
        'Solicito uma declaração para comprovação de vínculo.',
      );
      await tap('Enviar solicitação');
      expect(find.text('Pedido pelo aplicativo'), findsOneWidget);
      final requests = await tester.runAsync(() => api.get('requests'));
      expect(requests, hasLength(1));
      app.themeMode.value = ThemeMode.dark;
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(tester.widget<TabBar>(find.byType(TabBar)).isScrollable, isTrue);
      expect(tester.takeException(), isNull);
      final colors = FTheme.of(tester.element(find.byType(StudentsPage)))
          .colors;
      double contrast(Color a, Color b) {
        final x = a.computeLuminance(), y = b.computeLuminance();
        return x > y ? (x + .05) / (y + .05) : (y + .05) / (x + .05);
      }

      expect(
        contrast(colors.foreground, colors.background),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(colors.mutedForeground, colors.background),
        greaterThanOrEqualTo(4.5),
      );
      await capture('aluno-android-layout');
      tester.view.physicalSize = const Size(1440, 1000);
      app.themeMode.value = ThemeMode.light;
      await tester.pumpAndSettle();
      await click(find.byTooltip('Sair da conta'));
      await tester.enterText(find.byType(EditableText).at(0), 'admin-escola');
      await tester.enterText(
        find.byType(EditableText).at(1),
        'senha longa de acesso teste',
      );
      await tap('Entrar');
      await tap('Atendimento');
      await tap('Pedido pelo aplicativo');
      expect(find.text('Conta do aluno'), findsOneWidget);
      expect(find.text('Pessoa matriculada'), findsOneWidget);
      await capture('atendimento-com-identificacao');
      await tap('Cursos e turmas');
      await tap('GRP-01');
      await tap('Justificativas');
      await tap('Pessoa matriculada · Componente registrado');
      await tap('Analisar justificativa');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Documento e motivo conferidos. Falta justificada.');
      await tap('Salvar');
      expect(find.text('Deferida'), findsOneWidget);
      await capture('justificativa-analisada');
      await tap('Modelos de pasta');
      await tap('Criar modelo');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Complemento documental');
      await fill(form, 1, 'RG');
      await tap('Salvar modelo');
      await tap('Pastas de alunos');
      await tap('Pessoa matriculada');
      await tap('Aplicar modelo');
      await tap('Complemento documental');
      await tap('Confirmar');
      expect(find.text('RG'), findsOneWidget);

      await tap('Arquivo de documentos');
      await tap('Nova pasta');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Atas de teste');
      await tap('Salvar pasta');
      expect(
        find.text('Pasta vazia. Importe um arquivo ou adicione uma subpasta.'),
        findsOneWidget,
      );
      await tap('Nova pasta');
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Reuniões');
      await tap('Salvar pasta');
      final folderRows = await tester.runAsync(() => api.get('folders'));
      final parent = List<JsonMap>.from(folderRows)
          .firstWhere((f) => f['name'] == 'Atas de teste');
      final child = List<JsonMap>.from(folderRows)
          .firstWhere((f) => f['name'] == 'Reuniões');
      await tester.runAsync(() async {
        final queue = await api.get('requests?queue=true');
        final pdf = await api.pdf(queue.first['id']);
        await api.upload(pdf, 'Ata da reunião.pdf', child['id'], 'Ata');
      });
      await click(find.byTooltip('Atualizar arquivo'));
      expect(find.text('Ata da reunião.pdf'), findsOneWidget);
      final archiveSearch = find.descendant(
        of: find.byKey(const ValueKey('archive-search')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(archiveSearch, 'reuniao');
      await tester.pumpAndSettle();
      expect(find.text('Ata da reunião.pdf'), findsOneWidget);
      await tester.enterText(archiveSearch, '');
      await tester.pumpAndSettle();
      await tap('Ata da reunião.pdf');
      final pane = find.byKey(const ValueKey('details-pane'));
      final oldWidth = tester.getSize(pane).width;
      await tester.drag(
        find.byKey(const ValueKey('resize-details')),
        const Offset(-65, 0),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(pane).width, greaterThan(oldWidth));
      await tap('Editar / mover');
      form = find.byType(AlertDialog);
      await click(
        find.descendant(
          of: form,
          matching: find.text('Atas de teste / Reuniões'),
        ),
      );
      await tap('Atas de teste', last: true);
      await tap('Salvar');
      await click(find.byTooltip('Fechar detalhes'));
      expect(
        find.text('Pasta vazia. Importe um arquivo ou adicione uma subpasta.'),
        findsOneWidget,
      );
      await click(find.byTooltip('Editar pasta'));
      form = find.byType(AlertDialog);
      await fill(form, 0, 'Pré-matrícula');
      await tap('Atas de teste');
      await tap('Raiz do arquivo', last: true);
      await tap('Salvar pasta');
      await tap('Arquivo administrativo');
      await click(find.byTooltip('Opções da pasta Pré-matrícula'));
      await tap('Excluir pasta vazia');
      await tap('Confirmar');
      final afterDelete = await tester.runAsync(() => api.get('folders'));
      expect(
        List<JsonMap>.from(afterDelete).any((f) => f['id'] == child['id']),
        isFalse,
      );
      final documents = await tester.runAsync(() => api.get('documents'));
      expect(
        List<JsonMap>.from(documents)
            .firstWhere((d) => d['name'] == 'Ata da reunião.pdf')['folder'],
        parent['id'],
      );
      await click(find.byTooltip('Recolher navegação'));
      expect(app.preferences.getBool('sidebarCollapsed'), isTrue);
      expect(find.byTooltip('Expandir navegação'), findsOneWidget);
      await capture('arquivo-sidebar-recolhida');
      await click(find.byTooltip('Expandir navegação'));
      expect(app.preferences.getBool('sidebarCollapsed'), isFalse);
      await capture('arquivo-navegavel');

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 20));
      app.themeMode.value = ThemeMode.system;
    },
    skip: !enabled,
  );
}
