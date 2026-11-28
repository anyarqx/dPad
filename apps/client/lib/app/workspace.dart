import 'package:material_ui/material_ui.dart';

import 'dart:ui' show AppExitResponse;
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../shared/api.dart';
import '../shared/folders.dart';
import '../shared/search_picker.dart';
import '../shared/widgets.dart';
import '../shared/page_header.dart';
import '../shared/app_theme.dart';
import '../shared/software_menu.dart';
import '../shared/operation_status.dart';
import '../shared/suggestion_field.dart';
import '../shared/launcher.dart';
import '../shared/window_chrome.dart';
import '../features/forms.dart';
import '../features/documents/archive_page.dart';
import '../features/viewer.dart';
import '../features/students/students_page.dart';
import '../features/students/student_form.dart';
import '../features/accounts/auth_page.dart';
import '../features/accounts/accounts_page.dart';
import '../features/accounts/maintenance_page.dart';
import '../features/school/classes_page.dart';
import '../features/school/academic_page.dart';
import '../features/students/templates_page.dart';
import '../main.dart' show preferences, themeMode;

part 'details.dart';
part 'dialogs.dart';
part 'navigation.dart';

class Workspace extends ConsumerStatefulWidget {
  final String section;
  final String? folder;
  final String? student;
  final String? classId;
  const Workspace({
    super.key,
    required this.section,
    this.folder,
    this.student,
    this.classId,
  });
  @override
  ConsumerState<Workspace> createState() => _WorkspaceState();
}

