import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:crypto/crypto.dart' as digest;
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';

import 'store.dart';

const accountRoles = {
  'admin': 'Administração',
  'secretaria': 'Secretaria',
  'coordenacao': 'Coordenação',
  'professor': 'Professor',
  'gremio': 'Grêmio',
  'aluno': 'Aluno',
  'responsavel': 'Responsável',
};

Future<List<int>> _passwordKey(String password, List<int> salt) =>
    Isolate.run(() async {
      final key = await Pbkdf2.hmacSha256(
        iterations: 600000,
        bits: 256,
      ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);
      return key.extractBytes();
    });

class Auth {
  final Store s;
  Auth(this.s);
  final _failures = <String, ({int count, DateTime since})>{};
  int _verifying = 0;
  String randomToken([int length = 32]) => base64UrlEncode(
    List.generate(length, (_) => Random.secure().nextInt(256)),
  );
  String tokenHash(String token) =>
      digest.sha256.convert(utf8.encode(token)).toString();
  Future<bool> configured() async =>
      (await s.db.rows('SELECT user FROM credentials LIMIT 1')).isNotEmpty;
  String loginName(Map b) {
    final login = s.text(b, 'login', max: 80).toLowerCase();
    if (!RegExp(r'^[a-z0-9][a-z0-9_.@-]{2,79}$').hasMatch(login)) {
      throw ApiError(
        400,
        'Use um usuário com 3 a 80 letras, números, ponto, @, hífen ou sublinhado.',
      );
    }
    return login;
  }

  String password(Map b, [String key = 'password']) {
    final p = b[key];
    if (p is! String || p.length < 12 || p.length > 128) {
      throw ApiError(400, 'A senha deve ter entre 12 e 128 caracteres.');
    }
    return p;
  }

  Future<({String salt, String hash})> hashPassword(String p) async {
    final salt = randomToken(16);
    return (
      salt: salt,
      hash: base64Encode(await _passwordKey(p, base64Url.decode(salt))),
    );
  }

  Future<Map<String, dynamic>> issue(String user) async {
    final token = randomToken();
    final expires = DateTime.now()
        .toUtc()
        .add(const Duration(hours: 8))
        .toIso8601String();
    await s.db.exec('DELETE FROM sessions WHERE expires<=?', [now()]);
    await s.db.exec('INSERT INTO sessions VALUES(?,?,?)', [
      tokenHash(token),
      user,
      expires,
    ]);
    return {
      'token': token,
      'expires': expires,
      'user': await s.one('users', user),
    };
  }

  Future<Map<String, dynamic>> setup(Map b) async {
    if (await configured())
      throw ApiError(409, 'A instalação já foi configurada.');
    final login = loginName(b), name = s.text(b, 'name', max: 180);
    final hashed = await hashPassword(password(b));
    await s.db.transaction(() async {
      if (await configured())
        throw ApiError(
          409,
          'A instalação já possui administrador. Entre com sua conta.',
        );
      await s.db.exec(
        "UPDATE users SET name=?,role='admin',department='secretaria' WHERE id='local'",
        [name],
      );
      await s.db.exec(
        'INSERT INTO credentials(user,login,salt,password_hash) VALUES(?,?,?,?)',
        ['local', login, hashed.salt, hashed.hash],
      );
    });
    return issue('local');
  }

  Future<Map<String, dynamic>> login(Map b, String remote) async {
    final login = loginName(b);
    final p = b['password'];
    if (p is! String || p.length > 128) throw ApiError(400, 'Informe a senha.');
    final key = '$remote:$login';
    final time = DateTime.now();
    final failure = _failures[key];
    if (failure != null &&
        time.difference(failure.since) < const Duration(minutes: 10) &&
        failure.count >= 5) {
      throw ApiError(
        429,
        'Muitas tentativas. Aguarde dez minutos antes de tentar novamente.',
      );
    }
    if (_verifying >= 2)
      throw ApiError(
        429,
        'Há entradas em processamento. Tente novamente em instantes.',
      );
    _verifying++;
    try {
      final accounts = await s.db.rows(
        'SELECT * FROM credentials WHERE login=? COLLATE NOCASE',
        [login],
      );
      final account = accounts.firstOrNull;
      final salt = account == null
          ? List.filled(16, 0)
          : base64Url.decode(account['salt']);
      final actual = await _passwordKey(p, salt);
      final expected = account == null
          ? List.filled(32, 0)
          : base64Decode(account['password_hash']);
      if (!constantTimeBytesEquality.equals(actual, expected) ||
          account?['enabled'] != 1) {
        if (_failures.length >= 1024) _failures.remove(_failures.keys.first);
        final fresh =
            failure == null ||
            time.difference(failure.since) >= const Duration(minutes: 10);
        _failures[key] = (
          count: fresh ? 1 : failure.count + 1,
          since: fresh ? time : failure.since,
        );
        throw ApiError(401, 'Usuário ou senha inválidos.');
      }
      _failures.remove(key);
      return await issue(account!['user']);
    } finally {
      _verifying--;
    }
  }

  Future<Map<String, dynamic>> authenticate(String? authorization) async {
    if (authorization == null ||
        !authorization.startsWith('Bearer ') ||
        authorization.length > 128) {
      throw ApiError(401, 'Entre com sua conta para continuar.');
    }
    final rows = await s.db.rows(
      'SELECT u.* FROM sessions t JOIN credentials c ON c.user=t.user JOIN users u ON u.id=t.user WHERE t.token_hash=? AND t.expires>? AND c.enabled=1',
      [tokenHash(authorization.substring(7)), now()],
    );
    if (rows.isEmpty) throw ApiError(401, 'Sessão expirada. Entre novamente.');
    return rows.single;
  }

