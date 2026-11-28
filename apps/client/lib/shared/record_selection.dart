import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

class RecordSelection extends ChangeNotifier {
  final ids = <String>{};
  String? anchor;
  bool get active => ids.isNotEmpty;
  void clear() {
    if (ids.isEmpty) return;
    ids.clear();
    anchor = null;
    notifyListeners();
  }

  void all(Iterable<String> values) {
    ids.addAll(values);
    notifyListeners();
  }

  void toggle(String id, List<String> order, {bool? range}) {
    if ((range ?? HardwareKeyboard.instance.isShiftPressed) &&
        anchor != null &&
        order.contains(anchor) &&
        order.contains(id)) {
      final a = order.indexOf(anchor!), b = order.indexOf(id);
      ids.addAll(order.sublist(a < b ? a : b, (a > b ? a : b) + 1));
    } else {
      ids.contains(id) ? ids.remove(id) : ids.add(id);
      anchor = id;
    }
    notifyListeners();
  }

  bool intercept(String id, List<String> order) {
    final keys = HardwareKeyboard.instance;
    if (active ||
        keys.isControlPressed ||
        keys.isMetaPressed ||
        keys.isShiftPressed) {
      toggle(id, order);
      return true;
    }
    return false;
  }
}

class SelectionScope extends StatelessWidget {
  final RecordSelection selection;
  final List<String> order;
  final WidgetBuilder builder;
  final VoidCallback? onDelete, onRename, onUp, onSearch;
  const SelectionScope({
    super.key,
    required this.selection,
    required this.order,
    required this.builder,
    this.onDelete,
    this.onRename,
    this.onUp,
    this.onSearch,
  });
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: selection,
    builder: (c, _) => Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final focus = FocusManager.instance.primaryFocus?.context;
        if (focus?.widget is EditableText ||
            focus?.findAncestorWidgetOfExactType<EditableText>() != null) {
          return KeyEventResult.ignored;
        }
        final keys = HardwareKeyboard.instance, key = event.logicalKey;
        if ((keys.isControlPressed || keys.isMetaPressed) &&
            key == LogicalKeyboardKey.keyA) {
          selection.all(order);
        } else if (key == LogicalKeyboardKey.escape && selection.active) {
          selection.clear();
        } else if (key == LogicalKeyboardKey.delete &&
            selection.active &&
            onDelete != null) {
          onDelete!();
        } else if (key == LogicalKeyboardKey.f2 &&
            selection.ids.length == 1 &&
            onRename != null) {
          onRename!();
        } else if (keys.isAltPressed &&
            key == LogicalKeyboardKey.arrowUp &&
            onUp != null) {
          onUp!();
        } else if ((keys.isControlPressed || keys.isMetaPressed) &&
            key == LogicalKeyboardKey.keyF &&
            onSearch != null) {
          onSearch!();
        } else {
          return KeyEventResult.ignored;
        }
        return KeyEventResult.handled;
      },
      child: builder(c),
    ),
  );
}

class SelectionToolbar extends StatelessWidget {
  final RecordSelection selection;
  final List<String> order;
  final List<Widget> actions;
  const SelectionToolbar({
    super.key,
    required this.selection,
    required this.order,
    this.actions = const [],
  });
  @override
  Widget build(BuildContext c) => ListenableBuilder(
    listenable: selection,
    builder: (c, _) => SizedBox(
      height: 44,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Checkbox(
              value: order.isNotEmpty && order.every(selection.ids.contains),
              onChanged: order.isEmpty
                  ? null
                  : (value) => value == true
                        ? selection.all(order)
                        : selection.clear(),
            ),
            Text(
              selection.active
                  ? selection.ids.length == 1
                        ? '1 selecionado'
                        : '${selection.ids.length} selecionados'
                  : 'Selecionar',
              style: const TextStyle(fontSize: 12),
            ),
            if (selection.active) ...[
              IconButton(
                tooltip: 'Limpar seleção (Esc)',
                onPressed: selection.clear,
                icon: const Icon(FLucideIcons.x, size: 16),
              ),
              ...actions,
            ],
          ],
        ),
      ),
    ),
  );
}

Widget recordCheck(
  RecordSelection selection,
  String id,
  List<String> order, {
  Widget? icon,
}) => Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Checkbox(
      value: selection.ids.contains(id),
      onChanged: (_) => selection.toggle(id, order),
      visualDensity: VisualDensity.compact,
    ),
    ?icon,
  ],
);
