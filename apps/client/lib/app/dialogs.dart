part of 'workspace.dart';

extension _Dialogs on _WorkspaceState {
  Future<void> documentForm(JsonMap data, JsonMap d) async {
    final name = TextEditingController(text: d['name']);
    final type = TextEditingController(text: d['type']);
    final note = TextEditingController(text: d['note']);
    String folder = d['folder'], status = d['status'];
    final folders = List<JsonMap>.from(data['folders']);
    final oldArea = folders.firstWhere((f) => f['id'] == folder)['area'];
    final owner = List<JsonMap>.from(data['students'])
        .where((p) => p['folder'] == folder)
        .firstOrNull;
    final documentTypes = <String>{d['type']};
    if (owner == null) {
      for (final template in List<JsonMap>.from(data['templates'])) {
        documentTypes.addAll(List<String>.from(template['documents']));
      }
    } else {
      try {
        final person = await api.get('students/${owner['id']}');
        documentTypes.addAll([
          for (final item in person['requirements']) item['type'] as String,
        ]);
      } catch (e) {
        if (mounted) feedback(context, e);
      }
    }
    if (!mounted) {
      name.dispose();
      type.dispose();
      note.dispose();
      return;
    }
    bool saving = false;
    final staff =
        data['session']['user']['department'] != null ||
        data['session']['user']['role'] == 'admin';
    await showEditorDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Editar documento'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  field('Nome', name),
                  SuggestionField(
                    label: 'Tipo documental',
                    controller: type,
                    suggestions: documentTypes.toList(),
                  ),
                  selector(
                    'Pasta',
                    folder,
                    folders
                        .where(
                          (f) =>
                              f['area'] == oldArea ||
                              data['session']['user']['role'] == 'admin' ||
                              data['session']['user']['department'] ==
                                  'secretaria',
                        )
                        .map(
                          (f) => DropdownMenuItem(
                            value: f['id'] as String,
                            child: Text(pathOf(f['id'], folders)),
                          ),
                        )
                        .toList(),
                    (v) => set(() => folder = v!),
                  ),
                  if (staff)
                    selector(
                      'Conferência',
                      status,
                      [
                            'Aguardando conferência',
                            'Conferido',
                            'Precisa de correção',
                          ]
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      (v) => set(() => status = v!),
                    ),
                  field('Observação', note, lines: 2),
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
              'Salvar',
              saving
                  ? null
                  : () async {
                      set(() => saving = true);
                      try {
                        final r = await api.send(
                          'PATCH',
                          'documents/${d['id']}',
                          {
                            'revision': d['revision'],
                            'name': name.text,
                            'type': type.text,
                            'folder': folder,
                            'status': status,
                            'note': note.text,
                          },
                        );
                        stateChange(() => selected = r);
                        refresh();
                        if (c.mounted) Navigator.pop(c);
                      } catch (e) {
                        if (c.mounted) feedback(c, e);
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
    type.dispose();
    note.dispose();
  }

  Future<void> requestAction(JsonMap r, String action, String title) async {
    final text = TextEditingController();
    String department = r['department'] == 'secretaria'
        ? 'coordenacao'
        : 'secretaria';
    bool saving = false;
    await showEditorDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action == 'forward')
                  selector(
                    'Setor',
                    department,
                    ['secretaria', 'coordenacao']
                        .where((d) => d != r['department'])
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    (v) => department = v!,
                  ),
                field('Mensagem', text, lines: 4),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(c),
              child: const Text('Cancelar'),
            ),
            button(
              'Confirmar',
              saving
                  ? null
                  : () async {
                      set(() => saving = true);
                      try {
                        await api.send('POST', 'requests/${r['id']}/actions', {
                          'revision': r['revision'],
                          'action': action,
                          'text': text.text,
                          'department': department,
                        });
                        if (action == 'forward') {
                          stateChange(() => selected = null);
                        } else {
                          await choose(r, 'request');
                        }
                        refresh();
                        if (c.mounted) Navigator.pop(c);
                      } catch (e) {
                        if (c.mounted) feedback(c, e);
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
    text.dispose();
  }

  Future<void> attachForm(JsonMap data, JsonMap r) async {
    final docs = List<JsonMap>.from(data['documents']);
    String? id = docs.firstOrNull?['id'];
    await showEditorDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Associar documento'),
          content: SizedBox(
            width: 440,
            child: selector(
              'Documento existente',
              id,
              docs
                  .map(
                    (d) => DropdownMenuItem(
                      value: d['id'] as String,
                      child: Text(d['name']),
                    ),
                  )
                  .toList(),
              (v) => set(() => id = v),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Cancelar'),
            ),
            button(
              'Associar',
              id == null
                  ? null
                  : () async {
                      try {
                        await api.send(
                          'POST',
                          'requests/${r['id']}/documents',
                          {'document': id},
                        );
                        await choose(r, 'request');
                        refresh();
                        if (c.mounted) Navigator.pop(c);
                      } catch (e) {
                        if (c.mounted) feedback(c, e);
                      }
                    },
              primary: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> connection() async {
    final address = TextEditingController(text: api.base);
    bool testing = false;
    String? error;
    await showEditorDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Conexão e hospedagem'),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                field('Endereço do servidor', address),
                Text(
                  canHost
                      ? 'Hospedagem local: 127.0.0.1:8080. Encerrar o aplicativo também encerra o servidor que ele iniciou.'
                      : 'Informe o endereço da instalação da escola. No celular, localhost aponta para o próprio aparelho.',
                  style: const TextStyle(fontSize: 12),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      error!,
                      style: TextStyle(color: Theme.of(c).colorScheme.error),
                    ),
                  ),
                if (testing)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: testing ? null : () => Navigator.pop(c),
              child: const Text('Fechar'),
            ),
            if (canHost)
              button(
                'Hospedar nesta máquina',
                testing
                    ? null
                    : () async {
                        set(() {
                          testing = true;
                          error = null;
                        });
                        try {
                          await host();
                          await api.health('http://127.0.0.1:8080');
                          await preferences.setString('api', api.base);
                          refresh();
                          if (c.mounted) Navigator.pop(c);
                        } catch (e) {
                          set(() => error = e.toString());
                        } finally {
                          if (c.mounted) set(() => testing = false);
                        }
                      },
              ),
            button(
              'Testar e conectar',
              testing
                  ? null
                  : () async {
                      set(() {
                        testing = true;
                        error = null;
                      });
                      try {
                        await api.health(address.text);
                        await preferences.setString('api', api.base);
                        refresh();
                        if (c.mounted) Navigator.pop(c);
                      } catch (e) {
                        set(() => error = e.toString());
                      } finally {
                        if (c.mounted) set(() => testing = false);
                      }
                    },
              primary: true,
            ),
          ],
        ),
      ),
    );
    address.dispose();
  }

