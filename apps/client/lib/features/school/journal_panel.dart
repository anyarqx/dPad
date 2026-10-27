import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import 'grades_panel.dart';

class JournalPanel extends StatefulWidget {
  final Api api;
  final JsonMap group, user;
  final bool canConfigure;
  const JournalPanel({
    super.key,
    required this.api,
    required this.group,
    required this.user,
    required this.canConfigure,
  });
  @override
  State<JournalPanel> createState() => _JournalPanelState();
}

class _JournalPanelState extends State<JournalPanel> {
  String? selected;
  bool showGrades = false;
  late Future<dynamic> content;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void didUpdateWidget(covariant JournalPanel old) {
    super.didUpdateWidget(old);
    if (old.group['id'] != widget.group['id']) {
      selected = null;
      load();
    }
  }

  void load() {
    content = widget.api.get(
      selected == null
          ? 'classes/${widget.group['id']}/journals'
          : 'journals/$selected',
    );
  }

  void refresh() {
    if (mounted) setState(load);
  }

  Future<void> create() async {
    try {
      final teachers = List<JsonMap>.from(await widget.api.get('teachers'));
      final catalog = await widget.api.get('academic/catalog');
      final components = List<JsonMap>.from(catalog['components'])
          .where((c) => c['course'] == widget.group['course'])
          .toList();
      if (!mounted) return;
      if (await showDialog<bool>(
            context: context,
            builder: (_) => _JournalForm(
              api: widget.api,
              group: widget.group['id'],
              teachers: teachers,
              components: components,
            ),
          ) ==
          true) {
        refresh();
      }
    } catch (e) {
      if (mounted) feedback(context, e);
    }
  }

