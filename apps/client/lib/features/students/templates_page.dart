import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:file_picker/file_picker.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

class TemplatesPage extends StatelessWidget {
  final Api api;
  final JsonMap data;
  final VoidCallback changed;
  const TemplatesPage({
    super.key,
    required this.api,
    required this.data,
    required this.changed,
  });
  Future<void> edit(
    BuildContext c, {
    JsonMap? template,
    JsonMap? imported,
  }) async {
    final saved = await showDialog<bool>(
      context: c,
      barrierDismissible: false,
      builder: (_) =>
          _TemplateForm(api: api, template: template, imported: imported),
    );
    if (saved == true) changed();
  }

  Future<void> import(BuildContext c) async {
    try {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (file == null || !c.mounted) return;
      if (file.files.single.size > 64 * 1024) {
        throw Exception('O modelo deve ter até 64 KB.');
      }
      final bytes = file.files.single.bytes;
      if (bytes == null) throw Exception('Não foi possível ler o arquivo.');
      final data = jsonDecode(utf8.decode(bytes));
      if (data is! Map<String, dynamic>) {
        throw Exception('O arquivo precisa conter um modelo JSON.');
      }
      if (data['name'] != null && data['name'] is! String) {
        throw Exception('O nome do modelo precisa ser um texto.');
      }
      if (data['fields'] != null && data['fields'] is! Map) {
        throw Exception('A configuração de campos é inválida.');
      }
      final configured = data['fields'] as Map?;
      for (final value in [
        data['documents'],
        data['extra_fields'] ?? configured?['extra'],
        data['required_identity'] ?? configured?['identity'],
      ]) {
        if (value != null &&
            (value is! List || value.any((v) => v is! String))) {
          throw Exception(
            'Os documentos e campos precisam ser listas de textos.',
          );
        }
      }
      await edit(c, imported: data);
    } catch (e) {
      if (c.mounted) feedback(c, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = List<JsonMap>.from(data['templates']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Modelos de pasta',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            button(
              'Criar modelo',
              () => edit(context),
              icon: FLucideIcons.plus,
              primary: true,
            ),
            button(
              'Importar JSON',
              () => import(context),
              icon: FLucideIcons.upload,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Defina documentos e informações exigidas para cada contexto. Ao cadastrar o aluno, o modelo escolhido é copiado para sua pasta; editar o modelo afeta os próximos cadastros.',
          style: TextStyle(fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: list.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum modelo cadastrado. Crie um modelo ou importe um arquivo JSON.',
                  ),
                )
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, i) => const PixelDivider(),
                  itemBuilder: (c, i) {
                    final t = list[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      leading: const Icon(FLucideIcons.files, size: 22),
                      title: Text(t['name']),
                      subtitle: Text(
                        '${(t['documents'] as List).length} documentos · ${(t['fields']['extra'] as List).length} informações adicionais${t['archived'] == 1 ? ' · Arquivado' : ''}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(FLucideIcons.chevronRight, size: 18),
                      onTap: () => edit(context, template: t),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TemplateForm extends StatefulWidget {
  final Api api;
  final JsonMap? template, imported;
  const _TemplateForm({required this.api, this.template, this.imported});
  @override
  State<_TemplateForm> createState() => _TemplateFormState();
}

class _TemplateFormState extends State<_TemplateForm> {
  JsonMap get initial => widget.template ?? widget.imported ?? {};
  late final name = TextEditingController(text: initial['name'] ?? '');
  late final documents = TextEditingController(
    text: List<String>.from(initial['documents'] ?? []).join('\n'),
  );
  late final fields = TextEditingController(
    text: List<String>.from(
      initial['fields']?['extra'] ?? initial['extra_fields'] ?? [],
    ).join('\n'),
  );
  late final identity = <String>{
    ...List<String>.from(
      initial['fields']?['identity'] ?? initial['required_identity'] ?? [],
    ),
  };
  late bool archived = initial['archived'] == 1;
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in [name, documents, fields]) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> lines(TextEditingController c) => c.text
      .split('\n')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(
      widget.template == null ? 'Criar modelo de pasta' : 'Editar modelo',
    ),
    content: SizedBox(
      width: 580,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            field('Nome do modelo', name),
            field('Documentos exigidos (um por linha)', documents, lines: 7),
            field(
              'Informações adicionais exigidas (uma por linha)',
              fields,
              lines: 3,
            ),
            const Text(
              'Dados básicos exigidos',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            for (final e in {
              'birth_date': 'Nascimento',
              'guardian': 'Responsável',
              'phone': 'Telefone',
              'email': 'E-mail',
              'sex': 'Sexo informado',
              'social_name': 'Nome social',
              'birthplace': 'Naturalidade',
              'nationality': 'Nacionalidade',
              'parentage': 'Filiação',
              'address': 'Endereço',
            }.entries)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(e.value),
                value: identity.contains(e.key),
                onChanged: saving
                    ? null
                    : (v) => setState(() {
                        v! ? identity.add(e.key) : identity.remove(e.key);
                      }),
              ),
            if (widget.template != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Arquivar modelo para novos cadastros'),
                value: archived,
                onChanged: saving ? null : (v) => setState(() => archived = v!),
              ),
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
        saving ? 'Salvando…' : 'Salvar modelo',
        saving
            ? null
            : () async {
                setState(() {
                  saving = true;
                  error = null;
                });
                try {
                  await widget.api.send(
                    widget.template == null ? 'POST' : 'PATCH',
                    widget.template == null
                        ? 'templates'
                        : 'templates/${widget.template!['id']}',
                    {
                      'name': name.text,
                      'documents': lines(documents),
                      'extra_fields': lines(fields),
                      'required_identity': identity.toList(),
                      'archived': archived ? 1 : 0,
                      if (widget.template != null)
                        'revision': widget.template!['revision'],
                    },
                  );
                  if (c.mounted) Navigator.pop(c, true);
                } catch (e) {
                  if (mounted) setState(() => error = '$e');
                } finally {
                  if (mounted) setState(() => saving = false);
                }
              },
        primary: true,
      ),
    ],
  );
}
