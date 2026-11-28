import 'package:material_ui/material_ui.dart';

import '../../shared/api.dart';
import '../../shared/folders.dart';
import '../../shared/record_selection.dart';
import '../../shared/search_picker.dart';
import '../../shared/widgets.dart';

class DocumentSelection extends StatelessWidget {
  final Api api;
  final RecordSelection selection;
  final List<JsonMap> documents, folders;
  final VoidCallback changed;
  final bool review;
  const DocumentSelection({
    super.key,
    required this.api,
    required this.selection,
    required this.documents,
    required this.folders,
    required this.changed,
    required this.review,
  });

  Future<void> apply(BuildContext c, String action) async {
    final items = documents
        .where((d) => selection.ids.contains(d['id']))
        .toList();
    if (items.isEmpty) return;
    final fields = <String, dynamic>{};
    try {
      switch (action) {
        case 'move':
          final folder = await pickChoice(
            c,
            title: 'Mover documentos',
            choices: [
              for (final f in folders)
                SearchChoice(
                  f['id'],
                  folderLocation(f['id'], folders),
                  description: f['area_name'] ?? '',
                ),
            ],
          );
          if (folder == null) return;
          fields['folder'] = folder;
        case 'attach':
          final requests = List<JsonMap>.from(await api.get('requests'));
          if (!c.mounted) return;
          final id = await pickChoice(
            c,
            title: 'Associar a solicitação',
            choices: [
              for (final r in requests.where((r) => r['state'] != 'Concluída'))
                SearchChoice(r['id'], r['subject'], description: r['protocol']),
            ],
          );
          if (id == null) return;
          fields['request'] = id;
        case 'review':
          fields['status'] = 'Conferido';
        case 'delete':
          if (!await confirm(c, 'Excluir ${items.length} documento(s)?')) {
            return;
          }
      }
      await api.send('POST', 'bulk', {
        'resource': 'documents',
        'action': action,
        'items': [
          for (final d in items) {'id': d['id'], 'revision': d['revision']},
        ],
        'fields': fields,
        if (action == 'delete') 'confirmation': 'EXCLUIR',
      });
      if (c.mounted) {
        selection.clear();
        changed();
        feedback(c, '${items.length} documento(s) atualizado(s).');
      }
    } catch (e) {
      if (c.mounted) feedbackError(c, e);
    }
  }

  @override
  Widget build(BuildContext c) => SelectionToolbar(
    selection: selection,
    order: [for (final d in documents) d['id']],
    actions: [
      TextButton(onPressed: () => apply(c, 'move'), child: const Text('Mover')),
      TextButton(
        onPressed: () => apply(c, 'attach'),
        child: const Text('Associar'),
      ),
      if (review)
        TextButton(
          onPressed: () => apply(c, 'review'),
          child: const Text('Conferir'),
        ),
      TextButton(
        onPressed: () => apply(c, 'delete'),
        child: const Text('Excluir'),
      ),
    ],
  );
}
