import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import 'api.dart';

class FolderBreadcrumbs extends StatelessWidget {
  final List<JsonMap> folders;
  final String current, rootLabel;
  final ValueChanged<String?> open;
  const FolderBreadcrumbs({
    super.key,
    required this.folders,
    required this.current,
    required this.open,
    required this.rootLabel,
  });
  @override
  Widget build(BuildContext c) {
    final path = <JsonMap>[], visited = <String>{};
    String? id = current;
    while (id != null && visited.add(id)) {
      final row = folders.where((f) => f['id'] == id).firstOrNull;
      if (row == null) break;
      path.insert(0, row);
      id = row['parent'];
    }
    Widget link(String label, String? id) => TextButton(
      onPressed: () => open(id),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(32, 36),
        foregroundColor: FTheme.of(c).colors.mutedForeground,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
    );
    return Row(
      children: [
        IconButton(
          tooltip: 'Subir uma pasta',
          onPressed: () => open(path.lastOrNull?['parent']),
          icon: const Icon(FLucideIcons.arrowUp, size: 18),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (c, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    link(rootLabel, null),
                    for (final row in path) ...[
                      Icon(
                        FLucideIcons.chevronRight,
                        size: 14,
                        color: FTheme.of(c).colors.mutedForeground,
                      ),
                      if (row['id'] == current)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            row['name'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        link(row['name'], row['id']),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
