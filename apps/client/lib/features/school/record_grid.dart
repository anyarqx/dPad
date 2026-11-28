import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

/// Each column is an existing lesson or assessment. Missing roster entries stay read-only.
class RecordGrid extends StatefulWidget {
  final Api api;
  final JsonMap journal;
  final List<JsonMap> records;
  final bool grades;
  const RecordGrid({
    super.key,
    required this.api,
    required this.journal,
    required this.records,
    this.grades = false,
  });
  @override
  State<RecordGrid> createState() => _RecordGridState();
}

class _RecordGridState extends State<RecordGrid> {
  final changes = <String, Map<String, JsonMap>>{};
  late final records = widget.records.toList();
  String? period;
  String? error;
  bool saving = false;
  String get dateKey => widget.grades ? 'held_on' : 'date';
  String get rowsKey => widget.grades ? 'grades' : 'attendance';

  Future<void> save() async {
    if (changes.values.any(
      (rows) => rows.values.any(
        (row) => widget.grades
            ? row['status'] == 'Lançada' && row['score'] == null
            : row['absences'] == null,
      ),
    )) {
      setState(
        () => error = widget.grades
            ? 'Confira as notas digitadas.'
            : 'Digite uma quantidade de faltas em cada célula alterada.',
      );
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.api.send(
        'POST',
        "journals/${widget.journal['id']}/${widget.grades ? 'grades' : 'attendance'}",
        {
          (widget.grades ? 'assessments' : 'lessons'): [
            for (final r in records.where((r) => changes.containsKey(r['id'])))
              {
                'id': r['id'],
                'revision': r['revision'],
                'cells': changes[r['id']]!.values.toList(),
              },
          ],
        },
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Widget cell(JsonMap record, JsonMap? row) {
    if (row == null) return const Text('—');
    final changesForRecord = changes[record['id']];
    final value = changesForRecord?[row['enrollment']] ?? row;
    final editable =
        widget.journal['canEdit'] == true &&
        record['state'] == 'Rascunho' &&
        !saving &&
        (widget.grades || row['status'] != 'Justificada');
    final initial = widget.grades
        ? value['status'] == 'Lançada'
              ? '${value['score']}'
              : value['status'] == 'Pendente'
              ? ''
              : value['status'] as String
        : '${value['absences'] ?? ''}';
    if (!editable) return Text(initial.isEmpty ? 'Pendente' : initial);
    return SizedBox(
      width: 94,
      child: TextFormField(
        key: ValueKey('${record['id']}:${row['enrollment']}'),
        initialValue: initial,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 7,
          ),
          hintText: widget.grades ? 'Nota' : 'Faltas',
        ),
        onChanged: (input) {
          final parsed = double.tryParse(input.trim().replaceAll(',', '.'));
          final entry = <String, dynamic>{'enrollment': row['enrollment']};
          if (widget.grades) {
            entry['score'] = parsed;
            entry['status'] = input.trim().isEmpty ? 'Pendente' : 'Lançada';
          } else {
            entry['absences'] = int.tryParse(input);
            entry['status'] = entry['absences'] == 0 ? 'Presente' : 'Ausente';
          }
          setState(
            () =>
                changes.putIfAbsent(record['id'], () => {})[row['enrollment']] =
                    entry,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    final periods =
        records
            .map((r) => (r[dateKey] as String).substring(0, 7))
            .toSet()
            .toList()
          ..sort();
    final current = period ?? periods.lastOrNull;
    final columns = records
        .where((r) => (r[dateKey] as String).startsWith(current ?? ''))
        .toList();
    final labels = <String, String>{};
    final entries = <String, Map<String, JsonMap>>{};
    for (final r in columns) {
      final byEnrollment = <String, JsonMap>{};
      for (final row in List<JsonMap>.from(r[rowsKey])) {
        labels[row['enrollment']] = row['student_name'];
        byEnrollment[row['enrollment']] = row;
      }
      entries[r['id']] = byEnrollment;
    }
    final ids = labels.keys.toList()
      ..sort((a, b) => labels[a]!.compareTo(labels[b]!));
    return EditorPage(
      title: widget.grades ? 'Grade de notas' : 'Frequência mensal',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.journal['subject'],
                  style: Theme.of(c).textTheme.titleMedium,
                ),
              ),
              DropdownButton<String>(
                value: current,
                items: [
                  for (final p in periods)
                    DropdownMenuItem(
                      value: p,
                      child: Text('${p.substring(5)}/${p.substring(0, 4)}'),
                    ),
                ],
                onChanged: (v) => setState(() => period = v),
              ),
            ],
          ),
          if (!widget.grades)
            const Text('Digite a quantidade de faltas. 0 indica presença.'),
          if (error != null)
            Text(
              error!,
              style: TextStyle(color: Theme.of(c).colorScheme.error),
            ),
          Expanded(
            child: records.isEmpty
                ? const Center(child: Text('Nenhum registro neste diário.'))
                : SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 16,
                        dataRowMinHeight: 42,
                        dataRowMaxHeight: 56,
                        columns: [
                          const DataColumn(label: Text('Aluno')),
                          for (final r in columns)
                            DataColumn(
                              label: Tooltip(
                                message: r['state'],
                                child: Text(
                                  widget.grades
                                      ? r['label']
                                      : '${DateFormat('dd/MM').format(DateTime.parse(r['date']))}\n${r['units']} aula(s)',
                                ),
                              ),
                            ),
                        ],
                        rows: [
                          for (final id in ids)
                            DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 175,
                                    child: Text(
                                      labels[id]!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                for (final r in columns)
                                  DataCell(cell(r, entries[r['id']]?[id])),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      actions: [
        button(
          'Salvar alterações',
          saving || changes.isEmpty ? null : save,
          loading: saving,
          primary: true,
        ),
      ],
    );
  }
}
