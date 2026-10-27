import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import 'field_help.dart';

String normalizeSearch(String value) {
  var text = value.toLowerCase().trim();
  const groups = {
    'a': 'áàâãä',
    'e': 'éèêë',
    'i': 'íìîï',
    'o': 'óòôõö',
    'u': 'úùûü',
    'c': 'ç',
  };
  for (final entry in groups.entries) {
    text = text.replaceAll(RegExp('[${entry.value}]'), entry.key);
  }
  return text;
}

class SearchChoice {
  final String value, label, description;
  late final String searchable = normalizeSearch('$label $description');
  SearchChoice(this.value, this.label, {this.description = ''});
}

Future<String?> pickChoice(
  BuildContext context, {
  required String title,
  required List<SearchChoice> choices,
  String? selected,
  String? hint,
  bool allowCustom = false,
}) => showDialog<String>(
  context: context,
  builder: (_) => _ChoiceDialog(
    title: title,
    choices: choices,
    selected: selected,
    hint: hint,
    allowCustom: allowCustom,
  ),
);

class SearchPicker extends StatelessWidget {
  final String label;
  final String? value, tip, hint;
  final List<SearchChoice> choices;
  final ValueChanged<String> onChanged;
  final bool enabled;
  const SearchPicker({
    super.key,
    required this.label,
    required this.value,
    required this.choices,
    required this.onChanged,
    this.tip,
    this.hint,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext c) {
    final selected = choices.where((o) => o.value == value).firstOrNull;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        key: ValueKey('picker:$label'),
        borderRadius: BorderRadius.circular(6),
        onTap: !enabled
            ? null
            : () async {
                final result = await pickChoice(
                  c,
                  title: label,
                  choices: choices,
                  selected: value,
                  hint: hint,
                );
                if (result != null) onChanged(result);
              },
        child: InputDecorator(
          isEmpty: value == null || value == '',
          decoration: InputDecoration(
            label: fieldLabel(label, tip),
            enabled: enabled,
            suffixIcon: const Icon(FLucideIcons.search, size: 18),
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            selected?.label ??
                (value?.isNotEmpty == true ? value! : hint ?? 'Selecionar'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(c).textTheme.bodyMedium!.copyWith(
              color: value?.isNotEmpty == true
                  ? FTheme.of(c).colors.foreground
                  : FTheme.of(c).colors.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceDialog extends StatefulWidget {
  final String title;
  final List<SearchChoice> choices;
  final String? selected, hint;
  final bool allowCustom;
  const _ChoiceDialog({
    required this.title,
    required this.choices,
    this.selected,
    this.hint,
    required this.allowCustom,
  });
  @override
  State<_ChoiceDialog> createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<_ChoiceDialog> {
  final query = TextEditingController();
  String text = '';
  List<SearchChoice> get results {
    final terms = normalizeSearch(text)
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    return widget.choices
        .where((o) => terms.every(o.searchable.contains))
        .toList();
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final all = results, shown = all.take(80).toList();
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 560,
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FTextField(
              key: const ValueKey('picker-query'),
              autofocus: true,
              hint: widget.hint ?? 'Digite para buscar',
              prefixBuilder: (c, s, v) => const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(FLucideIcons.search, size: 17),
              ),
              control: FTextFieldControl.managed(
                controller: query,
                onChange: (v) => setState(() => text = v.text),
              ),
              onSubmit: (_) {
                if (shown.isNotEmpty) {
                  Navigator.pop(c, shown.first.value);
                } else if (widget.allowCustom && text.trim().isNotEmpty) {
                  Navigator.pop(c, text.trim());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                all.length > shown.length
                    ? '${all.length} opções; refine a busca para localizar.'
                    : '${all.length} opção(ões)',
                style: Theme.of(c).textTheme.bodySmall,
              ),
            ),
            Expanded(
              child: shown.isEmpty
                  ? const Center(
                      child: Text('Nenhum resultado. Confira a busca.'),
                    )
                  : ListView.builder(
                      itemCount: shown.length,
                      itemExtent: 62,
                      itemBuilder: (c, i) {
                        final option = shown[i];
                        return ListTile(
                          dense: true,
                          title: Text(
                            option.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: option.description.isEmpty
                              ? null
                              : Text(
                                  option.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          trailing: option.value == widget.selected
                              ? const Icon(FLucideIcons.check, size: 18)
                              : null,
                          onTap: () => Navigator.pop(c, option.value),
                        );
                      },
                    ),
            ),
            if (widget.allowCustom &&
                text.trim().isNotEmpty &&
                !widget.choices.any(
                  (o) => normalizeSearch(o.value) == normalizeSearch(text),
                ))
              TextButton.icon(
                onPressed: () => Navigator.pop(c, text.trim()),
                icon: const Icon(FLucideIcons.plus, size: 16),
                label: Text('Usar “${text.trim()}”'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
