part of 'workspace.dart';

extension _Navigation on _WorkspaceState {
  bool get autoCompact =>
      MediaQuery.sizeOf(context).width >= 1050 &&
      MediaQuery.sizeOf(context).width < 1180;
  bool get compactNavigation => sidebarCollapsed || autoCompact;
  double get navigationWidth => compactNavigation ? 72 : 248;

  List<(String, String, IconData)> navigationItems(JsonMap data) {
    final u = data['session']['user'];
    final manage = u['role'] == 'admin' || u['department'] == 'secretaria';
    return [
      ('students', 'Pastas de alunos', FLucideIcons.usersRound),
      ('classes', 'Cursos e turmas', FLucideIcons.graduationCap),
      if (manage || u['department'] == 'coordenacao')
        ('academic', 'Org. Acadêmica', FLucideIcons.bookOpen),
      ('requests', 'Solicitações', FLucideIcons.inbox),
      if (u['department'] != null || u['role'] == 'admin')
        ('queue', 'Atendimento', FLucideIcons.clipboardList),
      if (manage) ('templates', 'Modelos de pasta', FLucideIcons.files),
      if (u['role'] == 'admin' && data['session']['demo'] != true)
        ('accounts', 'Contas e acessos', FLucideIcons.users),
    ];
  }

  Widget navText(String label, {double size = 13, FontWeight? weight}) =>
      Tooltip(
        message: label,
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: size, fontWeight: weight),
        ),
      );

  Future<void> logout() async {
    try {
      await api.logout();
    } catch (e) {
      if (mounted) feedback(context, e);
    } finally {
      if (mounted) {
        drafts.clear();
        go('students');
        refresh();
      }
    }
  }

  Widget sidebar(JsonMap data, {bool forceExpanded = false}) {
    final user = data['session']['user'];
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
    final compact = compactNavigation && !forceExpanded;
    final surfaces = AppSurfaces.of(context);
    final accountMenu = PopupMenuButton<String>(
      tooltip: 'Conta atual',
      onSelected: (v) => v == 'password' ? changePassword() : logout(),
      itemBuilder: (_) => [
        PopupMenuItem(enabled: false, child: Text(user['name'])),
        if (data['session']['demo'] != true)
          const PopupMenuItem(
            value: 'password',
            child: Text('Alterar minha senha'),
          ),
        const PopupMenuItem(value: 'logout', child: Text('Sair da conta')),
      ],
      child: compact
          ? const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(FLucideIcons.circleUserRound, size: 22),
            )
          : ListTile(
              dense: true,
              leading: const Icon(FLucideIcons.circleUserRound, size: 20),
              title: navText(user['name'], size: 12, weight: FontWeight.w600),
              subtitle: navText(roles[user['role']] ?? user['role'], size: 11),
              trailing: IconButton(
                tooltip: 'Sair da conta',
                icon: const Icon(FLucideIcons.logOut, size: 18),
                onPressed: logout,
              ),
            ),
    );
    return Material(
      color: surfaces.sidebar,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 56,
              child: compact
                  ? IconButton(
                      tooltip: 'Expandir navegação',
                      onPressed: autoCompact
                          ? () => _scaffoldKey.currentState?.openDrawer()
                          : toggleSidebar,
                      icon: const Icon(FLucideIcons.panelLeftOpen, size: 20),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'NAVEGAÇÃO',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .8,
                                color: FTheme.of(context)
                                    .colors
                                    .mutedForeground,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: forceExpanded
                                ? 'Fechar navegação'
                                : 'Recolher navegação',
                            onPressed: forceExpanded
                                ? () => _scaffoldKey.currentState?.closeDrawer()
                                : toggleSidebar,
                            icon: Icon(
                              forceExpanded
                                  ? FLucideIcons.x
                                  : FLucideIcons.panelLeftClose,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10),
                children: [
                  for (final item in navigationItems(data))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: compact
                          ? IconButton(
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
                              icon: Icon(item.$3, size: 22),
                            )
                          : ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              selected: widget.section == item.$1,
                              leading: Icon(item.$3, size: 20),
                              title: navText(
                                item.$2,
                                weight: widget.section == item.$1
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              trailing: item.$1 == 'students'
                                  ? Text(
                                      '${(data['students'] as List).length}',
                                      style: const TextStyle(fontSize: 11),
                                    )
                                  : null,
                              onTap: () => go(item.$1),
                            ),
                    ),
                  if (!compact) ...[
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'TURMAS',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .8,
                              ),
                            ),
                          ),
                          if (years.length == 1)
                            Text(
                              years.single,
                              style: const TextStyle(fontSize: 12),
                            )
                          else if (years.isNotEmpty)
                            DropdownButton<String>(
                              value: railYear,
                              underline: const SizedBox.shrink(),
                              isDense: true,
                              items: [
                                for (final year in years)
                                  DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      year,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
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
                          'Nenhuma turma disponível.',
                          style: TextStyle(
                            fontSize: 12,
                            color: FTheme.of(context).colors.mutedForeground,
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
                        shape: const Border(),
                        collapsedShape: const Border(),
                        title: navText(
                          course['name'],
                          size: 12,
                          weight: FontWeight.w600,
                        ),
                        subtitle: navText(course['modality'], size: 11),
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
                              shape: const Border(),
                              collapsedShape: const Border(),
                              initiallyExpanded: visible.any(
                                (g) =>
                                    g['id'] == widget.classId &&
                                    g['course'] == course['id'] &&
                                    g['period_label'] == period,
                              ),
                              title: navText(period, size: 12),
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
                                    title: navText(group['name'], size: 12),
                                    subtitle: navText(group['shift'], size: 11),
                                    onTap: () => go('classes', group['id']),
                                  ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
            Material(
              color: surfaces.footer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (compact)
                    IconButton(
                      tooltip: 'Arquivo de documentos',
                      isSelected: widget.section == 'documents',
                      onPressed: () => go('documents'),
                      icon: const Icon(FLucideIcons.folderOpen, size: 22),
                    )
                  else
                    ListTile(
                      dense: true,
                      selected: widget.section == 'documents',
                      leading: const Icon(FLucideIcons.folderOpen, size: 20),
                      title: navText('Arquivo de documentos', size: 12),
                      onTap: () => go('documents'),
                    ),
                  const PixelDivider(),
                  if (!compact &&
                      data['session']['demo'] == true &&
                      data['session']['users'].length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: DropdownButton<String>(
                        key: const ValueKey('demo-profile'),
                        value: api.profile,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final u in List<JsonMap>.from(
                            data['session']['users'],
                          ))
                            DropdownMenuItem(
                              value: u['id'] as String,
                              child: navText(
                                '${u['name']} · ${u['role']}',
                                size: 12,
                              ),
                            ),
                        ],
                        onChanged: (v) async {
                          api.profile = v!;
                          await preferences.setString('profile', v);
                          go('students');
                          refresh();
                        },
                      ),
                    )
                  else
                    accountMenu,
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
