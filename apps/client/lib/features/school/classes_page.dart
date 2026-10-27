import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import '../../shared/suggestion_field.dart';
import 'enrollment_panel.dart';
import 'journal_panel.dart';
import 'schedule_panel.dart';
import 'report_panel.dart';

class ClassesPage extends StatefulWidget {
  final Api api;
  final JsonMap data;
  final String? groupId;
  final ValueChanged<String?> open;
  final ValueChanged<String> openStudent;
  final VoidCallback changed;
  const ClassesPage({
    super.key,
    required this.api,
    required this.data,
    required this.open,
    required this.openStudent,
    required this.changed,
    this.groupId,
  });
  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  String search = '', tab = 'Matrículas';
  String? year;
  Future<JsonMap>? detail;
  bool get manage =>
      widget.data['session']['user']['role'] == 'admin' ||
      widget.data['session']['user']['department'] == 'secretaria';
  bool get configureJournals =>
      manage || widget.data['session']['user']['department'] == 'coordenacao';
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void didUpdateWidget(covariant ClassesPage old) {
    super.didUpdateWidget(old);
    if (old.groupId != widget.groupId || old.data != widget.data) load();
    if (old.groupId != widget.groupId) tab = 'Matrículas';
  }

  void load() {
    detail = widget.groupId == null
        ? null
        : widget.api
              .get('classes/${widget.groupId}')
              .then((v) => JsonMap.from(v));
  }

  void refresh() {
    if (mounted) setState(load);
    widget.changed();
  }

  Future<void> courseForm([JsonMap? course]) async {
    if (await showDialog<bool>(
          context: context,
          builder: (_) => CourseForm(
            api: widget.api,
            templates: List<JsonMap>.from(widget.data['templates']),
            course: course,
          ),
        ) ==
        true) {
      refresh();
    }
  }

  Future<void> classForm([JsonMap? group]) async {
    try {
      final catalog = await widget.api.get('academic/catalog');
      if (!mounted) return;
      if (await showDialog<bool>(
            context: context,
            builder: (_) => ClassForm(
              api: widget.api,
              courses: List<JsonMap>.from(widget.data['courses']),
              groups: List<JsonMap>.from(widget.data['classes']),
              components: List<JsonMap>.from(catalog['components']),
              group: group,
            ),
          ) ==
          true) {
        refresh();
      }
    } catch (e) {
      if (mounted) feedback(context, e);
    }
  }

