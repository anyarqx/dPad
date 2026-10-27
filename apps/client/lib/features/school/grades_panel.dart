import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

class GradesPanel extends StatefulWidget {
  final Api api;
  final JsonMap journal;
  const GradesPanel({super.key, required this.api, required this.journal});
  @override
  State<GradesPanel> createState() => _GradesPanelState();
}

class _GradesPanelState extends State<GradesPanel> {
  late Future<dynamic> pending;
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    pending = widget.api.get('journals/${widget.journal['id']}/assessments');
  }

  void refresh() {
    if (mounted) setState(load);
  }

  @override
  void didUpdateWidget(covariant GradesPanel old) {
    super.didUpdateWidget(old);
    if (old.journal['id'] != widget.journal['id']) load();
  }

  Future<void> edit([JsonMap? assessment]) async {
    if (await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => GradeForm(
            api: widget.api,
            journal: widget.journal,
            assessment: assessment,
          ),
        ) ==
        true) {
      refresh();
    }
  }

  Future<void> action(JsonMap a, String action) async {
    final note = TextEditingController();
    bool proceed;
    if (action == 'return') {
      proceed =
          await showEditorDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: const Text('Devolver notas para correção'),
              content: field('Motivo da devolução', note, lines: 3),
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
        action == 'submit'
            ? 'Enviar todas as notas desta avaliação para a coordenação?'
            : 'Publicar as notas? Cada aluno e responsável verá apenas os registros a que estiver vinculado.',
      );
    }
    final text = note.text;
    note.dispose();
    if (!proceed) return;
    try {
      await widget.api.send('POST', 'assessments/${a['id']}/actions', {
        'revision': a['revision'],
        'action': action,
        'note': text,
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
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Avaliações e notas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (widget.journal['canEdit'] == true)
            button(
              'Lançar avaliação',
              () => edit(),
              icon: FLucideIcons.plus,
              primary: true,
            ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Valores, pesos e etapas definidos por avaliação. As notas entram no boletim após conferência e publicação.',
        style: TextStyle(
          fontSize: 12,
          height: 1.5,
          color: FTheme.of(c).colors.mutedForeground,
        ),
      ),
      const SizedBox(height: 14),
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
            final list = List<JsonMap>.from(s.data);
            if (list.isEmpty) {
              return const Center(
                child: Text('Nenhuma avaliação disponível neste diário.'),
              );
            }
            return ListView(
              children: [
                for (final a in list) ...[
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: Text(
                      a['label'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${a['stage']} · ${a['held_on']} · valor ${a['max_score']} · peso ${a['weight']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: badge(a['state']),
                    children: [
                      for (final g in List<JsonMap>.from(a['grades']))
                        ListTile(
                          dense: true,
                          title: Text(
                            g['student_name'],
                            style: const TextStyle(fontSize: 13),
                          ),
                          subtitle: g['note'] == '' ? null : Text(g['note']),
                          trailing: Text(
                            g['score'] == null
                                ? g['status']
                                : '${g['score']} / ${a['max_score']}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (a['canEdit'] == true &&
                                a['state'] == 'Rascunho') ...[
                              button(
                                'Editar notas',
                                () => edit(a),
                                icon: FLucideIcons.pencil,
                              ),
                              button(
                                'Enviar notas',
                                () => action(a, 'submit'),
                                primary: true,
                              ),
                            ],
                            if (a['canReview'] == true &&
                                a['state'] == 'Em revisão')
                              button(
                                'Publicar notas',
                                () => action(a, 'publish'),
                                primary: true,
                              ),
                            if (a['canReview'] == true &&
                                a['state'] != 'Rascunho')
                              button(
                                'Devolver para correção',
                                () => action(a, 'return'),
                              ),
                          ],
                        ),
                      ),
                      if (a['events'] != null)
                        for (final e in List<JsonMap>.from(a['events']))
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
                  const PixelDivider(),
                ],
              ],
            );
          },
        ),
      ),
    ],
  );
}

class GradeForm extends StatefulWidget {
  final Api api;
  final JsonMap journal;
  final JsonMap? assessment;
  const GradeForm({
    super.key,
    required this.api,
    required this.journal,
    this.assessment,
  });
  @override
  State<GradeForm> createState() => _GradeFormState();
}

