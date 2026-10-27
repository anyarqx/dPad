part of 'workspace.dart';

extension _Navigation on _WorkspaceState {
  List<(String, String, IconData)> navigationItems(JsonMap data) {
    final u = data['session']['user'];
    final manage = u['role'] == 'admin' || u['department'] == 'secretaria';
    return [
      ('students', 'Pastas de alunos', FLucideIcons.usersRound),
      ('classes', 'Cursos e turmas', FLucideIcons.graduationCap),
      if (manage || u['department'] == 'coordenacao')
        ('academic', 'Organização acadêmica', FLucideIcons.bookOpen),
      ('requests', 'Solicitações', FLucideIcons.inbox),
      if (u['department'] != null || u['role'] == 'admin')
        ('queue', 'Atendimento', FLucideIcons.clipboardList),
      if (manage) ('templates', 'Modelos de pasta', FLucideIcons.files),
      if (u['role'] == 'admin' && data['session']['demo'] != true)
        ('accounts', 'Contas e acessos', FLucideIcons.users),
    ];
  }

  Widget sidebar(JsonMap data, {bool forceExpanded = false}) {
    final user = data['session']['user'];
    final students = List<JsonMap>.from(data['students']);
    final groups = List<JsonMap>.from(data['classes']);
    final courses = List<JsonMap>.from(data['courses']);
    final years =
        groups
            .where((g) => g['archived'] == 0)
            .map((g) => '${g['school_year']}')
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));
    if (!years.contains(railYear)) railYear = years.firstOrNull;
    final visible = groups
        .where((g) => '${g['school_year']}' == railYear && g['archived'] == 0)
        .toList();
    final manage =
        user['role'] == 'admin' || user['department'] == 'secretaria';
    if (sidebarCollapsed && !forceExpanded) {
      return Material(
        color: FTheme.of(context).colors.card,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18, bottom: 10),
                child: AppLogo(size: 30),
              ),
              IconButton(
                tooltip: 'Expandir navegação',
                onPressed: toggleSidebar,
                icon: const Icon(FLucideIcons.panelLeftOpen, size: 19),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    for (final item in navigationItems(data))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: IconButton(
                          tooltip: item.$2,
                          isSelected: widget.section == item.$1,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              widget.section == item.$1
                                  ? FTheme.of(context).colors.secondary
                                  : null,
                            ),
                          ),
                          onPressed: () => go(item.$1),
                          icon: Icon(item.$3, size: 21),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Arquivo de documentos',
                onPressed: () => go('documents'),
                icon: const Icon(FLucideIcons.files, size: 20),
              ),
              IconButton(
                tooltip: 'Preferências',
                onPressed: () => settings(data),
                icon: const Icon(FLucideIcons.settings, size: 20),
              ),
              Tooltip(
                message: user['name'],
                child: PopupMenuButton<String>(
                  tooltip: 'Conta atual',
                  icon: const Icon(FLucideIcons.circleUserRound, size: 21),
                  onSelected: (v) async {
                    if (v == 'logout') {
                      try {
                        await api.logout();
                      } finally {
                        drafts.clear();
                        go('students');
                        refresh();
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(enabled: false, child: Text(user['name'])),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text('Sair da conta'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
    return Material(
      color: FTheme.of(context).colors.card,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 8, 16),
              child: Row(
                children: [
                  const AppLogo(size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Do Papel ao Digital',
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (!forceExpanded)
                    IconButton(
                      tooltip: 'Recolher navegação',
                      onPressed: toggleSidebar,
                      icon: const Icon(FLucideIcons.panelLeftClose, size: 17),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 28,
                        height: 32,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  for (final item in navigationItems(data))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        selected: widget.section == item.$1,
                        selectedTileColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        leading: Icon(item.$3, size: 20),
                        title: Text(
                          item.$2,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: item.$1 == 'students'
                            ? Text(
                                '${students.length}',
                                style: const TextStyle(fontSize: 11),
                              )
                            : null,
                        onTap: () => go(item.$1),
                      ),
                    ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'TURMAS',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (years.isNotEmpty)
                          DropdownButton<String>(
                            value: railYear,
                            underline: const SizedBox.shrink(),
                            isDense: true,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                ),
                            items: [
                              for (final y in years)
                                DropdownMenuItem(value: y, child: Text(y)),
                            ],
                            onChanged: (v) => stateChange(() => railYear = v),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (visible.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        manage
                            ? 'Cadastre cursos e turmas para organizar as matrículas.'
                            : 'Nenhuma turma disponível para esta conta.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.6,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  for (final course in courses.where(
                    (c) => visible.any((g) => g['course'] == c['id']),
                  ))
                    ExpansionTile(
                      key: PageStorageKey(
                        'rail-${user['id']}-${course['id']}-$railYear',
                      ),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                      dense: true,
                      maintainState: true,
                      initiallyExpanded: visible.any(
                        (g) =>
                            g['id'] == widget.classId &&
                            g['course'] == course['id'],
                      ),
                      title: Text(
                        course['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        course['modality'],
                        style: const TextStyle(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      children: [
                        for (final period
                            in visible
                                .where((g) => g['course'] == course['id'])
                                .map((g) => g['period_label'] as String)
                                .toSet())
                          ExpansionTile(
                            key: PageStorageKey(
                              'rail-period-${course['id']}-$railYear-$period',
                            ),
                            tilePadding: const EdgeInsets.only(
                              left: 22,
                              right: 8,
                            ),
                            dense: true,
                            initiallyExpanded: visible.any(
                              (g) =>
                                  g['id'] == widget.classId &&
                                  g['course'] == course['id'] &&
                                  g['period_label'] == period,
                            ),
                            title: Text(
                              period,
                              style: const TextStyle(fontSize: 11),
                            ),
                            children: [
                              for (final group in visible.where(
                                (g) =>
                                    g['course'] == course['id'] &&
                                    g['period_label'] == period,
                              ))
                                ListTile(
                                  contentPadding: const EdgeInsets.only(
                                    left: 34,
                                    right: 8,
                                  ),
                                  dense: true,
                                  selected: widget.classId == group['id'],
                                  title: Text(
                                    group['name'],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  subtitle: Text(
                                    group['shift'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  onTap: () => go('classes', group['id']),
                                ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(FLucideIcons.files, size: 19),
              title: const Text(
                'Arquivo de documentos',
                style: TextStyle(fontSize: 11),
              ),
              selected: widget.section == 'documents',
              onTap: () => go('documents'),
            ),
            const PixelDivider(),
            if (data['session']['demo'] == true &&
                data['session']['users'].length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  key: const ValueKey('demo-profile'),
                  value: api.profile,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: List<JsonMap>.from(data['session']['users'])
                      .map(
                        (u) => DropdownMenuItem(
                          value: u['id'] as String,
                          child: Text(
                            '${u['name']} · ${u['role']}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) async {
                    api.profile = v!;
                    await preferences.setString('profile', v);
                    go('students');
                    refresh();
                  },
                ),
              )
            else
              ListTile(
                dense: true,
                leading: const Icon(FLucideIcons.circleUserRound, size: 20),
                title: Text(
                  user['name'],
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  roles[user['role']] ?? user['role'],
                  style: const TextStyle(fontSize: 10),
                ),
                trailing: IconButton(
                  tooltip: 'Sair da conta',
                  icon: const Icon(FLucideIcons.logOut, size: 17),
                  onPressed: () async {
                    try {
                      await api.logout();
                    } catch (e) {
                      if (mounted) feedback(context, e);
                    } finally {
                      drafts.clear();
                      go('students');
                      refresh();
                    }
                  },
                ),
              ),
            ListTile(
              dense: true,
              leading: const Icon(FLucideIcons.settings, size: 19),
              title: const Text('Preferências', style: TextStyle(fontSize: 12)),
              subtitle: data['session']['demo'] == true
                  ? const Text(
                      'Modo de demonstração',
                      style: TextStyle(fontSize: 10),
                    )
                  : null,
              onTap: () => settings(data),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
