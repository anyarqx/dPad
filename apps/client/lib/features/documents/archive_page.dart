import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/folders.dart';
import '../../shared/widgets.dart';
import '../../shared/search_picker.dart';
import '../forms.dart';
import '../scanner.dart';

class ArchivePage extends StatefulWidget {
  final Api api;
  final JsonMap data;
  final String? folderId;
  final ValueChanged<String?> openFolder;
  final ValueChanged<JsonMap> selectDocument;
  final VoidCallback changed;
  final Future<void> Function(JsonMap) assignDocument, registerStudent;
  const ArchivePage({
    super.key,
    required this.api,
    required this.data,
    this.folderId,
    required this.openFolder,
    required this.selectDocument,
    required this.changed,
    required this.assignDocument,
    required this.registerStudent,
  });
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String search = '';
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool working = false;
  @override
  void didUpdateWidget(covariant ArchivePage old) {
    super.didUpdateWidget(old);
    if (old.folderId != widget.folderId) {
      search = '';
      searchController.clear();
    }
  }

  List<JsonMap> get folders {
    final assigned = List<JsonMap>.from(widget.data['students'])
        .map((p) => p['folder'])
        .toSet();
    return List<JsonMap>.from(widget.data['folders'])
        .where((f) => !assigned.contains(f['id']))
        .toList();
  }

  String folderPath(String id) => folderLocation(id, folders);

