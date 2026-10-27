import 'package:material_ui/material_ui.dart';

import '../../shared/api.dart';
import '../../shared/app_logo.dart';
import '../../shared/widgets.dart';

class AuthPage extends StatefulWidget {
  final Api api;
  final JsonMap status;
  final VoidCallback authenticated, connection;
  final String? message;
  const AuthPage({
    super.key,
    required this.api,
    required this.status,
    required this.authenticated,
    required this.connection,
    this.message,
  });
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final name = TextEditingController(),
      login = TextEditingController(),
      password = TextEditingController(),
      confirmation = TextEditingController();
  bool busy = false;
  String? error;
  @override
  void dispose() {
    for (final c in [name, login, password, confirmation]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    final setup = widget.status['setupRequired'] == true;
    if (setup && password.text != confirmation.text) {
      setState(() => error = 'As senhas precisam ser iguais.');
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.api.authenticate({
        'name': name.text,
        'login': login.text,
        'password': password.text,
      }, setup: setup);
      widget.authenticated();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = widget.status['setupRequired'] == true;
    final remoteSetup = setup && widget.status['setupLocal'] != true;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AppLogo(size: 52),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    setup ? 'Configurar a instalação' : 'Entrar na escola',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    remoteSetup
                        ? 'O administrador precisa configurar a instalação no computador do servidor antes do primeiro acesso.'
                        : setup
                        ? 'Crie a conta administrativa. Depois, cadastre as contas da equipe, dos alunos e dos responsáveis.'
                        : 'Use a conta cadastrada pela administração.',
                    style: const TextStyle(fontSize: 13, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  if (!remoteSetup) ...[
                    if (setup) field('Nome do administrador', name),
                    TextField(
                      controller: login,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: const [AutofillHints.username],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: setup
                            ? 'Senha (mínimo 12 caracteres)'
                            : 'Senha',
                        border: const OutlineInputBorder(),
                      ),
                      autofillHints: [
                        setup
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      onSubmitted: (_) => busy ? null : submit(),
                    ),
                    if (setup) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmation,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar senha',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    if (error != null || widget.message != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          error ?? widget.message!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    button(
                      busy
                          ? 'Aguarde…'
                          : setup
                          ? 'Criar administrador'
                          : 'Entrar',
                      busy ? null : submit,
                      primary: true,
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: busy ? null : widget.connection,
                    child: const Text('Alterar conexão'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.api.base,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
