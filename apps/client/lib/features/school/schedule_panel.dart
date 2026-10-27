import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

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
  @override
  void initState() {
    super.initState();
    load();
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

  Future<void> edit([JsonMap? old]) async {
    try {
      final journals = List<JsonMap>.from(
        await widget.api.get('classes/${widget.group['id']}/journals'),
      );
      if (!mounted) return;
      if (journals.isEmpty) {
        feedback(
          context,
          'Configure um diário com componente e professor antes de adicionar o horário.',
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
            ),
          ) ==
          true) {
        refresh();
      }
    } catch (e) {
      if (mounted) feedback(context, e);
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
      if (mounted) feedback(context, e);
    }
  }

  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Horário semanal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (widget.configure)
            button(
              'Adicionar horário',
              () => edit(),
              icon: FLucideIcons.plus,
              primary: true,
            ),
          button(
            'Vigência: ${at.day.toString().padLeft(2, '0')}/${at.month.toString().padLeft(2, '0')}/${at.year}',
            () async {
              final picked = await showDatePicker(
                context: c,
                initialDate: at,
                firstDate: DateTime(widget.group['school_year'], 1, 1),
                lastDate: DateTime(widget.group['school_year'], 12, 31),
              );
              if (picked != null) setState(() => at = picked);
            },
            icon: FLucideIcons.calendarDays,
          ),
          FilterChip(
            label: const Text('Todas as vigências'),
            selected: all,
            onSelected: (v) => setState(() => all = v),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Text(
        'Horários vinculados ao componente, à fase e ao docente. O servidor verifica conflitos de turma, professor e sala.',
        style: TextStyle(
          fontSize: 12,
          height: 1.5,
          color: FTheme.of(c).colors.mutedForeground,
        ),
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
            if (rows.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum horário nesta vigência. Altere a data ou adicione os horários da turma.',
                ),
              );
            }
            return ListView(
              children: [
                for (var day = 1; day <= 7; day++)
                  if (rows.any((r) => r['weekday'] == day))
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: day.isEven
                            ? FTheme.of(c).colors.muted
                            : FTheme.of(c).colors.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              weekDays[day - 1],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: FTheme.of(c).colors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final r in rows.where(
                              (r) => r['weekday'] == day,
                            ))
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${clockTime(r['start_minute'])}–${clockTime(r['end_minute'])}  ${r['subject']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  '${r['teacher_name']} · ${r['phase'] ?? 'Fase não informada'}${r['room'] == '' ? '' : ' · ${r['room']}'}\n${r['valid_from']} a ${r['valid_to']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                                trailing: widget.configure
                                    ? PopupMenuButton<String>(
                                        tooltip: 'Opções do horário',
                                        onSelected: (v) =>
                                            v == 'edit' ? edit(r) : remove(r),
                                        itemBuilder: (_) => const [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Editar'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Excluir'),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                          ],
                        ),
                      ),
                    ),
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
  final JsonMap? slot;
  const _SlotForm({
    required this.api,
    required this.group,
    required this.journals,
    this.slot,
  });
  @override
  State<_SlotForm> createState() => _SlotFormState();
}

class _SlotFormState extends State<_SlotForm> {
  late String journal = widget.slot?['journal'] ?? widget.journals.first['id'],
      weekday = '${widget.slot?['weekday'] ?? 1}';
  late final start = TextEditingController(
        text: widget.slot == null
            ? ''
            : clockTime(widget.slot!['start_minute']),
      ),
      end = TextEditingController(
        text: widget.slot == null ? '' : clockTime(widget.slot!['end_minute']),
      ),
      from = TextEditingController(text: widget.slot?['valid_from'] ?? ''),
      to = TextEditingController(text: widget.slot?['valid_to'] ?? ''),
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
              tip: 'Primeira data em que este horário se aplica.',
            ),
            field(
              'Vigência final (AAAA-MM-DD)',
              to,
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
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(c),
        child: const Text('Cancelar'),
      ),
      button(
        saving ? 'Salvando…' : 'Salvar horário',
        saving ? null : save,
        primary: true,
      ),
    ],
  );
}