  @override
  Widget build(BuildContext context) => widget.groupId == null
      ? directory()
      : FutureBuilder<JsonMap>(
          future: detail,
          builder: (c, s) {
            if (s.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${s.error}'),
                    button('Voltar aos cursos', () => widget.open(null)),
                  ],
                ),
              );
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final group = s.data!;
            final roster = List<JsonMap>.from(group['enrollments']);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => widget.open(null),
                    icon: const Icon(FLucideIcons.arrowLeft, size: 16),
                    label: const Text('Cursos e turmas'),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      group['name'],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (manage)
                      button(
                        'Editar turma',
                        () => classForm(group),
                        icon: FLucideIcons.pencil,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${group['course_name']} · ${group['school_year']} / ${group['period_label']} · ${group['grade']} · ${group['shift']}',
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in [
                      'Matrículas',
                      'Diários',
                      'Horários',
                      if (widget.data['session']['user']['role'] == 'admin' ||
                          widget.data['session']['user']['department'] ==
                              'coordenacao')
                        'Justificativas',
                    ])
                      ChoiceChip(
                        label: Text(t),
                        selected: tab == t,
                        onSelected: (_) => setState(() => tab = t),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: tab == 'Horários'
                      ? SchedulePanel(
                          api: widget.api,
                          group: group,
                          configure: configureJournals,
                        )
                      : tab == 'Justificativas'
                      ? ReportPanel(
                          api: widget.api,
                          user: JsonMap.from(widget.data['session']['user']),
                          review: true,
                          group: group['id'],
                        )
                      : tab == 'Diários'
                      ? JournalPanel(
                          api: widget.api,
                          group: group,
                          user: JsonMap.from(widget.data['session']['user']),
                          canConfigure: configureJournals,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '${roster.where((e) => e['state'] == 'Ativa').length} ativas · ${roster.where((e) => e['state'] == 'Em análise').length} em análise · ${group['capacity']} vagas',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (manage)
                                  button(
                                    'Matricular aluno',
                                    () async {
                                      if (await enrollDialog(
                                            context,
                                            widget.api,
                                            List<JsonMap>.from(
                                              widget.data['classes'],
                                            ),
                                            List<JsonMap>.from(
                                              widget.data['students'],
                                            ),
                                            classGroup: group['id'],
                                          ) ==
                                          true) {
                                        refresh();
                                      }
                                    },
                                    icon: FLucideIcons.userPlus,
                                    primary: true,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: roster.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Nenhuma matrícula nesta turma. Cadastre um aluno ou selecione uma pasta existente.',
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: roster.length,
                                      separatorBuilder: (_, i) =>
                                          const PixelDivider(),
                                      itemBuilder: (c, i) {
                                        final e = roster[i];
                                        final canOpen = List<JsonMap>.from(
                                          widget.data['students'],
                                        ).any((p) => p['id'] == e['student']);
                                        return ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                          title: Text(
                                            e['student_name'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          subtitle: Text(
                                            e['registration'] ??
                                                'Sem identificação informada',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          trailing: badge(e['state']),
                                          onTap: canOpen
                                              ? () => widget.openStudent(
                                                  e['student'],
                                                )
                                              : null,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        );
  Widget directory() {
    final all = List<JsonMap>.from(widget.data['classes']),
        courses = List<JsonMap>.from(widget.data['courses']);
    final years = all.map((g) => '${g['school_year']}').toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    final groups = all
        .where(
          (g) =>
              (year == null || '${g['school_year']}' == year) &&
              '${g['course_name']} ${g['name']} ${g['period_label']} ${g['modality']}'
                  .toLowerCase()
                  .contains(search.toLowerCase()),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Cursos e turmas',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            if (manage) ...[
              button(
                'Cadastrar curso',
                () => courseForm(),
                icon: FLucideIcons.plus,
              ),
              button(
                'Cadastrar turma',
                courses.any((c) => c['archived'] == 0)
                    ? () => classForm()
                    : null,
                icon: FLucideIcons.plus,
                primary: true,
              ),
            ],
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Cadastre o curso e sua modalidade; depois organize as turmas por ano, período, etapa e turno.',
          style: TextStyle(fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: FTextField(
                hint: 'Buscar curso, turma ou período',
                control: FTextFieldControl.managed(
                  onChange: (v) => setState(() => search = v.text),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 145,
              child: DropdownButtonFormField<String>(
                initialValue: year ?? '',
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Ano',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(value: '', child: Text('Todos')),
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text(y)),
                ],
                onChanged: (v) => setState(() => year = v == '' ? null : v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Expanded(
          child: courses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(FLucideIcons.graduationCap, size: 40),
                      const SizedBox(height: 16),
                      const Text(
                        'Comece pelo curso',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'As turmas e suas matrículas ficarão vinculadas a ele.',
                      ),
                      if (manage) ...[
                        const SizedBox(height: 20),
                        button(
                          'Cadastrar primeiro curso',
                          () => courseForm(),
                          primary: true,
                        ),
                      ],
                    ],
                  ),
                )
              : ListView(
                  children: [
                    for (final course in courses.where(
                      (c) =>
                          groups.any((g) => g['course'] == c['id']) ||
                          search.isEmpty ||
                          '${c['name']} ${c['modality']}'
                              .toLowerCase()
                              .contains(search.toLowerCase()),
                    )) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['name'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${course['modality']}${course['archived'] == 1 ? ' · Arquivado' : ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (manage)
                              IconButton(
                                tooltip: 'Editar curso ${course['name']}',
                                onPressed: () => courseForm(course),
                                icon: const Icon(FLucideIcons.pencil, size: 18),
                              ),
                          ],
                        ),
                      ),
                      for (final g in groups.where(
                        (g) => g['course'] == course['id'],
                      ))
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          leading: const Icon(FLucideIcons.school, size: 21),
                          title: Text(
                            g['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${g['school_year']} / ${g['period_label']} · ${g['grade']} · ${g['shift']}\n${g['active_count']} ativas · ${g['pending_count']} em análise · ${g['capacity']} vagas${g['archived'] == 1 ? ' · Arquivada' : ''}',
                            style: const TextStyle(fontSize: 12, height: 1.6),
                          ),
                          trailing: const Icon(
                            FLucideIcons.chevronRight,
                            size: 18,
                          ),
                          onTap: () => widget.open(g['id']),
                        ),
                      if (!groups.any((g) => g['course'] == course['id']))
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Nenhuma turma para este filtro.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      const PixelDivider(),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class CourseForm extends StatefulWidget {
  final Api api;
  final List<JsonMap> templates;
  final JsonMap? course;
  const CourseForm({
    super.key,
    required this.api,
    required this.templates,
    this.course,
  });
  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  late final name = TextEditingController(text: widget.course?['name']),
      modality = TextEditingController(text: widget.course?['modality']),
      duration = TextEditingController(text: widget.course?['duration_label']);
  late String? template = widget.course?['template'];
  late bool archived = widget.course?['archived'] == 1;
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in [name, modality, duration]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(widget.course == null ? 'Cadastrar curso' : 'Editar curso'),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            field('Nome do curso ou formação', name),
            field('Modalidade', modality),
            field('Duração / organização (opcional)', duration),
            selector('Modelo documental padrão', template ?? '', [
              const DropdownMenuItem(
                value: '',
                child: Text('Sem modelo padrão'),
              ),
              for (final t in widget.templates.where(
                (t) => t['archived'] == 0 || t['id'] == template,
              ))
                DropdownMenuItem(
                  value: t['id'] as String,
                  child: Text(t['name']),
                ),
            ], (v) => setState(() => template = v == '' ? null : v)),
            if (widget.course != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Curso arquivado'),
                value: archived,
                onChanged: saving ? null : (v) => setState(() => archived = v!),
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
        saving ? 'Salvando…' : 'Salvar curso',
        saving
            ? null
            : () async {
                setState(() {
                  saving = true;
                  error = null;
                });
                try {
                  await widget.api.send(
                    widget.course == null ? 'POST' : 'PATCH',
                    widget.course == null
                        ? 'courses'
                        : 'courses/${widget.course!['id']}',
                    {
                      'name': name.text,
                      'modality': modality.text,
                      'duration_label': duration.text,
                      'template': template,
                      'archived': archived ? 1 : 0,
                      if (widget.course != null)
                        'revision': widget.course!['revision'],
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

class ClassForm extends StatefulWidget {
  final Api api;
  final List<JsonMap> courses;
  final List<JsonMap> groups, components;
  final JsonMap? group;
  const ClassForm({
    super.key,
    required this.api,
    required this.courses,
    this.groups = const [],
    this.components = const [],
    this.group,
  });
  @override
  State<ClassForm> createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  late final name = TextEditingController(text: widget.group?['name']),
      year = TextEditingController(
        text: '${widget.group?['school_year'] ?? DateTime.now().year}',
      ),
      period = TextEditingController(text: widget.group?['period_label']),
      grade = TextEditingController(text: widget.group?['grade']),
      capacity = TextEditingController(
        text: widget.group == null ? '' : '${widget.group!['capacity']}',
      );
  late String? course =
      widget.group?['course'] ??
      widget.courses.where((c) => c['archived'] == 0).firstOrNull?['id'];
  late String shift = widget.group?['shift'] ?? 'Matutino';
  late bool archived = widget.group?['archived'] == 1;
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in [name, year, period, grade, capacity]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(widget.group == null ? 'Cadastrar turma' : 'Editar turma'),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            selector(
              'Curso e modalidade',
              course,
              widget.courses
                  .where((c) => c['archived'] == 0 || c['id'] == course)
                  .map(
                    (c) => DropdownMenuItem(
                      value: c['id'] as String,
                      child: Text('${c['name']} · ${c['modality']}'),
                    ),
                  )
                  .toList(),
              (v) => setState(() => course = v),
            ),
            field('Nome / código da turma', name),
            field('Ano letivo', year),
            SuggestionField(
              label: 'Período de ingresso (anual, semestre ou ciclo)',
              controller: period,
              suggestions: [
                for (final g in widget.groups.where(
                  (g) => g['course'] == course,
                ))
                  g['period_label'] as String,
              ],
            ),
            SuggestionField(
              label: 'Etapa, série ou módulo',
              controller: grade,
              suggestions: [
                for (final component in widget.components.where(
                  (m) => m['course'] == course,
                ))
                  component['phase'] as String,
              ],
            ),
            field('Capacidade de alunos ativos', capacity),
            selector(
              'Turno',
              shift,
              [
                'Matutino',
                'Vespertino',
                'Noturno',
                'Integral',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              (v) => setState(() => shift = v!),
            ),
            if (widget.group != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Turma arquivada'),
                value: archived,
                onChanged: saving ? null : (v) => setState(() => archived = v!),
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
        saving ? 'Salvando…' : 'Salvar turma',
        saving || course == null
            ? null
            : () async {
                setState(() {
                  saving = true;
                  error = null;
                });
                try {
                  await widget.api.send(
                    widget.group == null ? 'POST' : 'PATCH',
                    widget.group == null
                        ? 'classes'
                        : 'classes/${widget.group!['id']}',
                    {
                      'course': course,
                      'name': name.text,
                      'school_year': int.tryParse(year.text),
                      'period_label': period.text,
                      'grade': grade.text,
                      'capacity': int.tryParse(capacity.text),
                      'shift': shift,
                      'archived': archived ? 1 : 0,
                      if (widget.group != null)
                        'revision': widget.group!['revision'],
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
