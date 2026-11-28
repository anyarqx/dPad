import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import 'app_theme.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final String? subtitle;
  final bool section;
  const PageHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.subtitle,
    this.section = false,
  });
  @override
  Widget build(BuildContext c) => Material(
    color: section ? Colors.transparent : AppSurfaces.of(c).header,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: section
            ? 0
            : MediaQuery.sizeOf(c).width < 600
            ? 16
            : 24,
        vertical: section ? 6 : 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: section ? 16 : 20,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: FTheme.of(c).colors.mutedForeground,
                ),
              ),
            ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: actions,
            ),
          ],
        ],
      ),
    ),
  );
}

class PageLayout extends StatelessWidget {
  final Widget header;
  final List<Widget> headerPrefix, children;
  const PageLayout({
    super.key,
    required this.header,
    this.headerPrefix = const [],
    required this.children,
  });
  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Material(
        color: AppSurfaces.of(c).header,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (headerPrefix.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.sizeOf(c).width < 600 ? 12 : 16,
                  8,
                  MediaQuery.sizeOf(c).width < 600 ? 12 : 16,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: headerPrefix,
                ),
              ),
            header,
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(c).width < 600 ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ],
  );
}
