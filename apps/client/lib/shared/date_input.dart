import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import 'field_help.dart';

class SchoolDateMask extends TextInputFormatter {
  const SchoolDateMask();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var source = newValue.text;
    final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(source);
    if (iso != null) source = '${iso[3]}${iso[2]}${iso[1]}';
    var digits = source.replaceAll(RegExp(r'\D'), '');
    if (oldValue.text.endsWith('/') &&
        newValue.text == oldValue.text.substring(0, oldValue.text.length - 1) &&
        digits.isNotEmpty) {
      digits = digits.substring(0, digits.length - 1);
    }
    digits = digits.substring(0, digits.length.clamp(0, 8));
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      out.write(digits[i]);
      if (i == 1 || i == 3) out.write('/');
    }
    final text = out.toString();
    var cursor = text.length;
    if (iso == null &&
        newValue.selection.isValid &&
        newValue.selection.baseOffset < newValue.text.length) {
      final before = newValue.text
          .substring(
            0,
            newValue.selection.baseOffset.clamp(0, newValue.text.length),
          )
          .replaceAll(RegExp(r'\D'), '')
          .length;
      var seen = 0;
      cursor = 0;
      while (cursor < text.length && seen < before) {
        if (text[cursor] != '/') seen++;
        cursor++;
      }
      if (cursor < text.length && text[cursor] == '/') cursor++;
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }
}

DateTime? schoolDate(String value) {
  final iso = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
  if (!iso && !RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
    return null;
  }
  try {
    final format = DateFormat(iso ? 'yyyy-MM-dd' : 'dd/MM/yyyy');
    final date = format.parseStrict(value);
    return date.year >= 1900 && date.year <= 2200 ? date : null;
  } catch (_) {
    return null;
  }
}

class SchoolDateInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool iso, enabled;
  final String? tip;
  const SchoolDateInput({
    super.key,
    required this.label,
    required this.controller,
    required this.iso,
    this.enabled = true,
    this.tip,
  });
  @override
  State<SchoolDateInput> createState() => _SchoolDateInputState();
}

class _SchoolDateInputState extends State<SchoolDateInput> {
  final display = TextEditingController();
  bool writing = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(sync);
    sync();
  }

  void sync() {
    if (writing) return;
    final date = schoolDate(widget.controller.text);
    display.text = date == null
        ? widget.controller.text
        : DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  void didUpdateWidget(covariant SchoolDateInput old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(sync);
      widget.controller.addListener(sync);
      sync();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(sync);
    display.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: FTextField(
      key: ValueKey('field:${widget.label}'),
      label: fieldLabel(
        widget.label.replaceAll(RegExp(r'\s*\((DD/MM/AAAA|AAAA-MM-DD)\)'), ''),
        widget.tip ?? 'Digite dia, mês e ano. As barras são inseridas automaticamente. Exemplo: 13/04/2026.',
      ),
      hint: 'DD/MM/AAAA',
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      inputFormatters: const [SchoolDateMask()],
      control: FTextFieldControl.managed(
        controller: display,
        onChange: (value) {
          final date = schoolDate(value.text);
          writing = true;
          widget.controller.text = date == null
              ? value.text
              : DateFormat(widget.iso ? 'yyyy-MM-dd' : 'dd/MM/yyyy')
                    .format(date);
          writing = false;
        },
      ),
    ),
  );
}
