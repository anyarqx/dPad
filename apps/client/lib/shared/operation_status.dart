import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

final operationNotice = ValueNotifier<({String message, bool error})?>(null);

Future<void> showOperationNotice(BuildContext c) async {
  final notice = operationNotice.value;
  await showDialog<void>(
    context: c,
    builder: (c) => AlertDialog(
      title: const Text('Atividade'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: SelectableText(
            notice?.message ?? 'Nenhuma mensagem nesta sessão.',
          ),
        ),
      ),
      actions: [
        if (notice != null)
          TextButton(
            onPressed: () {
              operationNotice.value = null;
              Navigator.pop(c);
            },
            child: const Text('Limpar'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}

class OperationNoticeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const OperationNoticeButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext c) => ValueListenableBuilder(
    valueListenable: operationNotice,
    builder: (c, notice, _) => IconButton(
      tooltip: 'Atividade',
      onPressed: onPressed,
      icon: SizedBox.square(
        dimension: 20,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              FLucideIcons.bell,
              size: 20,
              color: FTheme.of(c).colors.mutedForeground,
            ),
            if (notice != null)
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: notice.error
                        ? FTheme.of(c).colors.error
                        : FTheme.of(c).colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