class _WorkspaceState extends ConsumerState<Workspace>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _selection = ValueNotifier<JsonMap?>(null);
  JsonMap? get selected => _selection.value;
  set selected(JsonMap? item) => _selection.value = item;
  String? kind;
  late bool sidebarCollapsed;
  late double detailsWidth;
  int selectionTicket = 0;
  bool detailLoading = false;
  Future<Uint8List>? selectedImage;
  void toggleSidebar() {
    setState(() => sidebarCollapsed = !sidebarCollapsed);
    preferences.setBool('sidebarCollapsed', sidebarCollapsed);
  }

  void closeDetails() {
    selectionTicket++;
    _scaffoldKey.currentState?.closeEndDrawer();
    setState(() {
      selected = null;
      kind = null;
      detailLoading = false;
    });
  }

  bool get dockDetails {
    final width = MediaQuery.sizeOf(context).width;
    return const [
          'students',
          'documents',
          'requests',
          'queue',
        ].contains(widget.section) &&
        width >= 1050 &&
        width - navigationWidth - 520 >= 280;
  }

  void presentDetails() {
    if (!dockDetails) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && selected != null) {
          _scaffoldKey.currentState?.openEndDrawer();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant Workspace old) {
    super.didUpdateWidget(old);
    if (old.section != widget.section ||
        old.folder != widget.folder ||
        old.student != widget.student ||
        old.classId != widget.classId) {
      selectionTicket++;
      selected = null;
      kind = null;
      detailLoading = false;
    }
  }

  String search = '', filter = 'Todos';
  bool descending = false, busy = false;
  final drafts = <String, RequestDraft>{};
  String? railYear;
  Api get api => ref.read(apiProvider);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    softwareAction.addListener(handleSoftwareAction);
    sidebarCollapsed = preferences.getBool('sidebarCollapsed') ?? false;
    detailsWidth = (preferences.getDouble('detailsWidth') ?? 360).clamp(
      280,
      480,
    );
    api.base = preferences.getString('api') ?? api.base;
    api.profile = preferences.getString('profile') ?? 'local';
  }

  @override
  void dispose() {
    softwareAction.removeListener(handleSoftwareAction);
    WidgetsBinding.instance.removeObserver(this);
    _selection.dispose();
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await stopHost();
    return AppExitResponse.exit;
  }

  void handleSoftwareAction() {
    final action = softwareAction.value;
    if (!mounted || action == null) return;
    switch (action) {
      case SoftwareAction.appearance:
        settings();
      case SoftwareAction.connection:
        connection();
      case SoftwareAction.status:
        showServerStatus();
      case SoftwareAction.stop:
        stopHosting();
      case SoftwareAction.activity:
        showOperationNotice(context);
      case SoftwareAction.maintenance:
        final data = ref.read(dataProvider).value;
        if (data?['session']?['user']?['role'] == 'admin') {
          go('maintenance');
        } else {
          feedback(
            context,
            'A manutenção exige uma conta de administração.',
            error: true,
          );
        }
      case SoftwareAction.help:
        showShortcutTable(context, desktop: windowChromeEnabled);
      case SoftwareAction.fullscreen:
        toggleFullScreen();
      case SoftwareAction.navigation:
        final data = ref.read(dataProvider).value;
        if (data != null) chooseSection(data);
      case SoftwareAction.sidebar:
        if (MediaQuery.sizeOf(context).width < 1050 || autoCompact) {
          final scaffold = _scaffoldKey.currentState;
          if (scaffold?.isDrawerOpen == true) {
            scaffold?.closeDrawer();
          } else {
            scaffold?.openDrawer();
          }
        } else {
          toggleSidebar();
        }
      case SoftwareAction.licenses:
        openEditor<void>(context, const LicensePage(applicationName: 'dPad'));
    }
  }

  Future<void> chooseSection(JsonMap data) async {
    final section = await pickChoice(
      context,
      title: 'Ir para seção',
      choices: [
        for (final item in navigationItems(data))
          SearchChoice(item.$1, item.$2),
      ],
      selected: widget.section,
    );
    if (mounted && section != null) go(section);
  }

  void stateChange(VoidCallback fn) => setState(fn);

  void refresh() {
    ref.invalidate(dataProvider);
    ref.invalidate(resourceProvider);
  }

  void go(String section, [String? folder]) {
    _scaffoldKey.currentState?.closeDrawer();
    _scaffoldKey.currentState?.closeEndDrawer();
    selectionTicket++;
    setState(() {
      if (section == 'classes' && folder != null) {
        final data = ref.read(dataProvider).value;
        final group = data == null
            ? null
            : List<JsonMap>.from(data['classes'] ?? [])
                  .where((g) => g['id'] == folder)
                  .firstOrNull;
        if (group != null) railYear = '${group['school_year']}';
      }
      selected = null;
      kind = null;
      search = '';
      filter = 'Todos';
    });
    context.go(
      '/$section${folder == null
          ? ''
          : section == 'students'
          ? '?student=$folder'
          : section == 'classes'
          ? '?class=$folder'
          : '?folder=$folder'}',
    );
  }

  Future<void> run(Future<void> Function() fn) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await fn();
      refresh();
    } catch (e) {
      if (mounted) feedbackError(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> choose(JsonMap item, String type) async {
    final ticket = ++selectionTicket;
    setState(() {
      selected = item;
      kind = type;
      detailLoading = type == 'request';
      selectedImage = null;
    });
    presentDetails();
    if (type != 'request') return;
    try {
      final response = await api.get('requests/${item['id']}');
      if (mounted && ticket == selectionTicket) {
        setState(() {
          selected = response;
          detailLoading = false;
        });
      }
    } catch (e) {
      if (mounted && ticket == selectionTicket) {
        closeDetails();
        feedbackError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext c) {
    final state = ref.watch(dataProvider);
    return state.when(
      loading: () => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Conectando ao servidor…'),
              TextButton(
                onPressed: connection,
                child: const Text('Configurar conexão'),
              ),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 530),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(FLucideIcons.server, size: 36),
                    const SizedBox(height: 24),
                    Text(
                      e is ApiException
                          ? switch (e.failure) {
                              ApiFailure.permission => 'Acesso não autorizado',
                              ApiFailure.session => 'Sessão expirada',
                              ApiFailure.incompatible => 'API incompatível',
                              ApiFailure.address => 'Endereço inválido',
                              ApiFailure.connection => 'Falha de conexão',
                              _ => 'Não foi possível carregar',
                            }
                          : 'Não foi possível carregar',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 16),
                    button(
                      'Configurar conexão',
                      busy ? null : connection,
                      icon: FLucideIcons.network,
                      primary: true,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: busy ? null : refresh,
                      child: const Text('Tentar novamente'),
                    ),
                    const SizedBox(height: 16),
                    ExpansionTile(
                      title: const Text(
                        'Detalhes da conexão',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: SelectableText(
                            '${api.base}\n${e.toString().replaceFirst('Exception: ', '')}',
                            style: const TextStyle(fontSize: 12, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      data: (data) {
        if (data.containsKey('auth')) {
          if (state.isRefreshing) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return AuthPage(
            api: api,
            status: JsonMap.from(data['auth']),
            message: data['message'],
            authenticated: refresh,
            connection: connection,
          );
        }
        final modules = {
          for (final path in sectionResources[widget.section] ?? <String>[])
            path: ref.watch(resourceProvider(path)),
        };
        final primary =
            (mainSectionResources[widget.section] ?? const <String>[]).map(
              (key) => modules[key]!,
            );
        final moduleLoading = primary.any((v) => v.isLoading && !v.hasValue);
        final moduleError = primary.where((v) => v.hasError).firstOrNull?.error;
        data = {
          ...data,
          for (final key in [
            'students',
            'folders',
            'documents',
            'requests',
            'queue',
            'templates',
          ])
            key: const <dynamic>[],
          for (final entry in modules.entries)
            entry.key == 'requests?queue=true' ? 'queue' : entry.key:
                entry.value.value ?? const <dynamic>[],
        };
        final width = MediaQuery.sizeOf(c).width;
        final wide = width >= 1050;
        final navWidth = navigationWidth;
        final docked = dockDetails;
        final paneWidth = docked
            ? detailsWidth.clamp(
                280.0,
                (width - navWidth - 520).clamp(280.0, 480.0),
              )
            : (width - 32).clamp(0.0, 400.0);
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: ModalRoute.isCurrentOf(c) != false,
          drawer: wide && !autoCompact
              ? null
              : Drawer(child: sidebar(data, forceExpanded: true)),
          endDrawer: !docked && selected != null
              ? Drawer(
                  width: paneWidth,
                  child: Material(
                    color: AppSurfaces.of(c).detail,
                    child: SafeArea(
                      child: ValueListenableBuilder(
                        valueListenable: _selection,
                        builder: (c, item, _) => item == null
                            ? const SizedBox.shrink()
                            : details(data, onClose: closeDetails),
                      ),
                    ),
                  ),
                )
              : null,
          appBar: wide
              ? null
              : AppBar(
                  title: Text(
                    widget.section == 'students' && widget.student == null
                        ? 'dPad'
                        : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  actions: [
                    if (!windowChromeEnabled)
                      OperationNoticeButton(
                        onPressed: () => showOperationNotice(context),
                      ),
                    if (!windowChromeEnabled)
                      PopupMenuButton<SoftwareAction>(
                        tooltip: 'Software e servidor',
                        onSelected: openSoftwareAction,
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: SoftwareAction.appearance,
                            child: Text('Configurações'),
                          ),
                          PopupMenuItem(
                            value: SoftwareAction.connection,
                            child: Text('Servidor'),
                          ),
                          PopupMenuItem(
                            value: SoftwareAction.status,
                            child: Text('Verificar conexão'),
                          ),
                          PopupMenuItem(
                            value: SoftwareAction.maintenance,
                            child: Text('Manutenção'),
                          ),
                          PopupMenuItem(
                            value: SoftwareAction.help,
                            child: Text('Ajuda'),
                          ),
                        ],
                      ),
                    IconButton(
                      tooltip: 'Detalhes',
                      onPressed: selected == null
                          ? null
                          : () => _scaffoldKey.currentState?.openEndDrawer(),
                      icon: const Icon(FLucideIcons.panelRight, size: 20),
                    ),
                  ],
                ),
          body: Row(
            children: [
              if (wide) SizedBox(width: navWidth, child: sidebar(data)),
              if (wide) const PixelDivider(axis: Axis.vertical),
              Expanded(
                key: const ValueKey('workspace-main'),
                child: Column(
                  children: [
                    loadingLine(busy || state.isRefreshing),
                    Expanded(
                      child: moduleError != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('$moduleError'),
                                  TextButton(
                                    onPressed: refresh,
                                    child: const Text('Tentar novamente'),
                                  ),
                                ],
                              ),
                            )
                          : moduleLoading
                          ? const Center(child: CircularProgressIndicator())
                          : widget.section == 'students'
                          ? StudentsPage(
                              api: api,
                              data: data,
                              studentId: widget.student,
                              open: (id) => go('students', id),
                              changed: refresh,
                              selectDocument: (d) => choose(d, 'document'),
                              selectRequest: (r) => choose(r, 'request'),
                              requestDrafts: drafts,
                            )
                          : widget.section == 'documents'
                          ? ArchivePage(
                              api: api,
                              data: data,
                              folderId: widget.folder,
                              openFolder: (id) => go('documents', id),
                              changed: refresh,
                              selectDocument: (d) => choose(d, 'document'),
                              assignDocument: (d) => assignDocument(data, d),
                              editDocument: (d) => documentForm(data, d),
                              registerStudent: (d) async {
                                if (await editStudent(
                                      context,
                                      api,
                                      existingFolder: d['folder'],
                                    ) ==
                                    true) {
                                  refresh();
                                }
                              },
                            )
                          : widget.section == 'classes'
                          ? ClassesPage(
                              api: api,
                              data: data,
                              groupId: widget.classId,
                              open: (id) => go('classes', id),
                              openStudent: (id) => go('students', id),
                              changed: refresh,
                            )
                          : widget.section == 'academic'
                          ? AcademicPage(
                              api: api,
                              data: data,
                              openAccounts: () => go('accounts'),
                            )
                          : widget.section == 'accounts'
                          ? AccountsPage(api: api, data: data, changed: refresh)
                          : widget.section == 'templates'
                          ? TemplatesPage(
                              api: api,
                              data: data,
                              changed: refresh,
                            )
                          : widget.section == 'maintenance'
                          ? data['session']['user']['role'] == 'admin'
                                ? MaintenancePage(
                                    api: api,
                                    data: data,
                                    changed: refresh,
                                    restored: () {
                                      go('students');
                                      refresh();
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      'Manutenção exige administração.',
                                    ),
                                  )
                          : requests(data),
                    ),
                  ],
                ),
              ),
              if (docked) ...[
                MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: GestureDetector(
                    key: const ValueKey('resize-details'),
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragUpdate: (event) => setState(
                      () => detailsWidth =
                          (detailsWidth.clamp(
                                    280.0,
                                    (width - navWidth - 520).clamp(
                                      280.0,
                                      480.0,
                                    ),
                                  ) -
                                  event.delta.dx)
                              .clamp(
                                280.0,
                                (width - navWidth - 520).clamp(280.0, 480.0),
                              ),
                    ),
                    onHorizontalDragEnd: (_) =>
                        preferences.setDouble('detailsWidth', detailsWidth),
                    child: const SizedBox(
                      width: 5,
                      child: Center(child: PixelDivider(axis: Axis.vertical)),
                    ),
                  ),
                ),
                SizedBox(
                  key: const ValueKey('details-pane'),
                  width: paneWidth,
                  height: double.infinity,
                  child: Material(
                    color: AppSurfaces.of(c).detail,
                    child: selected == null
                        ? const Padding(
                            padding: EdgeInsets.all(22),
                            child: Text(
                              'Selecione um documento ou uma solicitação para ver os detalhes.',
                              style: TextStyle(fontSize: 13, height: 1.5),
                            ),
                          )
                        : details(data),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String get title => widget.section == 'students'
      ? 'Pastas de alunos'
      : widget.section == 'classes'
      ? 'Cursos e turmas'
      : widget.section == 'academic'
      ? 'Organização acadêmica'
      : widget.section == 'accounts'
      ? 'Contas e acessos'
      : widget.section == 'templates'
      ? 'Modelos de pasta'
      : widget.section == 'documents'
      ? 'Arquivo de documentos'
      : widget.section == 'queue'
      ? 'Atendimento'
      : 'Solicitações';
  Widget heading(String text, List<Widget> actions) =>
      PageHeader(title: text, actions: actions);
  Future<void> assignDocument(JsonMap data, JsonMap d) async {
    final students = List<JsonMap>.from(data['students']);
    final id = await pickChoice(
      context,
      title: 'Vincular documento ao aluno',
      choices: [
        for (final p in students)
          SearchChoice(
            p['id'],
            p['name'],
            description: p['registration'] ?? '',
          ),
      ],
    );
    if (id == null || !mounted) return;
    final student = students.firstWhere((p) => p['id'] == id);
    if (!await confirm(
      context,
      'Mover “${d['name']}” para a pasta de ${student['name']}?',
    )) {
      return;
    }
    await run(() async {
      await api.send('POST', 'bulk', {
        'resource': 'documents',
        'action': 'move',
        'items': [
          {'id': d['id'], 'revision': d['revision']},
        ],
        'fields': {'folder': student['folder']},
      });
      closeDetails();
    });
  }

  Widget requests(JsonMap data) {
    final queue = widget.section == 'queue';
    final studentNames = {
      for (final p in List<JsonMap>.from(data['students'])) p['id']: p['name'],
    };
    String? studentName(JsonMap r) =>
        r['student_name'] ?? studentNames[r['student']];
    final all = List<JsonMap>.from(data[queue ? 'queue' : 'requests']);
    final list = all
        .where(
          (r) =>
              (filter == 'Todos' || r['state'] == filter) &&
              '${r['subject']} ${r['protocol']} ${studentName(r) ?? ''}'
                  .toLowerCase()
                  .contains(search.toLowerCase()),
        )
        .toList();
    return PageLayout(
      header: heading(title, [
        if (!queue)
          button(
            'Nova solicitação',
            busy
                ? null
                : () async {
                    final draft = drafts.putIfAbsent(
                      api.profile,
                      () => RequestDraft(),
                    );
                    final sent = await showDialog<bool>(
                      context: context,
                      builder: (_) => RequestForm(
                        api: api,
                        data: data,
                        draft: draft,
                        folder: widget.folder,
                      ),
                    );
                    if (sent == true) drafts.remove(api.profile);
                    refresh();
                  },
            icon: FLucideIcons.plus,
            primary: true,
          ),
        IconButton(
          onPressed: refresh,
          tooltip: 'Atualizar',
          icon: const Icon(FLucideIcons.refreshCw, size: 18),
        ),
      ]),
      headerPrefix: [],
      children: [
        FTextField(
          hint: 'Pesquisar assunto, protocolo ou aluno…',
          control: FTextFieldControl.managed(
            onChange: (v) => setState(() => search = v.text),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final state in [
              'Todos',
              'Recebida',
              'Em atendimento',
              'Aguardando solicitante',
              'Concluída',
            ])
              ChoiceChip(
                label: Text(state, style: const TextStyle(fontSize: 11)),
                selected: filter == state,
                onSelected: (_) => setState(() => filter = state),
              ),
          ],
        ),
        const SizedBox(height: 16),
        const PixelDivider(),
        Expanded(
          child: list.isEmpty
              ? const Center(child: Text('Nenhuma solicitação encontrada.'))
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, i) => const PixelDivider(),
                  itemBuilder: (_, i) {
                    final r = list[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      selected: selected?['id'] == r['id'],
                      onTap: () => choose(r, 'request'),
                      title: Text(
                        r['subject'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '${studentName(r) == null ? '' : '${studentName(r)} · '}${r['protocol']} · ${r['department']}\nCriada ${date(r['created'])} · Atualizada ${date(r['updated'])}',
                          style: const TextStyle(fontSize: 11, height: 1.6),
                        ),
                      ),
                      trailing: badge(r['state']),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
