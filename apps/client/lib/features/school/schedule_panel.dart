import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import 'journal_panel.dart' show TeacherAssignments;
import '../../shared/search_picker.dart';
import '../../shared/date_input.dart';
import '../../shared/widgets.dart';
import '../../shared/page_header.dart';

const weekDays = [
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
  'Domingo',
];
String clockTime(dynamic minutes) =>
    '${'${(minutes as int) ~/ 60}'.padLeft(2, '0')}:${'${minutes % 60}'.padLeft(2, '0')}';

class SchedulePanel extends StatefulWidget {
  final Api api;
  final JsonMap group;
  final bool configure;
  const SchedulePanel({
    super.key,
    required this.api,
    required this.group,
    required this.configure,
  });
  @override
  State<SchedulePanel> createState() => _SchedulePanelState();
}

class _SchedulePanelState extends State<SchedulePanel> {
  late Future<dynamic> pending;
  late DateTime at = DateTime.now().year == widget.group['school_year']
      ? DateTime.now()
      : DateTime(widget.group['school_year'], 1, 1);
  bool all = false;
  List<JsonMap> models = [];
  String? modelId;
  JsonMap? get model => models.where((m) => m['id'] == modelId).firstOrNull;
  Future<void> editModels() async {
    final result = List<JsonMap>.from(await widget.api.get('period-models'));
    if (!mounted) return;
    setState(() {
      models = result;
      modelId ??= widget.group['period_model'];
    });
    final id = await pickChoice(
      context,
      title: 'Modelo de períodos',
      choices: [
        for (final m in models)
          SearchChoice(
            m['id'],
            m['name'],
            description: "${m['valid_from']} a ${m['valid_to']}",
          ),
        SearchChoice('new', 'Criar modelo de períodos'),
      ],
      selected: modelId,
    );
    if (!mounted || id == null) return;
    if (id == 'new') {
      final saved = await openEditor<JsonMap>(
        context,
        PeriodModelEditor(api: widget.api),
      );
      if (saved == null || !mounted) return;
      final fresh = List<JsonMap>.from(await widget.api.get('period-models'));
      if (mounted) setState(() => models = fresh);
      await assignModel(saved['id']);
    } else {
      await assignModel(id);
    }
  }

  @override
  void initState() {
    super.initState();
    load();
    if (widget.configure) loadModels();
  }

  Future<void> loadModels() async {
    try {
      final result = List<JsonMap>.from(await widget.api.get('period-models'));
      if (mounted) {
        setState(() {
          models = result;
          modelId = widget.group['period_model'];
        });
      }
    } catch (e) {
      if (mounted) feedbackError(context, e);
    }
  }

  void load() {
    pending = widget.api.get('classes/${widget.group['id']}/schedule');
  }

  void refresh() {
    if (mounted) setState(load);
  }

  @override
  void didUpdateWidget(covariant SchedulePanel old) {
    super.didUpdateWidget(old);
    if (old.group['id'] != widget.group['id']) load();
  }

  Future<void> edit([JsonMap? old, JsonMap? preset]) async {
    try {
      final journals = List<JsonMap>.from(
        await widget.api.get('classes/${widget.group['id']}/journals'),
      );
      if (!mounted) return;
      if (journals.isEmpty) {
        feedback(
          context,
          'Adicione componentes à fase da turma em Org. Acadêmica.',
        );
        return;
      }
      if (await showDialog<bool>(
            context: context,
            builder: (_) => _SlotForm(
              api: widget.api,
              group: widget.group,
              journals: journals,
              slot: old,
              preset: preset,
            ),
          ) ==
          true) {
        refresh();
      }
    } catch (e) {
      if (mounted) feedbackError(context, e);
    }
  }

  Future<void> remove(JsonMap slot) async {
    if (!await confirm(
      context,
      'Excluir este horário? As aulas já registradas permanecem no diário.',
    )) {
      return;
    }
    try {
      await widget.api.send('POST', 'schedule/${slot['id']}/delete', {
        'revision': slot['revision'],
      });
      refresh();
    } catch (e) {
      if (mounted) feedbackError(context, e);
    }
  }

