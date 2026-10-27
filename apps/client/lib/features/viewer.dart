import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:file_picker/file_picker.dart';

import '../shared/widgets.dart';

Future<void> preview(
  BuildContext context,
  Uint8List bytes,
  String name, {
  bool pdf = true,
}) => showDialog(
  context: context,
  builder: (_) => Viewer(bytes: bytes, name: name, pdf: pdf),
);

class Viewer extends StatefulWidget {
  final Uint8List bytes;
  final String name;
  final bool pdf;
  const Viewer({
    super.key,
    required this.bytes,
    required this.name,
    required this.pdf,
  });
  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  final controller = PdfViewerController();
  int page = 1;
  @override
  Widget build(BuildContext c) => Dialog(
    insetPadding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(widget.name),
              if (widget.pdf) ...[
                IconButton(
                  tooltip: 'Página anterior',
                  onPressed: () {
                    if (controller.isReady) {
                      controller.goToPage(
                        pageNumber: (page - 1).clamp(1, controller.pageCount),
                      );
                    }
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('Página $page'),
                IconButton(
                  tooltip: 'Próxima página',
                  onPressed: () {
                    if (controller.isReady) {
                      controller.goToPage(
                        pageNumber: (page + 1).clamp(1, controller.pageCount),
                      );
                    }
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
                IconButton(
                  tooltip: 'Reduzir',
                  onPressed: () {
                    if (controller.isReady) controller.zoomDown();
                  },
                  icon: const Icon(Icons.zoom_out),
                ),
                IconButton(
                  tooltip: 'Ampliar',
                  onPressed: () {
                    if (controller.isReady) controller.zoomUp();
                  },
                  icon: const Icon(Icons.zoom_in),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.isReady) {
                      controller.goToPage(pageNumber: page);
                    }
                  },
                  child: const Text('Ajustar página'),
                ),
              ],
              button('Baixar', () async {
                try {
                  await FilePicker.platform.saveFile(
                    fileName: widget.name,
                    bytes: widget.bytes,
                  );
                } catch (e) {
                  if (c.mounted) feedback(c, e);
                }
              }, icon: Icons.download),
              IconButton(
                onPressed: () => Navigator.pop(c),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: widget.pdf
              ? PdfViewer.data(
                  widget.bytes,
                  sourceName: widget.name,
                  controller: controller,
                  params: PdfViewerParams(
                    onPageChanged: (p) {
                      if (mounted) setState(() => page = p ?? 1);
                    },
                  ),
                )
              : InteractiveViewer(
                  minScale: .2,
                  maxScale: 8,
                  child: Center(
                    child: Image.memory(widget.bytes, fit: BoxFit.contain),
                  ),
                ),
        ),
      ],
    ),
  );
}
