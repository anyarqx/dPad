import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import '../../shared/page_header.dart';
import '../../shared/search_picker.dart';

const roles = {
  'admin': 'Administração',
  'secretaria': 'Secretaria',
  'coordenacao': 'Coordenação',
  'professor': 'Professor',
  'gremio': 'Grêmio',
  'aluno': 'Aluno',
  'responsavel': 'Responsável',
};

class AccountsPage extends StatefulWidget {
  final Api api;
  final JsonMap data;
  final VoidCallback changed;
  const AccountsPage({
    super.key,
    required this.api,
    required this.data,
    required this.changed,
  });
  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late Future<List<JsonMap>> accounts;
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    accounts = widget.api.get('accounts').then((v) => List<JsonMap>.from(v));
  }

  Future<void> edit([JsonMap? account]) async {
    final saved = await openEditor<bool>(
      context,
      AccountForm(
        api: widget.api,
        students: List<JsonMap>.from(widget.data['students']),
        account: account,
      ),
    );
    if (saved == true && mounted) {
      setState(load);
      widget.changed();
    }
  }

  @override
  Widget build(BuildContext context) => PageLayout(
    header: PageHeader(
      title: 'Contas e acessos',
      actions: [
        button(
          'Cadastrar conta',
          () => edit(),
          icon: FLucideIcons.userPlus,
          primary: true,
        ),
      ],
    ),
    headerPrefix: [],
    children: [
      Expanded(
        child: FutureBuilder<List<JsonMap>>(
          future: accounts,
          builder: (c, s) {
            if (s.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${s.error}'),
                    TextButton(
                      onPressed: () => setState(load),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (s.data!.isEmpty) {
              return const Center(child: Text('Nenhuma conta cadastrada.'));
            }
            return ListView.separated(
              itemCount: s.data!.length,
              separatorBuilder: (_, i) => const PixelDivider(),
              itemBuilder: (c, i) {
                final a = s.data![i];
                final hasLogin = a['login'] != null;
                final disabled = a['enabled'] == 0;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Icon(
                    disabled ? FLucideIcons.userRoundX : FLucideIcons.userRound,
                    size: 22,
                  ),
                  title: Text(
                    a['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    '${roles[a['role']] ?? a['role']} · ${a['login'] ?? 'Perfil de teste'}${disabled ? ' · Conta desativada' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: hasLogin
                      ? const Icon(FLucideIcons.chevronRight, size: 18)
                      : null,
                  onTap: hasLogin ? () => edit(a) : null,
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

class AccountForm extends StatefulWidget {
  final Api api;
  final List<JsonMap> students;
  final JsonMap? account;
  final JsonMap preset;
  final String? provisionStudent;
  const AccountForm({
    super.key,
    required this.api,
    required this.students,
    this.account,
    this.preset = const {},
    this.provisionStudent,
  });
  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late final name = TextEditingController(
    text: (widget.account ?? widget.preset)['name'],
  );
  late final login = TextEditingController(
    text: (widget.account ?? widget.preset)['login'],
  );
  final password = TextEditingController(),
      confirmation = TextEditingController();
  late String role = (widget.account ?? widget.preset)['role'] ?? 'professor';
  late bool enabled = (widget.account ?? widget.preset)['enabled'] != 0;
  late final students = <String>{
    ...List<String>.from((widget.account ?? widget.preset)['students'] ?? []),
  };
  bool busy = false;
  String? error;
  @override
  void dispose() {
    for (final c in [name, login, password, confirmation]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (name.text.trim().isEmpty) {
      setState(() => error = 'Informe o nome.');
      return;
    }
    if ((widget.account == null || password.text.isNotEmpty) &&
        (password.text.length < 12 || password.text != confirmation.text)) {
      setState(
        () => error = 'Use ao menos 12 caracteres e confirme a mesma senha.',
      );
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.api.send(
        widget.account == null ? 'POST' : 'PATCH',
        widget.account == null
            ? widget.provisionStudent == null
                  ? 'accounts'
                  : 'students/${widget.provisionStudent}/account'
            : 'accounts/${widget.account!['id']}',
        {
          'name': name.text,
          'login': login.text,
          'role': role,
          'enabled': enabled ? 1 : 0,
          'students': students.toList(),
          if (password.text.isNotEmpty) 'password': password.text,
          if (widget.account != null) 'revision': widget.account!['revision'],
        },
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => EditorPage(
    title: widget.account == null ? 'Cadastrar conta' : 'Editar conta',
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.provisionStudent != null && role == 'aluno')
            readOnlyValue('Aluno', Text(widget.preset['name']))
          else
            field('Nome completo', name),
          if (widget.account == null)
            field('Usuário para entrar', login)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('Usuário: ${login.text}'),
            ),
          selector(
            'Papel',
            role,
            roles.entries
                .where(
                  (e) =>
                      widget.provisionStudent == null ||
                      ['aluno', 'responsavel'].contains(e.key),
                )
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            (v) => setState(() {
              role = v!;
              if (widget.provisionStudent != null) {
                name.text = role == 'aluno'
                    ? widget.preset['name']
                    : (widget.preset['guardian'] ?? '');
              }
              if (!['aluno', 'responsavel'].contains(role)) students.clear();
              if (role == 'aluno' && students.length > 1) students.clear();
            }),
          ),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: widget.account == null
                  ? 'Senha inicial (mínimo 12 caracteres)'
                  : 'Nova senha (opcional)',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: confirmation,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar senha',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.account != null)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Conta ativa'),
              value: enabled,
              onChanged: busy ? null : (v) => setState(() => enabled = v!),
            ),
          if (widget.provisionStudent == null &&
              ['aluno', 'responsavel'].contains(role)) ...[
            Text(
              role == 'aluno' ? 'Aluno vinculado' : 'Alunos vinculados',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (widget.students.isEmpty) const Text('Nenhum aluno cadastrado.'),
            if (role == 'aluno')
              SearchPicker(
                label: 'Aluno',
                value: students.firstOrNull,
                choices: [
                  for (final p in widget.students)
                    SearchChoice(
                      p['id'],
                      p['name'],
                      description: p['registration'] ?? '',
                    ),
                ],
                onChanged: (id) => setState(() {
                  students.clear();
                  students.add(id);
                }),
              ),
            if (role == 'responsavel') ...[
              TextButton.icon(
                onPressed: busy
                    ? null
                    : () async {
                        final selected = await pickMany(
                          context,
                          title: 'Vincular alunos',
                          choices: [
                            for (final p in widget.students)
                              SearchChoice(
                                p['id'],
                                p['name'],
                                description: p['registration'] ?? '',
                              ),
                          ],
                          selected: students,
                          maximum: 30,
                        );
                        if (selected != null && mounted) {
                          setState(() {
                            students.clear();
                            students.addAll(selected);
                          });
                        }
                      },
                icon: const Icon(FLucideIcons.search, size: 18),
                label: Text('Selecionar alunos (${students.length})'),
              ),
              for (final p
                  in widget.students
                      .where((p) => students.contains(p['id']))
                      .take(3))
                Text(p['name']),
              if (students.length > 3) Text('e mais ${students.length - 3}'),
            ],
          ],
          const SizedBox(height: 12),
          const Text(
            'Alterar senha, papel ou vínculos encerra as sessões da conta. Não envie senhas por canais públicos.',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    ),
    actions: [
      button('Salvar conta', busy ? null : save, primary: true, loading: busy),
    ],
  );
}
