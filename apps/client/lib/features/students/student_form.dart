import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import '../../shared/localities.dart';

Future<bool?> editStudent(
  BuildContext context,
  Api api, {
  JsonMap? student,
  String? existingFolder,
}) async {
  final lists = await Future.wait([
    api.get('classes'),
    api.get('templates'),
    api.get('courses'),
  ]);
  if (!context.mounted) return false;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => StudentForm(
      api: api,
      student: student,
      existingFolder: existingFolder,
      classes: List<JsonMap>.from(lists[0]),
      templates: List<JsonMap>.from(lists[1]),
      courses: List<JsonMap>.from(lists[2]),
    ),
  );
}

class StudentForm extends StatefulWidget {
  final Api api;
  final JsonMap? student;
  final String? existingFolder;
  final List<JsonMap> classes, templates, courses;
  const StudentForm({
    super.key,
    required this.api,
    this.student,
    this.existingFolder,
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
      classGroup = widget.classes
          .where((g) => g['archived'] == 0)
          .firstOrNull?['id'];
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
    selectTemplate(course?['template']);
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

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(
      widget.student == null ? 'Abrir pasta de aluno' : 'Editar dados do aluno',
    ),
    content: SizedBox(
      width: 620,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionHeading(
              'Identificação',
              description: 'Campos com * são obrigatórios. Os demais podem ser preenchidos depois.',
            ),
            field('Nome completo *', fields['name']!),
            field(
              'Nome social',
              fields['social_name']!,
              tip: 'Preencha quando informado pela pessoa. Não substitui o nome do registro.',
            ),
            field('Matrícula ou identificação', fields['registration']!),
            if (widget.student == null) ...[
              if (widget.classes.where((g) => g['archived'] == 0).isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Cadastre um curso e uma turma antes de abrir a pasta do aluno.',
                  ),
                ),
              selector(
                'Turma inicial',
                classGroup,
                widget.classes
                    .where((g) => g['archived'] == 0)
                    .map(
                      (g) => DropdownMenuItem(
                        value: g['id'] as String,
                        child: Text(
                          '${g['course_name']} · ${g['name']} · ${g['school_year']} / ${g['period_label']}',
                        ),
                      ),
                    )
                    .toList(),
                (v) => setState(() => selectClass(v)),
              ),
              selector('Modelo de pasta', template ?? '', [
                const DropdownMenuItem(value: '', child: Text('Sem modelo')),
                for (final t in widget.templates.where(
                  (t) => t['archived'] == 0,
                ))
                  DropdownMenuItem(
                    value: t['id'] as String,
                    child: Text(t['name']),
                  ),
              ], (v) => setState(() => selectTemplate(v == '' ? null : v))),
            ],
            sectionHeading('Dados pessoais'),
            field('Nascimento (DD/MM/AAAA)', fields['birth_date']!),
            selector(
              'Sexo informado',
              sex,
              [
                const DropdownMenuItem(value: '', child: Text('Não informado')),
                for (final item in ['Feminino', 'Masculino', 'Intersexo'])
                  DropdownMenuItem(value: item, child: Text(item)),
              ],
              (v) => setState(() => sex = v ?? ''),
              tip: 'Conforme informação fornecida no cadastro; não é inferido pelo nome.',
            ),
            LocalityField(controller: fields['birthplace']!, enabled: !saving),
            field(
              'Nacionalidade',
              fields['nationality']!,
              tip: 'Exemplo: Brasileira. Para outras nacionalidades, informe o país.',
            ),
            field(
              'Filiação',
              fields['parentage']!,
              lines: 2,
              tip: 'Nomes das pessoas que constam no registro de nascimento, quando disponíveis.',
            ),
            sectionHeading('Contato e responsável'),
            AddressField(controller: fields['address']!, enabled: !saving),
            field('Responsável', fields['guardian']!),
            field('Telefone de contato', fields['phone']!),
            field('E-mail', fields['email']!),
            field('Observações', fields['notes']!, lines: 3),
            const Text(
              'Informações adicionais',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
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
                      tooltip: 'Remover informação adicional',
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
              child: button(
                'Adicionar informação',
                saving
                    ? null
                    : () => setState(
                        () => extra.add((
                          label: TextEditingController(),
                          value: TextEditingController(),
                        )),
                      ),
                icon: Icons.add,
              ),
            ),
            if (widget.student == null) ...[
              const SizedBox(height: 16),
              const Text(
                'A matrícula será aberta em análise. A secretaria confere as pendências antes da ativação.',
                style: TextStyle(fontSize: 12, height: 1.5),
              ),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
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
        onPressed: saving ? null : () => Navigator.pop(c, false),
        child: const Text('Cancelar'),
      ),
      button(
        saving
            ? 'Salvando…'
            : widget.student == null
            ? 'Criar pasta'
            : 'Salvar alterações',
        saving || (widget.student == null && classGroup == null)
            ? null
            : () async {
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
                    setState(
                      () => error =
                          'Informe uma data válida no formato DD/MM/AAAA.',
                    );
                    return;
                  }
                }
                final entries = extra
                    .where((e) => e.label.text.trim().isNotEmpty)
                    .toList();
                if (entries
                        .map((e) => e.label.text.trim().toLowerCase())
                        .toSet()
                        .length !=
                    entries.length) {
                  setState(
                    () => error =
                        'Cada informação adicional deve ter um nome diferente.',
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
                        e.key: e.key == 'birth_date' ? birth : e.value.text,
                      'sex': sex,
                      'extra': {
                        for (final e in entries)
                          e.label.text.trim(): e.value.text.trim(),
                      },
                      if (widget.student != null)
                        'revision': widget.student!['revision'],
                      if (widget.existingFolder != null)
                        'folder': widget.existingFolder,
                      if (widget.student == null) 'class_group': classGroup,
                      if (widget.student == null) 'template': template,
                    },
                  );
                  if (c.mounted) Navigator.pop(c, result.isNotEmpty);
                } catch (e) {
                  if (mounted) {
                    setState(
                      () =>
                          error = e.toString().replaceFirst('Exception: ', ''),
                    );
                  }
                } finally {
                  if (mounted) setState(() => saving = false);
                }
              },
        primary: true,
      ),
    ],
  );
}
