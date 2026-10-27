import 'package:material_ui/material_ui.dart';
import 'package:forui/forui.dart';

import '../../shared/api.dart';
import '../../shared/widgets.dart';
import 'academic_forms.dart';

class AcademicPage extends StatefulWidget {
  final Api api;
  final JsonMap data;
  final VoidCallback openAccounts;
  const AcademicPage({
    super.key,
    required this.api,
    required this.data,
    required this.openAccounts,
  });
  @override
  State<AcademicPage> createState() => _AcademicPageState();
}

class _AcademicPageState extends State<AcademicPage> {
  late Future<dynamic> pending;
  String tab = 'Matrizes';
  String? course;
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    pending = widget.api.get('academic/catalog');
  }

  void refresh() {
    if (mounted) setState(load);
  }

  Future<void> subject([JsonMap? old]) async {
    if (await academicEditor(
      context,
      widget.api,
      title: old == null ? 'Cadastrar disciplina' : 'Editar disciplina',
      path: old == null ? 'subjects' : 'subjects/${old['id']}',
      method: old == null ? 'POST' : 'PATCH',
      initial: old ?? {},
      fields: const [
        AcademicField(
          'name',
          'Nome da disciplina *',
          tip: 'Nome completo, reutilizado nas matrizes de diferentes cursos.',
        ),
        AcademicField(
          'code',
          'Código',
          tip: 'Identificador curricular, se a instituição utiliza.',
        ),
      ],
    )) {
      refresh();
    }
  }

  Future<void> component(JsonMap data, [JsonMap? old]) async {
    final subjects = List<JsonMap>.from(data['subjects']),
        courses = List<JsonMap>.from(widget.data['courses'])
            .where((c) => c['archived'] == 0)
            .toList();
    if (subjects.isEmpty || courses.isEmpty) {
      feedback(
        context,
        'Cadastre um curso e uma disciplina antes de montar a matriz.',
      );
      return;
    }
    if (await academicEditor(
      context,
      widget.api,
      title: old == null
          ? 'Adicionar componente à matriz'
          : 'Editar componente',
      path: old == null ? 'components' : 'components/${old['id']}',
      method: old == null ? 'POST' : 'PATCH',
      initial: old ?? {'course': course ?? courses.first['id']},
      fields: [
        AcademicField(
          'course',
          'Curso e modalidade',
          options: {
            for (final c in courses) c['id']: '${c['name']} · ${c['modality']}',
          },
        ),
        const AcademicField(
          'phase',
          'Fase / etapa *',
          tip: 'Exemplo: Fase 2 ou 1º semestre. Uma nova fase recebe seus próprios componentes.',
        ),
        AcademicField(
          'subject',
          'Disciplina',
          options: {for (final s in subjects) s['id']: s['name']},
        ),
        const AcademicField(
          'hours',
          'Carga horária em horas-relógio *',
          integer: true,
          tip: 'Total previsto nesta fase em horas de 60 minutos. Exemplo: 40.',
        ),
        const AcademicField(
          'lesson_minutes',
          'Duração da hora-aula em minutos *',
          integer: true,
          tip: 'Exemplo: 45 no horário fornecido. Não confunda hora-aula com hora-relógio.',
        ),
      ],
    )) {
      refresh();
    }
  }

  Future<void> teacher(JsonMap old) async {
    if (await academicEditor(
      context,
      widget.api,
      title: 'Cadastro docente · ${old['name']}',
      path: 'teachers/${old['id']}',
      method: 'PATCH',
      initial: old,
      fields: const [
        AcademicField(
          'staff_code',
          'Registro funcional',
          tip: 'Identificação profissional interna, se houver. Deve ser única.',
        ),
        AcademicField(
          'qualification',
          'Formação / habilitações',
          lines: 3,
          tip: 'Formações relevantes aos componentes que o docente ministra.',
        ),
        AcademicField(
          'phone',
          'Telefone profissional',
          tip: 'Inclua DDD. Prefira um contato institucional.',
        ),
        AcademicField(
          'email',
          'E-mail profissional',
          tip: 'Contato acadêmico. O usuário de entrada é gerenciado em Contas e acessos.',
        ),
      ],
    )) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Organização acadêmica',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      Text(
        'Disciplinas, matrizes por fase e cadastro docente',
        style: TextStyle(color: FTheme.of(c).colors.mutedForeground),
      ),
      const SizedBox(height: 18),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final t in ['Matrizes', 'Disciplinas', 'Professores'])
            ChoiceChip(
              label: Text(t),
              selected: tab == t,
              onSelected: (_) => setState(() => tab = t),
            ),
        ],
      ),
      const SizedBox(height: 16),
      Expanded(
        child: FutureBuilder<dynamic>(
          future: pending,
          builder: (c, s) {
            if (s.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${s.error}'),
                    button('Tentar novamente', refresh),
                  ],
                ),
              );
            }
            if (!s.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = JsonMap.from(s.data),
                subjects = List<JsonMap>.from(data['subjects']),
                components = List<JsonMap>.from(data['components']),
                teachers = List<JsonMap>.from(data['teachers']);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (tab == 'Disciplinas')
                      button(
                        'Cadastrar disciplina',
                        () => subject(),
                        icon: FLucideIcons.plus,
                        primary: true,
                      ),
                    if (tab == 'Matrizes')
                      button(
                        'Adicionar componente',
                        () => component(data),
                        icon: FLucideIcons.plus,
                        primary: true,
                      ),
                    if (tab == 'Professores' &&
                        widget.data['session']['user']['role'] == 'admin')
                      button(
                        'Cadastrar conta de professor',
                        widget.openAccounts,
                        icon: FLucideIcons.userPlus,
                        primary: true,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                if (tab == 'Matrizes')
                  selector('Curso', course ?? '', [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('Todos os cursos'),
                    ),
                    for (final k in List<JsonMap>.from(widget.data['courses']))
                      DropdownMenuItem(
                        value: k['id'] as String,
                        child: Text('${k['name']} · ${k['modality']}'),
                      ),
                  ], (v) => setState(() => course = v == '' ? null : v)),
                Expanded(
                  child: ListView(
                    children: [
                      if (tab == 'Disciplinas' && subjects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhuma disciplina cadastrada. Adicione uma disciplina para utilizá-la na matriz dos cursos.',
                          ),
                        ),
                      if (tab == 'Disciplinas')
                        for (final d in subjects)
                          ListTile(
                            leading: const Icon(
                              FLucideIcons.bookOpen,
                              size: 20,
                            ),
                            title: Text(d['name']),
                            subtitle: Text(
                              d['code'] == ''
                                  ? 'Sem código curricular'
                                  : d['code'],
                            ),
                            trailing: const Icon(FLucideIcons.pencil, size: 16),
                            onTap: () => subject(d),
                          ),
                      if (tab == 'Matrizes' && components.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhum componente cadastrado. Selecione curso, fase, disciplina e carga horária. Depois atribua os diários nas turmas.',
                          ),
                        ),
                      if (tab == 'Matrizes')
                        for (final k
                            in List<JsonMap>.from(widget.data['courses']).where(
                              (k) => course == null || k['id'] == course,
                            )) ...[
                          for (final phase
                              in components
                                  .where((m) => m['course'] == k['id'])
                                  .map((m) => m['phase'] as String)
                                  .toSet()) ...[
                            sectionHeading(
                              '${k['name']} · $phase',
                              description: k['modality'],
                            ),
                            for (final m in components.where(
                              (m) =>
                                  m['course'] == k['id'] && m['phase'] == phase,
                            ))
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                title: Text(m['subject_name']),
                                subtitle: Text(
                                  '${m['hours']} h · hora-aula de ${m['lesson_minutes']} min · ${((m['hours'] as num) * 60 / (m['lesson_minutes'] as num)).toStringAsFixed(1)} aulas previstas',
                                ),
                                trailing: const Icon(
                                  FLucideIcons.pencil,
                                  size: 16,
                                ),
                                onTap: () => component(data, m),
                              ),
                            const PixelDivider(),
                          ],
                        ],
                      if (tab == 'Professores' && teachers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhuma conta ativa de professor. A administração deve cadastrá-la em Contas e acessos; depois complete os dados profissionais aqui.',
                          ),
                        ),
                      if (tab == 'Professores')
                        for (final t in teachers) ...[
                          ListTile(
                            leading: const Icon(
                              FLucideIcons.userRound,
                              size: 21,
                            ),
                            title: Text(t['name']),
                            subtitle: Text(
                              '${t['staff_code'] ?? 'Sem registro funcional'} · ${t['journals']} diários\n${t['qualification'] ?? 'Formação não informada'}',
                            ),
                            isThreeLine: true,
                            trailing: const Icon(FLucideIcons.pencil, size: 16),
                            onTap: () => teacher(t),
                          ),
                          const PixelDivider(),
                        ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ],
  );
}