  Future<void> shareSchedule(List<JsonMap> rows) async {
    try {
      final info = await widget.api.get('bootstrap');
      if (!mounted) return;
      final group = widget.group;
      final targets = List<JsonMap>.from(info['classes'])
          .where(
            (g) =>
                g['archived'] == 0 &&
                g['id'] != group['id'] &&
                g['course'] == group['course'] &&
                g['grade'] == group['grade'] &&
                g['school_year'] == group['school_year'],
          )
          .toList();
      final ids = await pickMany(
        context,
        title: 'Aplicar a turmas da mesma fase',
        choices: [
          for (final g in targets)
            SearchChoice(g['id'], g['name'], description: g['period_label']),
        ],
        maximum: 30,
      );
      if (ids == null || ids.isEmpty || !mounted) return;
      await widget.api.send('POST', 'schedule/apply', {
        'classes': ids.toList(),
        'period_model': modelId,
        'slots': [
          for (final r in rows)
            {
              'component': r['component'],
              'weekday': r['weekday'],
              'start_minute': r['start_minute'],
              'end_minute': r['end_minute'],
              'valid_from': r['valid_from'],
              'valid_to': r['valid_to'],
            },
        ],
      });
      if (mounted) {
        feedback(
          context,
          'Horários aplicados em ${ids.length} turma(s). Defina os docentes e as salas da oferta.',
        );
      }
    } catch (e) {
      if (mounted) feedbackError(context, e);
    }
  }

  Future<void> assignModel(String id) async {
    await widget.api.send('POST', 'schedule/apply', {
      'classes': [widget.group['id']],
      'period_model': id,
      'slots': [],
    });
    if (mounted) setState(() => modelId = id);
  }