  Future<void> logout(String authorization) => s.db.exec(
    'DELETE FROM sessions WHERE token_hash=?',
    [tokenHash(authorization.substring(7))],
  );
  void admin(Map u) {
    if (!s.admin(u))
      throw ApiError(403, 'Somente a administração pode gerenciar contas.');
  }

  Future<List<Map<String, dynamic>>> accounts(Map u) async {
    admin(u);
    final rows = await s.db.rows(
      'SELECT u.*,c.login,c.enabled,c.revision FROM users u JOIN credentials c ON c.user=u.id ORDER BY u.name COLLATE NOCASE',
    );
    for (final row in rows) {
      row['students'] = (await s.db.rows(
        'SELECT student FROM student_access WHERE user=?',
        [row['id']],
      )).map((r) => r['student']).toList();
    }
    return rows;
  }

  Future<void> _links(String user, String role, Object? value) async {
    if (value is! List || value.any((id) => id is! String) || value.length > 30)
      throw ApiError(400, 'Selecione alunos válidos.');
    if (value.isNotEmpty && !['aluno', 'responsavel'].contains(role))
      throw ApiError(
        400,
        'Somente contas de aluno e responsável podem receber vínculo pessoal.',
      );
    if (role == 'aluno' && value.length > 1)
      throw ApiError(
        400,
        'A conta de aluno deve representar uma única pessoa.',
      );
    for (final id in value.toSet()) {
      await s.one('students', id);
    }
    await s.db.exec('DELETE FROM student_access WHERE user=?', [user]);
    for (final id in value.toSet()) {
      await s.db.exec('INSERT INTO student_access VALUES(?,?)', [id, user]);
    }
  }

  String role(Map b) {
    final r = s.text(b, 'role');
    if (!accountRoles.containsKey(r)) throw ApiError(400, 'Papel inválido.');
    return r;
  }

  String? department(String role) =>
      ['secretaria', 'coordenacao'].contains(role) ? role : null;
  Future<String> createAccount(Map u, Map b) async {
    admin(u);
    final login = loginName(b), name = s.text(b, 'name', max: 180), r = role(b);
    final hashed = await hashPassword(password(b));
    final id = uuid.v4();
    await s.db.transaction(() async {
      await s.db.exec('INSERT INTO users VALUES(?,?,?,?)', [
        id,
        name,
        r,
        department(r),
      ]);
      await s.db.exec(
        'INSERT INTO credentials(user,login,salt,password_hash) VALUES(?,?,?,?)',
        [id, login, hashed.salt, hashed.hash],
      );
      await _links(id, r, b['students'] ?? []);
      await s.createFolder(await s.one('users', id), {
        'name': 'Documentos pessoais',
      });
    });
    return id;
  }

  Future<void> updateAccount(Map u, String id, Map b) async {
    admin(u);
    final hashed = b['password'] == null || b['password'] == ''
        ? null
        : await hashPassword(password(b));
    await s.db.transaction(() async {
      final account = await s.one('users', id);
      final credentials = (await s.db.rows(
        'SELECT * FROM credentials WHERE user=?',
        [id],
      )).firstOrNull;
      if (credentials == null) throw ApiError(404, 'Conta não encontrada.');
      s.revision(b, credentials);
      final r = role({...account, ...b});
      final enabled = b['enabled'] ?? credentials['enabled'];
      if (enabled != 0 && enabled != 1)
        throw ApiError(400, 'Situação de conta inválida.');
      if (account['role'] == 'admin' && (r != 'admin' || enabled == 0)) {
        final count =
            (await s.db.rows(
                  "SELECT count(*) AS n FROM users u JOIN credentials c ON c.user=u.id WHERE u.role='admin' AND c.enabled=1",
                )).single['n']
                as int;
        if (count <= 1)
          throw ApiError(409, 'Mantenha ao menos um administrador ativo.');
      }
      await s.db.exec(
        'UPDATE users SET name=?,role=?,department=? WHERE id=?',
        [
          s.text({...account, ...b}, 'name', max: 180),
          r,
          department(r),
          id,
        ],
      );
      await s.db.exec(
        'UPDATE credentials SET enabled=?,salt=?,password_hash=?,revision=revision+1 WHERE user=?',
        [
          enabled,
          hashed?.salt ?? credentials['salt'],
          hashed?.hash ?? credentials['password_hash'],
          id,
        ],
      );
      if (b.containsKey('students')) {
        await _links(id, r, b['students']);
      } else if (!['aluno', 'responsavel'].contains(r)) {
        await s.db.exec('DELETE FROM student_access WHERE user=?', [id]);
      }
      if (enabled == 0 ||
          r != account['role'] ||
          hashed != null ||
          b.containsKey('students')) {
        await s.db.exec('DELETE FROM sessions WHERE user=?', [id]);
      }
    });
  }

  Future<void> changePassword(Map u, Map b) async {
    final credential = (await s.db.rows(
      'SELECT * FROM credentials WHERE user=?',
      [u['id']],
    )).single;
    final old = b['oldPassword'];
    if (old is! String || old.length > 128)
      throw ApiError(400, 'Informe sua senha atual.');
    final actual = await _passwordKey(
      old,
      base64Url.decode(credential['salt']),
    );
    if (!constantTimeBytesEquality.equals(
      actual,
      base64Decode(credential['password_hash']),
    ))
      throw ApiError(403, 'Senha atual incorreta.');
    final hashed = await hashPassword(password(b, 'newPassword'));
    await s.db.transaction(() async {
      await s.db.exec(
        'UPDATE credentials SET salt=?,password_hash=?,revision=revision+1 WHERE user=?',
        [hashed.salt, hashed.hash, u['id']],
      );
      await s.db.exec('DELETE FROM sessions WHERE user=?', [u['id']]);
    });
  }
}
