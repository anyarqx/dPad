import 'dart:io';
import 'dart:convert';

import 'database.dart';
import 'catalog.dart';
import 'pdf.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();
String now() => DateTime.now().toUtc().toIso8601String();

class ApiError implements Exception {
  final int status;
  final String message;
  ApiError(this.status, this.message);
}

class Store {
  final Database db;
  final Directory files;
  bool demo = false;
  Store(this.db, this.files);
  Future<Map<String, dynamic>> one(String table, String id) async {
    final r = await db.rows('SELECT * FROM $table WHERE id=?', [id]);
    if (r.isEmpty) throw ApiError(404, 'Registro não encontrado.');
    return r.first;
  }

  bool admin(Map u) => u['role'] == 'admin';
  bool area(Map u, String a) =>
      admin(u) ||
      a == 'user:${u['id']}' ||
      (u['department'] != null && a == 'sector:${u['department']}');
  bool staff(Map u, Map r) =>
      admin(u) ||
      (u['department'] != null && u['department'] == r['department']);
  Future<Set<String>> linkedStudents(Map u) async => (await db.rows(
    'SELECT student AS id FROM student_access WHERE user=?',
    [u['id']],
  )).map((p) => p['id'] as String).toSet();
  Future<bool> folderAccess(Map u, Map folder) async {
    final owners = await db.rows(
      'SELECT p.id,a.user FROM students p LEFT JOIN student_access a ON a.student=p.id AND a.user=? WHERE p.folder=?',
      [u['id'], folder['id']],
    );
    return owners.isEmpty
        ? area(u, folder['area'])
        : manageStudents(u) || owners.first['user'] != null;
  }

  Future<Map<String, dynamic>> folder(Map u, String id) async {
    final f = await one('folders', id);
    if (!await folderAccess(u, f)) throw ApiError(403, 'Pasta sem permissão.');
    return f;
  }

  Future<Map<String, dynamic>> request(Map u, String id) async {
    final r = await one('requests', id);
    if (r['requester'] != u['id'] &&
        !staff(u, r) &&
        !(await linkedStudents(u)).contains(r['student']))
      throw ApiError(403, 'Solicitação sem permissão.');
    return {
      ...r,
      'requester_name': (await one('users', r['requester']))['name'],
      'student_name': r['student'] == null
          ? null
          : (await one('students', r['student']))['name'],
    };
  }

  Future<Map<String, dynamic>> document(
    Map u,
    String id, {
    bool edit = false,
  }) async {
    final d = await one('documents', id);
    final f = await one('folders', d['folder']);
    if (await folderAccess(u, f)) return d;
    if (!edit) {
      if (u['department'] == 'coordenacao' &&
          (await db.rows(
            'SELECT id FROM absence_justifications WHERE document=?',
            [id],
          )).isNotEmpty)
        return d;
      final rs = await db.rows(
        'SELECT r.* FROM requests r JOIN attachments a ON a.request=r.id WHERE a.document=?',
        [id],
      );
      if (rs.any((r) => staff(u, r) || r['requester'] == u['id'])) return d;
    }
    throw ApiError(403, 'Documento sem permissão.');
  }

  String text(Map b, String key, {int max = 5000}) {
    final v = b[key];
    if (v is! String || v.trim().isEmpty || v.length > max)
      throw ApiError(400, 'Campo inválido: $key.');
    return v.trim();
  }

  void revision(Map b, Map row) {
    if (b['revision'] != row['revision'])
      throw ApiError(409, 'Registro alterado. Atualize e tente novamente.');
  }

  Future<String> createFolder(Map u, Map b) async {
    final name = text(b, 'name', max: 180);
    final parent = b['parent'];
    if (parent != null && parent is! String)
      throw ApiError(400, 'Pasta pai inválida.');
    final parentFolder = parent == null ? null : await folder(u, parent);
    if (parent != null &&
        (await db.rows('SELECT id FROM students WHERE folder=?', [
          parent,
        ])).isNotEmpty)
      throw ApiError(
        409,
        'Pastas de alunos recebem documentos diretamente, sem subpastas.',
      );
    final a = parent == null
        ? (b['area'] ?? 'user:${u['id']}')
        : parentFolder!['area'];
    if (a is! String || !area(u, a)) throw ApiError(403, 'Área sem permissão.');
    final id = uuid.v4();
    await db.exec(
      'INSERT INTO folders(id,name,parent,area,created,updated) VALUES(?,?,?,?,?,?)',
      [id, name, parent, a, now(), now()],
    );
    return id;
  }