class _GradeFormState extends State<GradeForm> {
  late final name = TextEditingController(text: widget.assessment?['label']),
      stage = TextEditingController(text: widget.assessment?['stage']),
      day = TextEditingController(
        text:
            widget.assessment?['held_on'] ??
            DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ),
      maximum = TextEditingController(
        text: widget.assessment?['max_score']?.toString(),
      ),
      weight = TextEditingController(
        text: widget.assessment?['weight']?.toString(),
      );
  late final rows = widget.assessment == null
      ? [
          for (final e in List<JsonMap>.from(widget.journal['roster']))
            <String, dynamic>{
              'enrollment': e['id'],
              'student_name': e['student_name'],
              'status': 'Pendente',
              'score': null,
              'note': '',
            },
        ]
      : List<JsonMap>.from(widget.assessment!['grades']);
  late final scores = {
        for (final r in rows)
          r['enrollment']: TextEditingController(text: r['score']?.toString()),
      },
      notes = {
        for (final r in rows)
          r['enrollment']: TextEditingController(text: r['note']),
      };
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in [
      name,
      stage,
      day,
      maximum,
      weight,
      ...scores.values,
      ...notes.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? decimal(String value) {
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    return parsed != null && parsed.isFinite ? parsed : null;
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final grades = <JsonMap>[];
      for (final r in rows) {
        final text = scores[r['enrollment']]!.text.trim(), status = r['status'];
        final score = status == 'Lançada' ? decimal(text) : null;
        if (status == 'Lançada' && score == null) {
          throw Exception('Informe uma nota válida para ${r['student_name']}.');
        }
        grades.add({
          'enrollment': r['enrollment'],
          'status': status,
          'score': score,
          'note': notes[r['enrollment']]!.text,
        });
      }
      await widget.api.send(
        widget.assessment == null ? 'POST' : 'PATCH',
        widget.assessment == null
            ? 'journals/${widget.journal['id']}/assessments'
            : 'assessments/${widget.assessment!['id']}',
        {
          'label': name.text,
          'stage': stage.text,
          'held_on': day.text,
          'max_score': decimal(maximum.text),
          'weight': decimal(weight.text),
          'grades': grades,
          if (widget.assessment != null)
            'revision': widget.assessment!['revision'],
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
    title: Text(
      widget.assessment == null ? 'Lançar avaliação' : 'Editar notas',
    ),
    content: SizedBox(
      width: 820,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionHeading(
              widget.journal['subject'],
              description: 'As notas são salvas juntas. Não informe zero para uma nota ainda pendente.',
            ),
            field(
              'Avaliação *',
              name,
              tip: 'Exemplo: Atividade prática de redes.',
            ),
            field(
              'Etapa avaliativa *',
              stage,
              tip: 'Nome da etapa conforme o calendário: 1º bimestre, unidade 2 ou avaliação da fase.',
            ),
            field(
              'Data da avaliação (AAAA-MM-DD)',
              day,
              tip: 'Data já ocorrida dentro do ano letivo.',
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: field(
                    'Valor máximo *',
                    maximum,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    tip: 'Exemplo: 10 ou 100.',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: field(
                    'Peso *',
                    weight,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    tip: 'Peso relativo na média. Exemplo: 1 ou 2.',
                  ),
                ),
              ],
            ),
            sectionHeading(
              'Notas por aluno',
              description: 'Ausência e dispensa são situações próprias. Dispensa exige uma observação.',
            ),
            if (rows.isEmpty)
              const Text(
                'Não há matrículas ativas. Ative as matrículas antes de lançar uma avaliação.',
              ),
            for (final r in rows)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FTheme.of(c).colors.muted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      r['student_name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: selector('Situação', r['status'], [
                            for (final status in [
                              'Pendente',
                              'Lançada',
                              'Ausente',
                              'Dispensada',
                            ])
                              DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                          ], (v) => setState(() => r['status'] = v!)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: field(
                            'Nota',
                            scores[r['enrollment']]!,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            enabled: !saving && r['status'] == 'Lançada',
                            hint: '0',
                          ),
                        ),
                      ],
                    ),
                    field(
                      'Observação da nota',
                      notes[r['enrollment']]!,
                      tip: 'Obrigatória para dispensa. Visível ao aluno e responsável.',
                    ),
                  ],
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
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(c),
        child: const Text('Cancelar'),
      ),
      button(
        saving ? 'Salvando…' : 'Salvar rascunho',
        saving || rows.isEmpty ? null : save,
        primary: true,
      ),
    ],
  );
}
