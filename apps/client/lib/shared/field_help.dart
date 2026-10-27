import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

Widget fieldLabel(String label, String? help) => Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Flexible(child: Text(label)),
    if (help != null && help.isNotEmpty) ...[
      const SizedBox(width: 4),
      FieldHelp(label: label, message: help),
    ],
  ],
);

class FieldHelp extends StatefulWidget {
  final String label, message;
  const FieldHelp({super.key, required this.label, required this.message});
  @override
  State<FieldHelp> createState() => _FieldHelpState();
}

class _FieldHelpState extends State<FieldHelp> {
  final tooltip = GlobalKey<TooltipState>();
  @override
  Widget build(BuildContext context) => Tooltip(
    key: tooltip,
    message: widget.message,
    preferBelow: true,
    constraints: const BoxConstraints(maxWidth: 320),
    waitDuration: const Duration(milliseconds: 400),
    showDuration: const Duration(seconds: 8),
    child: IconButton(
      key: ValueKey('help:${widget.label}'),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 26, height: 26),
      visualDensity: VisualDensity.compact,
      onPressed: () => tooltip.currentState?.ensureTooltipVisible(),
      icon: Icon(
        FLucideIcons.info,
        semanticLabel: 'Ajuda sobre ${widget.label}',
        size: 15,
        color: FTheme.of(context).colors.mutedForeground,
      ),
      tooltip: null,
      style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    ),
  );
}
