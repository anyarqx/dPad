import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';

import 'field_help.dart';
import 'search_picker.dart';
export 'field_help.dart';

Widget button(
  String label,
  VoidCallback? action, {
  IconData? icon,
  bool primary = false,
}) => IntrinsicWidth(
  child: FButton(
    variant: primary ? FButtonVariant.primary : FButtonVariant.outline,
    onPress: action,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 7)],
        Text(label),
      ],
    ),
  ),
);
const fieldHints = <String, String>{
  'Nascimento (DD/MM/AAAA)': 'DD/MM/AAAA',
  'Data (DD/MM/AAAA)': 'DD/MM/AAAA',
  'E-mail': 'nome@dominio.com',
  'Telefone de contato': '(DDD) número',
  'Nome / código da turma': 'Ex.: INF-2026-A',
  'Ano letivo': 'AAAA',
  'Período de ingresso (anual, semestre ou ciclo)': 'Ex.: 2026.1',
  'Modalidade': 'Ex.: Integrado ou Regular',
  'Duração / organização (opcional)': 'Ex.: 3 anos / 6 fases',
  'Quantidade de aulas': '1 a 20',
};
const fieldTips = <String, String>{
  'Nome completo *':
      'Use o nome conforme o documento de identificação, sem abreviações.',
  'Matrícula ou identificação':
      'Identificador interno único da instituição. Pode ser informado depois.',
  'Nascimento (DD/MM/AAAA)':
      'Exemplo: 15/03/2008. Não informe uma data futura.',
  'Responsável': 'Pessoa de referência para contato. O acesso ao sistema é vinculado em Contas e acessos.',
  'Telefone de contato': 'Inclua DDD. Exemplo: (93) 90000-0000.',
  'E-mail': 'Endereço usado para contato; não cria uma conta de acesso.',
  'Observações': 'Registre apenas informações necessárias ao atendimento.',
  'Nome do curso ou formação': 'Exemplo: Técnico em Informática.',
  'Modalidade': 'Exemplo: Integrado, Subsequente, Concomitante ou EJA.',
  'Duração / organização (opcional)':
      'Exemplo: 3 anos, organizados em fases semestrais.',
  'Nome / código da turma':
      'Use um código que diferencie a oferta. Exemplo: INF-2026-A.',
  'Ano letivo': 'Ano em que a turma funciona, com quatro dígitos.',
  'Período de ingresso (anual, semestre ou ciclo)':
      'Identifica a oferta de matrícula. Exemplo: 2026.1 ou Anual.',
  'Etapa, série ou módulo': 'Etapa inicial da turma. Os componentes de cada fase são cadastrados na matriz.',
  'Capacidade de alunos ativos': 'Limite de matrículas ativas. Matrículas em análise não ocupam vaga até a ativação.',
  'Nome completo': 'Nome de identificação desta conta; a vinculação ao aluno é configurada separadamente.',
  'Usuário para entrar': 'Entre 3 e 80 caracteres: letras sem acento, números, ponto, traço ou sublinhado.',
  'Nome do administrador':
      'Pessoa responsável pela administração desta instalação.',
  'Nome do modelo':
      'Identifique a finalidade. Exemplo: Ingresso no ensino médio.',
  'Documentos exigidos (um por linha)': 'Cada linha define um tipo documental esperado. Não inclua instruções ou números pessoais.',
  'Informações adicionais exigidas (uma por linha)':
      'Nomes de campos exigidos pelo modelo. Exemplo: Contato alternativo.',
  'Nome do documento':
      'Nome para localizar o arquivo na pasta. Não altera seu conteúdo.',
  'Nome': 'Nome visível na lista.',
  'Tipo documental': 'Categoria usada na conferência. Use o mesmo nome previsto no modelo da pasta.',
  'Assunto': 'Descreva o pedido em uma frase curta.',
  'Descrição / texto do requerimento': 'Informe o que precisa e o contexto necessário ao atendimento. Revise antes de enviar.',
  'Data (DD/MM/AAAA)': 'Data da aula já realizada, dentro do ano letivo.',
  'Quantidade de aulas':
      'Número de horas-aula registradas nesta data, entre 1 e 20.',
  'Conteúdo e atividades realizadas': 'Registre o conteúdo ministrado e as atividades desenvolvidas nesta aula.',
  'Mensagem': 'Informe a resposta, a pendência ou o motivo do encaminhamento.',
  'Observação': 'Descreva o problema identificado e a correção necessária.',
  'Informação': 'Nome do campo adicional.',
  'Valor': 'Informação fornecida pela pessoa para esse campo.',
  'Endereço do servidor':
      'URL HTTP(S) da instalação. Exemplo: https://escola.exemplo.br.',
  'Senha': 'Use ao menos 12 caracteres. Evite nomes e datas previsíveis.',
  'Motivo da devolução':
      'Descreva o que precisa ser corrigido antes de reenviar.',
};
Widget field(
  String label,
  TextEditingController c, {
  int lines = 1,
  String? tip,
  String? hint,
  bool enabled = true,
  TextInputType? keyboardType,
  Widget? trailing,
}) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: FTextField(
    key: ValueKey('field:$label'),
    label: fieldLabel(label, tip ?? fieldTips[label]),
    hint: hint ?? fieldHints[label],
    enabled: enabled,
    keyboardType:
        keyboardType ??
        (label.contains('/AAAA)') || label.contains('AAAA-MM-DD)')
            ? TextInputType.datetime
            : null),
    suffixBuilder: trailing != null
        ? (_, _, _) => trailing
        : label.contains('/AAAA)') || label.contains('AAAA-MM-DD)')
        ? (context, style, variants) => IconButton(
            tooltip: 'Selecionar data',
            icon: const Icon(FLucideIcons.calendarDays, size: 17),
            onPressed: !enabled
                ? null
                : () async {
                    final format = DateFormat(
                      label.contains('AAAA-MM-DD')
                          ? 'yyyy-MM-dd'
                          : 'dd/MM/yyyy',
                    );
                    DateTime initial = DateTime.now();
                    try {
                      initial = format.parseStrict(c.text.trim());
                    } catch (_) {}
                    if (initial.year < 1900 || initial.year > 2200) {
                      initial = DateTime.now();
                    }
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2200, 12, 31),
                    );
                    if (picked != null) {
                      c.text = format.format(picked);
                    }
                  },
          )
        : null,
    control: FTextFieldControl.managed(controller: c),
    maxLines: lines,
  ),
);
Widget sectionHeading(String title, {String? description}) => Padding(
  padding: const EdgeInsets.only(top: 8, bottom: 14),
  child: Builder(
    builder: (c) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(c).textTheme.titleSmall!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        if (description != null) ...[
          const SizedBox(height: 5),
          Text(
            description,
            style: Theme.of(c).textTheme.bodySmall!.copyWith(
              color: FTheme.of(c).colors.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ],
    ),
  ),
);
Widget loadingLine(bool loading) => SizedBox(
  width: double.infinity,
  height: 2,
  child: loading ? const LinearProgressIndicator(minHeight: 2) : null,
);
String date(dynamic v) => v == null
    ? '—'
    : DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(v).toLocal());
