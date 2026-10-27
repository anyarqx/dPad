import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

Future<bool?> enrollDialog(
  BuildContext context,
  Api api,
  List<JsonMap> groups,
  List<JsonMap> students, {
  String? student,
  String? classGroup,
}) => showDialog<bool>(
  context: context,
  builder: (_) => _EnrollmentForm(
    api: api,
    groups: groups,
    students: students,
    student: student,
    classGroup: classGroup,
  ),
);

class _EnrollmentForm extends StatefulWidget {
  final Api api;
  final List<JsonMap> groups, students;
  final String? student, classGroup;
  const _EnrollmentForm({
    required this.api,
    required this.groups,
    required this.students,
    this.student,
    this.classGroup,
  });
  @override
  State<_EnrollmentForm> createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<_EnrollmentForm> {
  late String? student = widget.student ?? widget.students.firstOrNull?['id'];
  late String? group =
      widget.classGroup ??
      widget.groups.where((g) => g['archived'] == 0).firstOrNull?['id'];
  bool busy = false;
  String? error;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Abrir matrícula'),
    content: SizedBox(
      width: 460,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.student != null)
              Text(
                widget.students.firstWhere((p) => p['id'] == student)['name'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              )
            else
              selector(
                'Aluno',
                student,
                widget.students
                    .map(
                      (p) => DropdownMenuItem(
                        value: p['id'] as String,
                        child: Text(p['name']),
                      ),
                    )
                    .toList(),
                (v) => setState(() => student = v),
              ),
            const SizedBox(height: 16),
            selector(
              'Turma e ano letivo',
              group,
              widget.groups
                  .where((g) => g['archived'] == 0)
                  .map(
                    (g) => DropdownMenuItem(
                      value: g['id'] as String,
                      child: Text(
                        '${g['name']} · ${g['school_year']} · ${g['shift']}',
                      ),
                    ),
                  )
                  .toList(),
              widget.classGroup == null
                  ? (v) => setState(() => group = v)
                  : (_) => {},
            ),
            const Text(
              'A matrícula será aberta em análise. A ativação verifica os dados, os documentos e as vagas. O cadastro do aluno permanece o mesmo entre anos letivos.',
              style: TextStyle(fontSize: 13, height: 1.6),
            ),
            if (widget.groups.where((g) => g['archived'] == 0).isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text('Cadastre uma turma aberta antes de matricular.'),
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      button(
        busy ? 'Salvando…' : 'Abrir em análise',
        busy || student == null || group == null
            ? null
            : () async {
                setState(() {
                  busy = true;
                  error = null;
                });
                try {
                  await widget.api.send('POST', 'enrollments', {
                    'student': student,
                    'class_group': group,
                  });
                  if (context.mounted) Navigator.pop(context, true);
                } catch (e) {
                  if (mounted) setState(() => error = '$e');
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        primary: true,
      ),
    ],
  );
}

class EnrollmentPanel extends StatefulWidget {
  final Api api;
  final JsonMap student, data;
  final VoidCallback changed;
  const EnrollmentPanel({
    super.key,
    required this.api,
    required this.student,
    required this.data,
    required this.changed,
  });
  @override
  State<EnrollmentPanel> createState() => _EnrollmentPanelState();
}

class _EnrollmentPanelState extends State<EnrollmentPanel> {
  late Future<JsonMap> records;
  bool get manage =>
      widget.data['session']['user']['role'] == 'admin' ||
      widget.data['session']['user']['department'] == 'secretaria';
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void didUpdateWidget(covariant EnrollmentPanel old) {
    super.didUpdateWidget(old);
    if (old.student != widget.student) load();
  }

  void load() {
    records = widget.api
        .get('students/${widget.student['id']}/enrollments')
        .then((v) => JsonMap.from(v));
  }

  void refresh() {
    if (mounted) setState(load);
    widget.changed();
  }

  Future<void> action(JsonMap e, String action) async {
    final note = TextEditingController();
    String? target;
    bool saving = false;
    String? error;
    const labels = {
      'activate': 'Ativar matrícula',
      'move': 'Mudar turma',
      'finish': 'Encerrar ano letivo',
      'transfer': 'Registrar transferência',
      'cancel': 'Cancelar matrícula',
    };
    final groups = List<JsonMap>.from(widget.data['classes'])
        .where(
          (g) =>
              g['school_year'] == e['school_year'] &&
              g['course'] == e['course'] &&
              g['period_label'] == e['period_label'] &&
              g['archived'] == 0 &&
              g['id'] != e['class_group'],
        )
        .toList();
    target = groups.firstOrNull?['id'];
    final saved = await showEditorDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: Text(labels[action]!),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${widget.student['name']} · ${e['school_year']}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (action == 'move')
                    selector(
                      'Nova turma',
                      target,
                      groups
                          .map(
                            (g) => DropdownMenuItem(
                              value: g['id'] as String,
                              child: Text(g['name']),
                            ),
                          )
                          .toList(),
                      (v) => set(() => target = v),
                    ),
                  field(
                    action == 'activate'
                        ? 'Justificativa, caso existam pendências'
                        : 'Motivo / resultado',
                    note,
                    lines: 3,
                  ),
                  if (action == 'activate')
                    const Text(
                      'Com pendências, informe uma justificativa com ao menos 10 caracteres. Ela será registrada no histórico.',
                      style: TextStyle(fontSize: 12, height: 1.5),
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
              saving ? 'Salvando…' : 'Confirmar',
              saving || (action == 'move' && target == null)
                  ? null
                  : () async {
                      set(() {
                        saving = true;
                        error = null;
                      });
                      try {
                        await widget.api.send(
                          'POST',
                          'enrollments/${e['id']}/actions',
                          {
                            'revision': e['revision'],
                            'action': action,
                            'note': note.text,
                            if (action == 'move') 'class_group': target,
                          },
                        );
                        if (c.mounted) Navigator.pop(c, true);
                      } catch (e) {
                        if (c.mounted) set(() => error = '$e');
                      } finally {
                        if (c.mounted) set(() => saving = false);
                      }
                    },
              primary: true,
            ),
          ],
        ),
      ),
    );
    note.dispose();
    if (saved == true) refresh();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<JsonMap>(
    future: records,
    builder: (c, s) {
      if (s.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${s.error}'),
              button('Tentar novamente', () => setState(load)),
            ],
          ),
        );
      }
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      final items = List<JsonMap>.from(s.data!['items']);
      final pending = List<String>.from(s.data!['pending']);
      return ListView(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Matrículas locais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              if (manage)
                button(
                  'Nova matrícula',
                  () async {
                    final saved = await enrollDialog(
                      context,
                      widget.api,
                      List<JsonMap>.from(widget.data['classes']),
                      List<JsonMap>.from(widget.data['students']),
                      student: widget.student['id'],
                    );
                    if (saved == true) refresh();
                  },
                  icon: FLucideIcons.plus,
                  primary: true,
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Registro administrativo por ano letivo. O histórico e a pasta do aluno são preservados.',
            style: TextStyle(fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 18),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              '${pending.length} pendências para conferência',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            children: [
              for (final item in pending)
                ListTile(
                  dense: true,
                  leading: const Icon(FLucideIcons.circleAlert, size: 16),
                  title: Text(item, style: const TextStyle(fontSize: 12)),
                ),
              if (pending.isEmpty)
                const ListTile(
                  title: Text('Dados básicos e documentos conferidos.'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Nenhuma matrícula registrada. Abra a primeira para iniciar a análise.',
              ),
            ),
          for (final e in items) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${e['course_name']} · ${e['period_label']}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${e['school_year']} · ${e['class_name']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      badge(e['state']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${e['shift']} · Atualizada ${date(e['updated'])}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(c).hintColor,
                    ),
                  ),
                  if (manage &&
                      ['Ativa', 'Em análise'].contains(e['state'])) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (e['state'] == 'Em análise')
                          button(
                            'Ativar matrícula',
                            () => action(e, 'activate'),
                            primary: true,
                          ),
                        button('Mudar turma', () => action(e, 'move')),
                        PopupMenuButton<String>(
                          tooltip: 'Outras ações da matrícula',
                          onSelected: (a) => action(e, a),
                          itemBuilder: (_) => [
                            if (e['state'] == 'Ativa')
                              const PopupMenuItem(
                                value: 'finish',
                                child: Text('Encerrar ano letivo'),
                              ),
                            const PopupMenuItem(
                              value: 'transfer',
                              child: Text('Registrar transferência'),
                            ),
                            const PopupMenuItem(
                              value: 'cancel',
                              child: Text('Cancelar matrícula'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text(
                      'Histórico da matrícula',
                      style: TextStyle(fontSize: 12),
                    ),
                    children: [
                      for (final event in List<JsonMap>.from(e['events']))
                        ListTile(
                          dense: true,
                          title: Text(
                            event['message'],
                            style: const TextStyle(fontSize: 12, height: 1.5),
                          ),
                          subtitle: Text(
                            '${event['actor_name']} · ${date(event['created'])}',
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
      );
    },
  );
}
