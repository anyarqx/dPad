import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import '../../shared/localities.dart';
import '../../shared/search_picker.dart';

Future<bool?> editStudent(
  BuildContext context,
  Api api, {
  JsonMap? student,
  String? existingFolder,
}) async {
  final lists = await Future.wait([api.get('bootstrap'), api.get('templates')]);
  if (!context.mounted) return false;
  final config = JsonMap.from(lists[0]);
  return openEditor<bool>(
    context,
    StudentForm(
      api: api,
      student: student,
      existingFolder: existingFolder,
      classes: List<JsonMap>.from(config['classes']),
      templates: List<JsonMap>.from(lists[1]),
      courses: List<JsonMap>.from(config['courses']),
      institution: JsonMap.from(config['institution']),
    ),
  );
}

class StudentForm extends StatefulWidget {
  final Api api;
  final JsonMap? student;
  final String? existingFolder, initialClass;
  final JsonMap institution;
  final List<JsonMap> classes, templates, courses;
  const StudentForm({
    super.key,
    required this.api,
    this.student,
    this.existingFolder,
    this.initialClass,
    this.institution = const {},
    this.classes = const [],
    this.templates = const [],
    this.courses = const [],
  });
  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  late final fields = {
    for (final key in [
      'name',
      'registration',
      'birth_date',
      'social_name',
      'birthplace',
      'nationality',
      'parentage',
      'address',
      'guardian',
      'phone',
      'email',
      'notes',
    ])
      key: TextEditingController(
        text:
            key == 'birth_date' &&
                widget.student?[key] != null &&
                widget.student?[key] != ''
            ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(widget.student![key]))
            : widget.student?[key] ?? '',
      ),
  };
  late final extra =
      <({TextEditingController label, TextEditingController value})>[
        for (final e in (widget.student?['extra'] as Map? ?? {}).entries)
          (
            label: TextEditingController(text: e.key),
            value: TextEditingController(text: e.value),
          ),
      ];
  final retired = <TextEditingController>[];
  final templateLabels = <String>{};
  bool saving = false;
  String? error;
  String? classGroup, template;
  late String sex =
      ['Feminino', 'Masculino', 'Intersexo'].contains(widget.student?['sex'])
      ? widget.student!['sex']
      : '';
  @override
  void initState() {
    super.initState();
    if (widget.student == null) {
      classGroup =
          widget.classes.any(
            (g) => g['id'] == widget.initialClass && g['archived'] == 0,
          )
          ? widget.initialClass
          : null;
      selectClass(classGroup);
    } else {
      templateLabels.addAll(
        List<String>.from(widget.student?['templateFields']?['extra'] ?? []),
      );
    }
  }

  void selectClass(String? id) {
    classGroup = id;
    final group = widget.classes.where((g) => g['id'] == id).firstOrNull;
    final course = widget.courses
        .where((c) => c['id'] == group?['course'])
        .firstOrNull;
    selectTemplate(
      course?['template'] ?? widget.institution['document_template'],
    );
  }

  void selectTemplate(String? id) {
    template = widget.templates.any((t) => t['id'] == id && t['archived'] == 0)
        ? id
        : null;
    final model = widget.templates
        .where((t) => t['id'] == template)
        .firstOrNull;
    final requested = List<String>.from(model?['fields']?['extra'] ?? []);
    final removed = extra
        .where(
          (e) =>
              templateLabels.contains(e.label.text) &&
              e.value.text.trim().isEmpty &&
              !requested.contains(e.label.text),
        )
        .toList();
    for (final row in removed) {
      extra.remove(row);
      retired.addAll([row.label, row.value]);
    }
    templateLabels.clear();
    templateLabels.addAll(requested);
    for (final label in List<String>.from(model?['fields']?['extra'] ?? [])) {
      final existing = extra
          .where((e) => e.label.text.toLowerCase() == label.toLowerCase())
          .firstOrNull;
      if (existing != null) existing.label.text = label;
      if (existing == null) {
        extra.add((
          label: TextEditingController(text: label),
          value: TextEditingController(),
        ));
      }
    }
  }

  @override
  void dispose() {
    for (final c in retired) {
      c.dispose();
    }
    for (final c in fields.values) {
      c.dispose();
    }
    for (final e in extra) {
      e.label.dispose();
      e.value.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (fields['name']!.text.trim().isEmpty) {
      setState(() => error = 'Informe o nome do aluno.');
      return;
    }
    String birth = '';
    if (fields['birth_date']!.text.trim().isNotEmpty) {
      try {
        birth = DateFormat('dd/MM/yyyy')
            .parseStrict(fields['birth_date']!.text.trim())
            .toIso8601String()
            .substring(0, 10);
      } catch (_) {
        setState(() => error = 'Informe uma data de nascimento válida.');
        return;
      }
    }
    final entries = extra.where((e) => e.label.text.trim().isNotEmpty).toList();
    if (entries.map((e) => e.label.text.trim().toLowerCase()).toSet().length !=
        entries.length) {
      setState(
        () => error = 'Use nomes diferentes nas informações adicionais.',
      );
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final result = await widget.api.send(
        widget.student == null ? 'POST' : 'PATCH',
        widget.student == null
            ? 'students'
            : 'students/${widget.student!['id']}',
        {
          for (final e in fields.entries)
            e.key: e.key == 'birth_date' ? birth : e.value.text.trim(),
          'sex': sex,
          'extra': {
            for (final e in entries) e.label.text.trim(): e.value.text.trim(),
          },
          if (widget.student != null) 'revision': widget.student!['revision'],
          if (widget.existingFolder != null) 'folder': widget.existingFolder,
          if (widget.student == null) 'class_group': classGroup,
          if (widget.student == null) 'template': template,
        },
      );
      if (mounted) Navigator.pop(context, result.isNotEmpty);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext c) => EditorPage(
    title: widget.student == null ? 'Cadastrar aluno' : 'Editar aluno',
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sectionHeading('Identificação'),
          FormColumns(
            children: [
              field('Nome completo *', fields['name']!),
              field(
                'Nome social',
                fields['social_name']!,
                tip: 'Opcional. Informe somente quando solicitado pela pessoa.',
              ),
              field('Matrícula ou identificação', fields['registration']!),
            ],
          ),
          if (widget.student == null) ...[
            SearchPicker(
              label: 'Matrícula inicial',
              value: classGroup ?? '',
              hint: 'Sem matrícula — cadastrar somente o aluno',
              choices: [
                SearchChoice('', 'Sem matrícula'),
                for (final g in widget.classes.where((g) => g['archived'] == 0))
                  SearchChoice(
                    g['id'],
                    '${g['course_name']} · ${g['name']}',
                    description:
                        '${g['school_year']} / ${g['period_label']} · ${g['shift']}',
                  ),
              ],
              onChanged: (id) =>
                  setState(() => selectClass(id.isEmpty ? null : id)),
            ),
            SearchPicker(
              label: 'Modelo documental',
              value: template ?? '',
              choices: [
                SearchChoice('', 'Sem modelo'),
                for (final t in widget.templates.where(
                  (t) => t['archived'] == 0,
                ))
                  SearchChoice(t['id'], t['name']),
              ],
              onChanged: (id) =>
                  setState(() => selectTemplate(id.isEmpty ? null : id)),
            ),
          ],
          sectionHeading('Dados pessoais'),
          FormColumns(
            children: [
              field('Nascimento', fields['birth_date']!, kind: FieldKind.date),
              selector('Sexo informado', sex, [
                for (final value in ['', 'Feminino', 'Masculino', 'Intersexo'])
                  DropdownMenuItem(
                    value: value,
                    child: Text(value.isEmpty ? 'Não informado' : value),
                  ),
              ], (v) => setState(() => sex = v ?? '')),
              LocalityField(
                controller: fields['birthplace']!,
                enabled: !saving,
              ),
              field('Nacionalidade', fields['nationality']!),
            ],
          ),
          field('Filiação', fields['parentage']!),
          sectionHeading('Contato'),
          FormColumns(
            children: [
              field('Responsável', fields['guardian']!),
              field(
                'Telefone de contato',
                fields['phone']!,
                kind: FieldKind.phone,
              ),
              field('E-mail', fields['email']!, kind: FieldKind.email),
            ],
          ),
          AddressField(controller: fields['address']!, enabled: !saving),
          field('Observações', fields['notes']!, lines: 2),
          if (extra.isNotEmpty) sectionHeading('Informações adicionais'),
          for (final e in extra)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: field(
                    'Informação',
                    e.label,
                    enabled: !templateLabels.contains(e.label.text),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: field('Valor', e.value)),
                if (!templateLabels.contains(e.label.text))
                  IconButton(
                    tooltip: 'Remover informação',
                    onPressed: saving
                        ? null
                        : () => setState(() {
                            extra.remove(e);
                            retired.addAll([e.label, e.value]);
                          }),
                    icon: const Icon(Icons.close, size: 18),
                  ),
              ],
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: saving
                  ? null
                  : () => setState(
                      () => extra.add((
                        label: TextEditingController(),
                        value: TextEditingController(),
                      )),
                    ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Adicionar informação'),
            ),
          ),
          if (error != null)
            Text(
              error!,
              style: TextStyle(color: Theme.of(c).colorScheme.error),
            ),
        ],
      ),
    ),
    actions: [
      button(
        widget.student == null ? 'Salvar aluno' : 'Salvar alterações',
        saving ? null : save,
        primary: true,
        loading: saving,
      ),
    ],
  );
}