  Future<void> updateFolder(Map u, String id, Map b) async {
    await db.transaction(() async {
      final f = await folder(u, id);
      revision(b, f);
      final parent = b.containsKey('parent') ? b['parent'] : f['parent'];
      if (parent != null) {
        final target = await folder(u, parent);
        if ((await db.rows('SELECT id FROM students WHERE folder IN (?,?)', [
          id,
          parent,
        ])).isNotEmpty)
          throw ApiError(
            409,
            'A pasta do aluno deve permanecer individual, na raiz e sem subpastas.',
          );
        if (target['area'] != f['area'])
          throw ApiError(400, 'Mova somente dentro da mesma área.');
        String? cursor = parent;
        while (cursor != null) {
          if (cursor == id)
            throw ApiError(409, 'Uma pasta não pode conter a si própria.');
          cursor = (await one('folders', cursor))['parent'];
        }
      }
      await db.exec(
        'UPDATE folders SET name=?,parent=?,updated=?,revision=revision+1 WHERE id=?',
        [
          b.containsKey('name') ? text(b, 'name', max: 180) : f['name'],
          parent,
          now(),
          id,
        ],
      );
    });
  }

  Future<void> deleteFolder(Map u, String id) async {
    await folder(u, id);
    if ((await db.rows('SELECT id FROM students WHERE folder=?', [
      id,
    ])).isNotEmpty)
      throw ApiError(
        409,
        'Esta pasta pertence a um aluno e não pode ser excluída pelo arquivo.',
      );
    final n = await db.rows(
      'SELECT id FROM folders WHERE parent=? UNION ALL SELECT id FROM documents WHERE folder=?',
      [id, id],
    );
    if (n.isNotEmpty) throw ApiError(409, 'Esvazie a pasta antes de excluir.');
    await db.exec('DELETE FROM folders WHERE id=?', [id]);
  }

  Future<void> event(String id, String actor, String message) => db.exec(
    'INSERT INTO events VALUES(?,?,?,?,?)',
    [uuid.v4(), id, actor, message, now()],
  );
  Future<void> attach(Map u, String id, String doc) async {
    await document(u, doc, edit: true);
    await db.exec('INSERT OR IGNORE INTO attachments VALUES(?,?)', [id, doc]);
    await event(
      id,
      u['id'],
      'Documento associado: ${(await one('documents', doc))['name']}',
    );
  }

