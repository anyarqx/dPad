import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import '../viewer.dart';
import 'academic_forms.dart';

class ReportPanel extends StatefulWidget {
  final Api api;
  final JsonMap student, user;
  final bool review;
  final String? group;
  const ReportPanel({
    super.key,
    required this.api,
    required this.user,
    this.student = const {},
    this.review = false,
    this.group,
  });
  @override
  State<ReportPanel> createState() => _ReportPanelState();
}

class _ReportPanelState extends State<ReportPanel> {
  late Future<dynamic> pending;
  String tab = 'Notas';
  bool working = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    pending = widget.review
        ? widget.api.get('justifications?class=${widget.group}')
        : Future.wait([
            widget.api.get('students/${widget.student['id']}/report'),
            widget.api.get('justifications?student=${widget.student['id']}'),
          ]);
  }

  void refresh() {
    if (mounted) setState(load);
  }

  @override
  void didUpdateWidget(covariant ReportPanel old) {
    super.didUpdateWidget(old);
    if (old.student['id'] != widget.student['id'] ||
        old.group != widget.group) {
      load();
    }
  }

  Future<void> pdf() async {
    setState(() => working = true);
    try {
      final bytes = await widget.api.download(
        'students/${widget.student['id']}/report.pdf',
      );
      if (mounted) {
        await preview(
          context,
          bytes,
          'Boletim - ${widget.student['name']}.pdf',
        );
      }
    } catch (e) {
      if (mounted) feedback(context, e);
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> justify(JsonMap attendance, List<JsonMap> existing) async {
    if (existing.any(
      (x) =>
          x['lesson'] == attendance['lesson'] &&
          x['enrollment'] == attendance['enrollment'],
    )) {
      feedback(
        context,
        'Esta falta já possui uma justificativa. Consulte a aba Justificativas.',
      );
      return;
    }
    final docs = List<JsonMap>.from(widget.student['documents'] ?? []);
    if (await academicEditor(
      context,
      widget.api,
      title: 'Justificar falta · ${attendance['date']}',
      path: 'justifications',
      fixed: {
        'lesson': attendance['lesson'],
        'enrollment': attendance['enrollment'],
      },
      fields: [
        const AcademicField(
          'reason',
          'Motivo da falta *',
          lines: 4,
          tip: 'Explique o período e o motivo. A coordenação analisará o pedido; justificar não abona a falta.',
        ),
        if (docs.isNotEmpty)
          AcademicField(
            'document',
            'Comprovante (opcional)',
            options: {
              '': 'Sem comprovante',
              for (final d in docs) d['id']: d['name'],
            },
            tip: 'Para anexar um novo comprovante, importe-o antes na aba Documentos.',
          ),
      ],
    )) {
      refresh();
    }
  }

  Future<void> review(JsonMap item) async {
    if (await academicEditor(
      context,
      widget.api,
      title: 'Analisar justificativa · ${item['student_name']}',
      path: 'justifications/${item['id']}/review',
      initial: item,
      fixed: {'revision': item['revision']},
      fields: const [
        AcademicField(
          'state',
          'Resultado',
          options: {
            'Deferida': 'Deferir justificativa',
            'Indeferida': 'Indeferir justificativa',
          },
          tip: 'O deferimento registra a falta como justificada, sem transformá-la em presença.',
        ),
        AcademicField(
          'response',
          'Resposta ao solicitante *',
          lines: 3,
          tip: 'Registre o fundamento da decisão e orientações necessárias.',
        ),
      ],
    )) {
      refresh();
    }
  }

  Widget justificationList(List<JsonMap> list) => list.isEmpty
      ? const Center(child: Text('Nenhuma justificativa enviada.'))
      : ListView(
          children: [
            for (final x in list) ...[
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(
                  '${x['student_name']} · ${x['subject']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${x['date']} · ${x['units']} aula(s)',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: badge(x['state']),
                children: [
                  ListTile(
                    title: Text(x['reason']),
                    subtitle: Text(
                      'Enviada por ${x['requester_name']} · ${date(x['created'])}',
                    ),
                  ),
                  if (x['document_name'] != null)
                    ListTile(
                      leading: const Icon(FLucideIcons.paperclip, size: 18),
                      title: Text(x['document_name']),
                      onTap: () async {
                        try {
                          final bytes = await widget.api.bytes(x['document']);
                          if (mounted) {
                            await preview(
                              context,
                              bytes,
                              x['document_name'],
                              pdf:
                                  bytes.length > 4 &&
                                  String.fromCharCodes(bytes.take(4)) == '%PDF',
                            );
                          }
                        } catch (e) {
                          if (mounted) feedback(context, e);
                        }
                      },
                    ),
                  if (x['response'] != '')
                    ListTile(
                      title: Text(x['response']),
                      subtitle: Text('Resposta · ${date(x['updated'])}'),
                    ),
                  if (widget.review && x['state'] == 'Recebida')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: button(
                        'Analisar justificativa',
                        () => review(x),
                        primary: true,
                      ),
                    ),
                ],
              ),
              const PixelDivider(),
            ],
          ],
        );
  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (widget.review)
        sectionHeading(
          'Justificativas de faltas',
          description: 'Pedidos enviados pelos alunos e responsáveis da turma. A decisão permanece vinculada à falta.',
        ),
      if (!widget.review)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in ['Notas', 'Frequência', 'Justificativas'])
              ChoiceChip(
                label: Text(t),
                selected: tab == t,
                onSelected: (_) => setState(() => tab = t),
              ),
            button(
              'Exportar boletim PDF',
              working ? null : pdf,
              icon: FLucideIcons.fileDown,
            ),
          ],
        ),
      const SizedBox(height: 12),
      loadingLine(working),
      const SizedBox(height: 12),
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
            if (widget.review) {
              return justificationList(List<JsonMap>.from(s.data));
            }
            final result = s.data as List,
                report = JsonMap.from(result[0]),
                justifications = List<JsonMap>.from(result[1]);
            if (tab == 'Justificativas') {
              return justificationList(justifications);
            }
            final rows = List<JsonMap>.from(
              report[tab == 'Notas' ? 'grades' : 'attendance'],
            );
            if (rows.isEmpty) {
              return Center(
                child: Text(
                  tab == 'Notas'
                      ? 'Nenhuma nota publicada. As avaliações aparecem após a conferência da coordenação.'
                      : 'Nenhuma aula publicada para este aluno.',
                ),
              );
            }
            if (tab == 'Frequência') {
              return ListView(
                children: [
                  sectionHeading(
                    'Frequência publicada',
                    description: 'Cada registro informa a quantidade de horas-aula. Falta justificada continua registrada; não equivale a presença.',
                  ),
                  for (final a in rows) ...[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(
                        a['subject'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${a['date']} · ${a['class_name']} · ${a['units']} aula(s)',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: badge(a['status']),
                    ),
                    if (a['status'] == 'Ausente' &&
                        !justifications.any(
                          (x) =>
                              x['lesson'] == a['lesson'] &&
                              x['enrollment'] == a['enrollment'],
                        ))
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => justify(a, justifications),
                          child: const Text('Justificar falta'),
                        ),
                      ),
                    const PixelDivider(),
                  ],
                ],
              );
            }
            return ListView(
              children: [
                sectionHeading(
                  'Notas publicadas',
                  description: report['calculation'],
                ),
                for (final summary in List<JsonMap>.from(
                  report['summaries'],
                )) ...[
                  Builder(
                    builder: (c) {
                      final group = List<JsonMap>.from(summary['items']),
                          g = group.first;
                      final missing = summary['missing_count'] as int;
                      final average = summary['average'] as num?;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: FTheme.of(c).colors.card,
                          border: Border.all(color: FTheme.of(c).colors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${g['subject']} · ${g['stage']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${g['school_year']} · ${g['class_name']} · ${g['phase'] ?? ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: FTheme.of(c).colors.mutedForeground,
                              ),
                            ),
                            for (final a in group)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(a['label']),
                                subtitle: Text(
                                  '${a['held_on']} · peso ${a['weight']}${a['note'] == '' ? '' : ' · ${a['note']}'}',
                                ),
                                trailing: Text(
                                  a['score'] == null
                                      ? a['status']
                                      : '${a['score']} / ${a['max_score']}',
                                ),
                              ),
                            const PixelDivider(),
                            const SizedBox(height: 10),
                            Text(
                              average == null
                                  ? 'Sem nota numérica publicada'
                                  : 'Média ${missing > 0 ? 'parcial' : 'de acompanhamento'}: ${average.toStringAsFixed(2)} / 10',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: FTheme.of(c).colors.primary,
                              ),
                            ),
                            if (missing > 0)
                              Text(
                                '$missing avaliação(ões) sem nota numérica. A média está incompleta.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.6,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    ],
  );
}
