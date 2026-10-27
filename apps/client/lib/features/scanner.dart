import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

import '../shared/widgets.dart';
import 'viewer.dart';

class ScanResult {
  final Uint8List pdf;
  final List<Uint8List> originals;
  ScanResult(this.pdf, this.originals);
}

Future<ScanResult?> scan(BuildContext c) =>
    showDialog<ScanResult>(context: c, builder: (_) => const Scanner());

class Scanner extends StatefulWidget {
  final List<Uint8List> initialImages;
  const Scanner({super.key, this.initialImages = const []});
  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final pages = <Uint8List>[];
  final originals = <Uint8List>[];
  @override
  void initState() {
    super.initState();
    pages.addAll(widget.initialImages);
    originals.addAll(widget.initialImages);
  }

  int selected = 0;
  bool busy = false;
  Future<void> add() async {
    try {
      final r = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        allowMultiple: true,
        withData: true,
      );
      if (r == null) return;
      for (final f in r.files) {
        if (f.size > 15 * 1024 * 1024) throw Exception('Imagem excede 15 MB.');
        final b = f.bytes;
        if (b == null || img.decodeImage(b) == null) {
          throw Exception('Imagem inválida: ${f.name}');
        }
        if (pages.length >= 30) throw Exception('Limite de 30 páginas.');
        pages.add(b);
        originals.add(b);
      }
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) feedback(context, e);
    }
  }

  Future<Uint8List> generate() => generateScanPdf(pages);

  Future<void> crop() async {
    final ctrl = CropController();
    bool ready = false;
    final b = await showDialog<Uint8List>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setCrop) => Dialog(
          child: SizedBox(
            width: 800,
            height: 650,
            child: Column(
              children: [
                Expanded(
                  child: Crop(
                    image: pages[selected],
                    controller: ctrl,
                    onStatusChanged: (status) {
                      if (c.mounted) {
                        setCrop(() => ready = status == CropStatus.ready);
                      }
                    },
                    onCropped: (r) {
                      switch (r) {
                        case CropSuccess(:final croppedImage):
                          Navigator.pop(c, croppedImage);
                        case CropFailure(:final cause):
                          feedback(c, cause);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('Cancelar'),
                      ),
                      button(
                        'Aplicar recorte',
                        ready ? () => ctrl.crop() : null,
                        primary: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (b != null) setState(() => pages[selected] = b);
  }

  @override
  Widget build(BuildContext c) => Dialog(
    insetPadding: const EdgeInsets.all(24),
    child: SizedBox(
      width: 1050,
      height: 760,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Digitalizar documento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: busy ? null : () => Navigator.pop(c),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: pages.isEmpty
                ? Center(
                    child: button(
                      'Selecionar imagens',
                      add,
                      icon: Icons.add_photo_alternate,
                    ),
                  )
                : Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: ListView.builder(
                          itemCount: pages.length,
                          itemBuilder: (_, i) => ListTile(
                            selected: i == selected,
                            onTap: () => setState(() => selected = i),
                            title: Image.memory(
                              pages[i],
                              height: 95,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              isAntiAlias: true,
                            ),
                            subtitle: Text('Página ${i + 1}'),
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: InteractiveViewer(
                          child: Image.memory(
                            pages[selected],
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            isAntiAlias: true,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                button('Adicionar', busy ? null : add, icon: Icons.add),
                if (pages.isNotEmpty) ...[
                  button('Recortar', busy ? null : crop, icon: Icons.crop),
                  button(
                    'Girar',
                    busy
                        ? null
                        : () {
                            final image = img.decodeImage(pages[selected])!;
                            setState(
                              () => pages[selected] = Uint8List.fromList(
                                img.encodePng(img.copyRotate(image, angle: 90)),
                              ),
                            );
                          },
                    icon: Icons.rotate_right,
                  ),
                  button(
                    'Anterior',
                    !busy && selected > 0
                        ? () {
                            setState(() {
                              final p = pages.removeAt(selected);
                              pages.insert(--selected, p);
                            });
                          }
                        : null,
                  ),
                  button(
                    'Seguinte',
                    !busy && selected < pages.length - 1
                        ? () {
                            setState(() {
                              final p = pages.removeAt(selected);
                              pages.insert(++selected, p);
                            });
                          }
                        : null,
                  ),
                  button(
                    'Remover',
                    busy
                        ? null
                        : () => setState(() {
                            pages.removeAt(selected);
                            selected = selected.clamp(
                              0,
                              pages.isEmpty ? 0 : pages.length - 1,
                            );
                          }),
                  ),
                  button(
                    'Prévia PDF',
                    busy
                        ? null
                        : () async {
                            setState(() => busy = true);
                            try {
                              final b = await generate();
                              if (c.mounted) {
                                await preview(c, b, 'Digitalização.pdf');
                              }
                            } catch (e) {
                              if (c.mounted) feedback(c, e);
                            } finally {
                              if (mounted) setState(() => busy = false);
                            }
                          },
                  ),
                  button(
                    busy ? 'Gerando…' : 'Usar PDF',
                    busy
                        ? null
                        : () async {
                            setState(() => busy = true);
                            try {
                              final b = await generate();
                              if (c.mounted) {
                                Navigator.pop(
                                  c,
                                  ScanResult(b, List.of(originals)),
                                );
                              }
                            } catch (e) {
                              if (c.mounted) feedback(c, e);
                              if (mounted) setState(() => busy = false);
                            }
                          },
                    primary: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Uint8List> generateScanPdf(List<Uint8List> pages) async {
  final d = pw.Document();
  for (final bytes in pages) {
    final image = pw.MemoryImage(bytes);
    d.addPage(
      pw.Page(
        build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );
  }
  return d.save();
}