String size(dynamic v) => v == null
    ? '—'
    : v < 1024
    ? '$v B'
    : v < 1048576
    ? '${(v / 1024).toStringAsFixed(0)} KB'
    : '${(v / 1048576).toStringAsFixed(1)} MB';
void feedback(BuildContext c, Object error) => ScaffoldMessenger.of(c)
    .showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
    );
Future<bool> confirm(BuildContext c, String text) async =>
    await showDialog<bool>(
      context: c,
      builder: (c) => AlertDialog(
        title: const Text('Confirmar operação'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ) ??
    false;
Future<T?> formDialog<T>(
  BuildContext c,
  String title,
  Widget content,
  List<Widget> actions,
) => showDialog<T>(
  context: c,
  builder: (c) => AlertDialog(
    title: Text(title),
    content: SizedBox(width: 480, child: SingleChildScrollView(child: content)),
    actions: actions,
  ),
);
Widget selector(
  String label,
  String? value,
  List<DropdownMenuItem<String>> items,
  ValueChanged<String?> changed, {
  String? tip,
}) => items.length > 8
    ? SearchPicker(
        label: label,
        value: value,
        choices: [
          for (final item in items)
            SearchChoice(
              item.value!,
              item.child is Text
                  ? (item.child as Text).data ?? item.value!
                  : item.value!,
            ),
        ],
        onChanged: changed,
        tip: tip,
      )
    : Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          itemHeight: null,
          selectedItemBuilder: (_) => [
            for (final item in items)
              DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: item.child,
              ),
          ],
          decoration: InputDecoration(
            label: fieldLabel(label, tip),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          items: items,
          onChanged: changed,
        ),
      );
Widget badge(String text) => Builder(
  builder: (c) {
    final dark = Theme.of(c).brightness == Brightness.dark;
    final good = [
      'Concluída',
      'Conferido',
      'Publicado',
      'Ativa',
      'Presente',
      'Deferida',
    ].contains(text);
    final alert = [
      'Precisa de correção',
      'Aguardando solicitante',
      'Ausente',
      'Indeferida',
    ].contains(text);
    final foreground = good
        ? (dark ? const Color(0xFF89E2BB) : const Color(0xFF17603F))
        : alert
        ? (dark ? const Color(0xFFF2CF91) : const Color(0xFF785010))
        : FTheme.of(c).colors.mutedForeground;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: dark ? .16 : .09),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  },
);

Future<T?> showEditorDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    themes: InheritedTheme.capture(from: context, to: navigator.context),
  );
  final result = await navigator.push(route);
  // Os controladores do formulário só podem ser liberados após a animação de saída.
  await route.completed;
  return result;
}

class PixelDivider extends StatelessWidget {
  final Axis axis;
  const PixelDivider({super.key, this.axis = Axis.horizontal});
  @override
  Widget build(BuildContext context) {
    final thickness = 1 / MediaQuery.devicePixelRatioOf(context);
    return SizedBox(
      height: axis == Axis.horizontal ? thickness : null,
      width: axis == Axis.vertical ? thickness : null,
      child: ColoredBox(color: FTheme.of(context).colors.border),
    );
  }
}
