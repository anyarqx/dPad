import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
part 'database.g.dart';

@DriftDatabase(include: {'schema.drift'})
class Database extends _$Database {
  Database(File file) : super(NativeDatabase(file));
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement('PRAGMA application_id = 1146102101');
    },
    onUpgrade: (_, _, _) async => throw StateError(
      'Banco de desenvolvimento incompatível. Recrie com --reset-data RECRIAR.',
    ),
    beforeOpen: (_) async {
      final id = (await customSelect(
        'PRAGMA application_id',
      ).getSingle()).read<int>('application_id');
      if (id != 1146102101)
        throw StateError(
          'Banco de desenvolvimento incompatível. Recrie com --reset-data RECRIAR.',
        );
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
  Future<List<Map<String, dynamic>>> rows(
    String sql, [
    List<Object> args = const [],
  ]) async => (await customSelect(
    sql,
    variables: args.map((v) => Variable(v)).toList(),
  ).get()).map((r) => Map<String, dynamic>.from(r.data)).toList();
  Future<void> exec(String sql, [List<Object?> args = const []]) =>
      customStatement(sql, args);
}
