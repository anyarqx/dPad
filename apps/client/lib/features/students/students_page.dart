import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import '../../shared/search_picker.dart';
import '../forms.dart';
import '../scanner.dart';
import 'student_form.dart';
import '../school/enrollment_panel.dart';
import '../school/report_panel.dart';

class StudentsPage extends StatefulWidget {
  final Api api;
  final JsonMap data;
  final String? studentId;
  final ValueChanged<String?> open;
  final VoidCallback changed;
  final ValueChanged<JsonMap> selectDocument;
  final ValueChanged<JsonMap> selectRequest;
  final Map<String, RequestDraft> requestDrafts;
  final VoidCallback configureClasses;
  const StudentsPage({
    super.key,
    required this.api,
    required this.data,
    required this.open,
    required this.changed,
    required this.selectDocument,
    required this.selectRequest,
    required this.requestDrafts,
    required this.configureClasses,
    this.studentId,
  });
  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage>
    with SingleTickerProviderStateMixin {
  static const sections = [
    'Documentos',
    'Dados do aluno',
    'Matrículas',
    'Solicitações',
    'Boletim e frequência',
  ];
  late final tabsController = TabController(
    length: sections.length,
    vsync: this,
  );
  String search = '', filter = 'Todos', tab = 'Documentos';
  final searchController = TextEditingController();
  @override
  void dispose() {
    tabsController.dispose();
    searchController.dispose();
    super.dispose();
  }

  late Future<JsonMap>? detail;
  bool working = false;
  bool get canManage =>
      widget.data['session']['user']['role'] == 'admin' ||
      widget.data['session']['user']['department'] == 'secretaria';
  @override
  void initState() {
    super.initState();
    tabsController.addListener(() {
      final selected = sections[tabsController.index];
      if (mounted && tab != selected) setState(() => tab = selected);
    });
    reload();
  }

  @override
  void didUpdateWidget(covariant StudentsPage old) {
    super.didUpdateWidget(old);
    if (old.data['session']['user']['id'] !=
        widget.data['session']['user']['id']) {
      searchController.clear();
      search = '';
      filter = 'Todos';
    }
    if (old.studentId != widget.studentId || old.data != widget.data) {
      reload();
    }
    if (old.studentId != widget.studentId) {
      tab = 'Documentos';
      tabsController.index = 0;
    }
  }

  void reload() {
    detail = widget.studentId == null
        ? null
        : widget.api
              .get('students/${widget.studentId}')
              .then((v) => JsonMap.from(v));
  }

  Future<void> refresh() async {
    if (mounted) setState(reload);
    widget.changed();
  }

  Future<void> action(Future<void> Function() fn) async {
    if (working) return;
    setState(() => working = true);
    try {
      await fn();
      await refresh();
    } catch (e) {
      if (mounted) feedback(context, e);
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Widget title(String name, List<Widget> actions) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: -.6,
          ),
        ),
        ...actions,
      ],
    ),
  );
  @override
  Widget build(BuildContext c) {
    if (widget.studentId == null) return directory();
    return FutureBuilder<JsonMap>(
      future: detail,
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${s.error}'),
                const SizedBox(height: 16),
                button('Voltar às pastas', () => widget.open(null)),
              ],
            ),
          );
        }
        return dossier(s.data!);
      },
    );
  }

  Widget directory() {
    final all = List<JsonMap>.from(widget.data['students']);
    final list = all.where((p) {
      final q =
          '${p['name']} ${p['registration'] ?? ''} ${p['class_label'] ?? ''}'
              .toLowerCase();
      final missing =
          (p['required_count'] as int) -
          (p['verified_count'] as int) +
          (p['data_pending_count'] as int? ?? 0);
      return q.contains(search.toLowerCase()) &&
          (filter != 'Com pendências' || missing > 0);
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title('Pastas de alunos', [
          if (canManage)
            button(
              'Cadastrar aluno',
              List<JsonMap>.from(widget.data['classes'])
                      .any((g) => g['archived'] == 0)
                  ? () => action(() async {
                      await editStudent(context, widget.api);
                    })
                  : widget.configureClasses,
              icon: FLucideIcons.userPlus,
              primary: true,
            ),
          IconButton(
            tooltip: 'Atualizar pastas',
            onPressed: widget.changed,
            icon: const Icon(FLucideIcons.refreshCw, size: 20),
          ),
        ]),
        const Text(
          'Localize o aluno para consultar seus dados, documentos e pendências.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 20),
        FTextField(
          hint: 'Buscar por nome, matrícula ou turma',
          control: FTextFieldControl.managed(
            controller: searchController,
            onChange: (v) => setState(() => search = v.text),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          children: [
            for (final f in ['Todos', 'Com pendências'])
              ChoiceChip(
                label: Text(f),
                selected: f == filter,
                onSelected: (_) => setState(() => filter = f),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Expanded(
          child: all.isEmpty
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FLucideIcons.folderHeart,
                          size: 44,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          canManage
                              ? 'Nenhum aluno cadastrado'
                              : 'Nenhum aluno vinculado',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          canManage
                              ? 'Cadastre primeiro os cursos e as turmas. Depois, abra a pasta do aluno e selecione um modelo documental.'
                              : 'Peça à administração para vincular esta conta ao aluno correspondente.',
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 1.6, fontSize: 13),
                        ),
                        if (canManage) ...[
                          const SizedBox(height: 20),
                          button(
                            List<JsonMap>.from(widget.data['classes'])
                                    .any((g) => g['archived'] == 0)
                                ? 'Cadastrar primeiro aluno'
                                : 'Organizar cursos e turmas',
                            List<JsonMap>.from(widget.data['classes'])
                                    .any((g) => g['archived'] == 0)
                                ? () => action(() async {
                                    await editStudent(context, widget.api);
                                  })
                                : widget.configureClasses,
                            primary: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              : list.isEmpty
              ? const Center(
                  child: Text('Nenhum aluno encontrado para esta busca.'),
                )
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, i) => const PixelDivider(),
                  itemBuilder: (c, i) {
                    final p = list[i];
                    final received = p['received_count'] as int;
                    final required = p['required_count'] as int;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 4,
                      ),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Theme.of(c)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: Text(
                          p['name']
                              .toString()
                              .trim()
                              .split(RegExp(r'\s+'))
                              .take(2)
                              .map((s) => s[0])
                              .join(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(
                        p['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          [
                            if (p['registration'] != null)
                              'Matrícula ${p['registration']}',
                            if (p['class_label'] != null) p['class_label'],
                            '$received de $required documentos recebidos',
                          ].join(' · '),
                          style: const TextStyle(fontSize: 12, height: 1.6),
                        ),
                      ),
                      trailing: const Icon(FLucideIcons.chevronRight, size: 20),
                      onTap: () => widget.open(p['id']),
                    );
                  },
                ),
        ),
        const SizedBox(height: 12),
        Text(
          '${list.length} de ${all.length} alunos',
          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  Widget dossier(JsonMap p) {
    final requirements = List<JsonMap>.from(p['requirements']);
    final docs = List<JsonMap>.from(p['documents']);
    final received = requirements
        .where((r) => (r['documents'] as List).isNotEmpty)
        .length;
    final verified = requirements
        .where((r) => r['status'] == 'Conferido')
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => widget.open(null),
            icon: const Icon(FLucideIcons.arrowLeft, size: 16),
            label: const Text('Pastas de alunos'),
          ),
        ),
        const SizedBox(height: 12),
        title(p['name'], [
          if (canManage)
            button(
              'Editar dados',
              () => action(() async {
                await editStudent(context, widget.api, student: p);
              }),
              icon: FLucideIcons.userRoundPen,
            ),
          if (canManage)
            button(
              'Aplicar modelo',
              working ? null : () => applyTemplate(p),
              icon: FLucideIcons.files,
            ),
        ]),
        Text(
          [
            if (p['registration'] != null) 'Matrícula ${p['registration']}',
            if (List<JsonMap>.from(widget.data['students'])
                    .where((s) => s['id'] == p['id'])
                    .firstOrNull?['class_label'] !=
                null)
              List<JsonMap>.from(widget.data['students'])
                  .firstWhere((s) => s['id'] == p['id'])['class_label'],
          ].join(' · '),
          style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Text(
              '$received de ${requirements.length} recebidos',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            Text('$verified conferidos', style: const TextStyle(fontSize: 13)),
            Text(
              '${requirements.length - received} ainda não enviados',
              style: const TextStyle(fontSize: 13),
            ),
            if ((p['data_pending_count'] as int? ?? 0) > 0)
              Text(
                '${p['data_pending_count']} informações a preencher',
                style: const TextStyle(fontSize: 13),
              ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (c, box) => TabBar(
            controller: tabsController,
            isScrollable: box.maxWidth < 560,
            tabAlignment: box.maxWidth < 560
                ? TabAlignment.start
                : TabAlignment.fill,
            labelColor: FTheme.of(c).colors.foreground,
            unselectedLabelColor: FTheme.of(c).colors.mutedForeground,
            indicatorColor: FTheme.of(c).colors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerHeight: 0,
            labelStyle: Theme.of(c).textTheme.labelSmall!
                .copyWith(fontSize: 12),
            tabs: [for (final section in sections) Tab(text: section)],
          ),
        ),
        const PixelDivider(),
        const SizedBox(height: 18),
        loadingLine(working),
        Expanded(
          child: tab == 'Dados do aluno'
              ? studentData(p)
              : tab == 'Matrículas'
              ? EnrollmentPanel(
                  api: widget.api,
                  student: p,
                  data: widget.data,
                  changed: widget.changed,
                )
              : tab == 'Boletim e frequência'
              ? ReportPanel(
                  api: widget.api,
                  student: p,
                  user: JsonMap.from(widget.data['session']['user']),
                )
              : tab == 'Solicitações'
              ? studentRequests(p)
              : ListView(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        button(
                          'Adicionar documento',
                          working ? null : () => upload(p),
                          icon: FLucideIcons.upload,
                          primary: true,
                        ),
                        button(
                          'Digitalizar',
                          working ? null : () => upload(p, scanImages: true),
                          icon: FLucideIcons.scanLine,
                        ),
                        if (canManage)
                          button(
                            'Solicitar outro documento',
                            working ? null : () => addRequirement(p),
                            icon: FLucideIcons.listPlus,
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'DOCUMENTOS ESPERADOS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (requirements.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Nenhum documento exigido nesta pasta. Você pode adicionar arquivos ou solicitar documentos específicos.',
                        ),
                      ),
                    for (final r in requirements) ...[
                      LayoutBuilder(
                        builder: (c, constraints) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    r['status'] == 'Conferido'
                                        ? FLucideIcons.circleCheck
                                        : (r['documents'] as List).isEmpty
                                        ? FLucideIcons.circleDashed
                                        : FLucideIcons.fileCheck,
                                    size: 20,
                                    color: Theme.of(c)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r['type'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        badge(r['status']),
                                      ],
                                    ),
                                  ),
                                  if ((r['documents'] as List).isEmpty)
                                    TextButton(
                                      onPressed: working
                                          ? null
                                          : () => upload(p, type: r['type']),
                                      child: const Text('Adicionar'),
                                    ),
                                  if (canManage)
                                    PopupMenuButton<String>(
                                      tooltip: 'Opções de ${r['type']}',
                                      onSelected: (_) => action(() async {
                                        if (await confirm(
                                          context,
                                          'Retirar “${r['type']}” da lista esperada? Os arquivos enviados serão preservados.',
                                        )) {
                                          await widget.api.send(
                                            'DELETE',
                                            'students/${p['id']}/requirements/${r['id']}',
                                          );
                                        }
                                      }),
                                      itemBuilder: (_) => [
                                        const PopupMenuItem(
                                          value: 'remove',
                                          child: Text(
                                            'Não exigir este documento',
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              for (final d in List<JsonMap>.from(
                                r['documents'],
                              ))
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 32,
                                    top: 4,
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      d['name'],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      '${size(d['size'])} · ${date(d['created'])}',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    trailing: const Icon(
                                      FLucideIcons.chevronRight,
                                      size: 16,
                                    ),
                                    onTap: () => widget.selectDocument(d),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const PixelDivider(),
                    ],
                    if (docs.any(
                      (d) => !requirements.any(
                        (r) =>
                            r['type'].toString().toLowerCase() ==
                            d['type'].toString().toLowerCase(),
                      ),
                    )) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'OUTROS ARQUIVOS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      for (final d in docs.where(
                        (d) => !requirements.any(
                          (r) =>
                              r['type'].toString().toLowerCase() ==
                              d['type'].toString().toLowerCase(),
                        ),
                      ))
                        ListTile(
                          title: Text(
                            d['name'],
                            style: const TextStyle(fontSize: 13),
                          ),
                          subtitle: Text(
                            '${d['type']} · ${size(d['size'])}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          leading: const Icon(FLucideIcons.file, size: 20),
                          onTap: () => widget.selectDocument(d),
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> applyTemplate(JsonMap student) async {
    if (working) return;
    List<JsonMap> models;
    setState(() => working = true);
    try {
      models = List<JsonMap>.from(await widget.api.get('templates'))
          .where((m) => m['archived'] == 0)
          .toList();
    } catch (e) {
      if (mounted) feedback(context, e);
      return;
    } finally {
      if (mounted) setState(() => working = false);
    }
    if (!mounted) return;
    if (models.isEmpty) {
      feedback(
        context,
        'Crie um modelo em Modelos de pasta antes de aplicá-lo.',
      );
      return;
    }
    final selected = await pickChoice(
      context,
      title: 'Aplicar modelo à pasta',
      choices: [
        for (final m in models)
          SearchChoice(
            m['id'],
            m['name'],
            description:
                '${(m['documents'] as List).length} documentos · ${(m['fields']['extra'] as List).length} informações adicionais',
          ),
      ],
    );
    if (selected == null || !mounted) return;
    final model = models.firstWhere((m) => m['id'] == selected);
    if (!await confirm(
      context,
      'Adicionar as exigências de “${model['name']}” à pasta? Os arquivos e valores já preenchidos serão preservados.',
    )) {
      return;
    }
    await action(() async {
      await widget.api.send('POST', 'students/${student['id']}/template', {
        'template': selected,
        'revision': student['revision'],
      });
    });
  }

  Widget studentData(JsonMap p) {
    final values = {
      'Nome completo': p['name'],
      'Matrícula': p['registration'],
      'Nascimento': p['birth_date'] == null || p['birth_date'] == ''
          ? null
          : DateFormat('dd/MM/yyyy').format(DateTime.parse(p['birth_date'])),
      'Nome social': p['social_name'],
      'Sexo informado': p['sex'],
      'Naturalidade': p['birthplace'],
      'Nacionalidade': p['nationality'],
      'Filiação': p['parentage'],
      'Endereço': p['address'],
      'Responsável': p['guardian'],
      'Telefone': p['phone'],
      'E-mail': p['email'],
      'Observações': p['notes'],
    };
    return ListView(
      children: [
        if (p['templateName'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Último modelo aplicado: ${p['templateName']}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        for (final e in [
          ...values.entries,
          ...JsonMap.from(p['extra']).entries,
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.key,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 5),
                SelectableText(
                  e.value == null || e.value == ''
                      ? 'Não informado'
                      : '${e.value}',
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 12),
                const PixelDivider(),
              ],
            ),
          ),
      ],
    );
  }

  Widget studentRequests(JsonMap p) => ListView(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: button(
          'Nova solicitação',
          () async {
            final key = '${widget.api.profile}:${p['id']}';
            final sent = await showDialog<bool>(
              context: context,
              builder: (_) => RequestForm(
                api: widget.api,
                data: widget.data,
                draft: widget.requestDrafts.putIfAbsent(key, RequestDraft.new),
                folder: p['folder'],
                student: p['id'],
              ),
            );
            if (sent == true) widget.requestDrafts.remove(key);
            if (mounted) await refresh();
          },
          icon: FLucideIcons.plus,
          primary: true,
        ),
      ),
      const SizedBox(height: 20),
      if ((p['requests'] as List).isEmpty)
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Nenhuma solicitação vinculada a este aluno.'),
        ),
      for (final r in List<JsonMap>.from(p['requests']))
        ListTile(
          title: Text(r['subject']),
          subtitle: Text('${r['protocol']} · ${r['state']}'),
          onTap: () => widget.selectRequest(r),
        ),
    ],
  );
  Future<void> upload(JsonMap p, {String? type, bool scanImages = false}) =>
      action(() async {
        final bytes = scanImages ? await scan(context) : null;
        if (scanImages && bytes == null) return;
        if (!mounted) return;
        await uploadDialog(
          context,
          widget.api,
          List<JsonMap>.from(widget.data['folders']),
          p['folder'],
          bytes: bytes?.pdf,
          filename: scanImages ? 'Digitalização.pdf' : null,
          originals: bytes?.originals ?? [],
          suggestedType: type ?? 'Outros documentos',
          fixedDestination: true,
          personName: p['name'],
          documentTypes: [
            for (final r in List<JsonMap>.from(p['requirements']))
              r['type'] as String,
            'Outros documentos',
          ],
        );
      });
  Future<void> addRequirement(JsonMap p) async {
    final c = TextEditingController();
    await showEditorDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Solicitar outro documento'),
        content: SizedBox(width: 440, child: field('Nome do documento', c)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          button(
            'Adicionar à lista',
            () => action(() async {
              await widget.api.send(
                'POST',
                'students/${p['id']}/requirements',
                {'type': c.text},
              );
              if (ctx.mounted) Navigator.pop(ctx);
            }),
            primary: true,
          ),
        ],
      ),
    );
    c.dispose();
  }
}