  Future<void> action(Future<void> Function() fn) async {
    if (working) return;
    setState(() => working = true);
    try {
      await fn();
      widget.changed();
    } catch (e) {
      if (mounted) feedback(context, e);
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> editFolder([JsonMap? old]) async {
    final name = TextEditingController(text: old?['name']);
    String? parent = old == null ? widget.folderId : old['parent'];
    final invalid = <String>{if (old != null) old['id']};
    bool added = true;
    while (added) {
      added = false;
      for (final f in folders) {
        if (invalid.contains(f['parent']) && invalid.add(f['id'])) added = true;
      }
    }
    final destinations = folders
        .where(
          (f) =>
              !invalid.contains(f['id']) &&
              (old == null || f['area'] == old['area']),
        )
        .toList();
    bool saving = false;
    String? error;
    await showEditorDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: Text(old == null ? 'Nova pasta' : 'Editar pasta'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  field('Nome da pasta', name, hint: 'Ex.: Atas e reuniões'),
                  selector('Dentro de', parent ?? '', [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('Raiz do arquivo'),
                    ),
                    for (final f in destinations)
                      DropdownMenuItem(
                        value: f['id'] as String,
                        child: Text(folderPath(f['id'])),
                      ),
                  ], (v) => set(() => parent = v == '' ? null : v)),
                  if (error != null)
                    Text(
                      error!,
                      style: TextStyle(color: Theme.of(c).colorScheme.error),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(c),
              child: const Text('Cancelar'),
            ),
            button(
              saving ? 'Salvando…' : 'Salvar pasta',
              saving
                  ? null
                  : () async {
                      set(() {
                        saving = true;
                        error = null;
                      });
                      try {
                        final saved = await widget.api.send(
                          old == null ? 'POST' : 'PATCH',
                          old == null ? 'folders' : 'folders/${old['id']}',
                          {
                            'name': name.text,
                            'parent': parent,
                            if (old != null) 'revision': old['revision'],
                          },
                        );
                        widget.changed();
                        widget.openFolder(saved['id']);
                        if (c.mounted) Navigator.pop(c);
                      } catch (e) {
                        if (c.mounted) set(() => error = e.toString());
                      } finally {
                        if (c.mounted) set(() => saving = false);
                      }
                    },
              primary: true,
            ),
          ],
        ),
      ),
    );
    name.dispose();
  }

  Future<void> upload({bool scanImages = false}) => action(() async {
    final bytes = scanImages ? await scan(context) : null;
    if (scanImages && bytes == null) return;
    if (!mounted) return;
    await uploadDialog(
      context,
      widget.api,
      folders,
      widget.folderId ?? folders.firstOrNull?['id'],
      bytes: bytes?.pdf,
      originals: bytes?.originals ?? [],
      filename: scanImages ? 'Digitalização.pdf' : null,
      fixedDestination: widget.folderId != null,
    );
  });
  @override
  Widget build(BuildContext c) {
    final all = folders,
        current = all.where((f) => f['id'] == widget.folderId).firstOrNull;
    final term = normalizeSearch(search);
    final childFolders = all
        .where(
          (f) =>
              (widget.folderId == null
                  ? (search.isNotEmpty ||
                        f['parent'] == null ||
                        !all.any((p) => p['id'] == f['parent']))
                  : f['parent'] == widget.folderId) &&
              normalizeSearch(f['name'].toString()).contains(term),
        )
        .toList();
    final folderIds = all.map((f) => f['id']).toSet();
    final adoptable = all
        .where(
          (f) =>
              f['parent'] == null &&
              !all.any((child) => child['parent'] == f['id']),
        )
        .map((f) => f['id'])
        .toSet();
    final manager =
        widget.data['session']['user']['role'] == 'admin' ||
        widget.data['session']['user']['department'] == 'secretaria';
    final docs = List<JsonMap>.from(widget.data['documents'])
        .where(
          (d) =>
              folderIds.contains(d['folder']) &&
              (widget.folderId == null || d['folder'] == widget.folderId) &&
              normalizeSearch('${d['name']} ${d['type']}').contains(term),
        )
        .toList();
    final title =
        widget.data['session']['user']['department'] != null ||
            widget.data['session']['user']['role'] == 'admin'
        ? 'Arquivo administrativo'
        : 'Meus arquivos';
    if (widget.folderId != null && current == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Esta pasta não está disponível.'),
            button('Voltar ao arquivo', () => widget.openFolder(null)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (current != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => widget.openFolder(current['parent']),
              icon: const Icon(FLucideIcons.arrowLeft, size: 16),
              label: Text(current['parent'] == null ? title : 'Pasta anterior'),
            ),
          ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              current?['name'] ?? title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            IconButton(
              tooltip: 'Atualizar arquivo',
              onPressed: working ? null : widget.changed,
              icon: const Icon(FLucideIcons.refreshCw, size: 18),
            ),
            button(
              'Nova pasta',
              working ? null : () => editFolder(),
              icon: FLucideIcons.folderPlus,
            ),
            button(
              'Importar arquivo',
              working || all.isEmpty ? null : () => upload(),
              icon: FLucideIcons.upload,
              primary: true,
            ),
            button(
              'Digitalizar',
              working || all.isEmpty ? null : () => upload(scanImages: true),
              icon: FLucideIcons.scanLine,
            ),
            if (current != null)
              IconButton(
                tooltip: 'Editar pasta',
                onPressed: working ? null : () => editFolder(current),
                icon: const Icon(FLucideIcons.pencil, size: 18),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (current != null)
          Text(
            folderPath(current['id']),
            style: TextStyle(
              fontSize: 12,
              color: FTheme.of(c).colors.mutedForeground,
            ),
          )
        else
          Text(
            'Arquivos de trabalho e anexos. Documentos dos alunos ficam nas respectivas pastas.',
            style: TextStyle(
              fontSize: 12,
              color: FTheme.of(c).colors.mutedForeground,
            ),
          ),
        const SizedBox(height: 16),
        FTextField(
          key: const ValueKey('archive-search'),
          hint: 'Buscar pasta ou documento',
          control: FTextFieldControl.managed(
            controller: searchController,
            onChange: (v) => setState(() => search = v.text),
          ),
        ),
        const SizedBox(height: 10),
        loadingLine(working),
        Expanded(
          child: childFolders.isEmpty && docs.isEmpty
              ? Center(
                  child: Text(
                    search.isNotEmpty
                        ? 'Nenhum resultado para esta busca.'
                        : current != null
                        ? 'Pasta vazia. Importe um arquivo ou adicione uma subpasta.'
                        : 'Nenhuma pasta ou arquivo. Crie uma pasta para importar documentos.',
                  ),
                )
              : ListView(
                  children: [
                    for (final f in childFolders)
                      ListTile(
                        leading: const Icon(FLucideIcons.folder, size: 22),
                        title: Text(
                          f['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${current == null && f['area_name'] != null ? '${f['area_name']} · ' : ''}${all.where((r) => r['parent'] == f['id']).length} subpasta(s) · ${List<JsonMap>.from(widget.data['documents']).where((d) => d['folder'] == f['id']).length} arquivo(s)',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () => widget.openFolder(f['id']),
                        trailing: PopupMenuButton<String>(
                          tooltip: 'Opções da pasta ${f['name']}',
                          onSelected: (v) async {
                            if (v == 'edit') {
                              editFolder(f);
                            } else {
                              final accepted = await confirm(
                                context,
                                'Excluir a pasta vazia “${f['name']}”?',
                              );
                              if (accepted && mounted) {
                                await action(() async {
                                  await widget.api.send(
                                    'DELETE',
                                    'folders/${f['id']}',
                                  );
                                });
                              }
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Renomear / mover'),
                            ),
                            PopupMenuItem(
                              enabled:
                                  !all.any(
                                    (child) => child['parent'] == f['id'],
                                  ) &&
                                  !(widget.data['documents'] as List).any(
                                    (doc) => doc['folder'] == f['id'],
                                  ),
                              value: 'delete',
                              child: const Text('Excluir pasta vazia'),
                            ),
                          ],
                        ),
                      ),
                    if (childFolders.isNotEmpty) const PixelDivider(),
                    if (widget.folderId == null && docs.isNotEmpty)
                      sectionHeading('Todos os documentos'),
                    for (final d in docs)
                      ListTile(
                        leading: Icon(
                          d['mime'] == 'application/pdf'
                              ? FLucideIcons.fileText
                              : FLucideIcons.image,
                          size: 22,
                        ),
                        title: Text(
                          d['name'],
                          style: const TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          '${d['type']} · ${size(d['size'])}${current == null ? ' · ${folderPath(d['folder'])}' : ''}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () => widget.selectDocument(d),
                        trailing:
                            manager &&
                                ((widget.data['students'] as List).isNotEmpty ||
                                    adoptable.contains(d['folder']))
                            ? PopupMenuButton<String>(
                                tooltip: 'Vincular ${d['name']}',
                                onSelected: (v) => v == 'existing'
                                    ? widget.assignDocument(d)
                                    : widget.registerStudent(d),
                                itemBuilder: (_) => [
                                  if ((widget.data['students'] as List)
                                      .isNotEmpty)
                                    const PopupMenuItem(
                                      value: 'existing',
                                      child: Text(
                                        'Vincular a aluno cadastrado',
                                      ),
                                    ),
                                  if (adoptable.contains(d['folder']))
                                    const PopupMenuItem(
                                      value: 'folder',
                                      child: Text(
                                        'Cadastrar aluno com esta pasta',
                                      ),
                                    ),
                                ],
                              )
                            : null,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