  Future<void> lesson(JsonMap journal, [JsonMap? old]) async {
    if (await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              LessonForm(api: widget.api, journal: journal, lesson: old),
        ) ==
        true) {
      refresh();
    }
  }

  Future<void> action(JsonMap lesson, String action) async {
    final note = TextEditingController();
    var proceed = true;
    if (action == 'return') {
      proceed =
          await showEditorDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Devolver aula para correção'),
              content: SizedBox(
                width: 440,
                child: field('Motivo da devolução', note, lines: 3),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: const Text('Cancelar'),
                ),
                button('Devolver', () => Navigator.pop(c, true), primary: true),
              ],
            ),
          ) ??
          false;
    } else {
      proceed = await confirm(
        context,
        action == 'submit' ? 'Enviar a aula e a frequência para conferência?' : 'Publicar o conteúdo e a frequência para os alunos e responsáveis vinculados?',
      );
    }
    final text = note.text;
    note.dispose();
    if (!proceed) return;
    try {
      await widget.api.send('POST', 'lessons/${lesson['id']}/actions', {
        'revision': lesson['revision'],
        'action': action,
        'note': text,
      });
      refresh();
    } catch (e) {
      if (mounted) feedback(context, e);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<dynamic>(
    future: content,
    builder: (c, s) {
      if (s.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (s.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('${s.error}'), button('Tentar novamente', refresh)],
          ),
        );
      }
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      if (selected == null) {
        final list = List<JsonMap>.from(s.data);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Diários de classe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                if (widget.canConfigure)
                  button(
                    'Adicionar diário',
                    create,
                    icon: FLucideIcons.plus,
                    primary: true,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Cada componente tem seu docente responsável. Aulas e frequência passam por revisão antes de aparecer para alunos e responsáveis.',
              style: TextStyle(fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('Nenhum diário disponível nesta turma.'),
                    )
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, i) => const PixelDivider(),
                      itemBuilder: (c, i) {
                        final j = list[i];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          leading: const Icon(
                            FLucideIcons.notebookPen,
                            size: 22,
                          ),
                          title: Text(j['subject']),
                          subtitle: Text(
                            '${j['phase'] ?? 'Fase não informada'} · ${j['teacher_name']}',
                            style: const TextStyle(fontSize: 12, height: 1.5),
                          ),
                          trailing: const Icon(
                            FLucideIcons.chevronRight,
                            size: 18,
                          ),
                          onTap: () => setState(() {
                            selected = j['id'];
                            load();
                          }),
                        );
                      },
                    ),
            ),
          ],
        );
      }
      final j = JsonMap.from(s.data);
      final lessons = List<JsonMap>.from(j['lessons']);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() {
                selected = null;
                load();
              }),
              icon: const Icon(FLucideIcons.arrowLeft, size: 16),
              label: const Text('Todos os diários'),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                j['subject'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (j['canEdit'] == true)
                button(
                  'Registrar aula',
                  () => lesson(j),
                  icon: FLucideIcons.plus,
                  primary: true,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${j['teacher_name']} · ${j['class_name']}',
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
          if (j['component_info'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${'${j['component_info']['phase']}'} · ${j['component_info']['hours']} h previstas · ${((j['published_units'] as num) * (j['component_info']['lesson_minutes'] as num) / 60).toStringAsFixed(1)} h de aulas publicadas',
                style: const TextStyle(fontSize: 12, height: 1.5),
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Aulas e frequência'),
                selected: !showGrades,
                onSelected: (_) => setState(() => showGrades = false),
              ),
              ChoiceChip(
                label: const Text('Avaliações e notas'),
                selected: showGrades,
                onSelected: (_) => setState(() => showGrades = true),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: showGrades
                ? GradesPanel(api: widget.api, journal: j)
                : lessons.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma aula disponível. Registre uma aula após ativar as matrículas.',
                    ),
                  )
                : ListView(
                    children: [
                      for (final l in lessons) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${DateFormat('dd/MM/yyyy').format(DateTime.parse(l['date']))} · ${l['units']} aula(s)',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  badge(l['state']),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SelectableText(
                                l['content'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: Text(
                                  'Frequência · ${(l['attendance'] as List).length} registros',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                children: [
                                  for (final a in List<JsonMap>.from(
                                    l['attendance'],
                                  ))
                                    ListTile(
                                      dense: true,
                                      title: Text(
                                        a['student_name'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: badge(a['status']),
                                    ),
                                ],
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (j['canEdit'] == true &&
                                      l['state'] == 'Rascunho') ...[
                                    button(
                                      'Editar aula',
                                      () => lesson(j, l),
                                      icon: FLucideIcons.pencil,
                                    ),
                                    button(
                                      'Enviar para revisão',
                                      () => action(l, 'submit'),
                                    ),
                                  ],
                                  if (j['canReview'] == true &&
                                      l['state'] == 'Em revisão')
                                    button(
                                      'Publicar aula',
                                      () => action(l, 'publish'),
                                      primary: true,
                                    ),
                                  if (j['canReview'] == true &&
                                      [
                                        'Em revisão',
                                        'Publicado',
                                      ].contains(l['state']))
                                    button(
                                      'Devolver para correção',
                                      () => action(l, 'return'),
                                    ),
                                ],
                              ),
                              if (l['events'] != null)
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: const Text(
                                    'Histórico',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  children: [
                                    for (final e in List<JsonMap>.from(
                                      l['events'],
                                    ))
                                      ListTile(
                                        dense: true,
                                        title: Text(
                                          e['message'],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        subtitle: Text(
                                          '${e['actor_name']} · ${date(e['created'])}',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const PixelDivider(),
                      ],
                    ],
                  ),
          ),
        ],
      );
    },
  );
}

class _JournalForm extends StatefulWidget {
  final Api api;
  final String group;
  final List<JsonMap> teachers, components;
  const _JournalForm({
    required this.api,
    required this.group,
    required this.teachers,
    required this.components,
  });
  @override
  State<_JournalForm> createState() => _JournalFormState();
}

class _JournalFormState extends State<_JournalForm> {
  late String? component = widget.components.firstOrNull?['id'];
  late String? teacher = widget.teachers.firstOrNull?['id'];
  bool saving = false;
  String? error;

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: const Text('Adicionar diário'),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            selector(
              'Componente da matriz',
              component,
              [
                for (final m in widget.components)
                  DropdownMenuItem(
                    value: m['id'] as String,
                    child: Text(
                      '${m['subject_name']} · ${m['phase']} · ${m['hours']} h',
                    ),
                  ),
              ],
              (v) => setState(() => component = v),
              tip: 'Escolha a disciplina e a fase cadastradas na matriz deste curso.',
            ),
            if (widget.components.isEmpty)
              const Text(
                'Adicione componentes à matriz do curso em Organização acadêmica antes de criar o diário.',
              ),
            selector(
              'Docente responsável',
              teacher,
              widget.teachers
                  .map(
                    (t) => DropdownMenuItem(
                      value: t['id'] as String,
                      child: Text(t['name']),
                    ),
                  )
                  .toList(),
              (v) => setState(() => teacher = v),
            ),
            if (widget.teachers.isEmpty)
              const Text(
                'Cadastre uma conta ativa de professor em Contas e acessos.',
              ),
            if (error != null)
              Text(
                error!,
                style: TextStyle(color: Theme.of(c).colorScheme.error),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(c),
        child: const Text('Cancelar'),
      ),
      button(
        saving ? 'Salvando…' : 'Criar diário',
        saving || teacher == null || component == null
            ? null
            : () async {
                setState(() {
                  saving = true;
                  error = null;
                });
                try {
                  await widget.api.send('POST', 'journals', {
                    'class_group': widget.group,
                    'component': component,
                    'teacher': teacher,
                  });
                  if (c.mounted) Navigator.pop(c, true);
                } catch (e) {
                  if (mounted) setState(() => error = '$e');
                } finally {
                  if (mounted) setState(() => saving = false);
                }
              },
        primary: true,
      ),
    ],
  );
}

