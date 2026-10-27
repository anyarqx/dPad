bool get canHost => false;
Future<void> host() async => throw Exception(
  'Hospedagem disponível no aplicativo desktop. Inicie o servidor Dart e informe sua URL.',
);
Future<void> stopHost() async {}
