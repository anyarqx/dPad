import 'dart:convert';

import 'store.dart';

class Templates {
  final Store s;
  Templates(this.s);
  void manage(Map u) {
    if (!s.manageStudents(u))
      throw ApiError(403, 'Somente a secretaria pode alterar modelos.');
  }

  List<String> names(Map b, String key, {int max = 60}) {
    final items = b[key] ?? [];
    if (items is! List ||
        items.length > max ||
        items.any((v) => v is! String || v.trim().isEmpty || v.length > 120))
      throw ApiError(400, 'Lista inválida: $key.');
    final list = items.cast<String>().map((v) => v.trim()).toList();
    if (list.map((v) => v.toLowerCase()).toSet().length != list.length)
      throw ApiError(400, 'Não repita nomes em $key.');
    return list;
  }

  Map<String, dynamic> decode(Map<String, dynamic> row) =>
      {
          ...row,
          'documents': jsonDecode(row['documents_json']),
          'fields': jsonDecode(row['fields_json']),
        }
        ..remove('documents_json')
        ..remove('fields_json');
  Future<List<Map<String, dynamic>>> list(Map u) async {
    final rows = await s.db.rows(
      'SELECT * FROM document_templates ORDER BY name COLLATE NOCASE',
    );
    return rows
        .where((v) => s.manageStudents(u) || v['archived'] == 0)
        .map(decode)
        .toList();
  }

  Future<void> applyToStudent(Map u, String student, Map b) async {
    manage(u);
    await s.db.transaction(() async {
      final person = await s.student(u, student);
      s.revision(b, person);
      final template = await s.one('document_templates', s.text(b, 'template'));
      if (template['archived'] == 1)
        throw ApiError(409, 'O modelo está arquivado.');
      final configured = Map<String, dynamic>.from(
        jsonDecode(person['template_fields_json']),
      );
      final extra = Map<String, dynamic>.from(jsonDecode(person['extra_json']));
      final added = Map<String, dynamic>.from(
        jsonDecode(template['fields_json']),
      );
      final canonical = {
        for (final name in [
          ...extra.keys,
          ...List<String>.from(configured['extra'] ?? []),
        ])
          name.toLowerCase(): name,
      };
      final required = <String>{
        ...List<String>.from(configured['extra'] ?? []),
      };
      for (final label in List<String>.from(added['extra'] ?? [])) {
        final name = canonical.putIfAbsent(label.toLowerCase(), () => label);
        required.add(name);
        extra.putIfAbsent(name, () => '');
      }
      if (extra.length > 30)
        throw ApiError(
          400,
          'Os modelos excedem o limite de 30 informações adicionais na pasta.',
        );
      for (final type in jsonDecode(template['documents_json']) as List) {
        await s.db.exec('INSERT OR IGNORE INTO requirements VALUES(?,?,?)', [
          uuid.v4(),
          student,
          type,
        ]);
      }
      await s.db.exec(
        'UPDATE students SET template=?,template_fields_json=?,extra_json=?,updated=?,revision=revision+1 WHERE id=?',
        [
          template['id'],
          jsonEncode({
            'extra': required.toList(),
            'identity': {
              ...List<String>.from(configured['identity'] ?? []),
              ...List<String>.from(added['identity'] ?? []),
            }.toList(),
          }),
          jsonEncode(extra),
          now(),
          student,
        ],
      );
    });
  }

  Future<String> save(Map u, Map b, {String? id}) async {
    manage(u);
    final documents = names(b, 'documents'),
        fields = names(b, 'extra_fields', max: 30),
        identity = names(b, 'required_identity', max: 10);
    if (identity.any(
      (v) => ![
        'birth_date',
        'guardian',
        'phone',
        'email',
        'sex',
        'social_name',
        'birthplace',
        'nationality',
        'parentage',
        'address',
      ].contains(v),
    ))
      throw ApiError(400, 'Dado básico inválido no modelo.');
    final name = s.text(b, 'name', max: 120);
    final archived = b['archived'] ?? 0;
    if (archived != 0 && archived != 1)
      throw ApiError(400, 'Situação do modelo inválida.');
    return s.db.transaction(() async {
      if (id == null) {
        final created = uuid.v4();
        await s.db.exec(
          'INSERT INTO document_templates(id,name,documents_json,fields_json) VALUES(?,?,?,?)',
          [
            created,
            name,
            jsonEncode(documents),
            jsonEncode({'extra': fields, 'identity': identity}),
          ],
        );
        return created;
      }
      final old = await s.one('document_templates', id);
      s.revision(b, old);
      await s.db.exec(
        'UPDATE document_templates SET name=?,documents_json=?,fields_json=?,archived=?,revision=revision+1 WHERE id=?',
        [
          name,
          jsonEncode(documents),
          jsonEncode({'extra': fields, 'identity': identity}),
          archived,
          id,
        ],
      );
      return id;
    });
  }
}
