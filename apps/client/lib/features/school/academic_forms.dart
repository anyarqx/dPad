import 'package:material_ui/material_ui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

class AcademicField {
  final String keyName, label;
  final String? tip, hint;
  final int lines;
  final bool integer;
  final Map<String, String>? options;
  const AcademicField(
    this.keyName,
    this.label, {
    this.tip,
    this.hint,
    this.lines = 1,
    this.integer = false,
    this.options,
  });
}

Future<bool> academicEditor(
  BuildContext context,
  Api api, {
  required String title,
  required String path,
  required List<AcademicField> fields,
  JsonMap initial = const {},
  JsonMap fixed = const {},
  String method = 'POST',
}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AcademicEditor(
        api: api,
        title: title,
        path: path,
        fields: fields,
        initial: initial,
        fixed: fixed,
        method: method,
      ),
    ) ??
    false;

class _AcademicEditor extends StatefulWidget {
  final Api api;
  final String title, path, method;
  final List<AcademicField> fields;
  final JsonMap initial, fixed;
  const _AcademicEditor({
    required this.api,
    required this.title,
    required this.path,
    required this.fields,
    required this.initial,
    required this.fixed,
    required this.method,
  });
  @override
  State<_AcademicEditor> createState() => _AcademicEditorState();
}

class _AcademicEditorState extends State<_AcademicEditor> {
  late final controllers = {
    for (final f in widget.fields)
      f.keyName: TextEditingController(
        text: widget.initial[f.keyName]?.toString() ?? '',
      ),
  };
  late final choices = {
    for (final f in widget.fields.where((f) => f.options != null))
      f.keyName: f.options!.containsKey(widget.initial[f.keyName]?.toString())
          ? widget.initial[f.keyName].toString()
          : f.options!.keys.firstOrNull ?? '',
  };
  bool saving = false;
  String? error;
  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final body = <String, dynamic>{
        ...widget.fixed,
        if (widget.initial.containsKey('revision'))
          'revision': widget.initial['revision'],
      };
      for (final f in widget.fields) {
        final value = f.options == null
            ? controllers[f.keyName]!.text
            : choices[f.keyName];
        if (f.integer) {
          final parsed = int.tryParse(value ?? '');
          if (parsed == null) {
            throw Exception('Informe um número inteiro em ${f.label}.');
          }
          body[f.keyName] = parsed;
        } else {
          body[f.keyName] = value;
        }
      }
      await widget.api.send(widget.method, widget.path, body);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext c) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 540,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final f in widget.fields)
              if (f.options == null)
                field(
                  f.label,
                  controllers[f.keyName]!,
                  tip: f.tip,
                  hint: f.hint,
                  keyboardType: f.integer ? TextInputType.number : null,
                  lines: f.lines,
                  enabled: !saving,
                )
              else
                selector(
                  f.label,
                  choices[f.keyName],
                  [
                    for (final e in f.options!.entries)
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                  ],
                  (v) => setState(() => choices[f.keyName] = v ?? ''),
                  tip: f.tip,
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
        onPressed: saving ? null : () => Navigator.pop(c, false),
        child: const Text('Cancelar'),
      ),
      button(
        saving ? 'Salvando…' : 'Salvar',
        saving ? null : save,
        primary: true,
      ),
    ],
  );
}