  Future<String> createRequest(Map u, Map b) async {
    return db.transaction(() async {
      final op = text(b, 'operation', max: 100);
      final old = await db.rows(
        'SELECT id FROM requests WHERE requester=? AND operation=?',
        [u['id'], op],
      );
      if (old.isNotEmpty) return old.first['id'] as String;
      final service = text(b, 'service');
      final matches = services.where((s) => s['id'] == service);
      if (matches.isEmpty) throw ApiError(400, 'Serviço inválido.');
      if (service == 'atividade' &&
          !['professor', 'gremio', 'admin'].contains(u['role']))
        throw ApiError(403, 'Atividade disponível a professor e grêmio.');
      final dept = service == 'geral'
          ? text(b, 'department')
          : matches.first['department'];
      if (!['secretaria', 'coordenacao'].contains(dept))
        throw ApiError(400, 'Setor inválido.');
      if (b['student'] != null) await student(u, b['student']);
      final id = uuid.v4();
      await db.exec(
        'INSERT INTO requests(id,protocol,service,subject,description,requester,department,state,operation,student,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          id,
          'DP-${DateTime.now().year}-${id.substring(0, 8).toUpperCase()}',
          service,
          text(b, 'subject', max: 180),
          text(b, 'description'),
          u['id'],
          dept,
          'Recebida',
          op,
          b['student'],
          now(),
          now(),
        ],
      );
      await event(id, u['id'], 'Solicitação recebida.');
      for (final d in (b['documents'] as List? ?? [])) {
        await attach(u, id, d);
      }
      return id;
    });
  }

  Future<void> action(Map u, String id, Map b) async {
    await db.transaction(() async {
      final r = await request(u, id);
      revision(b, r);
      final a = text(b, 'action');
      var state = r['state'];
      var dept = r['department'];
      var result = r['result'];
      String message;
      if (a == 'complement') {
        if (r['requester'] != u['id'] || state != 'Aguardando solicitante')
          throw ApiError(409, 'Não há pendência para responder.');
        state = 'Em atendimento';
        message = 'Complemento do solicitante: ${text(b, 'text')}';
      } else {
        if (!staff(u, r))
          throw ApiError(403, 'Somente o setor responsável pode atender.');
        switch (a) {
          case 'start':
            if (state != 'Recebida')
              throw ApiError(409, 'Atendimento já iniciado.');
            state = 'Em atendimento';
            message = 'Atendimento iniciado.';
          case 'ask':
            if (state != 'Em atendimento')
              throw ApiError(409, 'Inicie o atendimento.');
            state = 'Aguardando solicitante';
            message = 'Complemento solicitado: ${text(b, 'text')}';
          case 'answer':
            if (state != 'Em atendimento')
              throw ApiError(409, 'Inicie o atendimento.');
            result = text(b, 'text');
            message = 'Resposta: $result';
          case 'complete':
            if (state != 'Em atendimento')
              throw ApiError(
                409,
                'Inicie ou retome o atendimento antes de concluir.',
              );
            result = text(b, 'text');
            state = 'Concluída';
            message = 'Concluída: $result';
          case 'forward':
            if (state == 'Concluída')
              throw ApiError(409, 'Solicitação concluída.');
            dept = text(b, 'department');
            if (!['secretaria', 'coordenacao'].contains(dept) ||
                dept == r['department'])
              throw ApiError(400, 'Escolha outro setor.');
            state = 'Recebida';
            message = 'Encaminhada para $dept: ${text(b, 'text')}';
          default:
            throw ApiError(400, 'Ação inválida.');
        }
      }
      await db.exec(
        'UPDATE requests SET state=?,department=?,result=?,updated=?,revision=revision+1 WHERE id=?',
        [state, dept, result, now(), id],
      );
      await event(id, u['id'], message);
    });
  }

  bool manageStudents(Map u) => admin(u) || u['department'] == 'secretaria';
  Future<Map<String, dynamic>> student(Map u, String id) async {
    final p = await one('students', id);
    if (!manageStudents(u) && !(await linkedStudents(u)).contains(id))
      throw ApiError(403, 'Pasta de aluno sem permissão.');
    return p;
  }

  Future<List<Map<String, dynamic>>> listStudents(Map u) async {
    final all = await db.rows(
      "SELECT s.id,s.name,s.registration,s.folder,s.updated,s.birth_date,s.sex,s.social_name,s.birthplace,s.nationality,s.parentage,s.address,s.guardian,s.phone,s.email,s.extra_json,s.template_fields_json,(SELECT group_concat(g.name||' · '||c.name||' · '||e.school_year||' / '||e.period_label,'; ') FROM enrollments e JOIN class_groups g ON g.id=e.class_group JOIN courses c ON c.id=e.course WHERE e.student=s.id AND e.state IN ('Ativa','Em análise')) AS class_label,(SELECT count(*) FROM requirements r WHERE r.student=s.id) AS required_count,(SELECT count(*) FROM requirements r WHERE r.student=s.id AND EXISTS(SELECT 1 FROM documents d WHERE d.folder=s.folder AND d.type=r.type COLLATE NOCASE)) AS received_count,(SELECT count(*) FROM requirements r WHERE r.student=s.id AND EXISTS(SELECT 1 FROM documents d WHERE d.folder=s.folder AND d.type=r.type COLLATE NOCASE AND d.status='Conferido')) AS verified_count FROM students s ORDER BY name COLLATE NOCASE",
    );
    final linked = await linkedStudents(u);
    return all
        .where((p) => manageStudents(u) || linked.contains(p['id']))
        .map(
          (p) => {...p, 'data_pending_count': missingData(p).length}
            ..removeWhere(
              (key, _) => [
                'birth_date',
                'sex',
                'social_name',
                'birthplace',
                'nationality',
                'parentage',
                'address',
                'guardian',
                'phone',
                'email',
                'extra_json',
                'template_fields_json',
              ].contains(key),
            ),
        )
        .toList();
  }

  List<String> missingData(Map p) {
    final fields = p['templateFields'] ?? jsonDecode(p['template_fields_json']);
    final extra = p['extra'] ?? jsonDecode(p['extra_json']);
    return [
      for (final key in fields['identity'] ?? [])
        if (p[key] == null || p[key] == '')
          '${{'birth_date': 'Nascimento', 'guardian': 'Responsável', 'phone': 'Telefone', 'email': 'E-mail', 'sex': 'Sexo informado', 'social_name': 'Nome social', 'birthplace': 'Naturalidade', 'nationality': 'Nacionalidade', 'parentage': 'Filiação', 'address': 'Endereço'}[key]} não informado',
      for (final key in fields['extra'] ?? [])
        if (extra[key] == null || extra[key].toString().trim().isEmpty)
          '$key não informado',
    ];
  }

  String optional(Map b, String key, {int max = 5000}) {
    final v = b[key] ?? '';
    if (v is! String || v.length > max)
      throw ApiError(400, 'Campo inválido: $key.');
    return v.trim();
  }

  Map<String, dynamic> studentFields(Map b) {
    final birth = optional(b, 'birth_date', max: 10);
    if (birth.isNotEmpty) {
      final parsed = DateTime.tryParse(birth);
      if (parsed == null ||
          parsed.toIso8601String().substring(0, 10) != birth ||
          parsed.isAfter(DateTime.now()))
        throw ApiError(400, 'Data de nascimento inválida. Use AAAA-MM-DD.');
    }
    if (![
      '',
      'Feminino',
      'Masculino',
      'Intersexo',
      'Não informado',
    ].contains(optional(b, 'sex')))
      throw ApiError(400, 'Selecione um sexo válido ou deixe sem informação.');
    final extra = b['extra'] ?? <String, dynamic>{};
    if (extra is! Map ||
        extra.length > 30 ||
        extra.entries.any(
          (e) =>
              e.key is! String ||
              e.key.toString().trim().isEmpty ||
              e.key.toString().length > 100 ||
              e.value is! String ||
              e.value.toString().length > 1000,
        ))
      throw ApiError(400, 'Campos adicionais inválidos.');
    if (extra.keys
            .map((k) => k.toString().trim().toLowerCase())
            .toSet()
            .length !=
        extra.length)
      throw ApiError(400, 'Informações adicionais com nomes repetidos.');
    return {
      'name': text(b, 'name', max: 180),
      'registration': optional(b, 'registration', max: 80),
      'birth_date': birth,
      for (final key in [
        'sex',
        'social_name',
        'birthplace',
        'nationality',
        'parentage',
        'address',
      ])
        key: optional(b, key, max: key == 'address' ? 500 : 180),
      'guardian': optional(b, 'guardian', max: 180),
      'phone': optional(b, 'phone', max: 80),
      'email': optional(b, 'email', max: 180),
      'notes': optional(b, 'notes'),
      'extra_json': jsonEncode({
        for (final e in extra.entries)
          e.key.toString().trim(): e.value.toString().trim(),
      }),
    };
  }

  Future<String> createStudent(Map u, Map b) async {
    if (!manageStudents(u))
      throw ApiError(403, 'O cadastro de alunos é feito pela secretaria.');
    return db.transaction(() async {
      final fields = studentFields(b);
      final id = uuid.v4();
      final String fid;
      if (b['folder'] != null) {
        final existing = await folder(u, b['folder']);
        if ((await db.rows('SELECT id FROM students WHERE folder=?', [
          existing['id'],
        ])).isNotEmpty)
          throw ApiError(409, 'Esta pasta já pertence a um aluno.');
        if (existing['parent'] != null ||
            (await db.rows('SELECT id FROM folders WHERE parent=?', [
              existing['id'],
            ])).isNotEmpty)
          throw ApiError(
            409,
            'Use uma pasta raiz sem subpastas para cadastrar o aluno. Os documentos também podem ser vinculados individualmente.',
          );
        fid = existing['id'];
      } else {
        fid = await createFolder(u, {
          'name': '${fields['name']} · ${id.substring(0, 8)}',
          'area': 'sector:secretaria',
        });
      }
      final templateId = b['template'];
      final template = templateId == null
          ? null
          : await one('document_templates', templateId);
      if (template?['archived'] == 1)
        throw ApiError(409, 'O modelo está arquivado.');
      await db.exec(
        'INSERT INTO students(id,name,registration,birth_date,sex,social_name,birthplace,nationality,parentage,address,guardian,phone,email,notes,extra_json,template,template_fields_json,folder,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          id,
          fields['name'],
          fields['registration'] == '' ? null : fields['registration'],
          fields['birth_date'],
          for (final key in [
            'sex',
            'social_name',
            'birthplace',
            'nationality',
            'parentage',
            'address',
          ])
            fields[key],
          fields['guardian'],
          fields['phone'],
          fields['email'],
          fields['notes'],
          fields['extra_json'],
          templateId,
          template?['fields_json'] ?? '{}',
          fid,
          now(),
          now(),
        ],
      );
      for (final type
          in template == null
              ? []
              : jsonDecode(template['documents_json']) as List) {
        await db.exec('INSERT INTO requirements VALUES(?,?,?)', [
          uuid.v4(),
          id,
          type,
        ]);
      }
      return id;
    });
  }

  Future<void> updateStudent(Map u, String id, Map b) async {
    if (!manageStudents(u))
      throw ApiError(
        403,
        'Somente a secretaria pode editar os dados do aluno.',
      );
    await db.transaction(() async {
      final p = await student(u, id);
      revision(b, p);
      final f = studentFields({
        ...p,
        'extra': jsonDecode(p['extra_json']),
        ...b,
      });
      await db.exec(
        'UPDATE students SET name=?,registration=?,birth_date=?,sex=?,social_name=?,birthplace=?,nationality=?,parentage=?,address=?,guardian=?,phone=?,email=?,notes=?,extra_json=?,updated=?,revision=revision+1 WHERE id=?',
        [
          f['name'],
          f['registration'] == '' ? null : f['registration'],
          f['birth_date'],
          for (final key in [
            'sex',
            'social_name',
            'birthplace',
            'nationality',
            'parentage',
            'address',
          ])
            f[key],
          f['guardian'],
          f['phone'],
          f['email'],
          f['notes'],
          f['extra_json'],
          now(),
          id,
        ],
      );
    });
  }

  Future<Map<String, dynamic>> studentDetail(Map u, String id) async {
    final p = await student(u, id);
    final linked = (await linkedStudents(u)).contains(id);
    final docs = await db.rows(
      'SELECT * FROM documents WHERE folder=? ORDER BY created DESC',
      [p['folder']],
    );
    final requirements = await db.rows(
      'SELECT * FROM requirements WHERE student=? ORDER BY rowid',
      [id],
    );
    return {
      ...p,
      'data_pending_count': missingData(p).length,
      'extra': jsonDecode(p['extra_json']),
      'templateFields': jsonDecode(p['template_fields_json']),
      'templateName': p['template'] == null
          ? null
          : (await one('document_templates', p['template']))['name'],
      'documents': docs,
      'requirements': requirements.map((r) {
        final matches = docs
            .where(
              (d) =>
                  d['type'].toString().toLowerCase() ==
                  r['type'].toString().toLowerCase(),
            )
            .toList();
        return {
          ...r,
          'documents': matches,
          'status': matches.isEmpty
              ? 'Não enviado'
              : matches.any((d) => d['status'] == 'Conferido')
              ? 'Conferido'
              : matches.any((d) => d['status'] == 'Precisa de correção')
              ? 'Precisa de correção'
              : 'Aguardando conferência',
        };
      }).toList(),
      'requests':
          (await db.rows(
                'SELECT DISTINCT r.* FROM requests r LEFT JOIN attachments a ON a.request=r.id LEFT JOIN documents d ON d.id=a.document WHERE r.student=? OR d.folder=? ORDER BY r.updated DESC',
                [id, p['folder']],
              ))
              .where((r) => r['requester'] == u['id'] || staff(u, r) || linked)
              .toList(),
    };
  }

  Future<String> documentType(String folder, String type) async {
    final list = await db.rows(
      'SELECT r.type FROM requirements r JOIN students s ON s.id=r.student WHERE s.folder=?',
      [folder],
    );
    return list
            .where(
              (r) => r['type'].toString().toLowerCase() == type.toLowerCase(),
            )
            .firstOrNull?['type'] ??
        type;
  }

  Future<void> seed({bool demo = false}) async {
    this.demo = demo;
    if (!demo) {
      await db.exec(
        "INSERT OR IGNORE INTO users VALUES('local','Secretaria local','admin','secretaria')",
      );
      return;
    }
    if ((await db.rows('SELECT id FROM users LIMIT 1')).isNotEmpty) return;
    await db.transaction(() async {
      for (final u in [
        ['aluno', 'Ana Oliveira', 'aluno', null],
        ['professor', 'Rafael Lima', 'professor', null],
        ['gremio', 'Júlia Santos', 'gremio', null],
        ['secretaria', 'Marina Costa', 'secretaria', 'secretaria'],
        ['coordenacao', 'Paulo Alves', 'coordenacao', 'coordenacao'],
        ['admin', 'Helena Souza', 'admin', null],
      ]) {
        await db.exec('INSERT INTO users VALUES(?,?,?,?)', u);
      }
      for (final id in [
        'aluno',
        'professor',
        'gremio',
        'secretaria',
        'coordenacao',
        'admin',
      ]) {
        final u = await one('users', id);
        await createFolder(u, {'name': 'Meus documentos'});
      }
      final a = await one('users', 'admin');
      final sec = await createFolder(a, {
        'name': 'Secretaria',
        'area': 'sector:secretaria',
      });
      await createFolder(a, {'name': 'Matrículas', 'parent': sec});
      await createFolder(a, {'name': 'Declarações', 'parent': sec});
      final co = await createFolder(a, {
        'name': 'Coordenação',
        'area': 'sector:coordenacao',
      });
      await createFolder(a, {'name': 'Atividades', 'parent': co});
      final aluno = await one('users', 'aluno');
      final f = (await db.rows(
        "SELECT id FROM folders WHERE area='user:aluno' LIMIT 1",
      )).first['id'];
      final bytes = await requestPdf(
        'Ana Oliveira (fictícia)',
        'Declaração escolar',
        'Solicito declaração de vínculo escolar para fins demonstrativos.',
      );
      final did = uuid.v4();
      await File('${files.path}/$did').writeAsBytes(bytes, flush: true);
      await db.exec(
        'INSERT INTO documents(id,name,folder,type,mime,size,storage,uploader,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?)',
        [
          did,
          'Requerimento demonstrativo.pdf',
          f,
          'Requerimento',
          'application/pdf',
          bytes.length,
          did,
          'aluno',
          now(),
          now(),
        ],
      );
      for (final target in [sec, co]) {
        final sample = await requestPdf(
          'Equipe demonstrativa',
          'Orientações para a feira',
          'Arquivo fictício de apoio à organização documental.',
        );
        final doc = uuid.v4();
        await File('${files.path}/$doc').writeAsBytes(sample, flush: true);
        await db.exec(
          'INSERT INTO documents(id,name,folder,type,mime,size,storage,uploader,created,updated) VALUES(?,?,?,?,?,?,?,?,?,?)',
          [
            doc,
            'Orientações demonstrativas.pdf',
            target,
            'Orientação',
            'application/pdf',
            sample.length,
            doc,
            'admin',
            now(),
            now(),
          ],
        );
      }
      await createRequest(aluno, {
        'operation': 'seed-1',
        'service': 'declaracao',
        'subject': 'Declaração de vínculo',
        'description':
            'Preciso de uma declaração para apresentação científica.',
        'documents': [did],
      });
      final waiting = await createRequest(aluno, {
        'operation': 'seed-wait',
        'service': 'geral',
        'department': 'secretaria',
        'subject': 'Conferência de comprovante',
        'description':
            'Desejo orientações para apresentar o comprovante fictício.',
      });
      final secretary = await one('users', 'secretaria');
      await action(secretary, waiting, {'revision': 1, 'action': 'start'});
      await action(secretary, waiting, {
        'revision': 2,
        'action': 'ask',
        'text': 'Informe a finalidade do comprovante.',
      });
      final done = await createRequest(await one('users', 'professor'), {
        'operation': 'seed-done',
        'service': 'geral',
        'department': 'secretaria',
        'subject': 'Formulário para projeto',
        'description': 'Solicito orientações sobre o formulário demonstrativo.',
      });
      await action(secretary, done, {'revision': 1, 'action': 'start'});
      await action(secretary, done, {
        'revision': 2,
        'action': 'complete',
        'text':
            'Orientações fornecidas. Utilize o serviço Requerimento escolar.',
      });
      final r = await createRequest(await one('users', 'gremio'), {
        'operation': 'seed-2',
        'service': 'atividade',
        'subject': 'Mostra de ciências',
        'description':
            'Solicitamos o uso do auditório para a mostra de ciências.',
      });
      await action(await one('users', 'coordenacao'), r, {
        'revision': 1,
        'action': 'start',
      });
    });
  }
}
