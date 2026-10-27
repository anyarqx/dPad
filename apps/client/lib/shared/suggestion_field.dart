import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import 'widgets.dart';
import 'search_picker.dart';

class SuggestionField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> suggestions;
  const SuggestionField({
    super.key,
    required this.label,
    required this.controller,
    required this.suggestions,
  });
  @override
  Widget build(BuildContext c) => field(
    label,
    controller,
    trailing: suggestions.isEmpty
        ? null
        : IconButton(
            tooltip: 'Selecionar ${label.toLowerCase()}',
            icon: const Icon(FLucideIcons.listFilter, size: 18),
            onPressed: () async {
              final value = await pickChoice(
                c,
                title: label,
                selected: controller.text,
                choices: [
                  for (final value in suggestions.toSet())
                    SearchChoice(value, value),
                ],
                allowCustom: true,
              );
              if (value != null) controller.text = value;
            },
          ),
  );
}
