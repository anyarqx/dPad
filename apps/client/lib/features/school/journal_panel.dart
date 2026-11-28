import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/search_picker.dart';
import '../../shared/widgets.dart';
import '../../shared/page_header.dart';
import '../../shared/section_tabs.dart';
import 'grades_panel.dart';
import 'record_grid.dart';

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

  Future<void> teachers(JsonMap journal) async {
    try {
      final options = List<JsonMap>.from(await widget.api.get('teachers'));
      if (!mounted) return;
      if (await openEditor<bool>(
            context,
            TeacherAssignments(
              api: widget.api,
              journal: journal,
              teachers: options,
              year: widget.group['school_year'],
            ),
          ) ==
          true) {
        refresh();
      }
    } catch (e) {
      if (mounted) feedbackError(context, e);
    }
  }

  Future<void> lesson(JsonMap journal, [JsonMap? old]) async {
    if (await openEditor<bool>(
          context,
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
      if (mounted) feedbackError(context, e);
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
            const PageHeader(section: true, title: 'Diários de classe'),
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
              if (widget.canConfigure) button('Docentes', () => teachers(j)),
              if (lessons.isNotEmpty)
                button('Frequência mensal', () async {
                  if (await openEditor<bool>(
                        c,
                        RecordGrid(
                          api: widget.api,
                          journal: j,
                          records: lessons,
                        ),
                        width: 1080,
                      ) ==
                      true) {
                    refresh();
                  }
                }),
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
          SectionTabs(
            items: const ['Aulas e frequência', 'Avaliações e notas'],
            value: showGrades ? 'Avaliações e notas' : 'Aulas e frequência',
            onChanged: (v) =>
                setState(() => showGrades = v == 'Avaliações e notas'),
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
  Widget build(BuildContext c) => EditorPage(
    title: widget.lesson == null
        ? 'Registrar aula e frequência'
        : 'Editar rascunho da aula',
    body: ListView(
      children: [
        FormColumns(
          children: [
            field('Data (DD/MM/AAAA)', date, kind: FieldKind.date),
            field('Quantidade de aulas', units, kind: FieldKind.integer),
          ],
        ),
        field('Conteúdo e atividades realizadas', content, lines: 2),
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
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p['student_name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Selecionar frequência'),
                    value: values[p['id']],
                    items: [
                      for (final value in [
                        'Presente',
                        'Ausente',
                        'Justificada',
                      ])
                        DropdownMenuItem(value: value, child: Text(value)),
                    ],
                    onChanged: saving
                        ? null
                        : (v) => setState(() => values[p['id']] = v!),
                  ),
                ),
              ],
            ),
          ),
        if (error != null)
          Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
      ],
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(c),
        child: const Text('Cancelar'),
      ),
      button(
        'Salvar rascunho',
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
                          {
                            'enrollment': p['id'],
                            'status': values[p['id']],
                            if (widget.lesson != null)
                              'absences': (widget.lesson!['attendance'] as List)
                                  .where(
                                    (a) =>
                                        a['enrollment'] == p['id'] &&
                                        a['status'] == values[p['id']],
                                  )
                                  .firstOrNull?['absences'],
                          },
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
        loading: saving,
      ),
    ],
  );
}

class TeacherAssignments extends StatefulWidget {
  final Api api;
  final JsonMap journal;
  final List<JsonMap> teachers;
  final int year;
  const TeacherAssignments({
    super.key,
    required this.api,
    required this.journal,
    required this.teachers,
    required this.year,
  });
  @override
  State<TeacherAssignments> createState() => _TeacherAssignmentsState();
}

class _TeacherAssignmentsState extends State<TeacherAssignments> {
  late final assignments = List<JsonMap>.from(widget.journal['teachers'] ?? []);
  late final from = TextEditingController(text: '${widget.year}-01-01'),
      to = TextEditingController(text: '${widget.year}-12-31');
  final role = TextEditingController();
  String? error;
  bool saving = false;
  @override
  void dispose() {
    from.dispose();
    to.dispose();
    role.dispose();
    super.dispose();
  }

  Future<void> add() async {
    final values = await pickMany(
      context,
      title: 'Professores na vigência informada',
      choices: [
        for (final t in widget.teachers) SearchChoice(t['id'], t['name']),
      ],
      maximum: 12,
    );
    if (values == null || !mounted) return;
    setState(() {
      for (final t in widget.teachers.where((t) => values.contains(t['id']))) {
        if (assignments.any(
          (a) => a['teacher'] == t['id'] && a['valid_from'] == from.text,
        )) {
          continue;
        }
        assignments.add({
          'teacher': t['id'],
          'name': t['name'],
          'valid_from': from.text,
          'valid_to': to.text,
          'assignment': role.text,
        });
      }
    });
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.api.send(
        'POST',
        'journals/${widget.journal['id']}/teachers',
        {'teachers': assignments, 'revision': widget.journal['revision']},
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext c) => EditorPage(
    title: 'Docentes · ${widget.journal['subject']}',
    body: ListView(
      children: [
        for (final a in assignments)
          ListTile(
            title: Text(a['name']),
            subtitle: Text(
              "${a['valid_from']} a ${a['valid_to']} · ${a['assignment']}",
            ),
            trailing: IconButton(
              tooltip: 'Remover atribuição',
              onPressed: saving
                  ? null
                  : () => setState(() => assignments.remove(a)),
              icon: const Icon(FLucideIcons.x),
            ),
          ),
        const PixelDivider(),
        FormColumns(
          children: [
            field('Início', from, kind: FieldKind.isoDate),
            field('Término', to, kind: FieldKind.isoDate),
            field('Atribuição', role, hint: 'Docência'),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: button(
            'Adicionar docentes',
            saving ? null : add,
            icon: FLucideIcons.plus,
          ),
        ),
        if (error != null)
          Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
      ],
    ),
    actions: [
      button(
        'Salvar atribuições',
        saving ? null : save,
        loading: saving,
        primary: true,
      ),
    ],
  );
}