class LessonForm extends StatefulWidget {
  final Api api;
  final JsonMap journal;
  final JsonMap? lesson;
  const LessonForm({
    super.key,
    required this.api,
    required this.journal,
    this.lesson,
  });
  @override
  State<LessonForm> createState() => _LessonFormState();
}

class _LessonFormState extends State<LessonForm> {
  late final date = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(
          widget.lesson == null
              ? DateTime.now()
              : DateTime.parse(widget.lesson!['date']),
        ),
      ),
      units = TextEditingController(text: '${widget.lesson?['units'] ?? 1}'),
      content = TextEditingController(text: widget.lesson?['content']);
  late final roster = widget.lesson == null
      ? List<JsonMap>.from(widget.journal['roster'])
      : [
          for (final a in List<JsonMap>.from(widget.lesson!['attendance']))
            {'id': a['enrollment'], 'student_name': a['student_name']},
        ];
  late final values = <String, String>{
    if (widget.lesson != null)
      for (final a in List<JsonMap>.from(widget.lesson!['attendance']))
        a['enrollment']: a['status'],
  };
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in [date, units, content]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(
      widget.lesson == null
          ? 'Registrar aula e frequência'
          : 'Editar rascunho da aula',
    ),
    content: SizedBox(
      width: 640,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            field('Data (DD/MM/AAAA)', date),
            field('Quantidade de aulas', units),
            field('Conteúdo e atividades realizadas', content, lines: 4),
            Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Frequência',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: saving
                      ? null
                      : () => setState(() {
                          for (final p in roster) {
                            values[p['id']] = 'Presente';
                          }
                        }),
                  child: const Text('Marcar todos presentes'),
                ),
              ],
            ),
            if (roster.isEmpty)
              const Text(
                'Não há matrículas ativas. Ative os alunos antes de lançar a aula.',
              ),
            for (final p in roster)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      p['student_name'],
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    selector(
                      'Presença',
                      values[p['id']],
                      ['Presente', 'Ausente', 'Justificada']
                          .map(
                            (v) => DropdownMenuItem(value: v, child: Text(v)),
                          )
                          .toList(),
                      (v) => setState(() => values[p['id']] = v!),
                    ),
                  ],
                ),
              ),
            const Text(
              'O rascunho fica disponível apenas à equipe autorizada. Envie para revisão quando terminar.',
              style: TextStyle(fontSize: 12, height: 1.5),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(c).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(c),
        child: const Text('Cancelar'),
      ),
      button(
        saving ? 'Salvando…' : 'Salvar rascunho',
        saving || roster.isEmpty
            ? null
            : () async {
                if (values.length != roster.length) {
                  setState(
                    () => error = 'Informe a frequência de todos os alunos.',
                  );
                  return;
                }
                String iso;
                try {
                  iso = DateFormat('dd/MM/yyyy')
                      .parseStrict(date.text.trim())
                      .toIso8601String()
                      .substring(0, 10);
                } catch (_) {
                  setState(
                    () => error =
                        'Informe uma data válida no formato DD/MM/AAAA.',
                  );
                  return;
                }
                setState(() {
                  saving = true;
                  error = null;
                });
                try {
                  await widget.api.send(
                    widget.lesson == null ? 'POST' : 'PATCH',
                    widget.lesson == null
                        ? 'journals/${widget.journal['id']}/lessons'
                        : 'lessons/${widget.lesson!['id']}',
                    {
                      'date': iso,
                      'units': int.tryParse(units.text),
                      'content': content.text,
                      'attendance': [
                        for (final p in roster)
                          {'enrollment': p['id'], 'status': values[p['id']]},
                      ],
                      if (widget.lesson != null)
                        'revision': widget.lesson!['revision'],
                    },
                  );
                  if (c.mounted) Navigator.pop(c, true);
                } catch (e) {
                  if (mounted) setState(() => error = '$e');
                } finally {
                  if (mounted) setState(() => saving = false);
                }
              },
        primary: true,
      ),
    ],
  );
}
