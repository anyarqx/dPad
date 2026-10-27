import 'package:material_ui/material_ui.dart';

import 'launcher.dart';
import 'operation_status.dart';
import 'app_logo.dart';
import 'app_theme.dart';

enum SoftwareAction {
  appearance,
  connection,
  status,
  host,
  stop,
  licenses,
  activity,
}

class SoftwareMenuObserver extends NavigatorObserver {
  Route<dynamic>? active;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name?.startsWith('software-menu:') == true) {
      active = route;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (identical(route, active)) active = null;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (identical(route, active)) active = null;
  }

  void close() {
    final route = active;
    active = null;
    if (route != null && route.navigator?.mounted == true) {
      route.navigator!.removeRoute(route);
    }
  }
}

final softwareMenuObserver = SoftwareMenuObserver();

final softwareNavigatorKey = GlobalKey<NavigatorState>();

final softwareAction = ValueNotifier<SoftwareAction?>(null);
void openSoftwareAction(SoftwareAction action) {
  softwareMenuObserver.close();
  softwareAction.value = null;
  softwareAction.value = action;
}

void openActivity() => openSoftwareAction(SoftwareAction.activity);

class SoftwareMenus extends StatelessWidget {
  const SoftwareMenus({super.key});
  @override
  Widget build(BuildContext c) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _menu('Configurações', const {
        SoftwareAction.appearance: 'Aparência',
        SoftwareAction.licenses: 'Sobre e licenças',
      }),
      _menu('Servidor', {
        SoftwareAction.connection: 'Conectar a um servidor…',
        SoftwareAction.status: 'Verificar conexão',
        if (canHost) SoftwareAction.host: 'Hospedar nesta máquina',
        if (canHost) SoftwareAction.stop: 'Encerrar hospedagem local',
      }),
      const OperationNoticeButton(onPressed: openActivity),
    ],
  );
  Widget _menu(String label, Map<SoftwareAction, String> items) => Builder(
    builder: (c) => TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(c).colorScheme.onSurface,
        minimumSize: const Size(48, 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      onPressed: () async {
        final target = softwareNavigatorKey.currentContext ?? c;
        final navigator = Navigator.of(target, rootNavigator: true);
        final same =
            softwareMenuObserver.active?.settings.name ==
            'software-menu:$label';
        softwareMenuObserver.close();
        if (same) return;
        final overlay =
            navigator.overlay!.context.findRenderObject()! as RenderBox;
        final button = c.findRenderObject()! as RenderBox;
        final origin =
            button.localToGlobal(Offset(0, button.size.height)) -
            overlay.localToGlobal(Offset.zero);
        final action = await showMenu<SoftwareAction>(
          context: target,
          routeSettings: RouteSettings(name: 'software-menu:$label'),
          position: RelativeRect.fromRect(
            origin & Size(button.size.width, 0),
            Offset.zero & overlay.size,
          ),
          items: [
            for (final entry in items.entries)
              PopupMenuItem(
                value: entry.key,
                enabled: entry.key != SoftwareAction.stop || isHosting,
                child: Text(entry.value),
              ),
          ],
        );
        if (action != null) openSoftwareAction(action);
      },
      child: Text(label, style: const TextStyle(fontSize: 13)),
    ),
  );
}

class SoftwareToolbar extends StatelessWidget {
  const SoftwareToolbar({super.key});
  @override
  Widget build(BuildContext c) => Material(
    color: AppSurfaces.of(c).chrome,
    child: const SizedBox(
      height: 44,
      child: Row(
        children: [
          SizedBox(width: 16),
          AppLogo(size: 22),
          SizedBox(width: 10),
          Text(
            'Do Papel ao Digital',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 24),
          SoftwareMenus(),
        ],
      ),
    ),
  );
}
