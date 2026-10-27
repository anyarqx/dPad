import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

import '../shared/api.dart';
import '../shared/folders.dart';
import '../shared/widgets.dart';
import 'viewer.dart';

Future<bool?> uploadDialog(
  BuildContext c,
  Api api,
  List<JsonMap> folders,
  String? current, {
  Uint8List? bytes,
  String? filename,
  List<Uint8List> originals = const [],
  ValueChanged<JsonMap>? onUploaded,
  String? suggestedType,
  bool fixedDestination = false,
  String? personName,
  List<String> documentTypes = const [],
}) async {
  if (bytes == null) {
    final r = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
      withData: true,
    );
    if (r == null) return false;
    if (r.files.single.size > 30 * 1024 * 1024) {
      if (c.mounted) feedback(c, 'Limite de 30 MB.');
      return false;
    }
    bytes = r.files.single.bytes;
    filename = r.files.single.name;
  }
  if (bytes == null || !c.mounted) return false;
  return showDialog<bool>(
    context: c,
    builder: (_) => UploadForm(
      originals: originals,
      onUploaded: onUploaded,
      suggestedType: suggestedType,
      fixedDestination: fixedDestination,
      personName: personName,
      documentTypes: documentTypes,
      api: api,
      folders: folders,
      current: current,
      bytes: bytes!,
      filename: filename ?? 'Digitalização.pdf',
    ),
  );
}

