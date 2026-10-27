import 'api.dart';

String folderLocation(String id, List<JsonMap> folders) {
  final parts = <String>[], visited = <String>{};
  String? cursor = id;
  while (cursor != null && visited.add(cursor)) {
    final folder = folders.where((f) => f['id'] == cursor).firstOrNull;
    if (folder == null) break;
    final name = folder['student_name'] ?? folder['name'];
    final ambiguous =
        folder['parent'] == null &&
        folder['student_name'] == null &&
        folders.any(
          (other) =>
              other['id'] != folder['id'] &&
              other['parent'] == null &&
              other['name'] == folder['name'],
        );
    parts.insert(
      0,
      ambiguous && folder['area_name'] != null
          ? '$name · ${folder['area_name']}'
          : name,
    );
    cursor = folder['parent'];
  }
  return parts.isEmpty ? 'Documento compartilhado' : parts.join(' / ');
}
