import 'package:material_ui/material_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/page_header.dart';
import '../../shared/search_picker.dart';
import '../../shared/widgets.dart';

class MaintenancePage extends StatefulWidget {
  final Api api;
  final JsonMap data;
  final VoidCallback changed, restored;
  const MaintenancePage({
    super.key,
    required this.api,
    required this.data,
    required this.changed,
    required this.restored,
  });
  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  late Future<dynamic> backups = widget.api.get('maintenance/backups');
  bool busy = false;
  String? error;
  Future<void> perform(Future<void> Function() action) async {
    if (busy) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> institution() async {
    final settings = JsonMap.from(await widget.api.get('institution'));
    final models = List<JsonMap>.from(await widget.api.get('templates'));
    if (!mounted) return;
    final name = TextEditingController(text: settings['name']);
    String? template = settings['document_template'];
    await showEditorDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Instituição'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  field('Nome da instituição', name),
                  SearchPicker(
                    label: 'Modelo documental padrão',
                    value: template ?? '',
                    choices: [
                      SearchChoice('', 'Sem modelo'),
                      for (final m in models.where((m) => m['archived'] == 0))
                        SearchChoice(m['id'], m['name']),
                    ],
                    onChanged: (v) =>
                        set(() => template = v.isEmpty ? null : v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Cancelar'),
            ),
            button('Salvar', () => Navigator.pop(c, true), primary: true),
          ],
        ),
      ),
    ).then((saved) async {
      if (saved == true) {
        await widget.api.send('PATCH', 'institution', {
          'name': name.text,
          'document_template': template,
          'revision': settings['revision'],
        });
      }
    });
    name.dispose();
    if (mounted) widget.changed();
  }

  Future<void> restore() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      withData: true,
    );
    final bytes = picked?.files.single.bytes;
    if (bytes == null) return;
    final result = await widget.api.uploadBackup(bytes);
    if (!mounted) return;
    final copy = JsonMap.from(result['backup']);
    final before = JsonMap.from(result['replaces']),
        after = JsonMap.from(copy['counts']);
    const labels = {
      'students': 'Alunos',
      'class_groups': 'Turmas',
      'journals': 'Diários',
      'documents': 'Documentos',
      'requests': 'Solicitações',
    };
    final confirmation = TextEditingController();
    final proceed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Substituir dados da instalação'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${copy['institution']} · ${date(copy['created'])}"),
              const Text(
                'A instalação atual será guardada em outro backup. Entre novamente após restaurar.',
              ),
              const SizedBox(height: 12),
              for (final e in labels.entries)
                Text("${e.value}  ${before[e.key]} → ${after[e.key]}"),
              const SizedBox(height: 12),
              field('Digite RESTAURAR para confirmar', confirmation),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancelar'),
          ),
          button(
            'Restaurar',
            () => Navigator.pop(c, confirmation.text == 'RESTAURAR'),
            primary: true,
          ),
        ],
      ),
    );
    confirmation.dispose();
    if (proceed != true) return;
    await widget.api.send('POST', "maintenance/restore/${result['id']}", {
      'confirmation': 'RESTAURAR',
    });
    widget.api.token = null;
    if (mounted) widget.restored();
  }

  Future<void> resetTestData() async {
    if (busy) return;
    if (!await confirm(
      context,
      'Repor os dados fictícios iniciais? Os registros atuais do ambiente de testes serão substituídos.',
    )) {
      return;
    }
    if (!mounted) return;
    await perform(() async {
      await widget.api.send('POST', 'reset', {'confirmation': 'RESTAURAR'});
      if (mounted) {
        feedback(context, 'Dados fictícios restaurados.');
        widget.restored();
      }
    });
  }

  @override
  Widget build(BuildContext c) => PageLayout(
    header: PageHeader(
      title: 'Manutenção',
      subtitle: widget.data['session']['test'] == true
          ? 'Ambiente de testes'
          : null,
      actions: [
        button(
          'Instituição',
          busy ? null : () => perform(institution),
          icon: FLucideIcons.settings,
        ),
        button(
          'Gerar backup',
          busy
              ? null
              : () => perform(() async {
                  await widget.api.send('POST', 'maintenance/backups');
                  if (mounted) {
                    setState(
                      () => backups = widget.api.get('maintenance/backups'),
                    );
                  }
                }),
          primary: true,
          icon: FLucideIcons.plus,
        ),
        button('Restaurar backup', busy ? null : () => perform(restore)),
        if (widget.data['session']['test'] == true)
          button(
            'Restaurar dados fictícios',
            busy ? null : resetTestData,
            icon: FLucideIcons.rotateCcw,
          ),
      ],
    ),
    children: [
      loadingLine(busy),
      if (error != null)
        Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
      Expanded(
        child: FutureBuilder<dynamic>(
          future: backups,
          builder: (c, s) {
            if (s.hasError) return Center(child: Text('${s.error}'));
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final rows = List<JsonMap>.from(s.data);
            return rows.isEmpty
                ? const Center(child: Text('Nenhum backup nesta instalação.'))
                : ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (c, i) {
                      final b = rows[i];
                      return ListTile(
                        title: Text(
                          "${b['institution']} · ${date(b['created'])}",
                        ),
                        subtitle: Text(
                          "${b['counts']['documents']} documento(s) · ${size(b['size'])}",
                        ),
                        trailing: IconButton(
                          tooltip: 'Baixar backup',
                          icon: const Icon(FLucideIcons.download),
                          onPressed: busy
                              ? null
                              : () => perform(() async {
                                  final bytes = await widget.api.download(
                                    "maintenance/backups/${b['id']}/content",
                                  );
                                  await FilePicker.platform.saveFile(
                                    fileName: "dPad-${b['id']}.zip",
                                    bytes: bytes,
                                  );
                                }),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    ],
  );
}
