bool get isHosting => false;
bool get canHost => false;
Uri? get hostedAddress => null;
Future<Uri> host({int port = 8080}) async => throw Exception(
  'Hospedagem disponível no aplicativo desktop. Inicie o servidor Dart e informe sua URL.',
);
Future<void> stopHost() async {}
