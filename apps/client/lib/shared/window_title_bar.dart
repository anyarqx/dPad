import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import 'app_logo.dart';
import 'software_menu.dart';
import 'app_theme.dart';

class WindowTitleBar extends StatelessWidget {
  final VoidCallback minimize, maximize, close, drag;
  final bool maximized;
  const WindowTitleBar({
    super.key,
    required this.minimize,
    required this.maximize,
    required this.close,
    required this.drag,
    this.maximized = false,
  });
  @override
  Widget build(BuildContext c) => Material(
    color: AppSurfaces.of(c).chrome,
    child: SizedBox(
      height: 44,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(c).width < 760 ? 88 : 110,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (_) => drag(),
              onDoubleTap: maximize,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    AppLogo(size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'dPad',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SoftwareMenus(),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (_) => drag(),
              onDoubleTap: maximize,
              child: const SizedBox.expand(),
            ),
          ),
          _caption(c, 'Minimizar', FLucideIcons.minus, minimize),
          _caption(
            c,
            maximized ? 'Restaurar janela' : 'Maximizar',
            maximized ? FLucideIcons.copy : FLucideIcons.square,
            maximize,
          ),
          _caption(c, 'Fechar janela', FLucideIcons.x, close, danger: true),
        ],
      ),
    ),
  );
  Widget _caption(
    BuildContext c,
    String label,
    IconData icon,
    VoidCallback action, {
    bool danger = false,
  }) => Tooltip(
    message: label,
    child: Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: action,
        hoverColor: danger
            ? Theme.of(c).colorScheme.error.withValues(alpha: .18)
            : null,
        child: SizedBox(
          width: 48,
          height: 44,
          child: Icon(
            icon,
            size: 16,
            color: FTheme.of(c).colors.mutedForeground,
          ),
        ),
      ),
    ),
  );
}