  Future<void> referenceDate() async {
    final date = TextEditingController(
      text: at.toIso8601String().substring(0, 10),
    );
    final value = await showDialog<DateTime>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Data de referência'),
        content: field('Data', date, kind: FieldKind.isoDate),
        actions: [
          TextButton(
            onPressed: () {
              final value = schoolDate(date.text);
              if (value != null && value.year == widget.group['school_year']) {
                Navigator.pop(c, value);
              }
            },
            child: const Text('Consultar'),
          ),
        ],
      ),
    );
    date.dispose();
    if (value != null && mounted) setState(() => at = value);
  }

  Widget grid(List<JsonMap> rows) {
    final iso = at.toIso8601String().substring(0, 10);
    final activeModel = model;
    final showModel =
        activeModel != null &&
        (all ||
            (activeModel['valid_from'].compareTo(iso) <= 0 &&
                activeModel['valid_to'].compareTo(iso) >= 0));
    final modelPeriods = List<JsonMap>.from(
      showModel ? activeModel['periods'] : [],
    );

    final periods = <(int, int), String>{
      for (final p in modelPeriods)
        (p['start_minute'], p['end_minute']): p['label'],
      for (final r in rows) (r['start_minute'], r['end_minute']): '',
    };
    final keys = periods.keys.toList()..sort((a, b) => a.$1.compareTo(b.$1));
    if (keys.isEmpty) {
      return const Center(
        child: Text('Adicione um horário ou selecione um modelo de períodos.'),
      );
    }
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 12,
          dataRowMinHeight: 54,
          dataRowMaxHeight: 112,
          columns: [
            const DataColumn(label: Text('Período')),
            for (final day in weekDays) DataColumn(label: Text(day)),
          ],
          rows: [
            for (final interval in keys)
              DataRow(
                cells: [
                  DataCell(
                    Text(
                      "${periods[interval]}\n${clockTime(interval.$1)}–${clockTime(interval.$2)}",
                    ),
                  ),
                  for (var i = 1; i <= 7; i++)
                    DataCell(
                      Builder(
                        builder: (c) {
                          final entries = rows
                              .where(
                                (r) =>
                                    r['weekday'] == i &&
                                    r['start_minute'] == interval.$1 &&
                                    r['end_minute'] == interval.$2,
                              )
                              .toList();
                          return SizedBox(
                            width: 110,
                            child: entries.isEmpty
                                ? widget.configure
                                      ? IconButton(
                                          tooltip:
                                              'Adicionar em ${weekDays[i - 1]}',
                                          onPressed: () => edit(null, {
                                            'weekday': i,
                                            'start_minute': interval.$1,
                                            'end_minute': interval.$2,
                                            'valid_from': model?['valid_from'],
                                            'valid_to': model?['valid_to'],
                                          }),
                                          icon: const Icon(
                                            FLucideIcons.plus,
                                            size: 16,
                                          ),
                                        )
                                      : const Text('—')
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (final r in entries.take(2))
                                        InkWell(
                                          onTap: widget.configure
                                              ? () => edit(r)
                                              : null,
                                          onLongPress: widget.configure
                                              ? () => remove(r)
                                              : null,
                                          child: Tooltip(
                                            message:
                                                "${r['subject']} · ${r['teacher_name']} · ${r['valid_from']} a ${r['valid_to']}",
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                  ),
                                              child: Text(
                                                "${r['subject']}\n${r['room'] == '' ? r['teacher_name'] : r['room']}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (entries.length > 2)
                                        Text('+ ${entries.length - 2}'),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeader(
        section: true,
        title: 'Horário semanal',
        subtitle: 'Consulte a vigência e organize os horários da turma.',
        actions: [
          if (widget.configure)
            button(
              'Adicionar horário',
              () => edit(),
              icon: FLucideIcons.plus,
              primary: true,
            ),
          button(
            'Vigência: ${at.day.toString().padLeft(2, '0')}/${at.month.toString().padLeft(2, '0')}/${at.year}',
            referenceDate,
            icon: FLucideIcons.calendarDays,
          ),
          if (widget.configure)
            button(model?['name'] ?? 'Modelo de períodos', () async {
              try {
                await editModels();
              } catch (e) {
                if (c.mounted) feedbackError(c, e);
              }
            }),
          FilterChip(
            label: const Text('Todas as vigências'),
            selected: all,
            onSelected: (v) => setState(() => all = v),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Expanded(
        child: FutureBuilder<dynamic>(
          future: pending,
          builder: (c, s) {
            if (s.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${s.error}'),
                    button('Tentar novamente', refresh),
                  ],
                ),
              );
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final iso = at.toIso8601String().substring(0, 10);
            final rows = List<JsonMap>.from(s.data)
                .where(
                  (r) =>
                      all ||
                      (r['valid_from'].compareTo(iso) <= 0 &&
                          r['valid_to'].compareTo(iso) >= 0),
                )
                .toList();
            return Column(
              children: [
                if (widget.configure &&
                    rows.isNotEmpty &&
                    rows.every((r) => r['component'] != null))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => shareSchedule(rows),
                      child: const Text('Aplicar a outras turmas'),
                    ),
                  ),
                Expanded(child: grid(rows)),
              ],
            );
          },
        ),
      ),
    ],
  );
}

class _SlotForm extends StatefulWidget {
  final Api api;
  final JsonMap group;
  final List<JsonMap> journals;
  final JsonMap? slot, preset;
  const _SlotForm({
    required this.api,
    required this.group,
    required this.journals,
    this.slot,
    this.preset,
  });
  @override
  State<_SlotForm> createState() => _SlotFormState();
}

class _SlotFormState extends State<_SlotForm> {
  late String? journal = widget.slot?['journal'];
  JsonMap get initial => widget.slot ?? widget.preset ?? {};
  late String weekday = '${initial['weekday'] ?? 1}';
  late final start = TextEditingController(
        text: initial['start_minute'] == null
            ? ''
            : clockTime(initial['start_minute']),
      ),
      end = TextEditingController(
        text: initial['end_minute'] == null
            ? ''
            : clockTime(initial['end_minute']),
      ),
      from = TextEditingController(text: initial['valid_from'] ?? ''),
      to = TextEditingController(text: initial['valid_to'] ?? ''),
      room = TextEditingController(text: widget.slot?['room'] ?? '');
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in [start, end, from, to, room]) {
      c.dispose();
    }
    super.dispose();
  }

  int minutes(String value) {
    if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
      throw Exception('Informe os horários no formato HH:MM.');
    }
    final p = value.split(':').map(int.parse).toList();
    if (p[0] > 23 || p[1] > 59) throw Exception('Horário inválido.');
    return p[0] * 60 + p[1];
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.api.send(
        widget.slot == null ? 'POST' : 'PATCH',
        widget.slot == null ? 'schedule' : 'schedule/${widget.slot!['id']}',
        {
          'journal': journal,
          'weekday': int.parse(weekday),
          'start_minute': minutes(start.text.trim()),
          'end_minute': minutes(end.text.trim()),
          'valid_from': from.text.trim(),
          'valid_to': to.text.trim(),
          'room': room.text,
          if (widget.slot != null) 'revision': widget.slot!['revision'],
        },
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(widget.slot == null ? 'Adicionar horário' : 'Editar horário'),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            selector('Diário / componente', journal, [
              for (final j in widget.journals)
                DropdownMenuItem(
                  value: j['id'] as String,
                  child: Text(
                    '${j['subject']} · ${j['phase'] ?? ''} · ${j['teacher_name']}',
                  ),
                ),
            ], (v) => setState(() => journal = v!)),
            if (journal != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: saving
                      ? null
                      : () async {
                          try {
                            final info = await Future.wait([
                              widget.api.get('journals/$journal'),
                              widget.api.get('teachers'),
                            ]);
                            if (!c.mounted) return;
                            await openEditor<bool>(
                              c,
                              TeacherAssignments(
                                api: widget.api,
                                journal: JsonMap.from(info[0]),
                                teachers: List<JsonMap>.from(info[1]),
                                year: widget.group['school_year'],
                              ),
                            );
                          } catch (e) {
                            if (mounted) setState(() => error = '$e');
                          }
                        },
                  icon: const Icon(FLucideIcons.users, size: 16),
                  label: const Text('Atribuir docentes'),
                ),
              ),
            selector('Dia da semana', weekday, [
              for (var i = 1; i <= 7; i++)
                DropdownMenuItem(value: '$i', child: Text(weekDays[i - 1])),
            ], (v) => setState(() => weekday = v!)),
            field(
              'Início (HH:MM)',
              start,
              tip: 'Horário local da instituição. Exemplo: 07:15.',
            ),
            field(
              'Término (HH:MM)',
              end,
              tip: 'Exemplo: 08:00. Intervalos não precisam ser cadastrados como disciplina.',
            ),
            field(
              'Vigência inicial (AAAA-MM-DD)',
              from,
              kind: FieldKind.isoDate,
              tip: 'Primeira data em que este horário se aplica.',
            ),
            field(
              'Vigência final (AAAA-MM-DD)',
              to,
              kind: FieldKind.isoDate,
              tip: 'Última data desta fase ou organização de horários. Não substitui vigências anteriores.',
            ),
            field(
              'Sala / ambiente',
              room,
              tip: 'Use um identificador consistente. Sala vazia não participa da verificação de conflito.',
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
      if (widget.slot != null)
        TextButton(
          onPressed: saving
              ? null
              : () async {
                  if (!await confirm(c, 'Excluir este horário?') ||
                      !c.mounted) {
                    return;
                  }
                  try {
                    await widget.api.send(
                      'POST',
                      'schedule/${widget.slot!['id']}/delete',
                      {'revision': widget.slot!['revision']},
                    );
                    if (c.mounted) Navigator.pop(c, true);
                  } catch (e) {
                    if (mounted) setState(() => error = '$e');
                  }
                },
          child: const Text('Excluir'),
        ),
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(c),
        child: const Text('Cancelar'),
      ),
      button(
        'Salvar horário',
        saving || journal == null ? null : save,
        primary: true,
        loading: saving,
      ),
    ],
  );
}

class PeriodModelEditor extends StatefulWidget {
  final Api api;
  const PeriodModelEditor({super.key, required this.api});
  @override
  State<PeriodModelEditor> createState() => _PeriodModelEditorState();
}

class _PeriodModelEditorState extends State<PeriodModelEditor> {
  final name = TextEditingController(),
      from = TextEditingController(),
      to = TextEditingController(),
      times = TextEditingController();
  String? error;
  bool busy = false;
  @override
  void dispose() {
    for (final c in [name, from, to, times]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final periods = <JsonMap>[];
      for (final line
          in times.text.split('\n').where((v) => v.trim().isNotEmpty)) {
        final match = RegExp(
          r'^(\d{2}):(\d{2})\s*[-–]\s*(\d{2}):(\d{2})\s*(.*)$',
        ).firstMatch(line.trim());
        if (match == null ||
            int.parse(match[2]!) > 59 ||
            int.parse(match[4]!) > 59) {
          throw const FormatException(
            'Use um intervalo por linha, como 07:00–07:45.',
          );
        }
        periods.add({
          'start_minute': int.parse(match[1]!) * 60 + int.parse(match[2]!),
          'end_minute': int.parse(match[3]!) * 60 + int.parse(match[4]!),
          'label': match[5]!.isEmpty ? 'Aula ${periods.length + 1}' : match[5],
        });
      }
      final result = await widget.api.send('POST', 'period-models', {
        'name': name.text,
        'valid_from': from.text,
        'valid_to': to.text,
        'periods': periods,
      });
      if (mounted) Navigator.pop(context, JsonMap.from(result));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext c) => EditorPage(
    title: 'Modelo de períodos',
    body: ListView(
      children: [
        field('Nome', name),
        FormColumns(
          children: [
            field('Vigência inicial', from, kind: FieldKind.isoDate),
            field('Vigência final', to, kind: FieldKind.isoDate),
          ],
        ),
        field(
          'Períodos',
          times,
          lines: 8,
          hint: '07:00–07:45 Primeira aula',
          tip: 'Informe um intervalo por linha. Use o formato HH:MM–HH:MM. O nome é opcional.',
        ),
        if (error != null)
          Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
      ],
    ),
    actions: [
      button('Salvar modelo', busy ? null : save, loading: busy, primary: true),
    ],
  );
}
