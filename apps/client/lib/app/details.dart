part of 'workspace.dart';

extension _Details on _WorkspaceState {
  Widget details(JsonMap data, {VoidCallback? onClose}) {
    final item = selected!;
    final folders = List<JsonMap>.from(data['folders']);
    final u = data['session']['user'];
    final isDoc = kind == 'document';
    final imageFuture = isDoc && item['mime'].toString().startsWith('image/')
        ? (selectedImage ??= api.bytes(item['id']))
        : null;

    final own = folders.any((f) => f['id'] == item['folder']);
    final student = List<JsonMap>.from(data['students'])
        .where(
          (p) => isDoc
              ? p['folder'] == item['folder']
              : p['id'] == item['student'],
        )
        .firstOrNull;
    Widget meta(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 3),
          SelectableText(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'DETALHES',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Fechar detalhes',
                onPressed: onClose ?? closeDetails,
                icon: const Icon(FLucideIcons.x, size: 17),
              ),
            ],
          ),
        ),
        const PixelDivider(),
        loadingLine(detailLoading),
        Expanded(
          child: detailLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  key: ValueKey('details-${item['id']}'),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isDoc) ...[
                        if (imageFuture != null)
                          SizedBox(
                            height: 160,
                            child: FutureBuilder<Uint8List>(
                              key: ValueKey('image-${item['id']}'),
                              future: imageFuture,
                              builder: (c, s) => s.hasError
                                  ? const Center(
                                      child: Text(
                                        'Prévia indisponível. Use Abrir / baixar.',
                                      ),
                                    )
                                  : !s.hasData
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        s.data!,
                                        fit: BoxFit.contain,
                                        cacheWidth: 700,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              const Icon(FLucideIcons.fileText, size: 25),
                              const SizedBox(width: 10),
                              Text(
                                item['mime'] == 'application/pdf'
                                    ? 'Documento PDF'
                                    : 'Arquivo',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        item['name'] ?? item['subject'],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (isDoc) ...[
                        badge(item['status']),
                        const SizedBox(height: 16),
                        meta(
                          'Formato / tamanho',
                          '${item['mime'] == 'application/pdf' ? 'PDF' : item['mime'].toString().split('/').last.toUpperCase()} · ${size(item['size'])}',
                        ),
                        meta('Tipo documental', item['type']),
                        meta('Pasta', pathOf(item['folder'], folders)),
                        if (student != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: button(
                              'Abrir pasta do aluno',
                              () => go('students', student['id']),
                              icon: FLucideIcons.userRound,
                            ),
                          ),
                        meta(
                          'Aluno',
                          List<JsonMap>.from(data['students'])
                                  .where((p) => p['folder'] == item['folder'])
                                  .firstOrNull?['name'] ??
                              (own
                                  ? 'Sem vínculo'
                                  : 'Arquivo compartilhado por solicitação'),
                        ),
                        meta('Enviado em', date(item['created'])),
                        if (u['department'] != null || u['role'] == 'admin')
                          button('Conferir documento', () => reviewForm(item)),
                        if (item['note'] != '')
                          meta('Observação', item['note']),
                        button(
                          'Abrir / baixar',
                          busy
                              ? null
                              : () => run(() async {
                                  final b = await api.bytes(item['id']);
                                  if (mounted) {
                                    await preview(
                                      context,
                                      b,
                                      item['name'],
                                      pdf: item['mime'] == 'application/pdf',
                                    );
                                  }
                                }),
                          icon: FLucideIcons.externalLink,
                          primary: true,
                        ),
                        if (own) ...[
                          const SizedBox(height: 8),
                          button(
                            'Editar / mover',
                            () => documentForm(data, item),
                          ),
                          const SizedBox(height: 8),
                          button(
                            'Excluir documento',
                            busy
                                ? null
                                : () => run(() async {
                                    if (await confirm(
                                      context,
                                      'Excluir “${item['name']}” permanentemente?',
                                    )) {
                                      await api.send(
                                        'DELETE',
                                        'documents/${item['id']}',
                                      );
                                      closeDetails();
                                    }
                                  }),
                          ),
                        ],
                      ],
                      if (kind == 'request') ...[
                        meta('Protocolo', item['protocol']),
                        if (student != null || item['student_name'] != null)
                          meta(
                            'Aluno',
                            student?['name'] ?? item['student_name'],
                          ),
                        badge(item['state']),
                        const SizedBox(height: 16),
                        meta(
                          'Setor responsável',
                          {
                                'secretaria': 'Secretaria',
                                'coordenacao': 'Coordenação',
                              }[item['department']] ??
                              item['department'],
                        ),
                        meta('Criada em', date(item['created'])),
                        meta('Última atualização', date(item['updated'])),
                        meta(
                          'Solicitante',
                          item['requester_name'] ??
                              List<JsonMap>.from(data['session']['users'])
                                  .where((u) => u['id'] == item['requester'])
                                  .firstOrNull?['name'] ??
                              item['requester'],
                        ),
                        meta('Descrição', item['description']),
                        if (item['result'] != '')
                          meta('Resposta', item['result']),
                        for (final doc in List<JsonMap>.from(
                          item['documents'] ?? [],
                        ))
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: const Icon(
                              FLucideIcons.paperclip,
                              size: 16,
                            ),
                            title: Text(
                              doc['name'],
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () => run(() async {
                              final bytes = await api.bytes(doc['id']);
                              if (mounted) {
                                await preview(
                                  context,
                                  bytes,
                                  doc['name'],
                                  pdf: doc['mime'] == 'application/pdf',
                                );
                              }
                            }),
                            trailing: IconButton(
                              tooltip: 'Detalhes de ${doc['name']}',
                              onPressed: () => choose(doc, 'document'),
                              icon: const Icon(
                                FLucideIcons.panelRight,
                                size: 17,
                              ),
                            ),
                          ),
                        if (item['state'] != 'Concluída')
                          button(
                            'Associar documento',
                            () => attachForm(data, item),
                          ),
                        if (item['service'] == 'requerimento') ...[
                          const SizedBox(height: 8),
                          button(
                            'Gerar requerimento PDF',
                            busy
                                ? null
                                : () => run(() async {
                                    final b = await api.pdf(item['id']);
                                    if (!mounted) return;
                                    await preview(
                                      context,
                                      b,
                                      'Requerimento.pdf',
                                    );
                                    if (!mounted ||
                                        item['state'] == 'Concluída') {
                                      return;
                                    }
                                    JsonMap? uploaded;
                                    final saved = await uploadDialog(
                                      context,
                                      api,
                                      folders,
                                      student?['folder'] ??
                                          folders.firstOrNull?['id'],
                                      fixedDestination: student != null,
                                      personName: student?['name'],
                                      bytes: b,
                                      filename: 'Requerimento.pdf',
                                      onUploaded: (d) => uploaded = d,
                                    );
                                    if (saved == true) {
                                      await api.send(
                                        'POST',
                                        'requests/${item['id']}/documents',
                                        {'document': uploaded!['id']},
                                      );
                                      await choose(item, 'request');
                                    }
                                  }),
                          ),
                        ],
                        const SizedBox(height: 16),
                        if (item['requester'] == u['id'] &&
                            item['state'] == 'Aguardando solicitante')
                          button(
                            'Responder pendência',
                            () => requestAction(
                              item,
                              'complement',
                              'Responder pendência',
                            ),
                          ),
                        if ((u['role'] == 'admin' ||
                                u['department'] == item['department']) &&
                            item['state'] != 'Concluída')
                          Wrap(
                            runSpacing: 8,
                            spacing: 6,
                            children: [
                              if (item['state'] == 'Recebida')
                                button(
                                  'Iniciar atendimento',
                                  busy
                                      ? null
                                      : () => run(() async {
                                          await api.send(
                                            'POST',
                                            'requests/${item['id']}/actions',
                                            {
                                              'revision': item['revision'],
                                              'action': 'start',
                                            },
                                          );
                                          await choose(item, 'request');
                                        }),
                                  primary: true,
                                ),
                              if (item['state'] == 'Em atendimento') ...[
                                button(
                                  'Pedir complemento',
                                  () => requestAction(
                                    item,
                                    'ask',
                                    'Solicitar complemento',
                                  ),
                                ),
                                button(
                                  'Registrar resposta',
                                  () => requestAction(
                                    item,
                                    'answer',
                                    'Registrar resposta',
                                  ),
                                ),
                                button(
                                  'Concluir',
                                  () => requestAction(
                                    item,
                                    'complete',
                                    'Concluir solicitação',
                                  ),
                                  primary: true,
                                ),
                              ],
                              button(
                                'Encaminhar',
                                () => requestAction(
                                  item,
                                  'forward',
                                  'Encaminhar solicitação',
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        const Text(
                          'HISTÓRICO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (final e in List<JsonMap>.from(
                          item['events'] ?? [],
                        ))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e['text'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${e['actor_name']} · ${date(e['created'])}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  String pathOf(String id, List<JsonMap> folders) =>
      folderLocation(id, folders);
}
