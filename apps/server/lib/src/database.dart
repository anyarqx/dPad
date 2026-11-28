import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
part 'database.g.dart';

@DriftDatabase(include: {'schema.drift'})
class Database extends _$Database {
  final _NativeState _native;
  Database(File file) : this._(file, _NativeState());
  Database._(File file, _NativeState state)
    : _native = state,
      super(NativeDatabase(file, setup: (db) => state.connection = db));
  Future<sqlite.Database> get native async {
    await customSelect('SELECT 1').get();
    return _native.connection!;
  }

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
      final columns = (await customSelect(
        "SELECT m.name || '.' || p.name AS name FROM sqlite_schema m, pragma_table_info(m.name) p WHERE m.type='table' AND m.name NOT GLOB 'sqlite_*'",
      ).get()).map((row) => row.read<String>('name')).toSet();
      final expected = {
        for (final table in allTables)
          for (final column in table.$columns)
            '${table.actualTableName}.${column.$name}',
      };
      if (id != 1146102101 ||
          columns.length != expected.length ||
          !columns.containsAll(expected)) {
        throw StateError(
          'Banco incompatível. Para recriar uma instalação de desenvolvimento, use --reset-data RECRIAR.',
        );
      }
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA busy_timeout = 5000');
      await customStatement('PRAGMA journal_mode = WAL');
      await customStatement(
        'INSERT OR IGNORE INTO institution_settings(id) VALUES(1)',
      );
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

class _NativeState {
  sqlite.Database? connection;
}