  Future<void> settings(JsonMap data) async {
    await showEditorDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Preferências'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                selector(
                  'Tema',
                  themeMode.value.name,
                  [
                    const DropdownMenuItem(
                      value: 'system',
                      child: Text('Sistema'),
                    ),
                    const DropdownMenuItem(
                      value: 'light',
                      child: Text('Claro'),
                    ),
                    const DropdownMenuItem(
                      value: 'dark',
                      child: Text('Escuro'),
                    ),
                  ],
                  (v) async {
                    themeMode.value = ThemeMode.values.firstWhere(
                      (m) => m.name == v,
                    );
                    await preferences.setInt('theme', themeMode.value.index);
                    set(() {});
                  },
                ),
                button('Conexão / Hospedagem', () {
                  Navigator.pop(c);
                  connection();
                }),
                const SizedBox(height: 16),
                if (data['session']['demo'] == true &&
                    data['session']['user']['role'] == 'admin')
                  button('Restaurar dados fictícios', () async {
                    if (await confirm(
                      c,
                      'Restaurar o banco demonstrativo? Os registros atuais serão removidos.',
                    )) {
                      try {
                        await api.send('POST', 'reset', {
                          'confirmation': 'RESTAURAR',
                        });
                        stateChange(() => selected = null);
                        go('documents');
                        refresh();
                        if (c.mounted) Navigator.pop(c);
                      } catch (e) {
                        if (c.mounted) feedback(c, e);
                      }
                    }
                  }),
                const SizedBox(height: 16),
                if (data['session']['demo'] != true)
                  button('Alterar minha senha', () async {
                    Navigator.pop(c);
                    await changePassword();
                  }),
                const SizedBox(height: 12),
                Text(
                  data['session']['demo'] == true
                      ? 'Perfis de demonstração não são autenticação. Utilize dados fictícios em ambiente controlado.'
                      : 'As contas são locais à instalação. A sessão dura até 8 horas e não é salva em disco neste cliente.',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    final old = TextEditingController(),
        password = TextEditingController(),
        confirmation = TextEditingController();
    bool busy = false;
    String? error;
    final changed = await showEditorDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Alterar minha senha'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: old,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha atual',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Nova senha (mínimo 12 caracteres)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: confirmation,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar nova senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Text(
                        error!,
                        style: TextStyle(color: Theme.of(c).colorScheme.error),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.pop(c, false),
              child: const Text('Cancelar'),
            ),
            button(
              busy ? 'Salvando…' : 'Alterar e entrar novamente',
              busy
                  ? null
                  : () async {
                      if (password.text.length < 12 ||
                          password.text != confirmation.text) {
                        set(
                          () => error = 'Use ao menos 12 caracteres e confirme a mesma senha.',
                        );
                        return;
                      }
                      set(() {
                        busy = true;
                        error = null;
                      });
                      try {
                        await api.send('POST', 'auth/password', {
                          'oldPassword': old.text,
                          'newPassword': password.text,
                        });
                        if (c.mounted) Navigator.pop(c, true);
                      } catch (e) {
                        if (c.mounted) set(() => error = '$e');
                      } finally {
                        if (c.mounted) set(() => busy = false);
                      }
                    },
              primary: true,
            ),
          ],
        ),
      ),
    );
    for (final controller in [old, password, confirmation]) {
      controller.dispose();
    }
    if (changed == true && mounted) {
      api.token = null;
      drafts.clear();
      go('students');
      refresh();
    }
  }

  Future<void> reviewForm(JsonMap d) async {
    var status = d['status'] as String;
    final note = TextEditingController(text: d['note']);
    await showEditorDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: const Text('Conferência documental'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                selector(
                  'Situação',
                  status,
                  ['Aguardando conferência', 'Conferido', 'Precisa de correção']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  (v) => set(() => status = v!),
                ),
                field('Observação', note, lines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Cancelar'),
            ),
            button('Salvar', () async {
              try {
                final updated = await api.send(
                  'POST',
                  'documents/${d['id']}/review',
                  {
                    'revision': d['revision'],
                    'status': status,
                    'note': note.text,
                  },
                );
                stateChange(() => selected = updated);
                refresh();
                if (c.mounted) Navigator.pop(c);
              } catch (e) {
                if (c.mounted) feedback(c, e);
              }
            }, primary: true),
          ],
        ),
      ),
    );
    note.dispose();
  }
}