class UploadForm extends StatefulWidget {
  final List<Uint8List> originals;
  final ValueChanged<JsonMap>? onUploaded;
  final String? suggestedType, personName;
  final bool fixedDestination;
  final List<String> documentTypes;
  final Api api;
  final List<JsonMap> folders;
  final String? current;
  final Uint8List bytes;
  final String filename;
  const UploadForm({
    super.key,
    this.originals = const [],
    this.onUploaded,
    this.suggestedType,
    this.personName,
    this.fixedDestination = false,
    this.documentTypes = const [],
    required this.api,
    required this.folders,
    this.current,
    required this.bytes,
    required this.filename,
  });
  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  late final name = TextEditingController(text: widget.filename);
  late final type = TextEditingController(
    text: widget.suggestedType ?? 'Outros documentos',
  );
  late String? folder = widget.current ?? widget.folders.firstOrNull?['id'];
  bool busy = false;
  @override
  void dispose() {
    name.dispose();
    type.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: const Text('Salvar documento'),
    content: SizedBox(
      width: 460,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.personName != null) ...[
              Text(
                'Pasta de ${widget.personName}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
            ],
            Text('${widget.filename} · ${size(widget.bytes.length)}'),
            if (widget.originals.isNotEmpty)
              Text(
                '${widget.originals.length} imagens originais também serão preservadas nesta pasta.',
                style: const TextStyle(fontSize: 12),
              ),
            const SizedBox(height: 16),
            field('Nome', name),
            if (widget.documentTypes.isNotEmpty)
              selector(
                'Tipo de documento',
                type.text,
                {...widget.documentTypes, type.text}
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                (v) => setState(() => type.text = v!),
              )
            else
              field('Tipo documental', type),
            if (!widget.fixedDestination)
              selector(
                'Pasta de destino',
                folder,
                widget.folders
                    .map(
                      (f) => DropdownMenuItem(
                        value: f['id'] as String,
                        child: Text(folderLocation(f['id'], widget.folders)),
                      ),
                    )
                    .toList(),
                (v) => setState(() => folder = v),
              ),
            button(
              'Pré-visualizar',
              () => preview(
                c,
                widget.bytes,
                widget.filename,
                pdf: widget.filename.toLowerCase().endsWith('.pdf'),
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(c, false),
        child: const Text('Cancelar'),
      ),
      button(
        busy ? 'Salvando…' : 'Salvar',
        busy || folder == null
            ? null
            : () async {
                setState(() => busy = true);
                try {
                  for (var i = 0; i < widget.originals.length; i++) {
                    await widget.api.upload(
                      widget.originals[i],
                      'Original ${i + 1} - ${name.text.replaceAll('.pdf', '')}.${widget.originals[i][0] == 137
                          ? 'png'
                          : widget.originals[i][0] == 255
                          ? 'jpg'
                          : 'webp'}',
                      folder!,
                      'Imagem original da digitalização',
                    );
                  }
                  final saved = await widget.api.upload(
                    widget.bytes,
                    name.text,
                    folder!,
                    type.text,
                  );
                  widget.onUploaded?.call(saved);
                  if (c.mounted) Navigator.pop(c, true);
                } catch (e) {
                  if (c.mounted) feedback(c, e);
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        primary: true,
      ),
    ],
  );
}

class RequestDraft {
  String service = 'declaracao',
      department = 'secretaria',
      subject = '',
      description = '',
      operation = const Uuid().v4();
  final Set<String> documents = {};
}

class RequestForm extends StatefulWidget {
  final String? student;
  final Api api;
  final JsonMap data;
  final RequestDraft draft;
  final String? folder;
  const RequestForm({
    super.key,
    required this.api,
    required this.data,
    required this.draft,
    this.student,
    this.folder,
  });
  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  late final subject = TextEditingController(text: widget.draft.subject);
  late final description = TextEditingController(
    text: widget.draft.description,
  );
  bool busy = false;
  late List<JsonMap> documents = List<JsonMap>.from(widget.data['documents'])
      .where((d) => widget.student == null || d['folder'] == widget.folder)
      .toList();
  RequestDraft get d => widget.draft;
  @override
  void dispose() {
    d.subject = subject.text;
    d.description = description.text;
    subject.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: const Text('Nova solicitação'),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selector(
              'Serviço',
              d.service,
              List<JsonMap>.from(widget.data['session']['services'])
                  .where(
                    (s) =>
                        s['id'] != 'atividade' ||
                        [
                          'professor',
                          'gremio',
                          'admin',
                        ].contains(widget.data['session']['user']['role']),
                  )
                  .map(
                    (s) => DropdownMenuItem(
                      value: s['id'] as String,
                      child: Text(s['name']),
                    ),
                  )
                  .toList(),
              (v) => setState(() => d.service = v!),
            ),
            field('Assunto', subject),
            field('Descrição / texto do requerimento', description, lines: 4),
            if (d.service == 'geral')
              selector(
                'Setor',
                d.department,
                ['secretaria', 'coordenacao']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                (v) => setState(() => d.department = v!),
              ),
            const Text('Anexos', style: TextStyle(fontWeight: FontWeight.w600)),
            for (final doc in documents)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FCheckbox(
                  label: Text(doc['name']),
                  value: d.documents.contains(doc['id']),
                  enabled: !busy,
                  onChange: (value) => setState(() {
                    value
                        ? d.documents.add(doc['id'])
                        : d.documents.remove(doc['id']);
                  }),
                ),
              ),
            button(
              'Importar anexo',
              busy
                  ? null
                  : () async {
                      try {
                        await uploadDialog(
                          c,
                          widget.api,
                          List<JsonMap>.from(widget.data['folders']),
                          widget.folder,
                          fixedDestination: widget.student != null,
                          personName:
                              List<JsonMap>.from(widget.data['students'])
                                  .where((s) => s['id'] == widget.student)
                                  .firstOrNull?['name'],
                        );
                        documents =
                            List<JsonMap>.from(
                                  await widget.api.get('documents'),
                                )
                                .where(
                                  (d) =>
                                      widget.student == null ||
                                      d['folder'] == widget.folder,
                                )
                                .toList();
                        if (mounted) setState(() {});
                      } catch (e) {
                        if (c.mounted) feedback(c, e);
                      }
                    },
              icon: Icons.attach_file,
            ),
            const SizedBox(height: 8),
            const Text(
              'O rascunho é preservado ao fechar esta janela.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(c, false),
        child: const Text('Fechar'),
      ),
      button(
        busy ? 'Enviando…' : 'Enviar solicitação',
        busy
            ? null
            : () async {
                if (subject.text.trim().isEmpty ||
                    description.text.trim().isEmpty) {
                  feedback(c, 'Preencha assunto e descrição.');
                  return;
                }
                setState(() => busy = true);
                try {
                  final r = await widget.api.send('POST', 'requests', {
                    'operation': d.operation,
                    if (widget.student != null) 'student': widget.student,
                    'service': d.service,
                    'department': d.department,
                    'subject': subject.text,
                    'description': description.text,
                    'documents': d.documents.toList(),
                  });
                  if (c.mounted) {
                    feedback(c, 'Solicitação ${r['protocol']} recebida.');
                    Navigator.pop(c, true);
                  }
                } catch (e) {
                  if (c.mounted) feedback(c, e);
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        primary: true,
      ),
    ],
  );
}
