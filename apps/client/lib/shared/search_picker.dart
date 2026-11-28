import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import 'field_help.dart';
import 'record_selection.dart';

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
    final text =
        selected?.label ??
        (value?.isNotEmpty == true ? value! : hint ?? 'Selecionar');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          fieldLabel(label, tip),
          const SizedBox(height: 4),
          Semantics(
            label: label,
            value: text,
            button: true,
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
                decoration: InputDecoration(
                  enabled: enabled,
                  suffixIcon: const Icon(FLucideIcons.search, size: 18),
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  text,
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
          ),
        ],
      ),
    );
  }
}

class _ChoiceDialog extends StatefulWidget {
  final String title;
  final List<SearchChoice> choices;
  final String? selected, hint;
  final bool allowCustom, multiple;
  final Set<String> initial;
  final int maximum;
  const _ChoiceDialog({
    required this.title,
    required this.choices,
    this.selected,
    this.hint,
    required this.allowCustom,
    this.multiple = false,
    this.initial = const {},
    this.maximum = 200,
  });
  @override
  State<_ChoiceDialog> createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<_ChoiceDialog> {
  final query = TextEditingController();
  final selection = RecordSelection();
  @override
  void initState() {
    super.initState();
    selection.ids.addAll(widget.initial);
    selection.addListener(changed);
  }

  void changed() {
    if (mounted) setState(() {});
  }

  void choose(SearchChoice option) {
    if (widget.multiple) {
      selection.toggle(option.value, results.map((o) => o.value).toList());
    } else {
      Navigator.pop(context, option.value);
    }
  }

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
    selection.dispose();
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final shown = results;
    final preferredHeight = (144.0 + widget.choices.length * 48).clamp(
      230.0,
      560.0,
    );
    final height =
        (MediaQuery.sizeOf(c).height - MediaQuery.viewInsetsOf(c).bottom - 32)
            .clamp(180.0, preferredHeight);
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: SizedBox(
        width: widget.multiple ? 480 : 440,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(c).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    onPressed: () => Navigator.pop(c),
                    icon: const Icon(FLucideIcons.x, size: 18),
                  ),
                ],
              ),
              FTextField(
                key: const ValueKey('picker-query'),
                autofocus: MediaQuery.sizeOf(c).width >= 600,
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
                  if (shown.length == 1 && !widget.multiple) {
                    choose(shown.first);
                  } else if (shown.isEmpty &&
                      widget.allowCustom &&
                      text.trim().isNotEmpty) {
                    Navigator.pop(c, text.trim());
                  }
                },
              ),
              const SizedBox(height: 6),
              Expanded(
                child: shown.isEmpty
                    ? const Center(
                        child: Text('Nenhum resultado. Confira a busca.'),
                      )
                    : ListView.builder(
                        itemCount: shown.length,

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
                            leading: widget.multiple
                                ? Checkbox(
                                    value: selection.ids.contains(option.value),
                                    onChanged: (_) => choose(option),
                                  )
                                : null,
                            trailing:
                                !widget.multiple &&
                                    option.value == widget.selected
                                ? const Icon(FLucideIcons.check, size: 18)
                                : null,
                            onTap: () => choose(option),
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
              if (widget.multiple)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selection.ids.length > widget.maximum
                            ? 'Selecione até ${widget.maximum}.'
                            : '${selection.ids.length} selecionado(s)',
                      ),
                    ),
                    TextButton(
                      onPressed: selection.clear,
                      child: const Text('Limpar'),
                    ),
                    FilledButton(
                      onPressed: selection.ids.length > widget.maximum
                          ? null
                          : () =>
                                Navigator.pop(c, Set<String>.of(selection.ids)),
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Set<String>?> pickMany(
  BuildContext context, {
  required String title,
  required List<SearchChoice> choices,
  Set<String> selected = const {},
  int maximum = 200,
}) => showDialog<Set<String>>(
  context: context,
  builder: (_) => _ChoiceDialog(
    title: title,
    choices: choices,
    allowCustom: false,
    multiple: true,
    initial: selected,
    maximum: maximum,
  ),
);
