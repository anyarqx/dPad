import 'package:material_ui/material_ui.dart';

Future<T?> openEditor<T>(
  BuildContext context,
  Widget child, {
  double width = 760,
}) => showDialog<T>(
  context: context,
  barrierDismissible: false,
  builder: (context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    clipBehavior: Clip.antiAlias,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width, maxHeight: 760),
      child: child,
    ),
  ),
);

class EditorPage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> actions;
  const EditorPage({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const CloseButton(),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      toolbarHeight: 48,
    ),
    resizeToAvoidBottomInset: false,
    body: SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: body,
                ),
              ),
            ),
          ),
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 8,
                  children: actions,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class FormColumns extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  const FormColumns({super.key, required this.children, this.minWidth = 280});
  @override
  Widget build(BuildContext c) => LayoutBuilder(
    builder: (c, box) {
      final columns =
          ((box.maxWidth + 12) /
                  (MediaQuery.textScalerOf(c).scale(minWidth) + 12))
              .floor()
              .clamp(1, 3);
      final width = (box.maxWidth - 12 * (columns - 1)) / columns;
      return Wrap(
        spacing: 12,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}
