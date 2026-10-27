import 'dart:convert';

import 'package:flutter/foundation.dart'
    show kIsWeb, kReleaseMode, defaultTargetPlatform, TargetPlatform;

import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef JsonMap = Map<String, dynamic>;
final apiProvider = Provider((ref) {
  final api = Api();
  ref.onDispose(api.client.close);
  return api;
});
final dataProvider = FutureProvider<JsonMap>((ref) async {
  final api = ref.watch(apiProvider);
  final auth = await api.get('auth/status');
  if (auth['demo'] != true && api.token == null) return {'auth': auth};
  dynamic session;
  try {
    session = await api.get('session');
  } on ApiException catch (e) {
    if (e.status != 401 || auth['demo'] == true) rethrow;
    return {'auth': auth, 'message': e.message};
  }
  api.profile = session['user']['id'];
  final results = await Future.wait([
    api.get('folders'),
    api.get('documents'),
    api.get('requests'),
    api.get('requests?queue=true'),
    api.get('students'),
    api.get('classes'),
    api.get('courses'),
    api.get('templates'),
  ]);
  return {
    'session': session,
    'folders': results[0],
    'documents': results[1],
    'requests': results[2],
    'queue': results[3],
    'students': results[4],
    'classes': results[5],
    'courses': results[6],
    'templates': results[7],
  };
});

class ApiException implements Exception {
  final int status;
  final String message;
  ApiException(this.status, this.message);
  @override
  String toString() => message;
}

class Api {
  static const configured = String.fromEnvironment('API_URL');
  String _base = configured.isNotEmpty
      ? configured
      : (kIsWeb ? Uri.base.origin : 'http://127.0.0.1:8080');
  String profile = 'local';
  String? token;
  String get base => _base;
  set base(String value) {
    if (_base != value) token = null;
    _base = value;
  }

  final http.Client client = http.Client();
  void validateTransport(Uri uri) {
    if (!kIsWeb &&
        kReleaseMode &&
        defaultTargetPlatform == TargetPlatform.android &&
        uri.scheme != 'https') {
      throw const FormatException(
        'No Android distribuído, utilize o endereço HTTPS da instalação. HTTP está disponível somente no APK de laboratório.',
      );
    }
  }

  Uri uri(String path) {
    final value = Uri.parse('$base/api/v1/$path');
    validateTransport(value);
    return value;
  }

  Map<String, String> get headers => {
    'X-Profile': profile,
    if (token != null) 'Authorization': 'Bearer $token',
  };
  Future<void> health(String value) async {
    final u = Uri.tryParse(value.trim());
    if (u == null ||
        !['http', 'https'].contains(u.scheme) ||
        u.host.isEmpty ||
        u.userInfo.isNotEmpty ||
        u.hasQuery ||
        u.hasFragment ||
        !(u.path.isEmpty || u.path == '/')) {
      throw Exception('Informe uma URL HTTP válida, sem caminho.');
    }
    validateTransport(u);
    final r = await client
        .get(u.replace(path: '/health'))
        .timeout(const Duration(seconds: 5));
    if (r.statusCode != 200 ||
        jsonDecode(r.body)['application'] != 'papel-digital') {
      throw Exception('Servidor incompatível ou indisponível.');
    }
    base = value.trim().replaceAll(RegExp(r'/$'), '');
  }

  dynamic decode(http.Response r) {
    if (r.statusCode >= 400) {
      if (r.statusCode == 401) token = null;
      final Object? decoded;
      try {
        decoded = jsonDecode(utf8.decode(r.bodyBytes));
      } catch (_) {
        throw ApiException(
          r.statusCode,
          'O servidor retornou HTTP ${r.statusCode}.',
        );
      }
      throw ApiException(
        r.statusCode,
        decoded is Map
            ? '${decoded['error'] ?? 'Erro HTTP ${r.statusCode}'}'
            : 'Erro HTTP ${r.statusCode}',
      );
    }
    return jsonDecode(utf8.decode(r.bodyBytes));
  }

  Future<void> authenticate(JsonMap fields, {bool setup = false}) async {
    final result = await send(
      'POST',
      setup ? 'auth/setup' : 'auth/login',
      fields,
    );
    token = result['token'];
    profile = result['user']['id'];
  }

  Future<void> logout() async {
    try {
      if (token != null) await send('POST', 'auth/logout');
    } finally {
      token = null;
    }
  }

  Future<dynamic> get(String p) async => decode(
    await client
        .get(uri(p), headers: headers)
        .timeout(const Duration(seconds: 15)),
  );
  Future<dynamic> send(String method, String p, [JsonMap? data]) async {
    final r = http.Request(method, uri(p))
      ..headers.addAll({...headers, 'Content-Type': 'application/json'})
      ..body = jsonEncode(data ?? {});
    return decode(
      await http.Response.fromStream(
        await client.send(r).timeout(const Duration(seconds: 30)),
      ),
    );
  }

  Future<JsonMap> upload(
    Uint8List bytes,
    String name,
    String folder,
    String type,
  ) async {
    if (bytes.length > 30 * 1024 * 1024) {
      throw Exception('Limite de 30 MB por arquivo.');
    }
    final r =
        http.MultipartRequest(
            'POST',
            uri('documents').replace(
              queryParameters: {'name': name, 'folder': folder, 'type': type},
            ),
          )
          ..headers.addAll(headers)
          ..files.add(
            http.MultipartFile.fromBytes('file', bytes, filename: name),
          );
    return decode(
      await http.Response.fromStream(
        await client.send(r).timeout(const Duration(seconds: 90)),
      ),
    ) as JsonMap;
  }

  Future<Uint8List> bytes(String id) => download('documents/$id/content');

  Future<Uint8List> download(String path) async {
    final r = await client
        .get(uri(path), headers: headers)
        .timeout(const Duration(seconds: 60));
    if (r.statusCode >= 400) decode(r);
    return r.bodyBytes;
  }

  Future<Uint8List> pdf(String id) async {
    final r = await client.post(uri('requests/$id/pdf'), headers: headers);
    if (r.statusCode >= 400) decode(r);
    return r.bodyBytes;
  }
}
