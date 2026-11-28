import 'dart:convert';
import 'dart:async';

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
  if (auth['test'] != true && api.token == null) return {'auth': auth};
  try {
    final bootstrap = await api.get('bootstrap');
    api.profile = bootstrap['session']['user']['id'];
    return JsonMap.from(bootstrap);
  } on ApiException catch (e) {
    if (e.status == 401 && auth['test'] != true) {
      return {'auth': auth, 'message': e.message};
    }
    rethrow;
  }
});

final resourceProvider = FutureProvider.autoDispose.family<dynamic, String>(
  (ref, path) => ref.watch(apiProvider).get(path),
);
const sectionResources = <String, List<String>>{
  'students': ['students', 'folders', 'documents', 'requests', 'templates'],
  'documents': ['students', 'folders', 'documents', 'templates'],
  'requests': ['students', 'folders', 'documents', 'requests'],
  'queue': ['students', 'folders', 'documents', 'requests?queue=true'],
  'classes': ['students', 'templates'],
  'academic': [],
  'accounts': ['students'],
  'templates': ['templates'],
  'maintenance': [],
};

const mainSectionResources = <String, List<String>>{
  'students': ['students'],
  'documents': ['folders', 'documents'],
  'requests': ['requests'],
  'queue': ['requests?queue=true'],
  'templates': ['templates'],
};

enum ApiFailure {
  connection,
  address,
  session,
  permission,
  incompatible,
  server,
}

class ApiException implements Exception {
  final ApiFailure failure;
  final int status;
  final String message;
  ApiException(this.status, this.message, {ApiFailure? failure})
    : failure =
          failure ??
          switch (status) {
            0 => ApiFailure.connection,
            401 => ApiFailure.session,
            403 => ApiFailure.permission,
            _ => ApiFailure.server,
          };
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
  Future<JsonMap> checkServer(String value) async {
    final u = Uri.tryParse(value.trim());
    if (u == null ||
        !['http', 'https'].contains(u.scheme) ||
        u.host.isEmpty ||
        u.userInfo.isNotEmpty ||
        u.hasQuery ||
        u.hasFragment ||
        !(u.path.isEmpty || u.path == '/')) {
      throw ApiException(
        400,
        'Informe uma URL HTTP válida, sem caminho.',
        failure: ApiFailure.address,
      );
    }
    validateTransport(u);
    try {
      final r = await client
          .get(u.replace(path: '/health'))
          .timeout(const Duration(seconds: 5));
      dynamic info;
      try {
        info = jsonDecode(r.body);
      } catch (_) {}
      if (r.statusCode != 200 ||
          info is! Map<String, dynamic> ||
          info['application'] != 'papel-digital' ||
          info['version'] != 1) {
        throw ApiException(
          503,
          'O endereço respondeu, mas a API é incompatível. Confira o endereço e a porta.',
          failure: ApiFailure.incompatible,
        );
      }
      return info;
    } on TimeoutException {
      throw ApiException(
        0,
        'O servidor não respondeu. Confira se está iniciado e se o computador está na mesma rede.',
      );
    } on http.ClientException {
      throw ApiException(
        0,
        'Não foi possível conectar ao servidor. Confira o endereço, a rede e a porta liberada no computador hospedeiro.',
      );
    }
  }

  Future<void> health(String value) async {
    await checkServer(value);
    final endpoint = Uri.parse(value.trim()).origin;
    if (endpoint != base) profile = 'local';
    base = endpoint;
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
    try {
      return jsonDecode(utf8.decode(r.bodyBytes));
    } catch (_) {
      throw ApiException(
        502,
        'O endereço retornou uma página ou resposta incompatível com a API dPad.',
        failure: ApiFailure.incompatible,
      );
    }
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

  Future<http.Response> network(
    Future<http.Response> Function() action, {
    int seconds = 30,
  }) async {
    try {
      return await action().timeout(Duration(seconds: seconds));
    } on TimeoutException {
      throw ApiException(
        0,
        'A conexão excedeu o tempo de espera. Tente novamente.',
      );
    } on http.ClientException {
      throw ApiException(
        0,
        'Não foi possível conectar. Confira endereço, porta, HTTPS, rede e liberação no servidor.',
      );
    } on FormatException {
      throw ApiException(
        400,
        'Endereço de servidor inválido.',
        failure: ApiFailure.address,
      );
    }
  }

  Future<dynamic> get(String p) async =>
      decode(await network(() => client.get(uri(p), headers: headers)));
  Future<dynamic> send(String method, String p, [JsonMap? data]) async {
    final r = http.Request(method, uri(p))
      ..headers.addAll({...headers, 'Content-Type': 'application/json'})
      ..body = jsonEncode(data ?? {});
    return decode(
      await network(() async => http.Response.fromStream(await client.send(r))),
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
      await network(
        () async => http.Response.fromStream(await client.send(r)),
        seconds: 90,
      ),
    ) as JsonMap;
  }

  Future<JsonMap> uploadBackup(Uint8List bytes) async => JsonMap.from(
    decode(
      await network(
        () => client.post(
          uri('maintenance/inspect'),
          headers: {...headers, 'Content-Type': 'application/zip'},
          body: bytes,
        ),
        seconds: 180,
      ),
    ),
  );

  Future<Uint8List> bytes(String id) => download('documents/$id/content');

  Future<Uint8List> download(String path) async {
    final r = await network(
      () => client.get(uri(path), headers: headers),
      seconds: 60,
    );
    if (r.statusCode >= 400) decode(r);
    return r.bodyBytes;
  }

  Future<Uint8List> pdf(String id) async {
    final r = await network(
      () => client.post(uri('requests/$id/pdf'), headers: headers),
    );
    if (r.statusCode >= 400) decode(r);
    return r.bodyBytes;
  }
}
