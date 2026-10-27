import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'widgets.dart';
import 'search_picker.dart';

class BrazilianLocalities {
  final List<SearchChoice> cities;
  final Map<String, String> states;
  BrazilianLocalities(this.cities, this.states);
  static final Future<BrazilianLocalities> catalog = _load();
  static Future<BrazilianLocalities> _load() async {
    final json = jsonDecode(
      await rootBundle.loadString('assets/data/br-localities.json'),
    ) as Map;
    final states = {
      for (final state in json['states'])
        state[2] as String: state[1] as String,
    };
    return BrazilianLocalities([
      for (final city in json['cities'])
        SearchChoice(
          '${city[1]} / ${city[2]}',
          '${city[1]} / ${city[2]}',
          description: '${states[city[2]]} · IBGE ${city[0]}',
        ),
    ], states);
  }
}

class LocalityField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String label;
  const LocalityField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.label = 'Naturalidade',
  });
  Future<void> select(BuildContext context) async {
    try {
      final catalog = await BrazilianLocalities.catalog;
      if (!context.mounted) return;
      final result = await pickChoice(
        context,
        title: label,
        choices: [SearchChoice('', 'Não informado'), ...catalog.cities],
        selected: controller.text,
        hint: 'Município, UF ou estado — ex.: Santarém PA',
        allowCustom: true,
      );
      if (result != null) controller.text = result;
    } catch (e) {
      if (context.mounted) {
        feedback(
          context,
          'Não foi possível carregar o catálogo de municípios. $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext c) => ValueListenableBuilder(
    valueListenable: controller,
    builder: (c, value, _) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        key: ValueKey('picker:$label'),
        onTap: enabled ? () => select(c) : null,
        child: InputDecorator(
          isEmpty: value.text.isEmpty,
          decoration: InputDecoration(
            enabled: enabled,
            label: fieldLabel(
              label,
              'Pesquise município e UF na lista do IBGE. Para uma localidade no exterior ou localidade não encontrada, digite a identificação e escolha Usar.',
            ),
            isDense: true,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.search, size: 19),
          ),
          child: Text(
            value.text.isEmpty ? 'Selecionar município / UF' : value.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(c).textTheme.bodyMedium,
          ),
        ),
      ),
    ),
  );
}

class AddressField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  const AddressField({
    super.key,
    required this.controller,
    this.enabled = true,
  });
  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  late final street = TextEditingController(), city = TextEditingController();
  @override
  void initState() {
    super.initState();
    final value = widget.controller.text,
        marker = value.lastIndexOf('\nMunicípio: ');
    street.text = marker < 0 ? value : value.substring(0, marker);
    city.text = marker < 0
        ? ''
        : value.substring(marker + '\nMunicípio: '.length);
    street.addListener(update);
    city.addListener(update);
  }

  void update() {
    final value = [
      street.text.trim(),
      if (city.text.isNotEmpty) 'Município: ${city.text}',
    ].join('\n');
    if (widget.controller.text != value) widget.controller.text = value;
  }

  @override
  void dispose() {
    street.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      field(
        'Endereço de residência',
        street,
        lines: 2,
        enabled: widget.enabled,
        hint: 'Logradouro, número, bairro, complemento e CEP',
        tip: 'Informe o endereço e escolha o município no campo seguinte. Endereços já cadastrados são preservados.',
      ),
      LocalityField(
        controller: city,
        enabled: widget.enabled,
        label: 'Município de residência',
      ),
    ],
  );
}
