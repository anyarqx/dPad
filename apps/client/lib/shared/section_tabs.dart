import 'package:material_ui/material_ui.dart';

class SectionTabs extends StatefulWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String> onChanged;
  const SectionTabs({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });
  @override
  State<SectionTabs> createState() => _SectionTabsState();
}

class _SectionTabsState extends State<SectionTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int get index =>
      widget.items.indexOf(widget.value).clamp(0, widget.items.length - 1);
  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: widget.items.length,
      vsync: this,
      initialIndex: index,
    );
  }

  @override
  void didUpdateWidget(covariant SectionTabs old) {
    super.didUpdateWidget(old);
    if (old.items.length != widget.items.length) {
      controller.dispose();
      controller = TabController(
        length: widget.items.length,
        vsync: this,
        initialIndex: index,
      );
    } else if (controller.index != index) {
      controller.index = index;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => LayoutBuilder(
    builder: (c, box) {
      final requiredWidth = widget.items.fold<double>(0, (sum, label) {
        final painter = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          textDirection: Directionality.of(c),
          textScaler: MediaQuery.textScalerOf(c),
        )..layout();
        final width = painter.width + 36;
        painter.dispose();
        return sum + width;
      });
      final scroll = requiredWidth > box.maxWidth;
      return TabBar(
        controller: controller,
        isScrollable: scroll,
        tabAlignment: scroll ? TabAlignment.start : TabAlignment.fill,
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: (i) => widget.onChanged(widget.items[i]),
        tabs: [
          for (final item in widget.items)
            Tab(height: 48, child: Text(item, maxLines: 1, softWrap: false)),
        ],
      );
    },
  );
}
