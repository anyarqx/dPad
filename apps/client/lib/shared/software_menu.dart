import 'package:material_ui/material_ui.dart';

import 'launcher.dart';
import 'operation_status.dart';
import 'app_logo.dart';
import 'app_theme.dart';
import 'window_chrome.dart' show windowChromeEnabled;

enum SoftwareAction {
  appearance,
  connection,
  status,
  stop,
  maintenance,
  help,
  licenses,
  activity,
  fullscreen,
  navigation,
  sidebar,
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
      _menu('Configurações', {
        SoftwareAction.appearance: 'Aparência',
        if (windowChromeEnabled) SoftwareAction.fullscreen: 'Tela cheia',
        SoftwareAction.licenses: 'Sobre e licenças',
      }),
      _menu('Servidor', {
        SoftwareAction.connection: canHost
            ? 'Conexão e hospedagem…'
            : 'Conectar a um servidor…',
        SoftwareAction.status: 'Verificar conexão',
        SoftwareAction.maintenance: 'Manutenção',
        if (canHost) SoftwareAction.stop: 'Encerrar hospedagem local',
      }),
      _menu('Ajuda', const {SoftwareAction.help: 'Atalhos de teclado'}),
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
          constraints: BoxConstraints(
            minWidth: 140,
            maxWidth: MediaQuery.textScalerOf(c).scale(224).clamp(224, 340),
          ),
          menuPadding: const EdgeInsets.symmetric(vertical: 4),
          position: RelativeRect.fromRect(
            origin & Size(button.size.width, 0),
            Offset.zero & overlay.size,
          ),
          items: [
            for (final entry in items.entries)
              PopupMenuItem(
                value: entry.key,
                height: 38,
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

Future<void> showShortcutTable(
  BuildContext context, {
  required bool desktop,
}) => showDialog<void>(
  context: context,
  builder: (c) {
    final scheme = Theme.of(c).colorScheme;
    final groups = {
      'Aplicativo': [
        ('F1', 'Abrir a tabela de atalhos'),
        if (desktop) ('F11', 'Entrar ou sair da tela cheia'),
        ('Ctrl + Alt + K', 'Ir para uma seção'),
        ('Ctrl + Alt + B', 'Recolher ou abrir a navegação'),
      ],
      'Listas e arquivo': [
        ('Ctrl / ⌘ + clique', 'Alternar a seleção de um item'),
        ('Shift + clique', 'Selecionar um intervalo de itens'),
        ('Ctrl / ⌘ + A', 'Selecionar os itens visíveis'),
        ('Esc', 'Limpar a seleção'),
        ('Delete', 'Excluir documentos selecionados, com confirmação'),
        ('F2', 'Editar o documento selecionado no arquivo'),
        ('Alt + ↑', 'Subir uma pasta no arquivo'),
        ('Ctrl / ⌘ + F', 'Buscar no arquivo'),
      ],
      'Formulários e tabelas': [
        ('Tab / Shift + Tab', 'Avançar ou voltar entre campos e controles'),
        ('Enter', 'Confirmar um resultado único no seletor'),
        ('Espaço', 'Marcar ou desmarcar a caixa em foco'),
      ],
    };
    Widget cell(String value, {bool heading = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 13,
          fontWeight: heading ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
    return AlertDialog(
      insetPadding: const EdgeInsets.all(16),
      title: const Text('Atalhos de teclado'),
      content: SizedBox(
        width: 570,
        child: SingleChildScrollView(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
            border: TableBorder(
              horizontalInside: BorderSide(color: scheme.outlineVariant),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(color: scheme.surfaceContainer),
                children: [
                  cell('Tecla', heading: true),
                  cell('Ação', heading: true),
                ],
              ),
              for (final group in groups.entries) ...[
                TableRow(
                  decoration: BoxDecoration(color: scheme.surfaceContainerLow),
                  children: [
                    cell(group.key, heading: true),
                    const SizedBox.shrink(),
                  ],
                ),
                for (final row in group.value)
                  TableRow(children: [cell(row.$1), cell(row.$2)]),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Fechar'),
        ),
      ],
    );
  },
);

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
            'dPad',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 24),
          SoftwareMenus(),
        ],
      ),
    ),
  );
}
