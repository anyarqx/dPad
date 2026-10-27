import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';

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
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AccountForm(
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        spacing: 16,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Contas e acessos',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          button(
            'Cadastrar conta',
            () => edit(),
            icon: FLucideIcons.userPlus,
            primary: true,
          ),
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        'Cada pessoa entra com seu usuário e senha. Alunos e responsáveis acessam somente os alunos vinculados.',
        style: TextStyle(fontSize: 13, height: 1.6),
      ),
      const SizedBox(height: 20),
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
            return ListView.separated(
              itemCount: s.data!.length,
              separatorBuilder: (_, i) => const PixelDivider(),
              itemBuilder: (c, i) {
                final a = s.data![i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Icon(
                    a['enabled'] == 1
                        ? FLucideIcons.userRound
                        : FLucideIcons.userRoundX,
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
                    '${a['login']} · ${roles[a['role']] ?? a['role']}${a['enabled'] == 1 ? '' : ' · Conta desativada'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(FLucideIcons.chevronRight, size: 18),
                  onTap: () => edit(a),
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
  const AccountForm({
    super.key,
    required this.api,
    required this.students,
    this.account,
  });
  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late final name = TextEditingController(text: widget.account?['name']);
  late final login = TextEditingController(text: widget.account?['login']);
  final password = TextEditingController(),
      confirmation = TextEditingController();
  late String role = widget.account?['role'] ?? 'professor';
  late bool enabled = widget.account?['enabled'] != 0;
  late final students = <String>{
    ...List<String>.from(widget.account?['students'] ?? []),
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
            ? 'accounts'
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
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.account == null ? 'Cadastrar conta' : 'Editar conta'),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              (v) => setState(() {
                role = v!;
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
            if (['aluno', 'responsavel'].contains(role)) ...[
              Text(
                role == 'aluno' ? 'Aluno vinculado' : 'Alunos vinculados',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (widget.students.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Cadastre primeiro a pasta do aluno.'),
                ),
              for (final p in widget.students)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(p['name'], style: const TextStyle(fontSize: 13)),
                  subtitle: p['registration'] == null
                      ? null
                      : Text('Matrícula ${p['registration']}'),
                  value: students.contains(p['id']),
                  onChanged: busy
                      ? null
                      : (v) => setState(() {
                          if (v!) {
                            if (role == 'aluno') students.clear();
                            students.add(p['id']);
                          } else {
                            students.remove(p['id']);
                          }
                        }),
                ),
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
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      button(
        busy ? 'Salvando…' : 'Salvar conta',
        busy ? null : save,
        primary: true,
      ),
    ],
  );
}
