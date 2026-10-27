// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Users extends Table with TableInfo<Users, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Users(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, role, department];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
    );
  }

  @override
  Users createAlias(String alias) {
    return Users(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String role;
  final String? department;
  const User({
    required this.id,
    required this.name,
    required this.role,
    this.department,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      department: serializer.fromJson<String?>(json['department']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'department': serializer.toJson<String?>(department),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? role,
    Value<String?> department = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    department: department.present ? department.value : this.department,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      department: data.department.present
          ? data.department.value
          : this.department,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('department: $department')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, role, department);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.department == this.department);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String?> department;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String role,
    this.department = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       role = Value(role);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? department,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (department != null) 'department': department,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? role,
    Value<String?>? department,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('department: $department, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Folders extends Table with TableInfo<Folders, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Folders(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(name)) > 0)',
  );
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
    'parent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES folders(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parent,
    area,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Folder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(
        _parentMeta,
        parent.isAcceptableOrUnknown(data['parent']!, _parentMeta),
      );
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent'],
      ),
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Folders createAlias(String alias) {
    return Folders(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Folder extends DataClass implements Insertable<Folder> {
  final String id;
  final String name;
  final String? parent;
  final String area;
  final String created;
  final String updated;
  final int revision;
  const Folder({
    required this.id,
    required this.name,
    this.parent,
    required this.area,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parent != null) {
      map['parent'] = Variable<String>(parent);
    }
    map['area'] = Variable<String>(area);
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      parent: parent == null && nullToAbsent
          ? const Value.absent()
          : Value(parent),
      area: Value(area),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory Folder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parent: serializer.fromJson<String?>(json['parent']),
      area: serializer.fromJson<String>(json['area']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parent': serializer.toJson<String?>(parent),
      'area': serializer.toJson<String>(area),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Folder copyWith({
    String? id,
    String? name,
    Value<String?> parent = const Value.absent(),
    String? area,
    String? created,
    String? updated,
    int? revision,
  }) => Folder(
    id: id ?? this.id,
    name: name ?? this.name,
    parent: parent.present ? parent.value : this.parent,
    area: area ?? this.area,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parent: data.parent.present ? data.parent.value : this.parent,
      area: data.area.present ? data.area.value : this.area,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parent: $parent, ')
          ..write('area: $area, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parent, area, created, updated, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.name == this.name &&
          other.parent == this.parent &&
          other.area == this.area &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parent;
  final Value<String> area;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parent = const Value.absent(),
    this.area = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    this.parent = const Value.absent(),
    required String area,
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       area = Value(area),
       created = Value(created),
       updated = Value(updated);
  static Insertable<Folder> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parent,
    Expression<String>? area,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parent != null) 'parent': parent,
      if (area != null) 'area': area,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parent,
    Value<String>? area,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      area: area ?? this.area,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parent: $parent, ')
          ..write('area: $area, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Documents extends Table with TableInfo<Documents, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Documents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _folderMeta = const VerificationMeta('folder');
  late final GeneratedColumn<String> folder = GeneratedColumn<String>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES folders(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (size > 0)',
  );
  static const VerificationMeta _storageMeta = const VerificationMeta(
    'storage',
  );
  late final GeneratedColumn<String> storage = GeneratedColumn<String>(
    'storage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'Aguardando conferência\'',
    defaultValue: const CustomExpression('\'Aguardando conferência\''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _uploaderMeta = const VerificationMeta(
    'uploader',
  );
  late final GeneratedColumn<String> uploader = GeneratedColumn<String>(
    'uploader',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    folder,
    type,
    mime,
    size,
    storage,
    status,
    note,
    uploader,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('folder')) {
      context.handle(
        _folderMeta,
        folder.isAcceptableOrUnknown(data['folder']!, _folderMeta),
      );
    } else if (isInserting) {
      context.missing(_folderMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('mime')) {
      context.handle(
        _mimeMeta,
        mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('storage')) {
      context.handle(
        _storageMeta,
        storage.isAcceptableOrUnknown(data['storage']!, _storageMeta),
      );
    } else if (isInserting) {
      context.missing(_storageMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('uploader')) {
      context.handle(
        _uploaderMeta,
        uploader.isAcceptableOrUnknown(data['uploader']!, _uploaderMeta),
      );
    } else if (isInserting) {
      context.missing(_uploaderMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      storage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      uploader: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploader'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Documents createAlias(String alias) {
    return Documents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Document extends DataClass implements Insertable<Document> {
  final String id;
  final String name;
  final String folder;
  final String type;
  final String mime;
  final int size;
  final String storage;
  final String status;
  final String note;
  final String uploader;
  final String created;
  final String updated;
  final int revision;
  const Document({
    required this.id,
    required this.name,
    required this.folder,
    required this.type,
    required this.mime,
    required this.size,
    required this.storage,
    required this.status,
    required this.note,
    required this.uploader,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['folder'] = Variable<String>(folder);
    map['type'] = Variable<String>(type);
    map['mime'] = Variable<String>(mime);
    map['size'] = Variable<int>(size);
    map['storage'] = Variable<String>(storage);
    map['status'] = Variable<String>(status);
    map['note'] = Variable<String>(note);
    map['uploader'] = Variable<String>(uploader);
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      name: Value(name),
      folder: Value(folder),
      type: Value(type),
      mime: Value(mime),
      size: Value(size),
      storage: Value(storage),
      status: Value(status),
      note: Value(note),
      uploader: Value(uploader),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      folder: serializer.fromJson<String>(json['folder']),
      type: serializer.fromJson<String>(json['type']),
      mime: serializer.fromJson<String>(json['mime']),
      size: serializer.fromJson<int>(json['size']),
      storage: serializer.fromJson<String>(json['storage']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String>(json['note']),
      uploader: serializer.fromJson<String>(json['uploader']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'folder': serializer.toJson<String>(folder),
      'type': serializer.toJson<String>(type),
      'mime': serializer.toJson<String>(mime),
      'size': serializer.toJson<int>(size),
      'storage': serializer.toJson<String>(storage),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String>(note),
      'uploader': serializer.toJson<String>(uploader),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Document copyWith({
    String? id,
    String? name,
    String? folder,
    String? type,
    String? mime,
    int? size,
    String? storage,
    String? status,
    String? note,
    String? uploader,
    String? created,
    String? updated,
    int? revision,
  }) => Document(
    id: id ?? this.id,
    name: name ?? this.name,
    folder: folder ?? this.folder,
    type: type ?? this.type,
    mime: mime ?? this.mime,
    size: size ?? this.size,
    storage: storage ?? this.storage,
    status: status ?? this.status,
    note: note ?? this.note,
    uploader: uploader ?? this.uploader,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      folder: data.folder.present ? data.folder.value : this.folder,
      type: data.type.present ? data.type.value : this.type,
      mime: data.mime.present ? data.mime.value : this.mime,
      size: data.size.present ? data.size.value : this.size,
      storage: data.storage.present ? data.storage.value : this.storage,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      uploader: data.uploader.present ? data.uploader.value : this.uploader,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('folder: $folder, ')
          ..write('type: $type, ')
          ..write('mime: $mime, ')
          ..write('size: $size, ')
          ..write('storage: $storage, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('uploader: $uploader, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    folder,
    type,
    mime,
    size,
    storage,
    status,
    note,
    uploader,
    created,
    updated,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.name == this.name &&
          other.folder == this.folder &&
          other.type == this.type &&
          other.mime == this.mime &&
          other.size == this.size &&
          other.storage == this.storage &&
          other.status == this.status &&
          other.note == this.note &&
          other.uploader == this.uploader &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> folder;
  final Value<String> type;
  final Value<String> mime;
  final Value<int> size;
  final Value<String> storage;
  final Value<String> status;
  final Value<String> note;
  final Value<String> uploader;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.folder = const Value.absent(),
    this.type = const Value.absent(),
    this.mime = const Value.absent(),
    this.size = const Value.absent(),
    this.storage = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.uploader = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required String id,
    required String name,
    required String folder,
    required String type,
    required String mime,
    required int size,
    required String storage,
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    required String uploader,
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       folder = Value(folder),
       type = Value(type),
       mime = Value(mime),
       size = Value(size),
       storage = Value(storage),
       uploader = Value(uploader),
       created = Value(created),
       updated = Value(updated);
  static Insertable<Document> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? folder,
    Expression<String>? type,
    Expression<String>? mime,
    Expression<int>? size,
    Expression<String>? storage,
    Expression<String>? status,
    Expression<String>? note,
    Expression<String>? uploader,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (folder != null) 'folder': folder,
      if (type != null) 'type': type,
      if (mime != null) 'mime': mime,
      if (size != null) 'size': size,
      if (storage != null) 'storage': storage,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (uploader != null) 'uploader': uploader,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? folder,
    Value<String>? type,
    Value<String>? mime,
    Value<int>? size,
    Value<String>? storage,
    Value<String>? status,
    Value<String>? note,
    Value<String>? uploader,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      folder: folder ?? this.folder,
      type: type ?? this.type,
      mime: mime ?? this.mime,
      size: size ?? this.size,
      storage: storage ?? this.storage,
      status: status ?? this.status,
      note: note ?? this.note,
      uploader: uploader ?? this.uploader,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (storage.present) {
      map['storage'] = Variable<String>(storage.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (uploader.present) {
      map['uploader'] = Variable<String>(uploader.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('folder: $folder, ')
          ..write('type: $type, ')
          ..write('mime: $mime, ')
          ..write('size: $size, ')
          ..write('storage: $storage, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('uploader: $uploader, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentTemplates extends Table
    with TableInfo<DocumentTemplates, DocumentTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentTemplates(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE COLLATE NOCASE',
  );
  static const VerificationMeta _documentsJsonMeta = const VerificationMeta(
    'documentsJson',
  );
  late final GeneratedColumn<String> documentsJson = GeneratedColumn<String>(
    'documents_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _fieldsJsonMeta = const VerificationMeta(
    'fieldsJson',
  );
  late final GeneratedColumn<String> fieldsJson = GeneratedColumn<String>(
    'fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (archived IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    documentsJson,
    fieldsJson,
    archived,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('documents_json')) {
      context.handle(
        _documentsJsonMeta,
        documentsJson.isAcceptableOrUnknown(
          data['documents_json']!,
          _documentsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentsJsonMeta);
    }
    if (data.containsKey('fields_json')) {
      context.handle(
        _fieldsJsonMeta,
        fieldsJson.isAcceptableOrUnknown(data['fields_json']!, _fieldsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldsJsonMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      documentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}documents_json'],
      )!,
      fieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields_json'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  DocumentTemplates createAlias(String alias) {
    return DocumentTemplates(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DocumentTemplate extends DataClass
    implements Insertable<DocumentTemplate> {
  final String id;
  final String name;
  final String documentsJson;
  final String fieldsJson;
  final int archived;
  final int revision;
  const DocumentTemplate({
    required this.id,
    required this.name,
    required this.documentsJson,
    required this.fieldsJson,
    required this.archived,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['documents_json'] = Variable<String>(documentsJson);
    map['fields_json'] = Variable<String>(fieldsJson);
    map['archived'] = Variable<int>(archived);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  DocumentTemplatesCompanion toCompanion(bool nullToAbsent) {
    return DocumentTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      documentsJson: Value(documentsJson),
      fieldsJson: Value(fieldsJson),
      archived: Value(archived),
      revision: Value(revision),
    );
  }

  factory DocumentTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      documentsJson: serializer.fromJson<String>(json['documents_json']),
      fieldsJson: serializer.fromJson<String>(json['fields_json']),
      archived: serializer.fromJson<int>(json['archived']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'documents_json': serializer.toJson<String>(documentsJson),
      'fields_json': serializer.toJson<String>(fieldsJson),
      'archived': serializer.toJson<int>(archived),
      'revision': serializer.toJson<int>(revision),
    };
  }

  DocumentTemplate copyWith({
    String? id,
    String? name,
    String? documentsJson,
    String? fieldsJson,
    int? archived,
    int? revision,
  }) => DocumentTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    documentsJson: documentsJson ?? this.documentsJson,
    fieldsJson: fieldsJson ?? this.fieldsJson,
    archived: archived ?? this.archived,
    revision: revision ?? this.revision,
  );
  DocumentTemplate copyWithCompanion(DocumentTemplatesCompanion data) {
    return DocumentTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      documentsJson: data.documentsJson.present
          ? data.documentsJson.value
          : this.documentsJson,
      fieldsJson: data.fieldsJson.present
          ? data.fieldsJson.value
          : this.fieldsJson,
      archived: data.archived.present ? data.archived.value : this.archived,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('documentsJson: $documentsJson, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('archived: $archived, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, documentsJson, fieldsJson, archived, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.documentsJson == this.documentsJson &&
          other.fieldsJson == this.fieldsJson &&
          other.archived == this.archived &&
          other.revision == this.revision);
}

class DocumentTemplatesCompanion extends UpdateCompanion<DocumentTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> documentsJson;
  final Value<String> fieldsJson;
  final Value<int> archived;
  final Value<int> revision;
  final Value<int> rowid;
  const DocumentTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.documentsJson = const Value.absent(),
    this.fieldsJson = const Value.absent(),
    this.archived = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentTemplatesCompanion.insert({
    required String id,
    required String name,
    required String documentsJson,
    required String fieldsJson,
    this.archived = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       documentsJson = Value(documentsJson),
       fieldsJson = Value(fieldsJson);
  static Insertable<DocumentTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? documentsJson,
    Expression<String>? fieldsJson,
    Expression<int>? archived,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (documentsJson != null) 'documents_json': documentsJson,
      if (fieldsJson != null) 'fields_json': fieldsJson,
      if (archived != null) 'archived': archived,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? documentsJson,
    Value<String>? fieldsJson,
    Value<int>? archived,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return DocumentTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      documentsJson: documentsJson ?? this.documentsJson,
      fieldsJson: fieldsJson ?? this.fieldsJson,
      archived: archived ?? this.archived,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (documentsJson.present) {
      map['documents_json'] = Variable<String>(documentsJson.value);
    }
    if (fieldsJson.present) {
      map['fields_json'] = Variable<String>(fieldsJson.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('documentsJson: $documentsJson, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('archived: $archived, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Students extends Table with TableInfo<Students, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Students(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(name)) > 0)',
  );
  static const VerificationMeta _registrationMeta = const VerificationMeta(
    'registration',
  );
  late final GeneratedColumn<String> registration = GeneratedColumn<String>(
    'registration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE COLLATE NOCASE',
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\' CHECK (sex IN (\'\', \'Feminino\', \'Masculino\', \'Intersexo\', \'Não informado\'))',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _socialNameMeta = const VerificationMeta(
    'socialName',
  );
  late final GeneratedColumn<String> socialName = GeneratedColumn<String>(
    'social_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _birthplaceMeta = const VerificationMeta(
    'birthplace',
  );
  late final GeneratedColumn<String> birthplace = GeneratedColumn<String>(
    'birthplace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _nationalityMeta = const VerificationMeta(
    'nationality',
  );
  late final GeneratedColumn<String> nationality = GeneratedColumn<String>(
    'nationality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _parentageMeta = const VerificationMeta(
    'parentage',
  );
  late final GeneratedColumn<String> parentage = GeneratedColumn<String>(
    'parentage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _guardianMeta = const VerificationMeta(
    'guardian',
  );
  late final GeneratedColumn<String> guardian = GeneratedColumn<String>(
    'guardian',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _extraJsonMeta = const VerificationMeta(
    'extraJson',
  );
  late final GeneratedColumn<String> extraJson = GeneratedColumn<String>(
    'extra_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'{}\'',
    defaultValue: const CustomExpression('\'{}\''),
  );
  static const VerificationMeta _templateMeta = const VerificationMeta(
    'template',
  );
  late final GeneratedColumn<String> template = GeneratedColumn<String>(
    'template',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES document_templates(id)',
  );
  static const VerificationMeta _templateFieldsJsonMeta =
      const VerificationMeta('templateFieldsJson');
  late final GeneratedColumn<String> templateFieldsJson =
      GeneratedColumn<String>(
        'template_fields_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        $customConstraints: 'NOT NULL DEFAULT \'{}\'',
        defaultValue: const CustomExpression('\'{}\''),
      );
  static const VerificationMeta _folderMeta = const VerificationMeta('folder');
  late final GeneratedColumn<String> folder = GeneratedColumn<String>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL UNIQUE REFERENCES folders(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    registration,
    birthDate,
    sex,
    socialName,
    birthplace,
    nationality,
    parentage,
    address,
    guardian,
    phone,
    email,
    notes,
    extraJson,
    template,
    templateFieldsJson,
    folder,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('registration')) {
      context.handle(
        _registrationMeta,
        registration.isAcceptableOrUnknown(
          data['registration']!,
          _registrationMeta,
        ),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('social_name')) {
      context.handle(
        _socialNameMeta,
        socialName.isAcceptableOrUnknown(data['social_name']!, _socialNameMeta),
      );
    }
    if (data.containsKey('birthplace')) {
      context.handle(
        _birthplaceMeta,
        birthplace.isAcceptableOrUnknown(data['birthplace']!, _birthplaceMeta),
      );
    }
    if (data.containsKey('nationality')) {
      context.handle(
        _nationalityMeta,
        nationality.isAcceptableOrUnknown(
          data['nationality']!,
          _nationalityMeta,
        ),
      );
    }
    if (data.containsKey('parentage')) {
      context.handle(
        _parentageMeta,
        parentage.isAcceptableOrUnknown(data['parentage']!, _parentageMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('guardian')) {
      context.handle(
        _guardianMeta,
        guardian.isAcceptableOrUnknown(data['guardian']!, _guardianMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('extra_json')) {
      context.handle(
        _extraJsonMeta,
        extraJson.isAcceptableOrUnknown(data['extra_json']!, _extraJsonMeta),
      );
    }
    if (data.containsKey('template')) {
      context.handle(
        _templateMeta,
        template.isAcceptableOrUnknown(data['template']!, _templateMeta),
      );
    }
    if (data.containsKey('template_fields_json')) {
      context.handle(
        _templateFieldsJsonMeta,
        templateFieldsJson.isAcceptableOrUnknown(
          data['template_fields_json']!,
          _templateFieldsJsonMeta,
        ),
      );
    }
    if (data.containsKey('folder')) {
      context.handle(
        _folderMeta,
        folder.isAcceptableOrUnknown(data['folder']!, _folderMeta),
      );
    } else if (isInserting) {
      context.missing(_folderMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      registration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      socialName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}social_name'],
      )!,
      birthplace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birthplace'],
      )!,
      nationality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nationality'],
      )!,
      parentage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parentage'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      guardian: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guardian'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      extraJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_json'],
      )!,
      template: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template'],
      ),
      templateFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_fields_json'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Students createAlias(String alias) {
    return Students(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String name;
  final String? registration;
  final String birthDate;
  final String sex;
  final String socialName;
  final String birthplace;
  final String nationality;
  final String parentage;
  final String address;
  final String guardian;
  final String phone;
  final String email;
  final String notes;
  final String extraJson;
  final String? template;
  final String templateFieldsJson;
  final String folder;
  final String created;
  final String updated;
  final int revision;
  const Student({
    required this.id,
    required this.name,
    this.registration,
    required this.birthDate,
    required this.sex,
    required this.socialName,
    required this.birthplace,
    required this.nationality,
    required this.parentage,
    required this.address,
    required this.guardian,
    required this.phone,
    required this.email,
    required this.notes,
    required this.extraJson,
    this.template,
    required this.templateFieldsJson,
    required this.folder,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || registration != null) {
      map['registration'] = Variable<String>(registration);
    }
    map['birth_date'] = Variable<String>(birthDate);
    map['sex'] = Variable<String>(sex);
    map['social_name'] = Variable<String>(socialName);
    map['birthplace'] = Variable<String>(birthplace);
    map['nationality'] = Variable<String>(nationality);
    map['parentage'] = Variable<String>(parentage);
    map['address'] = Variable<String>(address);
    map['guardian'] = Variable<String>(guardian);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['notes'] = Variable<String>(notes);
    map['extra_json'] = Variable<String>(extraJson);
    if (!nullToAbsent || template != null) {
      map['template'] = Variable<String>(template);
    }
    map['template_fields_json'] = Variable<String>(templateFieldsJson);
    map['folder'] = Variable<String>(folder);
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      name: Value(name),
      registration: registration == null && nullToAbsent
          ? const Value.absent()
          : Value(registration),
      birthDate: Value(birthDate),
      sex: Value(sex),
      socialName: Value(socialName),
      birthplace: Value(birthplace),
      nationality: Value(nationality),
      parentage: Value(parentage),
      address: Value(address),
      guardian: Value(guardian),
      phone: Value(phone),
      email: Value(email),
      notes: Value(notes),
      extraJson: Value(extraJson),
      template: template == null && nullToAbsent
          ? const Value.absent()
          : Value(template),
      templateFieldsJson: Value(templateFieldsJson),
      folder: Value(folder),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      registration: serializer.fromJson<String?>(json['registration']),
      birthDate: serializer.fromJson<String>(json['birth_date']),
      sex: serializer.fromJson<String>(json['sex']),
      socialName: serializer.fromJson<String>(json['social_name']),
      birthplace: serializer.fromJson<String>(json['birthplace']),
      nationality: serializer.fromJson<String>(json['nationality']),
      parentage: serializer.fromJson<String>(json['parentage']),
      address: serializer.fromJson<String>(json['address']),
      guardian: serializer.fromJson<String>(json['guardian']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      notes: serializer.fromJson<String>(json['notes']),
      extraJson: serializer.fromJson<String>(json['extra_json']),
      template: serializer.fromJson<String?>(json['template']),
      templateFieldsJson: serializer.fromJson<String>(
        json['template_fields_json'],
      ),
      folder: serializer.fromJson<String>(json['folder']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'registration': serializer.toJson<String?>(registration),
      'birth_date': serializer.toJson<String>(birthDate),
      'sex': serializer.toJson<String>(sex),
      'social_name': serializer.toJson<String>(socialName),
      'birthplace': serializer.toJson<String>(birthplace),
      'nationality': serializer.toJson<String>(nationality),
      'parentage': serializer.toJson<String>(parentage),
      'address': serializer.toJson<String>(address),
      'guardian': serializer.toJson<String>(guardian),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'notes': serializer.toJson<String>(notes),
      'extra_json': serializer.toJson<String>(extraJson),
      'template': serializer.toJson<String?>(template),
      'template_fields_json': serializer.toJson<String>(templateFieldsJson),
      'folder': serializer.toJson<String>(folder),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Student copyWith({
    String? id,
    String? name,
    Value<String?> registration = const Value.absent(),
    String? birthDate,
    String? sex,
    String? socialName,
    String? birthplace,
    String? nationality,
    String? parentage,
    String? address,
    String? guardian,
    String? phone,
    String? email,
    String? notes,
    String? extraJson,
    Value<String?> template = const Value.absent(),
    String? templateFieldsJson,
    String? folder,
    String? created,
    String? updated,
    int? revision,
  }) => Student(
    id: id ?? this.id,
    name: name ?? this.name,
    registration: registration.present ? registration.value : this.registration,
    birthDate: birthDate ?? this.birthDate,
    sex: sex ?? this.sex,
    socialName: socialName ?? this.socialName,
    birthplace: birthplace ?? this.birthplace,
    nationality: nationality ?? this.nationality,
    parentage: parentage ?? this.parentage,
    address: address ?? this.address,
    guardian: guardian ?? this.guardian,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    notes: notes ?? this.notes,
    extraJson: extraJson ?? this.extraJson,
    template: template.present ? template.value : this.template,
    templateFieldsJson: templateFieldsJson ?? this.templateFieldsJson,
    folder: folder ?? this.folder,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      registration: data.registration.present
          ? data.registration.value
          : this.registration,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      sex: data.sex.present ? data.sex.value : this.sex,
      socialName: data.socialName.present
          ? data.socialName.value
          : this.socialName,
      birthplace: data.birthplace.present
          ? data.birthplace.value
          : this.birthplace,
      nationality: data.nationality.present
          ? data.nationality.value
          : this.nationality,
      parentage: data.parentage.present ? data.parentage.value : this.parentage,
      address: data.address.present ? data.address.value : this.address,
      guardian: data.guardian.present ? data.guardian.value : this.guardian,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
      extraJson: data.extraJson.present ? data.extraJson.value : this.extraJson,
      template: data.template.present ? data.template.value : this.template,
      templateFieldsJson: data.templateFieldsJson.present
          ? data.templateFieldsJson.value
          : this.templateFieldsJson,
      folder: data.folder.present ? data.folder.value : this.folder,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('registration: $registration, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('socialName: $socialName, ')
          ..write('birthplace: $birthplace, ')
          ..write('nationality: $nationality, ')
          ..write('parentage: $parentage, ')
          ..write('address: $address, ')
          ..write('guardian: $guardian, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('extraJson: $extraJson, ')
          ..write('template: $template, ')
          ..write('templateFieldsJson: $templateFieldsJson, ')
          ..write('folder: $folder, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    registration,
    birthDate,
    sex,
    socialName,
    birthplace,
    nationality,
    parentage,
    address,
    guardian,
    phone,
    email,
    notes,
    extraJson,
    template,
    templateFieldsJson,
    folder,
    created,
    updated,
    revision,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.name == this.name &&
          other.registration == this.registration &&
          other.birthDate == this.birthDate &&
          other.sex == this.sex &&
          other.socialName == this.socialName &&
          other.birthplace == this.birthplace &&
          other.nationality == this.nationality &&
          other.parentage == this.parentage &&
          other.address == this.address &&
          other.guardian == this.guardian &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.notes == this.notes &&
          other.extraJson == this.extraJson &&
          other.template == this.template &&
          other.templateFieldsJson == this.templateFieldsJson &&
          other.folder == this.folder &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> registration;
  final Value<String> birthDate;
  final Value<String> sex;
  final Value<String> socialName;
  final Value<String> birthplace;
  final Value<String> nationality;
  final Value<String> parentage;
  final Value<String> address;
  final Value<String> guardian;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> notes;
  final Value<String> extraJson;
  final Value<String?> template;
  final Value<String> templateFieldsJson;
  final Value<String> folder;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.registration = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    this.socialName = const Value.absent(),
    this.birthplace = const Value.absent(),
    this.nationality = const Value.absent(),
    this.parentage = const Value.absent(),
    this.address = const Value.absent(),
    this.guardian = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.extraJson = const Value.absent(),
    this.template = const Value.absent(),
    this.templateFieldsJson = const Value.absent(),
    this.folder = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String name,
    this.registration = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    this.socialName = const Value.absent(),
    this.birthplace = const Value.absent(),
    this.nationality = const Value.absent(),
    this.parentage = const Value.absent(),
    this.address = const Value.absent(),
    this.guardian = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.extraJson = const Value.absent(),
    this.template = const Value.absent(),
    this.templateFieldsJson = const Value.absent(),
    required String folder,
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       folder = Value(folder),
       created = Value(created),
       updated = Value(updated);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? registration,
    Expression<String>? birthDate,
    Expression<String>? sex,
    Expression<String>? socialName,
    Expression<String>? birthplace,
    Expression<String>? nationality,
    Expression<String>? parentage,
    Expression<String>? address,
    Expression<String>? guardian,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<String>? extraJson,
    Expression<String>? template,
    Expression<String>? templateFieldsJson,
    Expression<String>? folder,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (registration != null) 'registration': registration,
      if (birthDate != null) 'birth_date': birthDate,
      if (sex != null) 'sex': sex,
      if (socialName != null) 'social_name': socialName,
      if (birthplace != null) 'birthplace': birthplace,
      if (nationality != null) 'nationality': nationality,
      if (parentage != null) 'parentage': parentage,
      if (address != null) 'address': address,
      if (guardian != null) 'guardian': guardian,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (extraJson != null) 'extra_json': extraJson,
      if (template != null) 'template': template,
      if (templateFieldsJson != null)
        'template_fields_json': templateFieldsJson,
      if (folder != null) 'folder': folder,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? registration,
    Value<String>? birthDate,
    Value<String>? sex,
    Value<String>? socialName,
    Value<String>? birthplace,
    Value<String>? nationality,
    Value<String>? parentage,
    Value<String>? address,
    Value<String>? guardian,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? notes,
    Value<String>? extraJson,
    Value<String?>? template,
    Value<String>? templateFieldsJson,
    Value<String>? folder,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      registration: registration ?? this.registration,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      socialName: socialName ?? this.socialName,
      birthplace: birthplace ?? this.birthplace,
      nationality: nationality ?? this.nationality,
      parentage: parentage ?? this.parentage,
      address: address ?? this.address,
      guardian: guardian ?? this.guardian,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      extraJson: extraJson ?? this.extraJson,
      template: template ?? this.template,
      templateFieldsJson: templateFieldsJson ?? this.templateFieldsJson,
      folder: folder ?? this.folder,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (registration.present) {
      map['registration'] = Variable<String>(registration.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (socialName.present) {
      map['social_name'] = Variable<String>(socialName.value);
    }
    if (birthplace.present) {
      map['birthplace'] = Variable<String>(birthplace.value);
    }
    if (nationality.present) {
      map['nationality'] = Variable<String>(nationality.value);
    }
    if (parentage.present) {
      map['parentage'] = Variable<String>(parentage.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (guardian.present) {
      map['guardian'] = Variable<String>(guardian.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (extraJson.present) {
      map['extra_json'] = Variable<String>(extraJson.value);
    }
    if (template.present) {
      map['template'] = Variable<String>(template.value);
    }
    if (templateFieldsJson.present) {
      map['template_fields_json'] = Variable<String>(templateFieldsJson.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('registration: $registration, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('socialName: $socialName, ')
          ..write('birthplace: $birthplace, ')
          ..write('nationality: $nationality, ')
          ..write('parentage: $parentage, ')
          ..write('address: $address, ')
          ..write('guardian: $guardian, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('extraJson: $extraJson, ')
          ..write('template: $template, ')
          ..write('templateFieldsJson: $templateFieldsJson, ')
          ..write('folder: $folder, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Requests extends Table with TableInfo<Requests, Request> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Requests(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _protocolMeta = const VerificationMeta(
    'protocol',
  );
  late final GeneratedColumn<String> protocol = GeneratedColumn<String>(
    'protocol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _serviceMeta = const VerificationMeta(
    'service',
  );
  late final GeneratedColumn<String> service = GeneratedColumn<String>(
    'service',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _requesterMeta = const VerificationMeta(
    'requester',
  );
  late final GeneratedColumn<String> requester = GeneratedColumn<String>(
    'requester',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (department IN (\'secretaria\', \'coordenacao\'))',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (state IN (\'Recebida\', \'Em atendimento\', \'Aguardando solicitante\', \'Concluída\'))',
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _studentMeta = const VerificationMeta(
    'student',
  );
  late final GeneratedColumn<String> student = GeneratedColumn<String>(
    'student',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES students(id)',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    protocol,
    service,
    subject,
    description,
    requester,
    department,
    state,
    result,
    operation,
    student,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<Request> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('protocol')) {
      context.handle(
        _protocolMeta,
        protocol.isAcceptableOrUnknown(data['protocol']!, _protocolMeta),
      );
    } else if (isInserting) {
      context.missing(_protocolMeta);
    }
    if (data.containsKey('service')) {
      context.handle(
        _serviceMeta,
        service.isAcceptableOrUnknown(data['service']!, _serviceMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('requester')) {
      context.handle(
        _requesterMeta,
        requester.isAcceptableOrUnknown(data['requester']!, _requesterMeta),
      );
    } else if (isInserting) {
      context.missing(_requesterMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('student')) {
      context.handle(
        _studentMeta,
        student.isAcceptableOrUnknown(data['student']!, _studentMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {requester, operation},
  ];
  @override
  Request map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Request(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      protocol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocol'],
      )!,
      service: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      requester: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      student: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Requests createAlias(String alias) {
    return Requests(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(requester, operation)'];
  @override
  bool get dontWriteConstraints => true;
}

class Request extends DataClass implements Insertable<Request> {
  final String id;
  final String protocol;
  final String service;
  final String subject;
  final String description;
  final String requester;
  final String department;
  final String state;
  final String result;
  final String operation;
  final String? student;
  final String created;
  final String updated;
  final int revision;
  const Request({
    required this.id,
    required this.protocol,
    required this.service,
    required this.subject,
    required this.description,
    required this.requester,
    required this.department,
    required this.state,
    required this.result,
    required this.operation,
    this.student,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['protocol'] = Variable<String>(protocol);
    map['service'] = Variable<String>(service);
    map['subject'] = Variable<String>(subject);
    map['description'] = Variable<String>(description);
    map['requester'] = Variable<String>(requester);
    map['department'] = Variable<String>(department);
    map['state'] = Variable<String>(state);
    map['result'] = Variable<String>(result);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || student != null) {
      map['student'] = Variable<String>(student);
    }
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  RequestsCompanion toCompanion(bool nullToAbsent) {
    return RequestsCompanion(
      id: Value(id),
      protocol: Value(protocol),
      service: Value(service),
      subject: Value(subject),
      description: Value(description),
      requester: Value(requester),
      department: Value(department),
      state: Value(state),
      result: Value(result),
      operation: Value(operation),
      student: student == null && nullToAbsent
          ? const Value.absent()
          : Value(student),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory Request.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Request(
      id: serializer.fromJson<String>(json['id']),
      protocol: serializer.fromJson<String>(json['protocol']),
      service: serializer.fromJson<String>(json['service']),
      subject: serializer.fromJson<String>(json['subject']),
      description: serializer.fromJson<String>(json['description']),
      requester: serializer.fromJson<String>(json['requester']),
      department: serializer.fromJson<String>(json['department']),
      state: serializer.fromJson<String>(json['state']),
      result: serializer.fromJson<String>(json['result']),
      operation: serializer.fromJson<String>(json['operation']),
      student: serializer.fromJson<String?>(json['student']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'protocol': serializer.toJson<String>(protocol),
      'service': serializer.toJson<String>(service),
      'subject': serializer.toJson<String>(subject),
      'description': serializer.toJson<String>(description),
      'requester': serializer.toJson<String>(requester),
      'department': serializer.toJson<String>(department),
      'state': serializer.toJson<String>(state),
      'result': serializer.toJson<String>(result),
      'operation': serializer.toJson<String>(operation),
      'student': serializer.toJson<String?>(student),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Request copyWith({
    String? id,
    String? protocol,
    String? service,
    String? subject,
    String? description,
    String? requester,
    String? department,
    String? state,
    String? result,
    String? operation,
    Value<String?> student = const Value.absent(),
    String? created,
    String? updated,
    int? revision,
  }) => Request(
    id: id ?? this.id,
    protocol: protocol ?? this.protocol,
    service: service ?? this.service,
    subject: subject ?? this.subject,
    description: description ?? this.description,
    requester: requester ?? this.requester,
    department: department ?? this.department,
    state: state ?? this.state,
    result: result ?? this.result,
    operation: operation ?? this.operation,
    student: student.present ? student.value : this.student,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  Request copyWithCompanion(RequestsCompanion data) {
    return Request(
      id: data.id.present ? data.id.value : this.id,
      protocol: data.protocol.present ? data.protocol.value : this.protocol,
      service: data.service.present ? data.service.value : this.service,
      subject: data.subject.present ? data.subject.value : this.subject,
      description: data.description.present
          ? data.description.value
          : this.description,
      requester: data.requester.present ? data.requester.value : this.requester,
      department: data.department.present
          ? data.department.value
          : this.department,
      state: data.state.present ? data.state.value : this.state,
      result: data.result.present ? data.result.value : this.result,
      operation: data.operation.present ? data.operation.value : this.operation,
      student: data.student.present ? data.student.value : this.student,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Request(')
          ..write('id: $id, ')
          ..write('protocol: $protocol, ')
          ..write('service: $service, ')
          ..write('subject: $subject, ')
          ..write('description: $description, ')
          ..write('requester: $requester, ')
          ..write('department: $department, ')
          ..write('state: $state, ')
          ..write('result: $result, ')
          ..write('operation: $operation, ')
          ..write('student: $student, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    protocol,
    service,
    subject,
    description,
    requester,
    department,
    state,
    result,
    operation,
    student,
    created,
    updated,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Request &&
          other.id == this.id &&
          other.protocol == this.protocol &&
          other.service == this.service &&
          other.subject == this.subject &&
          other.description == this.description &&
          other.requester == this.requester &&
          other.department == this.department &&
          other.state == this.state &&
          other.result == this.result &&
          other.operation == this.operation &&
          other.student == this.student &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class RequestsCompanion extends UpdateCompanion<Request> {
  final Value<String> id;
  final Value<String> protocol;
  final Value<String> service;
  final Value<String> subject;
  final Value<String> description;
  final Value<String> requester;
  final Value<String> department;
  final Value<String> state;
  final Value<String> result;
  final Value<String> operation;
  final Value<String?> student;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const RequestsCompanion({
    this.id = const Value.absent(),
    this.protocol = const Value.absent(),
    this.service = const Value.absent(),
    this.subject = const Value.absent(),
    this.description = const Value.absent(),
    this.requester = const Value.absent(),
    this.department = const Value.absent(),
    this.state = const Value.absent(),
    this.result = const Value.absent(),
    this.operation = const Value.absent(),
    this.student = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RequestsCompanion.insert({
    required String id,
    required String protocol,
    required String service,
    required String subject,
    required String description,
    required String requester,
    required String department,
    required String state,
    this.result = const Value.absent(),
    required String operation,
    this.student = const Value.absent(),
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       protocol = Value(protocol),
       service = Value(service),
       subject = Value(subject),
       description = Value(description),
       requester = Value(requester),
       department = Value(department),
       state = Value(state),
       operation = Value(operation),
       created = Value(created),
       updated = Value(updated);
  static Insertable<Request> custom({
    Expression<String>? id,
    Expression<String>? protocol,
    Expression<String>? service,
    Expression<String>? subject,
    Expression<String>? description,
    Expression<String>? requester,
    Expression<String>? department,
    Expression<String>? state,
    Expression<String>? result,
    Expression<String>? operation,
    Expression<String>? student,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (protocol != null) 'protocol': protocol,
      if (service != null) 'service': service,
      if (subject != null) 'subject': subject,
      if (description != null) 'description': description,
      if (requester != null) 'requester': requester,
      if (department != null) 'department': department,
      if (state != null) 'state': state,
      if (result != null) 'result': result,
      if (operation != null) 'operation': operation,
      if (student != null) 'student': student,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? protocol,
    Value<String>? service,
    Value<String>? subject,
    Value<String>? description,
    Value<String>? requester,
    Value<String>? department,
    Value<String>? state,
    Value<String>? result,
    Value<String>? operation,
    Value<String?>? student,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return RequestsCompanion(
      id: id ?? this.id,
      protocol: protocol ?? this.protocol,
      service: service ?? this.service,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      requester: requester ?? this.requester,
      department: department ?? this.department,
      state: state ?? this.state,
      result: result ?? this.result,
      operation: operation ?? this.operation,
      student: student ?? this.student,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (protocol.present) {
      map['protocol'] = Variable<String>(protocol.value);
    }
    if (service.present) {
      map['service'] = Variable<String>(service.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (requester.present) {
      map['requester'] = Variable<String>(requester.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (student.present) {
      map['student'] = Variable<String>(student.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestsCompanion(')
          ..write('id: $id, ')
          ..write('protocol: $protocol, ')
          ..write('service: $service, ')
          ..write('subject: $subject, ')
          ..write('description: $description, ')
          ..write('requester: $requester, ')
          ..write('department: $department, ')
          ..write('state: $state, ')
          ..write('result: $result, ')
          ..write('operation: $operation, ')
          ..write('student: $student, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Events extends Table with TableInfo<Events, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Events(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _requestMeta = const VerificationMeta(
    'request',
  );
  late final GeneratedColumn<String> request = GeneratedColumn<String>(
    'request',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES requests(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _text$Meta = const VerificationMeta('text\$');
  late final GeneratedColumn<String> text$ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, request, actor, text$, created];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('request')) {
      context.handle(
        _requestMeta,
        request.isAcceptableOrUnknown(data['request']!, _requestMeta),
      );
    } else if (isInserting) {
      context.missing(_requestMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _text$Meta,
        text$.isAcceptableOrUnknown(data['text']!, _text$Meta),
      );
    } else if (isInserting) {
      context.missing(_text$Meta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      request: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      text$: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
    );
  }

  @override
  Events createAlias(String alias) {
    return Events(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final String request;
  final String actor;
  final String text$;
  final String created;
  const Event({
    required this.id,
    required this.request,
    required this.actor,
    required this.text$,
    required this.created,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['request'] = Variable<String>(request);
    map['actor'] = Variable<String>(actor);
    map['text'] = Variable<String>(text$);
    map['created'] = Variable<String>(created);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      request: Value(request),
      actor: Value(actor),
      text$: Value(text$),
      created: Value(created),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      request: serializer.fromJson<String>(json['request']),
      actor: serializer.fromJson<String>(json['actor']),
      text$: serializer.fromJson<String>(json['text']),
      created: serializer.fromJson<String>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'request': serializer.toJson<String>(request),
      'actor': serializer.toJson<String>(actor),
      'text': serializer.toJson<String>(text$),
      'created': serializer.toJson<String>(created),
    };
  }

  Event copyWith({
    String? id,
    String? request,
    String? actor,
    String? text$,
    String? created,
  }) => Event(
    id: id ?? this.id,
    request: request ?? this.request,
    actor: actor ?? this.actor,
    text$: text$ ?? this.text$,
    created: created ?? this.created,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      request: data.request.present ? data.request.value : this.request,
      actor: data.actor.present ? data.actor.value : this.actor,
      text$: data.text$.present ? data.text$.value : this.text$,
      created: data.created.present ? data.created.value : this.created,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('request: $request, ')
          ..write('actor: $actor, ')
          ..write('text\$: ${text$}, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, request, actor, text$, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.request == this.request &&
          other.actor == this.actor &&
          other.text$ == this.text$ &&
          other.created == this.created);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> request;
  final Value<String> actor;
  final Value<String> text$;
  final Value<String> created;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.request = const Value.absent(),
    this.actor = const Value.absent(),
    this.text$ = const Value.absent(),
    this.created = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String request,
    required String actor,
    required String text$,
    required String created,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       request = Value(request),
       actor = Value(actor),
       text$ = Value(text$),
       created = Value(created);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? request,
    Expression<String>? actor,
    Expression<String>? text$,
    Expression<String>? created,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (request != null) 'request': request,
      if (actor != null) 'actor': actor,
      if (text$ != null) 'text': text$,
      if (created != null) 'created': created,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? request,
    Value<String>? actor,
    Value<String>? text$,
    Value<String>? created,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      request: request ?? this.request,
      actor: actor ?? this.actor,
      text$: text$ ?? this.text$,
      created: created ?? this.created,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (request.present) {
      map['request'] = Variable<String>(request.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (text$.present) {
      map['text'] = Variable<String>(text$.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('request: $request, ')
          ..write('actor: $actor, ')
          ..write('text\$: ${text$}, ')
          ..write('created: $created, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Attachments extends Table with TableInfo<Attachments, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Attachments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _requestMeta = const VerificationMeta(
    'request',
  );
  late final GeneratedColumn<String> request = GeneratedColumn<String>(
    'request',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES requests(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _documentMeta = const VerificationMeta(
    'document',
  );
  late final GeneratedColumn<String> document = GeneratedColumn<String>(
    'document',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES documents(id)ON DELETE RESTRICT',
  );
  @override
  List<GeneratedColumn> get $columns => [request, document];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('request')) {
      context.handle(
        _requestMeta,
        request.isAcceptableOrUnknown(data['request']!, _requestMeta),
      );
    } else if (isInserting) {
      context.missing(_requestMeta);
    }
    if (data.containsKey('document')) {
      context.handle(
        _documentMeta,
        document.isAcceptableOrUnknown(data['document']!, _documentMeta),
      );
    } else if (isInserting) {
      context.missing(_documentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {request, document};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      request: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request'],
      )!,
      document: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document'],
      )!,
    );
  }

  @override
  Attachments createAlias(String alias) {
    return Attachments(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(request, document)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final String request;
  final String document;
  const Attachment({required this.request, required this.document});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['request'] = Variable<String>(request);
    map['document'] = Variable<String>(document);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      request: Value(request),
      document: Value(document),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      request: serializer.fromJson<String>(json['request']),
      document: serializer.fromJson<String>(json['document']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'request': serializer.toJson<String>(request),
      'document': serializer.toJson<String>(document),
    };
  }

  Attachment copyWith({String? request, String? document}) => Attachment(
    request: request ?? this.request,
    document: document ?? this.document,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      request: data.request.present ? data.request.value : this.request,
      document: data.document.present ? data.document.value : this.document,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('request: $request, ')
          ..write('document: $document')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(request, document);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.request == this.request &&
          other.document == this.document);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> request;
  final Value<String> document;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.request = const Value.absent(),
    this.document = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String request,
    required String document,
    this.rowid = const Value.absent(),
  }) : request = Value(request),
       document = Value(document);
  static Insertable<Attachment> custom({
    Expression<String>? request,
    Expression<String>? document,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (request != null) 'request': request,
      if (document != null) 'document': document,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? request,
    Value<String>? document,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      request: request ?? this.request,
      document: document ?? this.document,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (request.present) {
      map['request'] = Variable<String>(request.value);
    }
    if (document.present) {
      map['document'] = Variable<String>(document.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('request: $request, ')
          ..write('document: $document, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Requirements extends Table with TableInfo<Requirements, Requirement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Requirements(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _studentMeta = const VerificationMeta(
    'student',
  );
  late final GeneratedColumn<String> student = GeneratedColumn<String>(
    'student',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES students(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(type)) > 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [id, student, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requirements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Requirement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student')) {
      context.handle(
        _studentMeta,
        student.isAcceptableOrUnknown(data['student']!, _studentMeta),
      );
    } else if (isInserting) {
      context.missing(_studentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {student},
  ];
  @override
  Requirement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Requirement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      student: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  Requirements createAlias(String alias) {
    return Requirements(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(student, type COLLATE NOCASE)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Requirement extends DataClass implements Insertable<Requirement> {
  final String id;
  final String student;
  final String type;
  const Requirement({
    required this.id,
    required this.student,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student'] = Variable<String>(student);
    map['type'] = Variable<String>(type);
    return map;
  }

  RequirementsCompanion toCompanion(bool nullToAbsent) {
    return RequirementsCompanion(
      id: Value(id),
      student: Value(student),
      type: Value(type),
    );
  }

  factory Requirement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Requirement(
      id: serializer.fromJson<String>(json['id']),
      student: serializer.fromJson<String>(json['student']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'student': serializer.toJson<String>(student),
      'type': serializer.toJson<String>(type),
    };
  }

  Requirement copyWith({String? id, String? student, String? type}) =>
      Requirement(
        id: id ?? this.id,
        student: student ?? this.student,
        type: type ?? this.type,
      );
  Requirement copyWithCompanion(RequirementsCompanion data) {
    return Requirement(
      id: data.id.present ? data.id.value : this.id,
      student: data.student.present ? data.student.value : this.student,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Requirement(')
          ..write('id: $id, ')
          ..write('student: $student, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, student, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Requirement &&
          other.id == this.id &&
          other.student == this.student &&
          other.type == this.type);
}

class RequirementsCompanion extends UpdateCompanion<Requirement> {
  final Value<String> id;
  final Value<String> student;
  final Value<String> type;
  final Value<int> rowid;
  const RequirementsCompanion({
    this.id = const Value.absent(),
    this.student = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RequirementsCompanion.insert({
    required String id,
    required String student,
    required String type,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       student = Value(student),
       type = Value(type);
  static Insertable<Requirement> custom({
    Expression<String>? id,
    Expression<String>? student,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (student != null) 'student': student,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RequirementsCompanion copyWith({
    Value<String>? id,
    Value<String>? student,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return RequirementsCompanion(
      id: id ?? this.id,
      student: student ?? this.student,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (student.present) {
      map['student'] = Variable<String>(student.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequirementsCompanion(')
          ..write('id: $id, ')
          ..write('student: $student, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Credentials extends Table with TableInfo<Credentials, Credential> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Credentials(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<String> user = GeneratedColumn<String>(
    'user',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES users(id)',
  );
  static const VerificationMeta _loginMeta = const VerificationMeta('login');
  late final GeneratedColumn<String> login = GeneratedColumn<String>(
    'login',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE COLLATE NOCASE',
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
    'salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  late final GeneratedColumn<int> enabled = GeneratedColumn<int>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (enabled IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    user,
    login,
    salt,
    passwordHash,
    enabled,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credentials';
  @override
  VerificationContext validateIntegrity(
    Insertable<Credential> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user')) {
      context.handle(
        _userMeta,
        user.isAcceptableOrUnknown(data['user']!, _userMeta),
      );
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    if (data.containsKey('login')) {
      context.handle(
        _loginMeta,
        login.isAcceptableOrUnknown(data['login']!, _loginMeta),
      );
    } else if (isInserting) {
      context.missing(_loginMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {user};
  @override
  Credential map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Credential(
      user: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user'],
      )!,
      login: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}login'],
      )!,
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salt'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enabled'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Credentials createAlias(String alias) {
    return Credentials(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Credential extends DataClass implements Insertable<Credential> {
  final String user;
  final String login;
  final String salt;
  final String passwordHash;
  final int enabled;
  final int revision;
  const Credential({
    required this.user,
    required this.login,
    required this.salt,
    required this.passwordHash,
    required this.enabled,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user'] = Variable<String>(user);
    map['login'] = Variable<String>(login);
    map['salt'] = Variable<String>(salt);
    map['password_hash'] = Variable<String>(passwordHash);
    map['enabled'] = Variable<int>(enabled);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  CredentialsCompanion toCompanion(bool nullToAbsent) {
    return CredentialsCompanion(
      user: Value(user),
      login: Value(login),
      salt: Value(salt),
      passwordHash: Value(passwordHash),
      enabled: Value(enabled),
      revision: Value(revision),
    );
  }

  factory Credential.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Credential(
      user: serializer.fromJson<String>(json['user']),
      login: serializer.fromJson<String>(json['login']),
      salt: serializer.fromJson<String>(json['salt']),
      passwordHash: serializer.fromJson<String>(json['password_hash']),
      enabled: serializer.fromJson<int>(json['enabled']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user': serializer.toJson<String>(user),
      'login': serializer.toJson<String>(login),
      'salt': serializer.toJson<String>(salt),
      'password_hash': serializer.toJson<String>(passwordHash),
      'enabled': serializer.toJson<int>(enabled),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Credential copyWith({
    String? user,
    String? login,
    String? salt,
    String? passwordHash,
    int? enabled,
    int? revision,
  }) => Credential(
    user: user ?? this.user,
    login: login ?? this.login,
    salt: salt ?? this.salt,
    passwordHash: passwordHash ?? this.passwordHash,
    enabled: enabled ?? this.enabled,
    revision: revision ?? this.revision,
  );
  Credential copyWithCompanion(CredentialsCompanion data) {
    return Credential(
      user: data.user.present ? data.user.value : this.user,
      login: data.login.present ? data.login.value : this.login,
      salt: data.salt.present ? data.salt.value : this.salt,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Credential(')
          ..write('user: $user, ')
          ..write('login: $login, ')
          ..write('salt: $salt, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('enabled: $enabled, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(user, login, salt, passwordHash, enabled, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Credential &&
          other.user == this.user &&
          other.login == this.login &&
          other.salt == this.salt &&
          other.passwordHash == this.passwordHash &&
          other.enabled == this.enabled &&
          other.revision == this.revision);
}

class CredentialsCompanion extends UpdateCompanion<Credential> {
  final Value<String> user;
  final Value<String> login;
  final Value<String> salt;
  final Value<String> passwordHash;
  final Value<int> enabled;
  final Value<int> revision;
  final Value<int> rowid;
  const CredentialsCompanion({
    this.user = const Value.absent(),
    this.login = const Value.absent(),
    this.salt = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.enabled = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CredentialsCompanion.insert({
    required String user,
    required String login,
    required String salt,
    required String passwordHash,
    this.enabled = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : user = Value(user),
       login = Value(login),
       salt = Value(salt),
       passwordHash = Value(passwordHash);
  static Insertable<Credential> custom({
    Expression<String>? user,
    Expression<String>? login,
    Expression<String>? salt,
    Expression<String>? passwordHash,
    Expression<int>? enabled,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (user != null) 'user': user,
      if (login != null) 'login': login,
      if (salt != null) 'salt': salt,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (enabled != null) 'enabled': enabled,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CredentialsCompanion copyWith({
    Value<String>? user,
    Value<String>? login,
    Value<String>? salt,
    Value<String>? passwordHash,
    Value<int>? enabled,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return CredentialsCompanion(
      user: user ?? this.user,
      login: login ?? this.login,
      salt: salt ?? this.salt,
      passwordHash: passwordHash ?? this.passwordHash,
      enabled: enabled ?? this.enabled,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (user.present) {
      map['user'] = Variable<String>(user.value);
    }
    if (login.present) {
      map['login'] = Variable<String>(login.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<int>(enabled.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CredentialsCompanion(')
          ..write('user: $user, ')
          ..write('login: $login, ')
          ..write('salt: $salt, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('enabled: $enabled, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Sessions extends Table with TableInfo<Sessions, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Sessions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<String> user = GeneratedColumn<String>(
    'user',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _expiresMeta = const VerificationMeta(
    'expires',
  );
  late final GeneratedColumn<String> expires = GeneratedColumn<String>(
    'expires',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [tokenHash, user, expires];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('user')) {
      context.handle(
        _userMeta,
        user.isAcceptableOrUnknown(data['user']!, _userMeta),
      );
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    if (data.containsKey('expires')) {
      context.handle(
        _expiresMeta,
        expires.isAcceptableOrUnknown(data['expires']!, _expiresMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tokenHash};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      user: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user'],
      )!,
      expires: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expires'],
      )!,
    );
  }

  @override
  Sessions createAlias(String alias) {
    return Sessions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Session extends DataClass implements Insertable<Session> {
  final String tokenHash;
  final String user;
  final String expires;
  const Session({
    required this.tokenHash,
    required this.user,
    required this.expires,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token_hash'] = Variable<String>(tokenHash);
    map['user'] = Variable<String>(user);
    map['expires'] = Variable<String>(expires);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      tokenHash: Value(tokenHash),
      user: Value(user),
      expires: Value(expires),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      tokenHash: serializer.fromJson<String>(json['token_hash']),
      user: serializer.fromJson<String>(json['user']),
      expires: serializer.fromJson<String>(json['expires']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'token_hash': serializer.toJson<String>(tokenHash),
      'user': serializer.toJson<String>(user),
      'expires': serializer.toJson<String>(expires),
    };
  }

  Session copyWith({String? tokenHash, String? user, String? expires}) =>
      Session(
        tokenHash: tokenHash ?? this.tokenHash,
        user: user ?? this.user,
        expires: expires ?? this.expires,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      user: data.user.present ? data.user.value : this.user,
      expires: data.expires.present ? data.expires.value : this.expires,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('tokenHash: $tokenHash, ')
          ..write('user: $user, ')
          ..write('expires: $expires')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tokenHash, user, expires);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.tokenHash == this.tokenHash &&
          other.user == this.user &&
          other.expires == this.expires);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> tokenHash;
  final Value<String> user;
  final Value<String> expires;
  final Value<int> rowid;
  const SessionsCompanion({
    this.tokenHash = const Value.absent(),
    this.user = const Value.absent(),
    this.expires = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String tokenHash,
    required String user,
    required String expires,
    this.rowid = const Value.absent(),
  }) : tokenHash = Value(tokenHash),
       user = Value(user),
       expires = Value(expires);
  static Insertable<Session> custom({
    Expression<String>? tokenHash,
    Expression<String>? user,
    Expression<String>? expires,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tokenHash != null) 'token_hash': tokenHash,
      if (user != null) 'user': user,
      if (expires != null) 'expires': expires,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? tokenHash,
    Value<String>? user,
    Value<String>? expires,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      tokenHash: tokenHash ?? this.tokenHash,
      user: user ?? this.user,
      expires: expires ?? this.expires,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (user.present) {
      map['user'] = Variable<String>(user.value);
    }
    if (expires.present) {
      map['expires'] = Variable<String>(expires.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('tokenHash: $tokenHash, ')
          ..write('user: $user, ')
          ..write('expires: $expires, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class StudentAccess extends Table
    with TableInfo<StudentAccess, StudentAccessData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  StudentAccess(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentMeta = const VerificationMeta(
    'student',
  );
  late final GeneratedColumn<String> student = GeneratedColumn<String>(
    'student',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES students(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<String> user = GeneratedColumn<String>(
    'user',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [student, user];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_access';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentAccessData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student')) {
      context.handle(
        _studentMeta,
        student.isAcceptableOrUnknown(data['student']!, _studentMeta),
      );
    } else if (isInserting) {
      context.missing(_studentMeta);
    }
    if (data.containsKey('user')) {
      context.handle(
        _userMeta,
        user.isAcceptableOrUnknown(data['user']!, _userMeta),
      );
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {student, user};
  @override
  StudentAccessData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentAccessData(
      student: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student'],
      )!,
      user: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user'],
      )!,
    );
  }

  @override
  StudentAccess createAlias(String alias) {
    return StudentAccess(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(student, user)'];
  @override
  bool get dontWriteConstraints => true;
}

class StudentAccessData extends DataClass
    implements Insertable<StudentAccessData> {
  final String student;
  final String user;
  const StudentAccessData({required this.student, required this.user});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student'] = Variable<String>(student);
    map['user'] = Variable<String>(user);
    return map;
  }

  StudentAccessCompanion toCompanion(bool nullToAbsent) {
    return StudentAccessCompanion(student: Value(student), user: Value(user));
  }

  factory StudentAccessData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentAccessData(
      student: serializer.fromJson<String>(json['student']),
      user: serializer.fromJson<String>(json['user']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'student': serializer.toJson<String>(student),
      'user': serializer.toJson<String>(user),
    };
  }

  StudentAccessData copyWith({String? student, String? user}) =>
      StudentAccessData(
        student: student ?? this.student,
        user: user ?? this.user,
      );
  StudentAccessData copyWithCompanion(StudentAccessCompanion data) {
    return StudentAccessData(
      student: data.student.present ? data.student.value : this.student,
      user: data.user.present ? data.user.value : this.user,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentAccessData(')
          ..write('student: $student, ')
          ..write('user: $user')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(student, user);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentAccessData &&
          other.student == this.student &&
          other.user == this.user);
}

class StudentAccessCompanion extends UpdateCompanion<StudentAccessData> {
  final Value<String> student;
  final Value<String> user;
  final Value<int> rowid;
  const StudentAccessCompanion({
    this.student = const Value.absent(),
    this.user = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentAccessCompanion.insert({
    required String student,
    required String user,
    this.rowid = const Value.absent(),
  }) : student = Value(student),
       user = Value(user);
  static Insertable<StudentAccessData> custom({
    Expression<String>? student,
    Expression<String>? user,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (student != null) 'student': student,
      if (user != null) 'user': user,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentAccessCompanion copyWith({
    Value<String>? student,
    Value<String>? user,
    Value<int>? rowid,
  }) {
    return StudentAccessCompanion(
      student: student ?? this.student,
      user: user ?? this.user,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (student.present) {
      map['student'] = Variable<String>(student.value);
    }
    if (user.present) {
      map['user'] = Variable<String>(user.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentAccessCompanion(')
          ..write('student: $student, ')
          ..write('user: $user, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Courses extends Table with TableInfo<Courses, Course> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Courses(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _modalityMeta = const VerificationMeta(
    'modality',
  );
  late final GeneratedColumn<String> modality = GeneratedColumn<String>(
    'modality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _durationLabelMeta = const VerificationMeta(
    'durationLabel',
  );
  late final GeneratedColumn<String> durationLabel = GeneratedColumn<String>(
    'duration_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _templateMeta = const VerificationMeta(
    'template',
  );
  late final GeneratedColumn<String> template = GeneratedColumn<String>(
    'template',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES document_templates(id)',
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (archived IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    modality,
    durationLabel,
    template,
    archived,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Course> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('modality')) {
      context.handle(
        _modalityMeta,
        modality.isAcceptableOrUnknown(data['modality']!, _modalityMeta),
      );
    } else if (isInserting) {
      context.missing(_modalityMeta);
    }
    if (data.containsKey('duration_label')) {
      context.handle(
        _durationLabelMeta,
        durationLabel.isAcceptableOrUnknown(
          data['duration_label']!,
          _durationLabelMeta,
        ),
      );
    }
    if (data.containsKey('template')) {
      context.handle(
        _templateMeta,
        template.isAcceptableOrUnknown(data['template']!, _templateMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [{}];
  @override
  Course map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Course(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      modality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modality'],
      )!,
      durationLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration_label'],
      )!,
      template: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Courses createAlias(String alias) {
    return Courses(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(name COLLATE NOCASE, modality COLLATE NOCASE)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Course extends DataClass implements Insertable<Course> {
  final String id;
  final String name;
  final String modality;
  final String durationLabel;
  final String? template;
  final int archived;
  final int revision;
  const Course({
    required this.id,
    required this.name,
    required this.modality,
    required this.durationLabel,
    this.template,
    required this.archived,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['modality'] = Variable<String>(modality);
    map['duration_label'] = Variable<String>(durationLabel);
    if (!nullToAbsent || template != null) {
      map['template'] = Variable<String>(template);
    }
    map['archived'] = Variable<int>(archived);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      name: Value(name),
      modality: Value(modality),
      durationLabel: Value(durationLabel),
      template: template == null && nullToAbsent
          ? const Value.absent()
          : Value(template),
      archived: Value(archived),
      revision: Value(revision),
    );
  }

  factory Course.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Course(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      modality: serializer.fromJson<String>(json['modality']),
      durationLabel: serializer.fromJson<String>(json['duration_label']),
      template: serializer.fromJson<String?>(json['template']),
      archived: serializer.fromJson<int>(json['archived']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'modality': serializer.toJson<String>(modality),
      'duration_label': serializer.toJson<String>(durationLabel),
      'template': serializer.toJson<String?>(template),
      'archived': serializer.toJson<int>(archived),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Course copyWith({
    String? id,
    String? name,
    String? modality,
    String? durationLabel,
    Value<String?> template = const Value.absent(),
    int? archived,
    int? revision,
  }) => Course(
    id: id ?? this.id,
    name: name ?? this.name,
    modality: modality ?? this.modality,
    durationLabel: durationLabel ?? this.durationLabel,
    template: template.present ? template.value : this.template,
    archived: archived ?? this.archived,
    revision: revision ?? this.revision,
  );
  Course copyWithCompanion(CoursesCompanion data) {
    return Course(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      modality: data.modality.present ? data.modality.value : this.modality,
      durationLabel: data.durationLabel.present
          ? data.durationLabel.value
          : this.durationLabel,
      template: data.template.present ? data.template.value : this.template,
      archived: data.archived.present ? data.archived.value : this.archived,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Course(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modality: $modality, ')
          ..write('durationLabel: $durationLabel, ')
          ..write('template: $template, ')
          ..write('archived: $archived, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    modality,
    durationLabel,
    template,
    archived,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Course &&
          other.id == this.id &&
          other.name == this.name &&
          other.modality == this.modality &&
          other.durationLabel == this.durationLabel &&
          other.template == this.template &&
          other.archived == this.archived &&
          other.revision == this.revision);
}

class CoursesCompanion extends UpdateCompanion<Course> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> modality;
  final Value<String> durationLabel;
  final Value<String?> template;
  final Value<int> archived;
  final Value<int> revision;
  final Value<int> rowid;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.modality = const Value.absent(),
    this.durationLabel = const Value.absent(),
    this.template = const Value.absent(),
    this.archived = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesCompanion.insert({
    required String id,
    required String name,
    required String modality,
    this.durationLabel = const Value.absent(),
    this.template = const Value.absent(),
    this.archived = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       modality = Value(modality);
  static Insertable<Course> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? modality,
    Expression<String>? durationLabel,
    Expression<String>? template,
    Expression<int>? archived,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (modality != null) 'modality': modality,
      if (durationLabel != null) 'duration_label': durationLabel,
      if (template != null) 'template': template,
      if (archived != null) 'archived': archived,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? modality,
    Value<String>? durationLabel,
    Value<String?>? template,
    Value<int>? archived,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return CoursesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      modality: modality ?? this.modality,
      durationLabel: durationLabel ?? this.durationLabel,
      template: template ?? this.template,
      archived: archived ?? this.archived,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (modality.present) {
      map['modality'] = Variable<String>(modality.value);
    }
    if (durationLabel.present) {
      map['duration_label'] = Variable<String>(durationLabel.value);
    }
    if (template.present) {
      map['template'] = Variable<String>(template.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modality: $modality, ')
          ..write('durationLabel: $durationLabel, ')
          ..write('template: $template, ')
          ..write('archived: $archived, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ClassGroups extends Table with TableInfo<ClassGroups, ClassGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ClassGroups(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES courses(id)',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _schoolYearMeta = const VerificationMeta(
    'schoolYear',
  );
  late final GeneratedColumn<int> schoolYear = GeneratedColumn<int>(
    'school_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (school_year BETWEEN 2000 AND 2200)',
  );
  static const VerificationMeta _periodLabelMeta = const VerificationMeta(
    'periodLabel',
  );
  late final GeneratedColumn<String> periodLabel = GeneratedColumn<String>(
    'period_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  late final GeneratedColumn<String> shift = GeneratedColumn<String>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (capacity BETWEEN 1 AND 200)',
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  late final GeneratedColumn<int> archived = GeneratedColumn<int>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (archived IN (0, 1))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    course,
    name,
    schoolYear,
    periodLabel,
    grade,
    shift,
    capacity,
    archived,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    } else if (isInserting) {
      context.missing(_courseMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('school_year')) {
      context.handle(
        _schoolYearMeta,
        schoolYear.isAcceptableOrUnknown(data['school_year']!, _schoolYearMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolYearMeta);
    }
    if (data.containsKey('period_label')) {
      context.handle(
        _periodLabelMeta,
        periodLabel.isAcceptableOrUnknown(
          data['period_label']!,
          _periodLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodLabelMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {course, schoolYear, periodLabel},
  ];
  @override
  ClassGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      schoolYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}school_year'],
      )!,
      periodLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_label'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  ClassGroups createAlias(String alias) {
    return ClassGroups(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(course, school_year, period_label, name COLLATE NOCASE)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ClassGroup extends DataClass implements Insertable<ClassGroup> {
  final String id;
  final String course;
  final String name;
  final int schoolYear;
  final String periodLabel;
  final String grade;
  final String shift;
  final int capacity;
  final int archived;
  final String created;
  final String updated;
  final int revision;
  const ClassGroup({
    required this.id,
    required this.course,
    required this.name,
    required this.schoolYear,
    required this.periodLabel,
    required this.grade,
    required this.shift,
    required this.capacity,
    required this.archived,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course'] = Variable<String>(course);
    map['name'] = Variable<String>(name);
    map['school_year'] = Variable<int>(schoolYear);
    map['period_label'] = Variable<String>(periodLabel);
    map['grade'] = Variable<String>(grade);
    map['shift'] = Variable<String>(shift);
    map['capacity'] = Variable<int>(capacity);
    map['archived'] = Variable<int>(archived);
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  ClassGroupsCompanion toCompanion(bool nullToAbsent) {
    return ClassGroupsCompanion(
      id: Value(id),
      course: Value(course),
      name: Value(name),
      schoolYear: Value(schoolYear),
      periodLabel: Value(periodLabel),
      grade: Value(grade),
      shift: Value(shift),
      capacity: Value(capacity),
      archived: Value(archived),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory ClassGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassGroup(
      id: serializer.fromJson<String>(json['id']),
      course: serializer.fromJson<String>(json['course']),
      name: serializer.fromJson<String>(json['name']),
      schoolYear: serializer.fromJson<int>(json['school_year']),
      periodLabel: serializer.fromJson<String>(json['period_label']),
      grade: serializer.fromJson<String>(json['grade']),
      shift: serializer.fromJson<String>(json['shift']),
      capacity: serializer.fromJson<int>(json['capacity']),
      archived: serializer.fromJson<int>(json['archived']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'course': serializer.toJson<String>(course),
      'name': serializer.toJson<String>(name),
      'school_year': serializer.toJson<int>(schoolYear),
      'period_label': serializer.toJson<String>(periodLabel),
      'grade': serializer.toJson<String>(grade),
      'shift': serializer.toJson<String>(shift),
      'capacity': serializer.toJson<int>(capacity),
      'archived': serializer.toJson<int>(archived),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  ClassGroup copyWith({
    String? id,
    String? course,
    String? name,
    int? schoolYear,
    String? periodLabel,
    String? grade,
    String? shift,
    int? capacity,
    int? archived,
    String? created,
    String? updated,
    int? revision,
  }) => ClassGroup(
    id: id ?? this.id,
    course: course ?? this.course,
    name: name ?? this.name,
    schoolYear: schoolYear ?? this.schoolYear,
    periodLabel: periodLabel ?? this.periodLabel,
    grade: grade ?? this.grade,
    shift: shift ?? this.shift,
    capacity: capacity ?? this.capacity,
    archived: archived ?? this.archived,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  ClassGroup copyWithCompanion(ClassGroupsCompanion data) {
    return ClassGroup(
      id: data.id.present ? data.id.value : this.id,
      course: data.course.present ? data.course.value : this.course,
      name: data.name.present ? data.name.value : this.name,
      schoolYear: data.schoolYear.present
          ? data.schoolYear.value
          : this.schoolYear,
      periodLabel: data.periodLabel.present
          ? data.periodLabel.value
          : this.periodLabel,
      grade: data.grade.present ? data.grade.value : this.grade,
      shift: data.shift.present ? data.shift.value : this.shift,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      archived: data.archived.present ? data.archived.value : this.archived,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassGroup(')
          ..write('id: $id, ')
          ..write('course: $course, ')
          ..write('name: $name, ')
          ..write('schoolYear: $schoolYear, ')
          ..write('periodLabel: $periodLabel, ')
          ..write('grade: $grade, ')
          ..write('shift: $shift, ')
          ..write('capacity: $capacity, ')
          ..write('archived: $archived, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    course,
    name,
    schoolYear,
    periodLabel,
    grade,
    shift,
    capacity,
    archived,
    created,
    updated,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassGroup &&
          other.id == this.id &&
          other.course == this.course &&
          other.name == this.name &&
          other.schoolYear == this.schoolYear &&
          other.periodLabel == this.periodLabel &&
          other.grade == this.grade &&
          other.shift == this.shift &&
          other.capacity == this.capacity &&
          other.archived == this.archived &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class ClassGroupsCompanion extends UpdateCompanion<ClassGroup> {
  final Value<String> id;
  final Value<String> course;
  final Value<String> name;
  final Value<int> schoolYear;
  final Value<String> periodLabel;
  final Value<String> grade;
  final Value<String> shift;
  final Value<int> capacity;
  final Value<int> archived;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const ClassGroupsCompanion({
    this.id = const Value.absent(),
    this.course = const Value.absent(),
    this.name = const Value.absent(),
    this.schoolYear = const Value.absent(),
    this.periodLabel = const Value.absent(),
    this.grade = const Value.absent(),
    this.shift = const Value.absent(),
    this.capacity = const Value.absent(),
    this.archived = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassGroupsCompanion.insert({
    required String id,
    required String course,
    required String name,
    required int schoolYear,
    required String periodLabel,
    required String grade,
    required String shift,
    required int capacity,
    this.archived = const Value.absent(),
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       course = Value(course),
       name = Value(name),
       schoolYear = Value(schoolYear),
       periodLabel = Value(periodLabel),
       grade = Value(grade),
       shift = Value(shift),
       capacity = Value(capacity),
       created = Value(created),
       updated = Value(updated);
  static Insertable<ClassGroup> custom({
    Expression<String>? id,
    Expression<String>? course,
    Expression<String>? name,
    Expression<int>? schoolYear,
    Expression<String>? periodLabel,
    Expression<String>? grade,
    Expression<String>? shift,
    Expression<int>? capacity,
    Expression<int>? archived,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (course != null) 'course': course,
      if (name != null) 'name': name,
      if (schoolYear != null) 'school_year': schoolYear,
      if (periodLabel != null) 'period_label': periodLabel,
      if (grade != null) 'grade': grade,
      if (shift != null) 'shift': shift,
      if (capacity != null) 'capacity': capacity,
      if (archived != null) 'archived': archived,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? course,
    Value<String>? name,
    Value<int>? schoolYear,
    Value<String>? periodLabel,
    Value<String>? grade,
    Value<String>? shift,
    Value<int>? capacity,
    Value<int>? archived,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return ClassGroupsCompanion(
      id: id ?? this.id,
      course: course ?? this.course,
      name: name ?? this.name,
      schoolYear: schoolYear ?? this.schoolYear,
      periodLabel: periodLabel ?? this.periodLabel,
      grade: grade ?? this.grade,
      shift: shift ?? this.shift,
      capacity: capacity ?? this.capacity,
      archived: archived ?? this.archived,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (schoolYear.present) {
      map['school_year'] = Variable<int>(schoolYear.value);
    }
    if (periodLabel.present) {
      map['period_label'] = Variable<String>(periodLabel.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (archived.present) {
      map['archived'] = Variable<int>(archived.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassGroupsCompanion(')
          ..write('id: $id, ')
          ..write('course: $course, ')
          ..write('name: $name, ')
          ..write('schoolYear: $schoolYear, ')
          ..write('periodLabel: $periodLabel, ')
          ..write('grade: $grade, ')
          ..write('shift: $shift, ')
          ..write('capacity: $capacity, ')
          ..write('archived: $archived, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Enrollments extends Table with TableInfo<Enrollments, Enrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Enrollments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _studentMeta = const VerificationMeta(
    'student',
  );
  late final GeneratedColumn<String> student = GeneratedColumn<String>(
    'student',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES students(id)',
  );
  static const VerificationMeta _classGroupMeta = const VerificationMeta(
    'classGroup',
  );
  late final GeneratedColumn<String> classGroup = GeneratedColumn<String>(
    'class_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES class_groups(id)',
  );
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES courses(id)',
  );
  static const VerificationMeta _schoolYearMeta = const VerificationMeta(
    'schoolYear',
  );
  late final GeneratedColumn<int> schoolYear = GeneratedColumn<int>(
    'school_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _periodLabelMeta = const VerificationMeta(
    'periodLabel',
  );
  late final GeneratedColumn<String> periodLabel = GeneratedColumn<String>(
    'period_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (state IN (\'Em análise\', \'Ativa\', \'Transferida\', \'Cancelada\', \'Encerrada\'))',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    student,
    classGroup,
    course,
    schoolYear,
    periodLabel,
    state,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enrollments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Enrollment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student')) {
      context.handle(
        _studentMeta,
        student.isAcceptableOrUnknown(data['student']!, _studentMeta),
      );
    } else if (isInserting) {
      context.missing(_studentMeta);
    }
    if (data.containsKey('class_group')) {
      context.handle(
        _classGroupMeta,
        classGroup.isAcceptableOrUnknown(data['class_group']!, _classGroupMeta),
      );
    } else if (isInserting) {
      context.missing(_classGroupMeta);
    }
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    } else if (isInserting) {
      context.missing(_courseMeta);
    }
    if (data.containsKey('school_year')) {
      context.handle(
        _schoolYearMeta,
        schoolYear.isAcceptableOrUnknown(data['school_year']!, _schoolYearMeta),
      );
    } else if (isInserting) {
      context.missing(_schoolYearMeta);
    }
    if (data.containsKey('period_label')) {
      context.handle(
        _periodLabelMeta,
        periodLabel.isAcceptableOrUnknown(
          data['period_label']!,
          _periodLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodLabelMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {student, course, schoolYear, periodLabel},
  ];
  @override
  Enrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Enrollment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      student: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student'],
      )!,
      classGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_group'],
      )!,
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      )!,
      schoolYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}school_year'],
      )!,
      periodLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_label'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Enrollments createAlias(String alias) {
    return Enrollments(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(student, course, school_year, period_label)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Enrollment extends DataClass implements Insertable<Enrollment> {
  final String id;
  final String student;
  final String classGroup;
  final String course;
  final int schoolYear;
  final String periodLabel;
  final String state;
  final String created;
  final String updated;
  final int revision;
  const Enrollment({
    required this.id,
    required this.student,
    required this.classGroup,
    required this.course,
    required this.schoolYear,
    required this.periodLabel,
    required this.state,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student'] = Variable<String>(student);
    map['class_group'] = Variable<String>(classGroup);
    map['course'] = Variable<String>(course);
    map['school_year'] = Variable<int>(schoolYear);
    map['period_label'] = Variable<String>(periodLabel);
    map['state'] = Variable<String>(state);
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  EnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return EnrollmentsCompanion(
      id: Value(id),
      student: Value(student),
      classGroup: Value(classGroup),
      course: Value(course),
      schoolYear: Value(schoolYear),
      periodLabel: Value(periodLabel),
      state: Value(state),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory Enrollment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Enrollment(
      id: serializer.fromJson<String>(json['id']),
      student: serializer.fromJson<String>(json['student']),
      classGroup: serializer.fromJson<String>(json['class_group']),
      course: serializer.fromJson<String>(json['course']),
      schoolYear: serializer.fromJson<int>(json['school_year']),
      periodLabel: serializer.fromJson<String>(json['period_label']),
      state: serializer.fromJson<String>(json['state']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'student': serializer.toJson<String>(student),
      'class_group': serializer.toJson<String>(classGroup),
      'course': serializer.toJson<String>(course),
      'school_year': serializer.toJson<int>(schoolYear),
      'period_label': serializer.toJson<String>(periodLabel),
      'state': serializer.toJson<String>(state),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Enrollment copyWith({
    String? id,
    String? student,
    String? classGroup,
    String? course,
    int? schoolYear,
    String? periodLabel,
    String? state,
    String? created,
    String? updated,
    int? revision,
  }) => Enrollment(
    id: id ?? this.id,
    student: student ?? this.student,
    classGroup: classGroup ?? this.classGroup,
    course: course ?? this.course,
    schoolYear: schoolYear ?? this.schoolYear,
    periodLabel: periodLabel ?? this.periodLabel,
    state: state ?? this.state,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  Enrollment copyWithCompanion(EnrollmentsCompanion data) {
    return Enrollment(
      id: data.id.present ? data.id.value : this.id,
      student: data.student.present ? data.student.value : this.student,
      classGroup: data.classGroup.present
          ? data.classGroup.value
          : this.classGroup,
      course: data.course.present ? data.course.value : this.course,
      schoolYear: data.schoolYear.present
          ? data.schoolYear.value
          : this.schoolYear,
      periodLabel: data.periodLabel.present
          ? data.periodLabel.value
          : this.periodLabel,
      state: data.state.present ? data.state.value : this.state,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Enrollment(')
          ..write('id: $id, ')
          ..write('student: $student, ')
          ..write('classGroup: $classGroup, ')
          ..write('course: $course, ')
          ..write('schoolYear: $schoolYear, ')
          ..write('periodLabel: $periodLabel, ')
          ..write('state: $state, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    student,
    classGroup,
    course,
    schoolYear,
    periodLabel,
    state,
    created,
    updated,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Enrollment &&
          other.id == this.id &&
          other.student == this.student &&
          other.classGroup == this.classGroup &&
          other.course == this.course &&
          other.schoolYear == this.schoolYear &&
          other.periodLabel == this.periodLabel &&
          other.state == this.state &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class EnrollmentsCompanion extends UpdateCompanion<Enrollment> {
  final Value<String> id;
  final Value<String> student;
  final Value<String> classGroup;
  final Value<String> course;
  final Value<int> schoolYear;
  final Value<String> periodLabel;
  final Value<String> state;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const EnrollmentsCompanion({
    this.id = const Value.absent(),
    this.student = const Value.absent(),
    this.classGroup = const Value.absent(),
    this.course = const Value.absent(),
    this.schoolYear = const Value.absent(),
    this.periodLabel = const Value.absent(),
    this.state = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnrollmentsCompanion.insert({
    required String id,
    required String student,
    required String classGroup,
    required String course,
    required int schoolYear,
    required String periodLabel,
    required String state,
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       student = Value(student),
       classGroup = Value(classGroup),
       course = Value(course),
       schoolYear = Value(schoolYear),
       periodLabel = Value(periodLabel),
       state = Value(state),
       created = Value(created),
       updated = Value(updated);
  static Insertable<Enrollment> custom({
    Expression<String>? id,
    Expression<String>? student,
    Expression<String>? classGroup,
    Expression<String>? course,
    Expression<int>? schoolYear,
    Expression<String>? periodLabel,
    Expression<String>? state,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (student != null) 'student': student,
      if (classGroup != null) 'class_group': classGroup,
      if (course != null) 'course': course,
      if (schoolYear != null) 'school_year': schoolYear,
      if (periodLabel != null) 'period_label': periodLabel,
      if (state != null) 'state': state,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnrollmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? student,
    Value<String>? classGroup,
    Value<String>? course,
    Value<int>? schoolYear,
    Value<String>? periodLabel,
    Value<String>? state,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return EnrollmentsCompanion(
      id: id ?? this.id,
      student: student ?? this.student,
      classGroup: classGroup ?? this.classGroup,
      course: course ?? this.course,
      schoolYear: schoolYear ?? this.schoolYear,
      periodLabel: periodLabel ?? this.periodLabel,
      state: state ?? this.state,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (student.present) {
      map['student'] = Variable<String>(student.value);
    }
    if (classGroup.present) {
      map['class_group'] = Variable<String>(classGroup.value);
    }
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (schoolYear.present) {
      map['school_year'] = Variable<int>(schoolYear.value);
    }
    if (periodLabel.present) {
      map['period_label'] = Variable<String>(periodLabel.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnrollmentsCompanion(')
          ..write('id: $id, ')
          ..write('student: $student, ')
          ..write('classGroup: $classGroup, ')
          ..write('course: $course, ')
          ..write('schoolYear: $schoolYear, ')
          ..write('periodLabel: $periodLabel, ')
          ..write('state: $state, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class EnrollmentEvents extends Table
    with TableInfo<EnrollmentEvents, EnrollmentEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EnrollmentEvents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _enrollmentMeta = const VerificationMeta(
    'enrollment',
  );
  late final GeneratedColumn<String> enrollment = GeneratedColumn<String>(
    'enrollment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES enrollments(id)',
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enrollment,
    actor,
    message,
    created,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enrollment_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnrollmentEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('enrollment')) {
      context.handle(
        _enrollmentMeta,
        enrollment.isAcceptableOrUnknown(data['enrollment']!, _enrollmentMeta),
      );
    } else if (isInserting) {
      context.missing(_enrollmentMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnrollmentEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnrollmentEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      enrollment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
    );
  }

  @override
  EnrollmentEvents createAlias(String alias) {
    return EnrollmentEvents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class EnrollmentEvent extends DataClass implements Insertable<EnrollmentEvent> {
  final String id;
  final String enrollment;
  final String actor;
  final String message;
  final String created;
  const EnrollmentEvent({
    required this.id,
    required this.enrollment,
    required this.actor,
    required this.message,
    required this.created,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['enrollment'] = Variable<String>(enrollment);
    map['actor'] = Variable<String>(actor);
    map['message'] = Variable<String>(message);
    map['created'] = Variable<String>(created);
    return map;
  }

  EnrollmentEventsCompanion toCompanion(bool nullToAbsent) {
    return EnrollmentEventsCompanion(
      id: Value(id),
      enrollment: Value(enrollment),
      actor: Value(actor),
      message: Value(message),
      created: Value(created),
    );
  }

  factory EnrollmentEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnrollmentEvent(
      id: serializer.fromJson<String>(json['id']),
      enrollment: serializer.fromJson<String>(json['enrollment']),
      actor: serializer.fromJson<String>(json['actor']),
      message: serializer.fromJson<String>(json['message']),
      created: serializer.fromJson<String>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'enrollment': serializer.toJson<String>(enrollment),
      'actor': serializer.toJson<String>(actor),
      'message': serializer.toJson<String>(message),
      'created': serializer.toJson<String>(created),
    };
  }

  EnrollmentEvent copyWith({
    String? id,
    String? enrollment,
    String? actor,
    String? message,
    String? created,
  }) => EnrollmentEvent(
    id: id ?? this.id,
    enrollment: enrollment ?? this.enrollment,
    actor: actor ?? this.actor,
    message: message ?? this.message,
    created: created ?? this.created,
  );
  EnrollmentEvent copyWithCompanion(EnrollmentEventsCompanion data) {
    return EnrollmentEvent(
      id: data.id.present ? data.id.value : this.id,
      enrollment: data.enrollment.present
          ? data.enrollment.value
          : this.enrollment,
      actor: data.actor.present ? data.actor.value : this.actor,
      message: data.message.present ? data.message.value : this.message,
      created: data.created.present ? data.created.value : this.created,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnrollmentEvent(')
          ..write('id: $id, ')
          ..write('enrollment: $enrollment, ')
          ..write('actor: $actor, ')
          ..write('message: $message, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, enrollment, actor, message, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnrollmentEvent &&
          other.id == this.id &&
          other.enrollment == this.enrollment &&
          other.actor == this.actor &&
          other.message == this.message &&
          other.created == this.created);
}

class EnrollmentEventsCompanion extends UpdateCompanion<EnrollmentEvent> {
  final Value<String> id;
  final Value<String> enrollment;
  final Value<String> actor;
  final Value<String> message;
  final Value<String> created;
  final Value<int> rowid;
  const EnrollmentEventsCompanion({
    this.id = const Value.absent(),
    this.enrollment = const Value.absent(),
    this.actor = const Value.absent(),
    this.message = const Value.absent(),
    this.created = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnrollmentEventsCompanion.insert({
    required String id,
    required String enrollment,
    required String actor,
    required String message,
    required String created,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       enrollment = Value(enrollment),
       actor = Value(actor),
       message = Value(message),
       created = Value(created);
  static Insertable<EnrollmentEvent> custom({
    Expression<String>? id,
    Expression<String>? enrollment,
    Expression<String>? actor,
    Expression<String>? message,
    Expression<String>? created,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enrollment != null) 'enrollment': enrollment,
      if (actor != null) 'actor': actor,
      if (message != null) 'message': message,
      if (created != null) 'created': created,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnrollmentEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? enrollment,
    Value<String>? actor,
    Value<String>? message,
    Value<String>? created,
    Value<int>? rowid,
  }) {
    return EnrollmentEventsCompanion(
      id: id ?? this.id,
      enrollment: enrollment ?? this.enrollment,
      actor: actor ?? this.actor,
      message: message ?? this.message,
      created: created ?? this.created,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (enrollment.present) {
      map['enrollment'] = Variable<String>(enrollment.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnrollmentEventsCompanion(')
          ..write('id: $id, ')
          ..write('enrollment: $enrollment, ')
          ..write('actor: $actor, ')
          ..write('message: $message, ')
          ..write('created: $created, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Subjects extends Table with TableInfo<Subjects, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Subjects(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE COLLATE NOCASE',
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, code, revision];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Subjects createAlias(String alias) {
    return Subjects(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String name;
  final String code;
  final int revision;
  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      revision: Value(revision),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Subject copyWith({String? id, String? name, String? code, int? revision}) =>
      Subject(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        revision: revision ?? this.revision,
      );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, code, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.revision == this.revision);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> code;
  final Value<int> revision;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    this.code = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? code,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CourseComponents extends Table
    with TableInfo<CourseComponents, CourseComponent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CourseComponents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _courseMeta = const VerificationMeta('course');
  late final GeneratedColumn<String> course = GeneratedColumn<String>(
    'course',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES courses(id)',
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES subjects(id)',
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  late final GeneratedColumn<int> hours = GeneratedColumn<int>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (hours BETWEEN 1 AND 5000)',
  );
  static const VerificationMeta _lessonMinutesMeta = const VerificationMeta(
    'lessonMinutes',
  );
  late final GeneratedColumn<int> lessonMinutes = GeneratedColumn<int>(
    'lesson_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (lesson_minutes BETWEEN 15 AND 120)',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    course,
    phase,
    subject,
    hours,
    lessonMinutes,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'course_components';
  @override
  VerificationContext validateIntegrity(
    Insertable<CourseComponent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course')) {
      context.handle(
        _courseMeta,
        course.isAcceptableOrUnknown(data['course']!, _courseMeta),
      );
    } else if (isInserting) {
      context.missing(_courseMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    if (data.containsKey('lesson_minutes')) {
      context.handle(
        _lessonMinutesMeta,
        lessonMinutes.isAcceptableOrUnknown(
          data['lesson_minutes']!,
          _lessonMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lessonMinutesMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {course, subject},
  ];
  @override
  CourseComponent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourseComponent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      course: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hours'],
      )!,
      lessonMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_minutes'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  CourseComponents createAlias(String alias) {
    return CourseComponents(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(course, phase COLLATE NOCASE, subject)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class CourseComponent extends DataClass implements Insertable<CourseComponent> {
  final String id;
  final String course;
  final String phase;
  final String subject;
  final int hours;
  final int lessonMinutes;
  final int revision;
  const CourseComponent({
    required this.id,
    required this.course,
    required this.phase,
    required this.subject,
    required this.hours,
    required this.lessonMinutes,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course'] = Variable<String>(course);
    map['phase'] = Variable<String>(phase);
    map['subject'] = Variable<String>(subject);
    map['hours'] = Variable<int>(hours);
    map['lesson_minutes'] = Variable<int>(lessonMinutes);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  CourseComponentsCompanion toCompanion(bool nullToAbsent) {
    return CourseComponentsCompanion(
      id: Value(id),
      course: Value(course),
      phase: Value(phase),
      subject: Value(subject),
      hours: Value(hours),
      lessonMinutes: Value(lessonMinutes),
      revision: Value(revision),
    );
  }

  factory CourseComponent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourseComponent(
      id: serializer.fromJson<String>(json['id']),
      course: serializer.fromJson<String>(json['course']),
      phase: serializer.fromJson<String>(json['phase']),
      subject: serializer.fromJson<String>(json['subject']),
      hours: serializer.fromJson<int>(json['hours']),
      lessonMinutes: serializer.fromJson<int>(json['lesson_minutes']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'course': serializer.toJson<String>(course),
      'phase': serializer.toJson<String>(phase),
      'subject': serializer.toJson<String>(subject),
      'hours': serializer.toJson<int>(hours),
      'lesson_minutes': serializer.toJson<int>(lessonMinutes),
      'revision': serializer.toJson<int>(revision),
    };
  }

  CourseComponent copyWith({
    String? id,
    String? course,
    String? phase,
    String? subject,
    int? hours,
    int? lessonMinutes,
    int? revision,
  }) => CourseComponent(
    id: id ?? this.id,
    course: course ?? this.course,
    phase: phase ?? this.phase,
    subject: subject ?? this.subject,
    hours: hours ?? this.hours,
    lessonMinutes: lessonMinutes ?? this.lessonMinutes,
    revision: revision ?? this.revision,
  );
  CourseComponent copyWithCompanion(CourseComponentsCompanion data) {
    return CourseComponent(
      id: data.id.present ? data.id.value : this.id,
      course: data.course.present ? data.course.value : this.course,
      phase: data.phase.present ? data.phase.value : this.phase,
      subject: data.subject.present ? data.subject.value : this.subject,
      hours: data.hours.present ? data.hours.value : this.hours,
      lessonMinutes: data.lessonMinutes.present
          ? data.lessonMinutes.value
          : this.lessonMinutes,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourseComponent(')
          ..write('id: $id, ')
          ..write('course: $course, ')
          ..write('phase: $phase, ')
          ..write('subject: $subject, ')
          ..write('hours: $hours, ')
          ..write('lessonMinutes: $lessonMinutes, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, course, phase, subject, hours, lessonMinutes, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourseComponent &&
          other.id == this.id &&
          other.course == this.course &&
          other.phase == this.phase &&
          other.subject == this.subject &&
          other.hours == this.hours &&
          other.lessonMinutes == this.lessonMinutes &&
          other.revision == this.revision);
}

class CourseComponentsCompanion extends UpdateCompanion<CourseComponent> {
  final Value<String> id;
  final Value<String> course;
  final Value<String> phase;
  final Value<String> subject;
  final Value<int> hours;
  final Value<int> lessonMinutes;
  final Value<int> revision;
  final Value<int> rowid;
  const CourseComponentsCompanion({
    this.id = const Value.absent(),
    this.course = const Value.absent(),
    this.phase = const Value.absent(),
    this.subject = const Value.absent(),
    this.hours = const Value.absent(),
    this.lessonMinutes = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CourseComponentsCompanion.insert({
    required String id,
    required String course,
    required String phase,
    required String subject,
    required int hours,
    required int lessonMinutes,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       course = Value(course),
       phase = Value(phase),
       subject = Value(subject),
       hours = Value(hours),
       lessonMinutes = Value(lessonMinutes);
  static Insertable<CourseComponent> custom({
    Expression<String>? id,
    Expression<String>? course,
    Expression<String>? phase,
    Expression<String>? subject,
    Expression<int>? hours,
    Expression<int>? lessonMinutes,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (course != null) 'course': course,
      if (phase != null) 'phase': phase,
      if (subject != null) 'subject': subject,
      if (hours != null) 'hours': hours,
      if (lessonMinutes != null) 'lesson_minutes': lessonMinutes,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CourseComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? course,
    Value<String>? phase,
    Value<String>? subject,
    Value<int>? hours,
    Value<int>? lessonMinutes,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return CourseComponentsCompanion(
      id: id ?? this.id,
      course: course ?? this.course,
      phase: phase ?? this.phase,
      subject: subject ?? this.subject,
      hours: hours ?? this.hours,
      lessonMinutes: lessonMinutes ?? this.lessonMinutes,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (course.present) {
      map['course'] = Variable<String>(course.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (hours.present) {
      map['hours'] = Variable<int>(hours.value);
    }
    if (lessonMinutes.present) {
      map['lesson_minutes'] = Variable<int>(lessonMinutes.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourseComponentsCompanion(')
          ..write('id: $id, ')
          ..write('course: $course, ')
          ..write('phase: $phase, ')
          ..write('subject: $subject, ')
          ..write('hours: $hours, ')
          ..write('lessonMinutes: $lessonMinutes, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Journals extends Table with TableInfo<Journals, Journal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Journals(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _classGroupMeta = const VerificationMeta(
    'classGroup',
  );
  late final GeneratedColumn<String> classGroup = GeneratedColumn<String>(
    'class_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES class_groups(id)',
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _teacherMeta = const VerificationMeta(
    'teacher',
  );
  late final GeneratedColumn<String> teacher = GeneratedColumn<String>(
    'teacher',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _componentMeta = const VerificationMeta(
    'component',
  );
  late final GeneratedColumn<String> component = GeneratedColumn<String>(
    'component',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES course_components(id)',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    classGroup,
    subject,
    teacher,
    component,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Journal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('class_group')) {
      context.handle(
        _classGroupMeta,
        classGroup.isAcceptableOrUnknown(data['class_group']!, _classGroupMeta),
      );
    } else if (isInserting) {
      context.missing(_classGroupMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('teacher')) {
      context.handle(
        _teacherMeta,
        teacher.isAcceptableOrUnknown(data['teacher']!, _teacherMeta),
      );
    } else if (isInserting) {
      context.missing(_teacherMeta);
    }
    if (data.containsKey('component')) {
      context.handle(
        _componentMeta,
        component.isAcceptableOrUnknown(data['component']!, _componentMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {classGroup, component},
  ];
  @override
  Journal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Journal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      classGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_group'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      teacher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher'],
      )!,
      component: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  Journals createAlias(String alias) {
    return Journals(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(class_group, component)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Journal extends DataClass implements Insertable<Journal> {
  final String id;
  final String classGroup;
  final String subject;
  final String teacher;
  final String? component;
  final int revision;
  const Journal({
    required this.id,
    required this.classGroup,
    required this.subject,
    required this.teacher,
    this.component,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['class_group'] = Variable<String>(classGroup);
    map['subject'] = Variable<String>(subject);
    map['teacher'] = Variable<String>(teacher);
    if (!nullToAbsent || component != null) {
      map['component'] = Variable<String>(component);
    }
    map['revision'] = Variable<int>(revision);
    return map;
  }

  JournalsCompanion toCompanion(bool nullToAbsent) {
    return JournalsCompanion(
      id: Value(id),
      classGroup: Value(classGroup),
      subject: Value(subject),
      teacher: Value(teacher),
      component: component == null && nullToAbsent
          ? const Value.absent()
          : Value(component),
      revision: Value(revision),
    );
  }

  factory Journal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Journal(
      id: serializer.fromJson<String>(json['id']),
      classGroup: serializer.fromJson<String>(json['class_group']),
      subject: serializer.fromJson<String>(json['subject']),
      teacher: serializer.fromJson<String>(json['teacher']),
      component: serializer.fromJson<String?>(json['component']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'class_group': serializer.toJson<String>(classGroup),
      'subject': serializer.toJson<String>(subject),
      'teacher': serializer.toJson<String>(teacher),
      'component': serializer.toJson<String?>(component),
      'revision': serializer.toJson<int>(revision),
    };
  }

  Journal copyWith({
    String? id,
    String? classGroup,
    String? subject,
    String? teacher,
    Value<String?> component = const Value.absent(),
    int? revision,
  }) => Journal(
    id: id ?? this.id,
    classGroup: classGroup ?? this.classGroup,
    subject: subject ?? this.subject,
    teacher: teacher ?? this.teacher,
    component: component.present ? component.value : this.component,
    revision: revision ?? this.revision,
  );
  Journal copyWithCompanion(JournalsCompanion data) {
    return Journal(
      id: data.id.present ? data.id.value : this.id,
      classGroup: data.classGroup.present
          ? data.classGroup.value
          : this.classGroup,
      subject: data.subject.present ? data.subject.value : this.subject,
      teacher: data.teacher.present ? data.teacher.value : this.teacher,
      component: data.component.present ? data.component.value : this.component,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Journal(')
          ..write('id: $id, ')
          ..write('classGroup: $classGroup, ')
          ..write('subject: $subject, ')
          ..write('teacher: $teacher, ')
          ..write('component: $component, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, classGroup, subject, teacher, component, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Journal &&
          other.id == this.id &&
          other.classGroup == this.classGroup &&
          other.subject == this.subject &&
          other.teacher == this.teacher &&
          other.component == this.component &&
          other.revision == this.revision);
}

class JournalsCompanion extends UpdateCompanion<Journal> {
  final Value<String> id;
  final Value<String> classGroup;
  final Value<String> subject;
  final Value<String> teacher;
  final Value<String?> component;
  final Value<int> revision;
  final Value<int> rowid;
  const JournalsCompanion({
    this.id = const Value.absent(),
    this.classGroup = const Value.absent(),
    this.subject = const Value.absent(),
    this.teacher = const Value.absent(),
    this.component = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalsCompanion.insert({
    required String id,
    required String classGroup,
    required String subject,
    required String teacher,
    this.component = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       classGroup = Value(classGroup),
       subject = Value(subject),
       teacher = Value(teacher);
  static Insertable<Journal> custom({
    Expression<String>? id,
    Expression<String>? classGroup,
    Expression<String>? subject,
    Expression<String>? teacher,
    Expression<String>? component,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (classGroup != null) 'class_group': classGroup,
      if (subject != null) 'subject': subject,
      if (teacher != null) 'teacher': teacher,
      if (component != null) 'component': component,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalsCompanion copyWith({
    Value<String>? id,
    Value<String>? classGroup,
    Value<String>? subject,
    Value<String>? teacher,
    Value<String?>? component,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return JournalsCompanion(
      id: id ?? this.id,
      classGroup: classGroup ?? this.classGroup,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      component: component ?? this.component,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (classGroup.present) {
      map['class_group'] = Variable<String>(classGroup.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (teacher.present) {
      map['teacher'] = Variable<String>(teacher.value);
    }
    if (component.present) {
      map['component'] = Variable<String>(component.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalsCompanion(')
          ..write('id: $id, ')
          ..write('classGroup: $classGroup, ')
          ..write('subject: $subject, ')
          ..write('teacher: $teacher, ')
          ..write('component: $component, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Lessons extends Table with TableInfo<Lessons, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Lessons(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _journalMeta = const VerificationMeta(
    'journal',
  );
  late final GeneratedColumn<String> journal = GeneratedColumn<String>(
    'journal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES journals(id)',
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  late final GeneratedColumn<int> units = GeneratedColumn<int>(
    'units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (units BETWEEN 1 AND 20)',
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (state IN (\'Rascunho\', \'Em revisão\', \'Publicado\'))',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journal,
    date,
    units,
    content,
    state,
    revision,
    created,
    updated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journal')) {
      context.handle(
        _journalMeta,
        journal.isAcceptableOrUnknown(data['journal']!, _journalMeta),
      );
    } else if (isInserting) {
      context.missing(_journalMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
        _unitsMeta,
        units.isAcceptableOrUnknown(data['units']!, _unitsMeta),
      );
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      journal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      units: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}units'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
    );
  }

  @override
  Lessons createAlias(String alias) {
    return Lessons(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final String id;
  final String journal;
  final String date;
  final int units;
  final String content;
  final String state;
  final int revision;
  final String created;
  final String updated;
  const Lesson({
    required this.id,
    required this.journal,
    required this.date,
    required this.units,
    required this.content,
    required this.state,
    required this.revision,
    required this.created,
    required this.updated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journal'] = Variable<String>(journal);
    map['date'] = Variable<String>(date);
    map['units'] = Variable<int>(units);
    map['content'] = Variable<String>(content);
    map['state'] = Variable<String>(state);
    map['revision'] = Variable<int>(revision);
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      journal: Value(journal),
      date: Value(date),
      units: Value(units),
      content: Value(content),
      state: Value(state),
      revision: Value(revision),
      created: Value(created),
      updated: Value(updated),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<String>(json['id']),
      journal: serializer.fromJson<String>(json['journal']),
      date: serializer.fromJson<String>(json['date']),
      units: serializer.fromJson<int>(json['units']),
      content: serializer.fromJson<String>(json['content']),
      state: serializer.fromJson<String>(json['state']),
      revision: serializer.fromJson<int>(json['revision']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journal': serializer.toJson<String>(journal),
      'date': serializer.toJson<String>(date),
      'units': serializer.toJson<int>(units),
      'content': serializer.toJson<String>(content),
      'state': serializer.toJson<String>(state),
      'revision': serializer.toJson<int>(revision),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
    };
  }

  Lesson copyWith({
    String? id,
    String? journal,
    String? date,
    int? units,
    String? content,
    String? state,
    int? revision,
    String? created,
    String? updated,
  }) => Lesson(
    id: id ?? this.id,
    journal: journal ?? this.journal,
    date: date ?? this.date,
    units: units ?? this.units,
    content: content ?? this.content,
    state: state ?? this.state,
    revision: revision ?? this.revision,
    created: created ?? this.created,
    updated: updated ?? this.updated,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      journal: data.journal.present ? data.journal.value : this.journal,
      date: data.date.present ? data.date.value : this.date,
      units: data.units.present ? data.units.value : this.units,
      content: data.content.present ? data.content.value : this.content,
      state: data.state.present ? data.state.value : this.state,
      revision: data.revision.present ? data.revision.value : this.revision,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('journal: $journal, ')
          ..write('date: $date, ')
          ..write('units: $units, ')
          ..write('content: $content, ')
          ..write('state: $state, ')
          ..write('revision: $revision, ')
          ..write('created: $created, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journal,
    date,
    units,
    content,
    state,
    revision,
    created,
    updated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.journal == this.journal &&
          other.date == this.date &&
          other.units == this.units &&
          other.content == this.content &&
          other.state == this.state &&
          other.revision == this.revision &&
          other.created == this.created &&
          other.updated == this.updated);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<String> id;
  final Value<String> journal;
  final Value<String> date;
  final Value<int> units;
  final Value<String> content;
  final Value<String> state;
  final Value<int> revision;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> rowid;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.journal = const Value.absent(),
    this.date = const Value.absent(),
    this.units = const Value.absent(),
    this.content = const Value.absent(),
    this.state = const Value.absent(),
    this.revision = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonsCompanion.insert({
    required String id,
    required String journal,
    required String date,
    required int units,
    required String content,
    required String state,
    this.revision = const Value.absent(),
    required String created,
    required String updated,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       journal = Value(journal),
       date = Value(date),
       units = Value(units),
       content = Value(content),
       state = Value(state),
       created = Value(created),
       updated = Value(updated);
  static Insertable<Lesson> custom({
    Expression<String>? id,
    Expression<String>? journal,
    Expression<String>? date,
    Expression<int>? units,
    Expression<String>? content,
    Expression<String>? state,
    Expression<int>? revision,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journal != null) 'journal': journal,
      if (date != null) 'date': date,
      if (units != null) 'units': units,
      if (content != null) 'content': content,
      if (state != null) 'state': state,
      if (revision != null) 'revision': revision,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonsCompanion copyWith({
    Value<String>? id,
    Value<String>? journal,
    Value<String>? date,
    Value<int>? units,
    Value<String>? content,
    Value<String>? state,
    Value<int>? revision,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? rowid,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      journal: journal ?? this.journal,
      date: date ?? this.date,
      units: units ?? this.units,
      content: content ?? this.content,
      state: state ?? this.state,
      revision: revision ?? this.revision,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journal.present) {
      map['journal'] = Variable<String>(journal.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (units.present) {
      map['units'] = Variable<int>(units.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('journal: $journal, ')
          ..write('date: $date, ')
          ..write('units: $units, ')
          ..write('content: $content, ')
          ..write('state: $state, ')
          ..write('revision: $revision, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Attendance extends Table with TableInfo<Attendance, AttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Attendance(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonMeta = const VerificationMeta('lesson');
  late final GeneratedColumn<String> lesson = GeneratedColumn<String>(
    'lesson',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES lessons(id)',
  );
  static const VerificationMeta _enrollmentMeta = const VerificationMeta(
    'enrollment',
  );
  late final GeneratedColumn<String> enrollment = GeneratedColumn<String>(
    'enrollment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES enrollments(id)',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (status IN (\'Presente\', \'Ausente\', \'Justificada\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [lesson, enrollment, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson')) {
      context.handle(
        _lessonMeta,
        lesson.isAcceptableOrUnknown(data['lesson']!, _lessonMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonMeta);
    }
    if (data.containsKey('enrollment')) {
      context.handle(
        _enrollmentMeta,
        enrollment.isAcceptableOrUnknown(data['enrollment']!, _enrollmentMeta),
      );
    } else if (isInserting) {
      context.missing(_enrollmentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lesson, enrollment};
  @override
  AttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceData(
      lesson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson'],
      )!,
      enrollment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  Attendance createAlias(String alias) {
    return Attendance(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(lesson, enrollment)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class AttendanceData extends DataClass implements Insertable<AttendanceData> {
  final String lesson;
  final String enrollment;
  final String status;
  const AttendanceData({
    required this.lesson,
    required this.enrollment,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson'] = Variable<String>(lesson);
    map['enrollment'] = Variable<String>(enrollment);
    map['status'] = Variable<String>(status);
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      lesson: Value(lesson),
      enrollment: Value(enrollment),
      status: Value(status),
    );
  }

  factory AttendanceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceData(
      lesson: serializer.fromJson<String>(json['lesson']),
      enrollment: serializer.fromJson<String>(json['enrollment']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lesson': serializer.toJson<String>(lesson),
      'enrollment': serializer.toJson<String>(enrollment),
      'status': serializer.toJson<String>(status),
    };
  }

  AttendanceData copyWith({
    String? lesson,
    String? enrollment,
    String? status,
  }) => AttendanceData(
    lesson: lesson ?? this.lesson,
    enrollment: enrollment ?? this.enrollment,
    status: status ?? this.status,
  );
  AttendanceData copyWithCompanion(AttendanceCompanion data) {
    return AttendanceData(
      lesson: data.lesson.present ? data.lesson.value : this.lesson,
      enrollment: data.enrollment.present
          ? data.enrollment.value
          : this.enrollment,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceData(')
          ..write('lesson: $lesson, ')
          ..write('enrollment: $enrollment, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lesson, enrollment, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceData &&
          other.lesson == this.lesson &&
          other.enrollment == this.enrollment &&
          other.status == this.status);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceData> {
  final Value<String> lesson;
  final Value<String> enrollment;
  final Value<String> status;
  final Value<int> rowid;
  const AttendanceCompanion({
    this.lesson = const Value.absent(),
    this.enrollment = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceCompanion.insert({
    required String lesson,
    required String enrollment,
    required String status,
    this.rowid = const Value.absent(),
  }) : lesson = Value(lesson),
       enrollment = Value(enrollment),
       status = Value(status);
  static Insertable<AttendanceData> custom({
    Expression<String>? lesson,
    Expression<String>? enrollment,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lesson != null) 'lesson': lesson,
      if (enrollment != null) 'enrollment': enrollment,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceCompanion copyWith({
    Value<String>? lesson,
    Value<String>? enrollment,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return AttendanceCompanion(
      lesson: lesson ?? this.lesson,
      enrollment: enrollment ?? this.enrollment,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lesson.present) {
      map['lesson'] = Variable<String>(lesson.value);
    }
    if (enrollment.present) {
      map['enrollment'] = Variable<String>(enrollment.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('lesson: $lesson, ')
          ..write('enrollment: $enrollment, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LessonEvents extends Table with TableInfo<LessonEvents, LessonEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LessonEvents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _lessonMeta = const VerificationMeta('lesson');
  late final GeneratedColumn<String> lesson = GeneratedColumn<String>(
    'lesson',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES lessons(id)',
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, lesson, actor, message, created];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson')) {
      context.handle(
        _lessonMeta,
        lesson.isAcceptableOrUnknown(data['lesson']!, _lessonMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LessonEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lesson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
    );
  }

  @override
  LessonEvents createAlias(String alias) {
    return LessonEvents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class LessonEvent extends DataClass implements Insertable<LessonEvent> {
  final String id;
  final String lesson;
  final String actor;
  final String message;
  final String created;
  const LessonEvent({
    required this.id,
    required this.lesson,
    required this.actor,
    required this.message,
    required this.created,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson'] = Variable<String>(lesson);
    map['actor'] = Variable<String>(actor);
    map['message'] = Variable<String>(message);
    map['created'] = Variable<String>(created);
    return map;
  }

  LessonEventsCompanion toCompanion(bool nullToAbsent) {
    return LessonEventsCompanion(
      id: Value(id),
      lesson: Value(lesson),
      actor: Value(actor),
      message: Value(message),
      created: Value(created),
    );
  }

  factory LessonEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonEvent(
      id: serializer.fromJson<String>(json['id']),
      lesson: serializer.fromJson<String>(json['lesson']),
      actor: serializer.fromJson<String>(json['actor']),
      message: serializer.fromJson<String>(json['message']),
      created: serializer.fromJson<String>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lesson': serializer.toJson<String>(lesson),
      'actor': serializer.toJson<String>(actor),
      'message': serializer.toJson<String>(message),
      'created': serializer.toJson<String>(created),
    };
  }

  LessonEvent copyWith({
    String? id,
    String? lesson,
    String? actor,
    String? message,
    String? created,
  }) => LessonEvent(
    id: id ?? this.id,
    lesson: lesson ?? this.lesson,
    actor: actor ?? this.actor,
    message: message ?? this.message,
    created: created ?? this.created,
  );
  LessonEvent copyWithCompanion(LessonEventsCompanion data) {
    return LessonEvent(
      id: data.id.present ? data.id.value : this.id,
      lesson: data.lesson.present ? data.lesson.value : this.lesson,
      actor: data.actor.present ? data.actor.value : this.actor,
      message: data.message.present ? data.message.value : this.message,
      created: data.created.present ? data.created.value : this.created,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonEvent(')
          ..write('id: $id, ')
          ..write('lesson: $lesson, ')
          ..write('actor: $actor, ')
          ..write('message: $message, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lesson, actor, message, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonEvent &&
          other.id == this.id &&
          other.lesson == this.lesson &&
          other.actor == this.actor &&
          other.message == this.message &&
          other.created == this.created);
}

class LessonEventsCompanion extends UpdateCompanion<LessonEvent> {
  final Value<String> id;
  final Value<String> lesson;
  final Value<String> actor;
  final Value<String> message;
  final Value<String> created;
  final Value<int> rowid;
  const LessonEventsCompanion({
    this.id = const Value.absent(),
    this.lesson = const Value.absent(),
    this.actor = const Value.absent(),
    this.message = const Value.absent(),
    this.created = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonEventsCompanion.insert({
    required String id,
    required String lesson,
    required String actor,
    required String message,
    required String created,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lesson = Value(lesson),
       actor = Value(actor),
       message = Value(message),
       created = Value(created);
  static Insertable<LessonEvent> custom({
    Expression<String>? id,
    Expression<String>? lesson,
    Expression<String>? actor,
    Expression<String>? message,
    Expression<String>? created,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lesson != null) 'lesson': lesson,
      if (actor != null) 'actor': actor,
      if (message != null) 'message': message,
      if (created != null) 'created': created,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? lesson,
    Value<String>? actor,
    Value<String>? message,
    Value<String>? created,
    Value<int>? rowid,
  }) {
    return LessonEventsCompanion(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      actor: actor ?? this.actor,
      message: message ?? this.message,
      created: created ?? this.created,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lesson.present) {
      map['lesson'] = Variable<String>(lesson.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonEventsCompanion(')
          ..write('id: $id, ')
          ..write('lesson: $lesson, ')
          ..write('actor: $actor, ')
          ..write('message: $message, ')
          ..write('created: $created, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class TeacherProfiles extends Table
    with TableInfo<TeacherProfiles, TeacherProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TeacherProfiles(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  late final GeneratedColumn<String> user = GeneratedColumn<String>(
    'user',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES users(id)',
  );
  static const VerificationMeta _staffCodeMeta = const VerificationMeta(
    'staffCode',
  );
  late final GeneratedColumn<String> staffCode = GeneratedColumn<String>(
    'staff_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE COLLATE NOCASE',
  );
  static const VerificationMeta _qualificationMeta = const VerificationMeta(
    'qualification',
  );
  late final GeneratedColumn<String> qualification = GeneratedColumn<String>(
    'qualification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    user,
    staffCode,
    qualification,
    phone,
    email,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teacher_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeacherProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user')) {
      context.handle(
        _userMeta,
        user.isAcceptableOrUnknown(data['user']!, _userMeta),
      );
    } else if (isInserting) {
      context.missing(_userMeta);
    }
    if (data.containsKey('staff_code')) {
      context.handle(
        _staffCodeMeta,
        staffCode.isAcceptableOrUnknown(data['staff_code']!, _staffCodeMeta),
      );
    }
    if (data.containsKey('qualification')) {
      context.handle(
        _qualificationMeta,
        qualification.isAcceptableOrUnknown(
          data['qualification']!,
          _qualificationMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {user};
  @override
  TeacherProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeacherProfile(
      user: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user'],
      )!,
      staffCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_code'],
      ),
      qualification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qualification'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  TeacherProfiles createAlias(String alias) {
    return TeacherProfiles(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TeacherProfile extends DataClass implements Insertable<TeacherProfile> {
  final String user;
  final String? staffCode;
  final String qualification;
  final String phone;
  final String email;
  final int revision;
  const TeacherProfile({
    required this.user,
    this.staffCode,
    required this.qualification,
    required this.phone,
    required this.email,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user'] = Variable<String>(user);
    if (!nullToAbsent || staffCode != null) {
      map['staff_code'] = Variable<String>(staffCode);
    }
    map['qualification'] = Variable<String>(qualification);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  TeacherProfilesCompanion toCompanion(bool nullToAbsent) {
    return TeacherProfilesCompanion(
      user: Value(user),
      staffCode: staffCode == null && nullToAbsent
          ? const Value.absent()
          : Value(staffCode),
      qualification: Value(qualification),
      phone: Value(phone),
      email: Value(email),
      revision: Value(revision),
    );
  }

  factory TeacherProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeacherProfile(
      user: serializer.fromJson<String>(json['user']),
      staffCode: serializer.fromJson<String?>(json['staff_code']),
      qualification: serializer.fromJson<String>(json['qualification']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'user': serializer.toJson<String>(user),
      'staff_code': serializer.toJson<String?>(staffCode),
      'qualification': serializer.toJson<String>(qualification),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'revision': serializer.toJson<int>(revision),
    };
  }

  TeacherProfile copyWith({
    String? user,
    Value<String?> staffCode = const Value.absent(),
    String? qualification,
    String? phone,
    String? email,
    int? revision,
  }) => TeacherProfile(
    user: user ?? this.user,
    staffCode: staffCode.present ? staffCode.value : this.staffCode,
    qualification: qualification ?? this.qualification,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    revision: revision ?? this.revision,
  );
  TeacherProfile copyWithCompanion(TeacherProfilesCompanion data) {
    return TeacherProfile(
      user: data.user.present ? data.user.value : this.user,
      staffCode: data.staffCode.present ? data.staffCode.value : this.staffCode,
      qualification: data.qualification.present
          ? data.qualification.value
          : this.qualification,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeacherProfile(')
          ..write('user: $user, ')
          ..write('staffCode: $staffCode, ')
          ..write('qualification: $qualification, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(user, staffCode, qualification, phone, email, revision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeacherProfile &&
          other.user == this.user &&
          other.staffCode == this.staffCode &&
          other.qualification == this.qualification &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.revision == this.revision);
}

class TeacherProfilesCompanion extends UpdateCompanion<TeacherProfile> {
  final Value<String> user;
  final Value<String?> staffCode;
  final Value<String> qualification;
  final Value<String> phone;
  final Value<String> email;
  final Value<int> revision;
  final Value<int> rowid;
  const TeacherProfilesCompanion({
    this.user = const Value.absent(),
    this.staffCode = const Value.absent(),
    this.qualification = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeacherProfilesCompanion.insert({
    required String user,
    this.staffCode = const Value.absent(),
    this.qualification = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : user = Value(user);
  static Insertable<TeacherProfile> custom({
    Expression<String>? user,
    Expression<String>? staffCode,
    Expression<String>? qualification,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (user != null) 'user': user,
      if (staffCode != null) 'staff_code': staffCode,
      if (qualification != null) 'qualification': qualification,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeacherProfilesCompanion copyWith({
    Value<String>? user,
    Value<String?>? staffCode,
    Value<String>? qualification,
    Value<String>? phone,
    Value<String>? email,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return TeacherProfilesCompanion(
      user: user ?? this.user,
      staffCode: staffCode ?? this.staffCode,
      qualification: qualification ?? this.qualification,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (user.present) {
      map['user'] = Variable<String>(user.value);
    }
    if (staffCode.present) {
      map['staff_code'] = Variable<String>(staffCode.value);
    }
    if (qualification.present) {
      map['qualification'] = Variable<String>(qualification.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeacherProfilesCompanion(')
          ..write('user: $user, ')
          ..write('staffCode: $staffCode, ')
          ..write('qualification: $qualification, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class TimetableSlots extends Table
    with TableInfo<TimetableSlots, TimetableSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TimetableSlots(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _journalMeta = const VerificationMeta(
    'journal',
  );
  late final GeneratedColumn<String> journal = GeneratedColumn<String>(
    'journal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES journals(id)',
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (weekday BETWEEN 1 AND 7)',
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (start_minute BETWEEN 0 AND 1439)',
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (end_minute BETWEEN 1 AND 1440 AND end_minute > start_minute)',
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _validToMeta = const VerificationMeta(
    'validTo',
  );
  late final GeneratedColumn<String> validTo = GeneratedColumn<String>(
    'valid_to',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (valid_to >= valid_from)',
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journal,
    weekday,
    startMinute,
    endMinute,
    validFrom,
    validTo,
    room,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetable_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journal')) {
      context.handle(
        _journalMeta,
        journal.isAcceptableOrUnknown(data['journal']!, _journalMeta),
      );
    } else if (isInserting) {
      context.missing(_journalMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_to')) {
      context.handle(
        _validToMeta,
        validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta),
      );
    } else if (isInserting) {
      context.missing(_validToMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableSlot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      journal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      )!,
      validTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_to'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  TimetableSlots createAlias(String alias) {
    return TimetableSlots(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TimetableSlot extends DataClass implements Insertable<TimetableSlot> {
  final String id;
  final String journal;
  final int weekday;
  final int startMinute;
  final int endMinute;
  final String validFrom;
  final String validTo;
  final String room;
  final int revision;
  const TimetableSlot({
    required this.id,
    required this.journal,
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
    required this.validFrom,
    required this.validTo,
    required this.room,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journal'] = Variable<String>(journal);
    map['weekday'] = Variable<int>(weekday);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    map['valid_from'] = Variable<String>(validFrom);
    map['valid_to'] = Variable<String>(validTo);
    map['room'] = Variable<String>(room);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  TimetableSlotsCompanion toCompanion(bool nullToAbsent) {
    return TimetableSlotsCompanion(
      id: Value(id),
      journal: Value(journal),
      weekday: Value(weekday),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
      validFrom: Value(validFrom),
      validTo: Value(validTo),
      room: Value(room),
      revision: Value(revision),
    );
  }

  factory TimetableSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableSlot(
      id: serializer.fromJson<String>(json['id']),
      journal: serializer.fromJson<String>(json['journal']),
      weekday: serializer.fromJson<int>(json['weekday']),
      startMinute: serializer.fromJson<int>(json['start_minute']),
      endMinute: serializer.fromJson<int>(json['end_minute']),
      validFrom: serializer.fromJson<String>(json['valid_from']),
      validTo: serializer.fromJson<String>(json['valid_to']),
      room: serializer.fromJson<String>(json['room']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journal': serializer.toJson<String>(journal),
      'weekday': serializer.toJson<int>(weekday),
      'start_minute': serializer.toJson<int>(startMinute),
      'end_minute': serializer.toJson<int>(endMinute),
      'valid_from': serializer.toJson<String>(validFrom),
      'valid_to': serializer.toJson<String>(validTo),
      'room': serializer.toJson<String>(room),
      'revision': serializer.toJson<int>(revision),
    };
  }

  TimetableSlot copyWith({
    String? id,
    String? journal,
    int? weekday,
    int? startMinute,
    int? endMinute,
    String? validFrom,
    String? validTo,
    String? room,
    int? revision,
  }) => TimetableSlot(
    id: id ?? this.id,
    journal: journal ?? this.journal,
    weekday: weekday ?? this.weekday,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo ?? this.validTo,
    room: room ?? this.room,
    revision: revision ?? this.revision,
  );
  TimetableSlot copyWithCompanion(TimetableSlotsCompanion data) {
    return TimetableSlot(
      id: data.id.present ? data.id.value : this.id,
      journal: data.journal.present ? data.journal.value : this.journal,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      room: data.room.present ? data.room.value : this.room,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableSlot(')
          ..write('id: $id, ')
          ..write('journal: $journal, ')
          ..write('weekday: $weekday, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('room: $room, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journal,
    weekday,
    startMinute,
    endMinute,
    validFrom,
    validTo,
    room,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableSlot &&
          other.id == this.id &&
          other.journal == this.journal &&
          other.weekday == this.weekday &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.room == this.room &&
          other.revision == this.revision);
}

class TimetableSlotsCompanion extends UpdateCompanion<TimetableSlot> {
  final Value<String> id;
  final Value<String> journal;
  final Value<int> weekday;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<String> validFrom;
  final Value<String> validTo;
  final Value<String> room;
  final Value<int> revision;
  final Value<int> rowid;
  const TimetableSlotsCompanion({
    this.id = const Value.absent(),
    this.journal = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.room = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimetableSlotsCompanion.insert({
    required String id,
    required String journal,
    required int weekday,
    required int startMinute,
    required int endMinute,
    required String validFrom,
    required String validTo,
    this.room = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       journal = Value(journal),
       weekday = Value(weekday),
       startMinute = Value(startMinute),
       endMinute = Value(endMinute),
       validFrom = Value(validFrom),
       validTo = Value(validTo);
  static Insertable<TimetableSlot> custom({
    Expression<String>? id,
    Expression<String>? journal,
    Expression<int>? weekday,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<String>? validFrom,
    Expression<String>? validTo,
    Expression<String>? room,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journal != null) 'journal': journal,
      if (weekday != null) 'weekday': weekday,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (room != null) 'room': room,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimetableSlotsCompanion copyWith({
    Value<String>? id,
    Value<String>? journal,
    Value<int>? weekday,
    Value<int>? startMinute,
    Value<int>? endMinute,
    Value<String>? validFrom,
    Value<String>? validTo,
    Value<String>? room,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return TimetableSlotsCompanion(
      id: id ?? this.id,
      journal: journal ?? this.journal,
      weekday: weekday ?? this.weekday,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      room: room ?? this.room,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journal.present) {
      map['journal'] = Variable<String>(journal.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<String>(validTo.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableSlotsCompanion(')
          ..write('id: $id, ')
          ..write('journal: $journal, ')
          ..write('weekday: $weekday, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('room: $room, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Assessments extends Table with TableInfo<Assessments, Assessment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Assessments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _journalMeta = const VerificationMeta(
    'journal',
  );
  late final GeneratedColumn<String> journal = GeneratedColumn<String>(
    'journal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES journals(id)',
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _heldOnMeta = const VerificationMeta('heldOn');
  late final GeneratedColumn<String> heldOn = GeneratedColumn<String>(
    'held_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _maxScoreMeta = const VerificationMeta(
    'maxScore',
  );
  late final GeneratedColumn<double> maxScore = GeneratedColumn<double>(
    'max_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (max_score > 0 AND max_score <= 1000)',
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (weight > 0 AND weight <= 100)',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (state IN (\'Rascunho\', \'Em revisão\', \'Publicado\'))',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journal,
    label,
    stage,
    heldOn,
    maxScore,
    weight,
    state,
    revision,
    updated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Assessment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journal')) {
      context.handle(
        _journalMeta,
        journal.isAcceptableOrUnknown(data['journal']!, _journalMeta),
      );
    } else if (isInserting) {
      context.missing(_journalMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('held_on')) {
      context.handle(
        _heldOnMeta,
        heldOn.isAcceptableOrUnknown(data['held_on']!, _heldOnMeta),
      );
    } else if (isInserting) {
      context.missing(_heldOnMeta);
    }
    if (data.containsKey('max_score')) {
      context.handle(
        _maxScoreMeta,
        maxScore.isAcceptableOrUnknown(data['max_score']!, _maxScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_maxScoreMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Assessment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Assessment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      journal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      heldOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}held_on'],
      )!,
      maxScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_score'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
    );
  }

  @override
  Assessments createAlias(String alias) {
    return Assessments(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Assessment extends DataClass implements Insertable<Assessment> {
  final String id;
  final String journal;
  final String label;
  final String stage;
  final String heldOn;
  final double maxScore;
  final double weight;
  final String state;
  final int revision;
  final String updated;
  const Assessment({
    required this.id,
    required this.journal,
    required this.label,
    required this.stage,
    required this.heldOn,
    required this.maxScore,
    required this.weight,
    required this.state,
    required this.revision,
    required this.updated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journal'] = Variable<String>(journal);
    map['label'] = Variable<String>(label);
    map['stage'] = Variable<String>(stage);
    map['held_on'] = Variable<String>(heldOn);
    map['max_score'] = Variable<double>(maxScore);
    map['weight'] = Variable<double>(weight);
    map['state'] = Variable<String>(state);
    map['revision'] = Variable<int>(revision);
    map['updated'] = Variable<String>(updated);
    return map;
  }

  AssessmentsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentsCompanion(
      id: Value(id),
      journal: Value(journal),
      label: Value(label),
      stage: Value(stage),
      heldOn: Value(heldOn),
      maxScore: Value(maxScore),
      weight: Value(weight),
      state: Value(state),
      revision: Value(revision),
      updated: Value(updated),
    );
  }

  factory Assessment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Assessment(
      id: serializer.fromJson<String>(json['id']),
      journal: serializer.fromJson<String>(json['journal']),
      label: serializer.fromJson<String>(json['label']),
      stage: serializer.fromJson<String>(json['stage']),
      heldOn: serializer.fromJson<String>(json['held_on']),
      maxScore: serializer.fromJson<double>(json['max_score']),
      weight: serializer.fromJson<double>(json['weight']),
      state: serializer.fromJson<String>(json['state']),
      revision: serializer.fromJson<int>(json['revision']),
      updated: serializer.fromJson<String>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journal': serializer.toJson<String>(journal),
      'label': serializer.toJson<String>(label),
      'stage': serializer.toJson<String>(stage),
      'held_on': serializer.toJson<String>(heldOn),
      'max_score': serializer.toJson<double>(maxScore),
      'weight': serializer.toJson<double>(weight),
      'state': serializer.toJson<String>(state),
      'revision': serializer.toJson<int>(revision),
      'updated': serializer.toJson<String>(updated),
    };
  }

  Assessment copyWith({
    String? id,
    String? journal,
    String? label,
    String? stage,
    String? heldOn,
    double? maxScore,
    double? weight,
    String? state,
    int? revision,
    String? updated,
  }) => Assessment(
    id: id ?? this.id,
    journal: journal ?? this.journal,
    label: label ?? this.label,
    stage: stage ?? this.stage,
    heldOn: heldOn ?? this.heldOn,
    maxScore: maxScore ?? this.maxScore,
    weight: weight ?? this.weight,
    state: state ?? this.state,
    revision: revision ?? this.revision,
    updated: updated ?? this.updated,
  );
  Assessment copyWithCompanion(AssessmentsCompanion data) {
    return Assessment(
      id: data.id.present ? data.id.value : this.id,
      journal: data.journal.present ? data.journal.value : this.journal,
      label: data.label.present ? data.label.value : this.label,
      stage: data.stage.present ? data.stage.value : this.stage,
      heldOn: data.heldOn.present ? data.heldOn.value : this.heldOn,
      maxScore: data.maxScore.present ? data.maxScore.value : this.maxScore,
      weight: data.weight.present ? data.weight.value : this.weight,
      state: data.state.present ? data.state.value : this.state,
      revision: data.revision.present ? data.revision.value : this.revision,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Assessment(')
          ..write('id: $id, ')
          ..write('journal: $journal, ')
          ..write('label: $label, ')
          ..write('stage: $stage, ')
          ..write('heldOn: $heldOn, ')
          ..write('maxScore: $maxScore, ')
          ..write('weight: $weight, ')
          ..write('state: $state, ')
          ..write('revision: $revision, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journal,
    label,
    stage,
    heldOn,
    maxScore,
    weight,
    state,
    revision,
    updated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Assessment &&
          other.id == this.id &&
          other.journal == this.journal &&
          other.label == this.label &&
          other.stage == this.stage &&
          other.heldOn == this.heldOn &&
          other.maxScore == this.maxScore &&
          other.weight == this.weight &&
          other.state == this.state &&
          other.revision == this.revision &&
          other.updated == this.updated);
}

class AssessmentsCompanion extends UpdateCompanion<Assessment> {
  final Value<String> id;
  final Value<String> journal;
  final Value<String> label;
  final Value<String> stage;
  final Value<String> heldOn;
  final Value<double> maxScore;
  final Value<double> weight;
  final Value<String> state;
  final Value<int> revision;
  final Value<String> updated;
  final Value<int> rowid;
  const AssessmentsCompanion({
    this.id = const Value.absent(),
    this.journal = const Value.absent(),
    this.label = const Value.absent(),
    this.stage = const Value.absent(),
    this.heldOn = const Value.absent(),
    this.maxScore = const Value.absent(),
    this.weight = const Value.absent(),
    this.state = const Value.absent(),
    this.revision = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssessmentsCompanion.insert({
    required String id,
    required String journal,
    required String label,
    required String stage,
    required String heldOn,
    required double maxScore,
    required double weight,
    required String state,
    this.revision = const Value.absent(),
    required String updated,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       journal = Value(journal),
       label = Value(label),
       stage = Value(stage),
       heldOn = Value(heldOn),
       maxScore = Value(maxScore),
       weight = Value(weight),
       state = Value(state),
       updated = Value(updated);
  static Insertable<Assessment> custom({
    Expression<String>? id,
    Expression<String>? journal,
    Expression<String>? label,
    Expression<String>? stage,
    Expression<String>? heldOn,
    Expression<double>? maxScore,
    Expression<double>? weight,
    Expression<String>? state,
    Expression<int>? revision,
    Expression<String>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journal != null) 'journal': journal,
      if (label != null) 'label': label,
      if (stage != null) 'stage': stage,
      if (heldOn != null) 'held_on': heldOn,
      if (maxScore != null) 'max_score': maxScore,
      if (weight != null) 'weight': weight,
      if (state != null) 'state': state,
      if (revision != null) 'revision': revision,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssessmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? journal,
    Value<String>? label,
    Value<String>? stage,
    Value<String>? heldOn,
    Value<double>? maxScore,
    Value<double>? weight,
    Value<String>? state,
    Value<int>? revision,
    Value<String>? updated,
    Value<int>? rowid,
  }) {
    return AssessmentsCompanion(
      id: id ?? this.id,
      journal: journal ?? this.journal,
      label: label ?? this.label,
      stage: stage ?? this.stage,
      heldOn: heldOn ?? this.heldOn,
      maxScore: maxScore ?? this.maxScore,
      weight: weight ?? this.weight,
      state: state ?? this.state,
      revision: revision ?? this.revision,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journal.present) {
      map['journal'] = Variable<String>(journal.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (heldOn.present) {
      map['held_on'] = Variable<String>(heldOn.value);
    }
    if (maxScore.present) {
      map['max_score'] = Variable<double>(maxScore.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('journal: $journal, ')
          ..write('label: $label, ')
          ..write('stage: $stage, ')
          ..write('heldOn: $heldOn, ')
          ..write('maxScore: $maxScore, ')
          ..write('weight: $weight, ')
          ..write('state: $state, ')
          ..write('revision: $revision, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Grades extends Table with TableInfo<Grades, Grade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Grades(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _assessmentMeta = const VerificationMeta(
    'assessment',
  );
  late final GeneratedColumn<String> assessment = GeneratedColumn<String>(
    'assessment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES assessments(id)',
  );
  static const VerificationMeta _enrollmentMeta = const VerificationMeta(
    'enrollment',
  );
  late final GeneratedColumn<String> enrollment = GeneratedColumn<String>(
    'enrollment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES enrollments(id)',
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (status IN (\'Pendente\', \'Lançada\', \'Ausente\', \'Dispensada\'))',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    assessment,
    enrollment,
    score,
    status,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Grade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('assessment')) {
      context.handle(
        _assessmentMeta,
        assessment.isAcceptableOrUnknown(data['assessment']!, _assessmentMeta),
      );
    } else if (isInserting) {
      context.missing(_assessmentMeta);
    }
    if (data.containsKey('enrollment')) {
      context.handle(
        _enrollmentMeta,
        enrollment.isAcceptableOrUnknown(data['enrollment']!, _enrollmentMeta),
      );
    } else if (isInserting) {
      context.missing(_enrollmentMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {assessment, enrollment};
  @override
  Grade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Grade(
      assessment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment'],
      )!,
      enrollment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  Grades createAlias(String alias) {
    return Grades(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(assessment, enrollment)',
    'CHECK((status = \'Lançada\' AND score IS NOT NULL AND score >= 0)OR(status <> \'Lançada\' AND score IS NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class Grade extends DataClass implements Insertable<Grade> {
  final String assessment;
  final String enrollment;
  final double? score;
  final String status;
  final String note;
  const Grade({
    required this.assessment,
    required this.enrollment,
    this.score,
    required this.status,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['assessment'] = Variable<String>(assessment);
    map['enrollment'] = Variable<String>(enrollment);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    map['status'] = Variable<String>(status);
    map['note'] = Variable<String>(note);
    return map;
  }

  GradesCompanion toCompanion(bool nullToAbsent) {
    return GradesCompanion(
      assessment: Value(assessment),
      enrollment: Value(enrollment),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      status: Value(status),
      note: Value(note),
    );
  }

  factory Grade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Grade(
      assessment: serializer.fromJson<String>(json['assessment']),
      enrollment: serializer.fromJson<String>(json['enrollment']),
      score: serializer.fromJson<double?>(json['score']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'assessment': serializer.toJson<String>(assessment),
      'enrollment': serializer.toJson<String>(enrollment),
      'score': serializer.toJson<double?>(score),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String>(note),
    };
  }

  Grade copyWith({
    String? assessment,
    String? enrollment,
    Value<double?> score = const Value.absent(),
    String? status,
    String? note,
  }) => Grade(
    assessment: assessment ?? this.assessment,
    enrollment: enrollment ?? this.enrollment,
    score: score.present ? score.value : this.score,
    status: status ?? this.status,
    note: note ?? this.note,
  );
  Grade copyWithCompanion(GradesCompanion data) {
    return Grade(
      assessment: data.assessment.present
          ? data.assessment.value
          : this.assessment,
      enrollment: data.enrollment.present
          ? data.enrollment.value
          : this.enrollment,
      score: data.score.present ? data.score.value : this.score,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Grade(')
          ..write('assessment: $assessment, ')
          ..write('enrollment: $enrollment, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(assessment, enrollment, score, status, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Grade &&
          other.assessment == this.assessment &&
          other.enrollment == this.enrollment &&
          other.score == this.score &&
          other.status == this.status &&
          other.note == this.note);
}

class GradesCompanion extends UpdateCompanion<Grade> {
  final Value<String> assessment;
  final Value<String> enrollment;
  final Value<double?> score;
  final Value<String> status;
  final Value<String> note;
  final Value<int> rowid;
  const GradesCompanion({
    this.assessment = const Value.absent(),
    this.enrollment = const Value.absent(),
    this.score = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GradesCompanion.insert({
    required String assessment,
    required String enrollment,
    this.score = const Value.absent(),
    required String status,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : assessment = Value(assessment),
       enrollment = Value(enrollment),
       status = Value(status);
  static Insertable<Grade> custom({
    Expression<String>? assessment,
    Expression<String>? enrollment,
    Expression<double>? score,
    Expression<String>? status,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (assessment != null) 'assessment': assessment,
      if (enrollment != null) 'enrollment': enrollment,
      if (score != null) 'score': score,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GradesCompanion copyWith({
    Value<String>? assessment,
    Value<String>? enrollment,
    Value<double?>? score,
    Value<String>? status,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return GradesCompanion(
      assessment: assessment ?? this.assessment,
      enrollment: enrollment ?? this.enrollment,
      score: score ?? this.score,
      status: status ?? this.status,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (assessment.present) {
      map['assessment'] = Variable<String>(assessment.value);
    }
    if (enrollment.present) {
      map['enrollment'] = Variable<String>(enrollment.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GradesCompanion(')
          ..write('assessment: $assessment, ')
          ..write('enrollment: $enrollment, ')
          ..write('score: $score, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AssessmentEvents extends Table
    with TableInfo<AssessmentEvents, AssessmentEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AssessmentEvents(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _assessmentMeta = const VerificationMeta(
    'assessment',
  );
  late final GeneratedColumn<String> assessment = GeneratedColumn<String>(
    'assessment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES assessments(id)',
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assessment,
    actor,
    message,
    created,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessment_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssessmentEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('assessment')) {
      context.handle(
        _assessmentMeta,
        assessment.isAcceptableOrUnknown(data['assessment']!, _assessmentMeta),
      );
    } else if (isInserting) {
      context.missing(_assessmentMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assessment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment'],
      )!,
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
    );
  }

  @override
  AssessmentEvents createAlias(String alias) {
    return AssessmentEvents(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AssessmentEvent extends DataClass implements Insertable<AssessmentEvent> {
  final String id;
  final String assessment;
  final String actor;
  final String message;
  final String created;
  const AssessmentEvent({
    required this.id,
    required this.assessment,
    required this.actor,
    required this.message,
    required this.created,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['assessment'] = Variable<String>(assessment);
    map['actor'] = Variable<String>(actor);
    map['message'] = Variable<String>(message);
    map['created'] = Variable<String>(created);
    return map;
  }

  AssessmentEventsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentEventsCompanion(
      id: Value(id),
      assessment: Value(assessment),
      actor: Value(actor),
      message: Value(message),
      created: Value(created),
    );
  }

  factory AssessmentEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentEvent(
      id: serializer.fromJson<String>(json['id']),
      assessment: serializer.fromJson<String>(json['assessment']),
      actor: serializer.fromJson<String>(json['actor']),
      message: serializer.fromJson<String>(json['message']),
      created: serializer.fromJson<String>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assessment': serializer.toJson<String>(assessment),
      'actor': serializer.toJson<String>(actor),
      'message': serializer.toJson<String>(message),
      'created': serializer.toJson<String>(created),
    };
  }

  AssessmentEvent copyWith({
    String? id,
    String? assessment,
    String? actor,
    String? message,
    String? created,
  }) => AssessmentEvent(
    id: id ?? this.id,
    assessment: assessment ?? this.assessment,
    actor: actor ?? this.actor,
    message: message ?? this.message,
    created: created ?? this.created,
  );
  AssessmentEvent copyWithCompanion(AssessmentEventsCompanion data) {
    return AssessmentEvent(
      id: data.id.present ? data.id.value : this.id,
      assessment: data.assessment.present
          ? data.assessment.value
          : this.assessment,
      actor: data.actor.present ? data.actor.value : this.actor,
      message: data.message.present ? data.message.value : this.message,
      created: data.created.present ? data.created.value : this.created,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentEvent(')
          ..write('id: $id, ')
          ..write('assessment: $assessment, ')
          ..write('actor: $actor, ')
          ..write('message: $message, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, assessment, actor, message, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentEvent &&
          other.id == this.id &&
          other.assessment == this.assessment &&
          other.actor == this.actor &&
          other.message == this.message &&
          other.created == this.created);
}

class AssessmentEventsCompanion extends UpdateCompanion<AssessmentEvent> {
  final Value<String> id;
  final Value<String> assessment;
  final Value<String> actor;
  final Value<String> message;
  final Value<String> created;
  final Value<int> rowid;
  const AssessmentEventsCompanion({
    this.id = const Value.absent(),
    this.assessment = const Value.absent(),
    this.actor = const Value.absent(),
    this.message = const Value.absent(),
    this.created = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssessmentEventsCompanion.insert({
    required String id,
    required String assessment,
    required String actor,
    required String message,
    required String created,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assessment = Value(assessment),
       actor = Value(actor),
       message = Value(message),
       created = Value(created);
  static Insertable<AssessmentEvent> custom({
    Expression<String>? id,
    Expression<String>? assessment,
    Expression<String>? actor,
    Expression<String>? message,
    Expression<String>? created,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assessment != null) 'assessment': assessment,
      if (actor != null) 'actor': actor,
      if (message != null) 'message': message,
      if (created != null) 'created': created,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssessmentEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? assessment,
    Value<String>? actor,
    Value<String>? message,
    Value<String>? created,
    Value<int>? rowid,
  }) {
    return AssessmentEventsCompanion(
      id: id ?? this.id,
      assessment: assessment ?? this.assessment,
      actor: actor ?? this.actor,
      message: message ?? this.message,
      created: created ?? this.created,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assessment.present) {
      map['assessment'] = Variable<String>(assessment.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentEventsCompanion(')
          ..write('id: $id, ')
          ..write('assessment: $assessment, ')
          ..write('actor: $actor, ')
          ..write('message: $message, ')
          ..write('created: $created, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AbsenceJustifications extends Table
    with TableInfo<AbsenceJustifications, AbsenceJustification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AbsenceJustifications(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _lessonMeta = const VerificationMeta('lesson');
  late final GeneratedColumn<String> lesson = GeneratedColumn<String>(
    'lesson',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _enrollmentMeta = const VerificationMeta(
    'enrollment',
  );
  late final GeneratedColumn<String> enrollment = GeneratedColumn<String>(
    'enrollment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _requesterMeta = const VerificationMeta(
    'requester',
  );
  late final GeneratedColumn<String> requester = GeneratedColumn<String>(
    'requester',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES users(id)',
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _documentMeta = const VerificationMeta(
    'document',
  );
  late final GeneratedColumn<String> document = GeneratedColumn<String>(
    'document',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES documents(id)ON DELETE RESTRICT',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (state IN (\'Recebida\', \'Deferida\', \'Indeferida\'))',
  );
  static const VerificationMeta _responseMeta = const VerificationMeta(
    'response',
  );
  late final GeneratedColumn<String> response = GeneratedColumn<String>(
    'response',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _reviewerMeta = const VerificationMeta(
    'reviewer',
  );
  late final GeneratedColumn<String> reviewer = GeneratedColumn<String>(
    'reviewer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES users(id)',
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  late final GeneratedColumn<String> created = GeneratedColumn<String>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _updatedMeta = const VerificationMeta(
    'updated',
  );
  late final GeneratedColumn<String> updated = GeneratedColumn<String>(
    'updated',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lesson,
    enrollment,
    requester,
    reason,
    document,
    state,
    response,
    reviewer,
    created,
    updated,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'absence_justifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<AbsenceJustification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson')) {
      context.handle(
        _lessonMeta,
        lesson.isAcceptableOrUnknown(data['lesson']!, _lessonMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonMeta);
    }
    if (data.containsKey('enrollment')) {
      context.handle(
        _enrollmentMeta,
        enrollment.isAcceptableOrUnknown(data['enrollment']!, _enrollmentMeta),
      );
    } else if (isInserting) {
      context.missing(_enrollmentMeta);
    }
    if (data.containsKey('requester')) {
      context.handle(
        _requesterMeta,
        requester.isAcceptableOrUnknown(data['requester']!, _requesterMeta),
      );
    } else if (isInserting) {
      context.missing(_requesterMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('document')) {
      context.handle(
        _documentMeta,
        document.isAcceptableOrUnknown(data['document']!, _documentMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('response')) {
      context.handle(
        _responseMeta,
        response.isAcceptableOrUnknown(data['response']!, _responseMeta),
      );
    }
    if (data.containsKey('reviewer')) {
      context.handle(
        _reviewerMeta,
        reviewer.isAcceptableOrUnknown(data['reviewer']!, _reviewerMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('updated')) {
      context.handle(
        _updatedMeta,
        updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {lesson, enrollment},
  ];
  @override
  AbsenceJustification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AbsenceJustification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lesson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson'],
      )!,
      enrollment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment'],
      )!,
      requester: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      document: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      response: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response'],
      )!,
      reviewer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewer'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created'],
      )!,
      updated: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
    );
  }

  @override
  AbsenceJustifications createAlias(String alias) {
    return AbsenceJustifications(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY(lesson, enrollment)REFERENCES attendance(lesson, enrollment)',
    'UNIQUE(lesson, enrollment)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class AbsenceJustification extends DataClass
    implements Insertable<AbsenceJustification> {
  final String id;
  final String lesson;
  final String enrollment;
  final String requester;
  final String reason;
  final String? document;
  final String state;
  final String response;
  final String? reviewer;
  final String created;
  final String updated;
  final int revision;
  const AbsenceJustification({
    required this.id,
    required this.lesson,
    required this.enrollment,
    required this.requester,
    required this.reason,
    this.document,
    required this.state,
    required this.response,
    this.reviewer,
    required this.created,
    required this.updated,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson'] = Variable<String>(lesson);
    map['enrollment'] = Variable<String>(enrollment);
    map['requester'] = Variable<String>(requester);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || document != null) {
      map['document'] = Variable<String>(document);
    }
    map['state'] = Variable<String>(state);
    map['response'] = Variable<String>(response);
    if (!nullToAbsent || reviewer != null) {
      map['reviewer'] = Variable<String>(reviewer);
    }
    map['created'] = Variable<String>(created);
    map['updated'] = Variable<String>(updated);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  AbsenceJustificationsCompanion toCompanion(bool nullToAbsent) {
    return AbsenceJustificationsCompanion(
      id: Value(id),
      lesson: Value(lesson),
      enrollment: Value(enrollment),
      requester: Value(requester),
      reason: Value(reason),
      document: document == null && nullToAbsent
          ? const Value.absent()
          : Value(document),
      state: Value(state),
      response: Value(response),
      reviewer: reviewer == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewer),
      created: Value(created),
      updated: Value(updated),
      revision: Value(revision),
    );
  }

  factory AbsenceJustification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AbsenceJustification(
      id: serializer.fromJson<String>(json['id']),
      lesson: serializer.fromJson<String>(json['lesson']),
      enrollment: serializer.fromJson<String>(json['enrollment']),
      requester: serializer.fromJson<String>(json['requester']),
      reason: serializer.fromJson<String>(json['reason']),
      document: serializer.fromJson<String?>(json['document']),
      state: serializer.fromJson<String>(json['state']),
      response: serializer.fromJson<String>(json['response']),
      reviewer: serializer.fromJson<String?>(json['reviewer']),
      created: serializer.fromJson<String>(json['created']),
      updated: serializer.fromJson<String>(json['updated']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lesson': serializer.toJson<String>(lesson),
      'enrollment': serializer.toJson<String>(enrollment),
      'requester': serializer.toJson<String>(requester),
      'reason': serializer.toJson<String>(reason),
      'document': serializer.toJson<String?>(document),
      'state': serializer.toJson<String>(state),
      'response': serializer.toJson<String>(response),
      'reviewer': serializer.toJson<String?>(reviewer),
      'created': serializer.toJson<String>(created),
      'updated': serializer.toJson<String>(updated),
      'revision': serializer.toJson<int>(revision),
    };
  }

  AbsenceJustification copyWith({
    String? id,
    String? lesson,
    String? enrollment,
    String? requester,
    String? reason,
    Value<String?> document = const Value.absent(),
    String? state,
    String? response,
    Value<String?> reviewer = const Value.absent(),
    String? created,
    String? updated,
    int? revision,
  }) => AbsenceJustification(
    id: id ?? this.id,
    lesson: lesson ?? this.lesson,
    enrollment: enrollment ?? this.enrollment,
    requester: requester ?? this.requester,
    reason: reason ?? this.reason,
    document: document.present ? document.value : this.document,
    state: state ?? this.state,
    response: response ?? this.response,
    reviewer: reviewer.present ? reviewer.value : this.reviewer,
    created: created ?? this.created,
    updated: updated ?? this.updated,
    revision: revision ?? this.revision,
  );
  AbsenceJustification copyWithCompanion(AbsenceJustificationsCompanion data) {
    return AbsenceJustification(
      id: data.id.present ? data.id.value : this.id,
      lesson: data.lesson.present ? data.lesson.value : this.lesson,
      enrollment: data.enrollment.present
          ? data.enrollment.value
          : this.enrollment,
      requester: data.requester.present ? data.requester.value : this.requester,
      reason: data.reason.present ? data.reason.value : this.reason,
      document: data.document.present ? data.document.value : this.document,
      state: data.state.present ? data.state.value : this.state,
      response: data.response.present ? data.response.value : this.response,
      reviewer: data.reviewer.present ? data.reviewer.value : this.reviewer,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AbsenceJustification(')
          ..write('id: $id, ')
          ..write('lesson: $lesson, ')
          ..write('enrollment: $enrollment, ')
          ..write('requester: $requester, ')
          ..write('reason: $reason, ')
          ..write('document: $document, ')
          ..write('state: $state, ')
          ..write('response: $response, ')
          ..write('reviewer: $reviewer, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lesson,
    enrollment,
    requester,
    reason,
    document,
    state,
    response,
    reviewer,
    created,
    updated,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AbsenceJustification &&
          other.id == this.id &&
          other.lesson == this.lesson &&
          other.enrollment == this.enrollment &&
          other.requester == this.requester &&
          other.reason == this.reason &&
          other.document == this.document &&
          other.state == this.state &&
          other.response == this.response &&
          other.reviewer == this.reviewer &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.revision == this.revision);
}

class AbsenceJustificationsCompanion
    extends UpdateCompanion<AbsenceJustification> {
  final Value<String> id;
  final Value<String> lesson;
  final Value<String> enrollment;
  final Value<String> requester;
  final Value<String> reason;
  final Value<String?> document;
  final Value<String> state;
  final Value<String> response;
  final Value<String?> reviewer;
  final Value<String> created;
  final Value<String> updated;
  final Value<int> revision;
  final Value<int> rowid;
  const AbsenceJustificationsCompanion({
    this.id = const Value.absent(),
    this.lesson = const Value.absent(),
    this.enrollment = const Value.absent(),
    this.requester = const Value.absent(),
    this.reason = const Value.absent(),
    this.document = const Value.absent(),
    this.state = const Value.absent(),
    this.response = const Value.absent(),
    this.reviewer = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AbsenceJustificationsCompanion.insert({
    required String id,
    required String lesson,
    required String enrollment,
    required String requester,
    required String reason,
    this.document = const Value.absent(),
    required String state,
    this.response = const Value.absent(),
    this.reviewer = const Value.absent(),
    required String created,
    required String updated,
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lesson = Value(lesson),
       enrollment = Value(enrollment),
       requester = Value(requester),
       reason = Value(reason),
       state = Value(state),
       created = Value(created),
       updated = Value(updated);
  static Insertable<AbsenceJustification> custom({
    Expression<String>? id,
    Expression<String>? lesson,
    Expression<String>? enrollment,
    Expression<String>? requester,
    Expression<String>? reason,
    Expression<String>? document,
    Expression<String>? state,
    Expression<String>? response,
    Expression<String>? reviewer,
    Expression<String>? created,
    Expression<String>? updated,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lesson != null) 'lesson': lesson,
      if (enrollment != null) 'enrollment': enrollment,
      if (requester != null) 'requester': requester,
      if (reason != null) 'reason': reason,
      if (document != null) 'document': document,
      if (state != null) 'state': state,
      if (response != null) 'response': response,
      if (reviewer != null) 'reviewer': reviewer,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AbsenceJustificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? lesson,
    Value<String>? enrollment,
    Value<String>? requester,
    Value<String>? reason,
    Value<String?>? document,
    Value<String>? state,
    Value<String>? response,
    Value<String?>? reviewer,
    Value<String>? created,
    Value<String>? updated,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return AbsenceJustificationsCompanion(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      enrollment: enrollment ?? this.enrollment,
      requester: requester ?? this.requester,
      reason: reason ?? this.reason,
      document: document ?? this.document,
      state: state ?? this.state,
      response: response ?? this.response,
      reviewer: reviewer ?? this.reviewer,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lesson.present) {
      map['lesson'] = Variable<String>(lesson.value);
    }
    if (enrollment.present) {
      map['enrollment'] = Variable<String>(enrollment.value);
    }
    if (requester.present) {
      map['requester'] = Variable<String>(requester.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (document.present) {
      map['document'] = Variable<String>(document.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (response.present) {
      map['response'] = Variable<String>(response.value);
    }
    if (reviewer.present) {
      map['reviewer'] = Variable<String>(reviewer.value);
    }
    if (created.present) {
      map['created'] = Variable<String>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<String>(updated.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbsenceJustificationsCompanion(')
          ..write('id: $id, ')
          ..write('lesson: $lesson, ')
          ..write('enrollment: $enrollment, ')
          ..write('requester: $requester, ')
          ..write('reason: $reason, ')
          ..write('document: $document, ')
          ..write('state: $state, ')
          ..write('response: $response, ')
          ..write('reviewer: $reviewer, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final Users users = Users(this);
  late final Folders folders = Folders(this);
  late final Index folderNames = Index(
    'folder_names',
    'CREATE UNIQUE INDEX folder_names ON folders (area, coalesce(parent, \'\'), name COLLATE NOCASE)',
  );
  late final Documents documents = Documents(this);
  late final DocumentTemplates documentTemplates = DocumentTemplates(this);
  late final Students students = Students(this);
  late final Requests requests = Requests(this);
  late final Events events = Events(this);
  late final Attachments attachments = Attachments(this);
  late final Requirements requirements = Requirements(this);
  late final Index documentsByFolderType = Index(
    'documents_by_folder_type',
    'CREATE INDEX documents_by_folder_type ON documents (folder, type COLLATE NOCASE, status)',
  );
  late final Credentials credentials = Credentials(this);
  late final Sessions sessions = Sessions(this);
  late final StudentAccess studentAccess = StudentAccess(this);
  late final Courses courses = Courses(this);
  late final ClassGroups classGroups = ClassGroups(this);
  late final Enrollments enrollments = Enrollments(this);
  late final EnrollmentEvents enrollmentEvents = EnrollmentEvents(this);
  late final Index enrollmentClassState = Index(
    'enrollment_class_state',
    'CREATE INDEX enrollment_class_state ON enrollments (class_group, state)',
  );
  late final Subjects subjects = Subjects(this);
  late final CourseComponents courseComponents = CourseComponents(this);
  late final Journals journals = Journals(this);
  late final Lessons lessons = Lessons(this);
  late final Attendance attendance = Attendance(this);
  late final LessonEvents lessonEvents = LessonEvents(this);
  late final TeacherProfiles teacherProfiles = TeacherProfiles(this);
  late final TimetableSlots timetableSlots = TimetableSlots(this);
  late final Assessments assessments = Assessments(this);
  late final Grades grades = Grades(this);
  late final AssessmentEvents assessmentEvents = AssessmentEvents(this);
  late final AbsenceJustifications absenceJustifications =
      AbsenceJustifications(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    folders,
    folderNames,
    documents,
    documentTemplates,
    students,
    requests,
    events,
    attachments,
    requirements,
    documentsByFolderType,
    credentials,
    sessions,
    studentAccess,
    courses,
    classGroups,
    enrollments,
    enrollmentEvents,
    enrollmentClassState,
    subjects,
    courseComponents,
    journals,
    lessons,
    attendance,
    lessonEvents,
    teacherProfiles,
    timetableSlots,
    assessments,
    grades,
    assessmentEvents,
    absenceJustifications,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'requests',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'requests',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('requirements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'students',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('student_access', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $UsersCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  required String role,
  Value<String?> department,
  Value<int> rowid,
});
typedef $UsersUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> role,
  Value<String?> department,
  Value<int> rowid,
});

final class $UsersReferences extends BaseReferences<_$Database, Users, User> {
  $UsersReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Documents, List<Document>> _documentsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'users__id__documents__uploader',
  );

  $DocumentsProcessedTableManager get documentsRefs {
    final manager = $DocumentsTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.uploader.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Requests, List<Request>> _requestsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.requests,
    aliasName: 'users__id__requests__requester',
  );

  $RequestsProcessedTableManager get requestsRefs {
    final manager = $RequestsTableManager(
      $_db,
      $_db.requests,
    ).filter((f) => f.requester.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Events, List<Event>> _eventsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'users__id__events__actor',
  );

  $EventsProcessedTableManager get eventsRefs {
    final manager = $EventsTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.actor.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Credentials, List<Credential>>
  _credentialsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.credentials,
    aliasName: 'users__id__credentials__user',
  );

  $CredentialsProcessedTableManager get credentialsRefs {
    final manager = $CredentialsTableManager(
      $_db,
      $_db.credentials,
    ).filter((f) => f.user.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_credentialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Sessions, List<Session>> _sessionsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'users__id__sessions__user',
  );

  $SessionsProcessedTableManager get sessionsRefs {
    final manager = $SessionsTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.user.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<StudentAccess, List<StudentAccessData>>
  _studentAccessRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.studentAccess,
    aliasName: 'users__id__student_access__user',
  );

  $StudentAccessProcessedTableManager get studentAccessRefs {
    final manager = $StudentAccessTableManager(
      $_db,
      $_db.studentAccess,
    ).filter((f) => f.user.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentAccessRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<EnrollmentEvents, List<EnrollmentEvent>>
  _enrollmentEventsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.enrollmentEvents,
    aliasName: 'users__id__enrollment_events__actor',
  );

  $EnrollmentEventsProcessedTableManager get enrollmentEventsRefs {
    final manager = $EnrollmentEventsTableManager(
      $_db,
      $_db.enrollmentEvents,
    ).filter((f) => f.actor.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _enrollmentEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Journals, List<Journal>> _journalsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.journals,
    aliasName: 'users__id__journals__teacher',
  );

  $JournalsProcessedTableManager get journalsRefs {
    final manager = $JournalsTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.teacher.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<LessonEvents, List<LessonEvent>>
  _lessonEventsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.lessonEvents,
    aliasName: 'users__id__lesson_events__actor',
  );

  $LessonEventsProcessedTableManager get lessonEventsRefs {
    final manager = $LessonEventsTableManager(
      $_db,
      $_db.lessonEvents,
    ).filter((f) => f.actor.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<TeacherProfiles, List<TeacherProfile>>
  _teacherProfilesRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.teacherProfiles,
    aliasName: 'users__id__teacher_profiles__user',
  );

  $TeacherProfilesProcessedTableManager get teacherProfilesRefs {
    final manager = $TeacherProfilesTableManager(
      $_db,
      $_db.teacherProfiles,
    ).filter((f) => f.user.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _teacherProfilesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<AssessmentEvents, List<AssessmentEvent>>
  _assessmentEventsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.assessmentEvents,
    aliasName: 'users__id__assessment_events__actor',
  );

  $AssessmentEventsProcessedTableManager get assessmentEventsRefs {
    final manager = $AssessmentEventsTableManager(
      $_db,
      $_db.assessmentEvents,
    ).filter((f) => f.actor.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _assessmentEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $UsersFilterComposer extends Composer<_$Database, Users> {
  $UsersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> documentsRefs(
    Expression<bool> Function($DocumentsFilterComposer f) f,
  ) {
    final $DocumentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.uploader,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> requestsRefs(
    Expression<bool> Function($RequestsFilterComposer f) f,
  ) {
    final $RequestsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.requester,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsFilterComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($EventsFilterComposer f) f,
  ) {
    final $EventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EventsFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> credentialsRefs(
    Expression<bool> Function($CredentialsFilterComposer f) f,
  ) {
    final $CredentialsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.credentials,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CredentialsFilterComposer(
            $db: $db,
            $table: $db.credentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($SessionsFilterComposer f) f,
  ) {
    final $SessionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SessionsFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studentAccessRefs(
    Expression<bool> Function($StudentAccessFilterComposer f) f,
  ) {
    final $StudentAccessFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentAccess,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentAccessFilterComposer(
            $db: $db,
            $table: $db.studentAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> enrollmentEventsRefs(
    Expression<bool> Function($EnrollmentEventsFilterComposer f) f,
  ) {
    final $EnrollmentEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollmentEvents,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentEventsFilterComposer(
            $db: $db,
            $table: $db.enrollmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalsRefs(
    Expression<bool> Function($JournalsFilterComposer f) f,
  ) {
    final $JournalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.teacher,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lessonEventsRefs(
    Expression<bool> Function($LessonEventsFilterComposer f) f,
  ) {
    final $LessonEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonEvents,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonEventsFilterComposer(
            $db: $db,
            $table: $db.lessonEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teacherProfilesRefs(
    Expression<bool> Function($TeacherProfilesFilterComposer f) f,
  ) {
    final $TeacherProfilesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teacherProfiles,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TeacherProfilesFilterComposer(
            $db: $db,
            $table: $db.teacherProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assessmentEventsRefs(
    Expression<bool> Function($AssessmentEventsFilterComposer f) f,
  ) {
    final $AssessmentEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessmentEvents,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentEventsFilterComposer(
            $db: $db,
            $table: $db.assessmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UsersOrderingComposer extends Composer<_$Database, Users> {
  $UsersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );
}

class $UsersAnnotationComposer extends Composer<_$Database, Users> {
  $UsersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($DocumentsAnnotationComposer a) f,
  ) {
    final $DocumentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.uploader,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> requestsRefs<T extends Object>(
    Expression<T> Function($RequestsAnnotationComposer a) f,
  ) {
    final $RequestsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.requester,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsAnnotationComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($EventsAnnotationComposer a) f,
  ) {
    final $EventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EventsAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> credentialsRefs<T extends Object>(
    Expression<T> Function($CredentialsAnnotationComposer a) f,
  ) {
    final $CredentialsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.credentials,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CredentialsAnnotationComposer(
            $db: $db,
            $table: $db.credentials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($SessionsAnnotationComposer a) f,
  ) {
    final $SessionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SessionsAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studentAccessRefs<T extends Object>(
    Expression<T> Function($StudentAccessAnnotationComposer a) f,
  ) {
    final $StudentAccessAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentAccess,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentAccessAnnotationComposer(
            $db: $db,
            $table: $db.studentAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> enrollmentEventsRefs<T extends Object>(
    Expression<T> Function($EnrollmentEventsAnnotationComposer a) f,
  ) {
    final $EnrollmentEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollmentEvents,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentEventsAnnotationComposer(
            $db: $db,
            $table: $db.enrollmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalsRefs<T extends Object>(
    Expression<T> Function($JournalsAnnotationComposer a) f,
  ) {
    final $JournalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.teacher,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lessonEventsRefs<T extends Object>(
    Expression<T> Function($LessonEventsAnnotationComposer a) f,
  ) {
    final $LessonEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonEvents,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonEventsAnnotationComposer(
            $db: $db,
            $table: $db.lessonEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> teacherProfilesRefs<T extends Object>(
    Expression<T> Function($TeacherProfilesAnnotationComposer a) f,
  ) {
    final $TeacherProfilesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teacherProfiles,
      getReferencedColumn: (t) => t.user,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TeacherProfilesAnnotationComposer(
            $db: $db,
            $table: $db.teacherProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> assessmentEventsRefs<T extends Object>(
    Expression<T> Function($AssessmentEventsAnnotationComposer a) f,
  ) {
    final $AssessmentEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessmentEvents,
      getReferencedColumn: (t) => t.actor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentEventsAnnotationComposer(
            $db: $db,
            $table: $db.assessmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UsersTableManager
    extends
        RootTableManager<
          _$Database,
          Users,
          User,
          $UsersFilterComposer,
          $UsersOrderingComposer,
          $UsersAnnotationComposer,
          $UsersCreateCompanionBuilder,
          $UsersUpdateCompanionBuilder,
          (User, $UsersReferences),
          User,
          PrefetchHooks Function({
            bool documentsRefs,
            bool requestsRefs,
            bool eventsRefs,
            bool credentialsRefs,
            bool sessionsRefs,
            bool studentAccessRefs,
            bool enrollmentEventsRefs,
            bool journalsRefs,
            bool lessonEventsRefs,
            bool teacherProfilesRefs,
            bool assessmentEventsRefs,
          })
        > {
  $UsersTableManager(_$Database db, Users table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UsersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UsersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UsersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                role: role,
                department: department,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String role,
                Value<String?> department = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                role: role,
                department: department,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Users, User>(table),
                  $UsersReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                documentsRefs = false,
                requestsRefs = false,
                eventsRefs = false,
                credentialsRefs = false,
                sessionsRefs = false,
                studentAccessRefs = false,
                enrollmentEventsRefs = false,
                journalsRefs = false,
                lessonEventsRefs = false,
                teacherProfilesRefs = false,
                assessmentEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (documentsRefs) db.documents,
                    if (requestsRefs) db.requests,
                    if (eventsRefs) db.events,
                    if (credentialsRefs) db.credentials,
                    if (sessionsRefs) db.sessions,
                    if (studentAccessRefs) db.studentAccess,
                    if (enrollmentEventsRefs) db.enrollmentEvents,
                    if (journalsRefs) db.journals,
                    if (lessonEventsRefs) db.lessonEvents,
                    if (teacherProfilesRefs) db.teacherProfiles,
                    if (assessmentEventsRefs) db.assessmentEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (documentsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          Document,
                          Documents
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences._documentsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).documentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'uploader',
                          typedResults: items,
                        ),
                      if (requestsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          Request,
                          Requests
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences._requestsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).requestsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'requester',
                          typedResults: items,
                        ),
                      if (eventsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          Event,
                          Events
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences._eventsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).eventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'actor',
                          typedResults: items,
                        ),
                      if (credentialsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          Credential,
                          Credentials
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._credentialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).credentialsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user',
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          Session,
                          Sessions
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences._sessionsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).sessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user',
                          typedResults: items,
                        ),
                      if (studentAccessRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          StudentAccessData,
                          StudentAccess
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._studentAccessRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).studentAccessRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user',
                          typedResults: items,
                        ),
                      if (enrollmentEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          EnrollmentEvent,
                          EnrollmentEvents
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._enrollmentEventsRefsTable(db),
                          managerFromTypedResult: (p0) => $UsersReferences(
                            db,
                            table,
                            p0,
                          ).enrollmentEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'actor',
                          typedResults: items,
                        ),
                      if (journalsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          Journal,
                          Journals
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences._journalsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).journalsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'teacher',
                          typedResults: items,
                        ),
                      if (lessonEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          LessonEvent,
                          LessonEvents
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._lessonEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsersReferences(db, table, p0).lessonEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'actor',
                          typedResults: items,
                        ),
                      if (teacherProfilesRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          TeacherProfile,
                          TeacherProfiles
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._teacherProfilesRefsTable(db),
                          managerFromTypedResult: (p0) => $UsersReferences(
                            db,
                            table,
                            p0,
                          ).teacherProfilesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user',
                          typedResults: items,
                        ),
                      if (assessmentEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          User,
                          Users,
                          AssessmentEvent,
                          AssessmentEvents
                        >(
                          currentTable: table,
                          referencedTable: $UsersReferences
                              ._assessmentEventsRefsTable(db),
                          managerFromTypedResult: (p0) => $UsersReferences(
                            db,
                            table,
                            p0,
                          ).assessmentEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'actor',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $UsersProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Users,
      User,
      $UsersFilterComposer,
      $UsersOrderingComposer,
      $UsersAnnotationComposer,
      $UsersCreateCompanionBuilder,
      $UsersUpdateCompanionBuilder,
      (User, $UsersReferences),
      User,
      PrefetchHooks Function({
        bool documentsRefs,
        bool requestsRefs,
        bool eventsRefs,
        bool credentialsRefs,
        bool sessionsRefs,
        bool studentAccessRefs,
        bool enrollmentEventsRefs,
        bool journalsRefs,
        bool lessonEventsRefs,
        bool teacherProfilesRefs,
        bool assessmentEventsRefs,
      })
    >;
typedef $FoldersCreateCompanionBuilder = FoldersCompanion Function({
  required String id,
  required String name,
  Value<String?> parent,
  required String area,
  required String created,
  required String updated,
  Value<int> revision,
  Value<int> rowid,
});
typedef $FoldersUpdateCompanionBuilder = FoldersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parent,
  Value<String> area,
  Value<String> created,
  Value<String> updated,
  Value<int> revision,
  Value<int> rowid,
});

final class $FoldersReferences
    extends BaseReferences<_$Database, Folders, Folder> {
  $FoldersReferences(super.$_db, super.$_table, super.$_typedResult);

  static Folders _parentTable(_$Database db) =>
      db.folders.createAlias('folders__parent__folders__id');

  $FoldersProcessedTableManager? get parent {
    final $_column = $_itemColumn<String>('parent');
    if ($_column == null) return null;
    final manager = $FoldersTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Documents, List<Document>> _documentsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'folders__id__documents__folder',
  );

  $DocumentsProcessedTableManager get documentsRefs {
    final manager = $DocumentsTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.folder.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Students, List<Student>> _studentsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.students,
    aliasName: 'folders__id__students__folder',
  );

  $StudentsProcessedTableManager get studentsRefs {
    final manager = $StudentsTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.folder.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $FoldersFilterComposer extends Composer<_$Database, Folders> {
  $FoldersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $FoldersFilterComposer get parent {
    final $FoldersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> documentsRefs(
    Expression<bool> Function($DocumentsFilterComposer f) f,
  ) {
    final $DocumentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.folder,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studentsRefs(
    Expression<bool> Function($StudentsFilterComposer f) f,
  ) {
    final $StudentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.folder,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $FoldersOrderingComposer extends Composer<_$Database, Folders> {
  $FoldersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $FoldersOrderingComposer get parent {
    final $FoldersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersOrderingComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FoldersAnnotationComposer extends Composer<_$Database, Folders> {
  $FoldersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $FoldersAnnotationComposer get parent {
    final $FoldersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($DocumentsAnnotationComposer a) f,
  ) {
    final $DocumentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.folder,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studentsRefs<T extends Object>(
    Expression<T> Function($StudentsAnnotationComposer a) f,
  ) {
    final $StudentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.folder,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $FoldersTableManager
    extends
        RootTableManager<
          _$Database,
          Folders,
          Folder,
          $FoldersFilterComposer,
          $FoldersOrderingComposer,
          $FoldersAnnotationComposer,
          $FoldersCreateCompanionBuilder,
          $FoldersUpdateCompanionBuilder,
          (Folder, $FoldersReferences),
          Folder,
          PrefetchHooks Function({
            bool parent,
            bool documentsRefs,
            bool studentsRefs,
          })
        > {
  $FoldersTableManager(_$Database db, Folders table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FoldersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FoldersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FoldersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parent = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                name: name,
                parent: parent,
                area: area,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parent = const Value.absent(),
                required String area,
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion.insert(
                id: id,
                name: name,
                parent: parent,
                area: area,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Folders, Folder>(table),
                  $FoldersReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({parent = false, documentsRefs = false, studentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (documentsRefs) db.documents,
                    if (studentsRefs) db.students,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parent) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parent,
                            referencedTable: $FoldersReferences._parentTable(
                              db,
                            ),
                            referencedColumn: $FoldersReferences
                                ._parentTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (documentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Folder,
                          Folders,
                          Document,
                          Documents
                        >(
                          currentTable: table,
                          referencedTable: $FoldersReferences
                              ._documentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $FoldersReferences(db, table, p0).documentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'folder',
                          typedResults: items,
                        ),
                      if (studentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Folder,
                          Folders,
                          Student,
                          Students
                        >(
                          currentTable: table,
                          referencedTable: $FoldersReferences
                              ._studentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $FoldersReferences(db, table, p0).studentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'folder',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $FoldersProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Folders,
      Folder,
      $FoldersFilterComposer,
      $FoldersOrderingComposer,
      $FoldersAnnotationComposer,
      $FoldersCreateCompanionBuilder,
      $FoldersUpdateCompanionBuilder,
      (Folder, $FoldersReferences),
      Folder,
      PrefetchHooks Function({
        bool parent,
        bool documentsRefs,
        bool studentsRefs,
      })
    >;
typedef $DocumentsCreateCompanionBuilder = DocumentsCompanion Function({
  required String id,
  required String name,
  required String folder,
  required String type,
  required String mime,
  required int size,
  required String storage,
  Value<String> status,
  Value<String> note,
  required String uploader,
  required String created,
  required String updated,
  Value<int> revision,
  Value<int> rowid,
});
typedef $DocumentsUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> folder,
  Value<String> type,
  Value<String> mime,
  Value<int> size,
  Value<String> storage,
  Value<String> status,
  Value<String> note,
  Value<String> uploader,
  Value<String> created,
  Value<String> updated,
  Value<int> revision,
  Value<int> rowid,
});

final class $DocumentsReferences
    extends BaseReferences<_$Database, Documents, Document> {
  $DocumentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Folders _folderTable(_$Database db) =>
      db.folders.createAlias('documents__folder__folders__id');

  $FoldersProcessedTableManager get folder {
    final $_column = $_itemColumn<String>('folder')!;

    final manager = $FoldersTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _uploaderTable(_$Database db) =>
      db.users.createAlias('documents__uploader__users__id');

  $UsersProcessedTableManager get uploader {
    final $_column = $_itemColumn<String>('uploader')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_uploaderTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Attachments, List<Attachment>>
  _attachmentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: 'documents__id__attachments__document',
  );

  $AttachmentsProcessedTableManager get attachmentsRefs {
    final manager = $AttachmentsTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.document.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<AbsenceJustifications, List<AbsenceJustification>>
  _absenceJustificationsRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(
        db.absenceJustifications,
        aliasName: 'documents__id__absence_justifications__document',
      );

  $AbsenceJustificationsProcessedTableManager get absenceJustificationsRefs {
    final manager = $AbsenceJustificationsTableManager(
      $_db,
      $_db.absenceJustifications,
    ).filter((f) => f.document.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _absenceJustificationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $DocumentsFilterComposer extends Composer<_$Database, Documents> {
  $DocumentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storage => $composableBuilder(
    column: $table.storage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $FoldersFilterComposer get folder {
    final $FoldersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folder,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get uploader {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploader,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($AttachmentsFilterComposer f) f,
  ) {
    final $AttachmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.document,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttachmentsFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> absenceJustificationsRefs(
    Expression<bool> Function($AbsenceJustificationsFilterComposer f) f,
  ) {
    final $AbsenceJustificationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.absenceJustifications,
      getReferencedColumn: (t) => t.document,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AbsenceJustificationsFilterComposer(
            $db: $db,
            $table: $db.absenceJustifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DocumentsOrderingComposer extends Composer<_$Database, Documents> {
  $DocumentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storage => $composableBuilder(
    column: $table.storage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $FoldersOrderingComposer get folder {
    final $FoldersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folder,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersOrderingComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get uploader {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploader,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DocumentsAnnotationComposer extends Composer<_$Database, Documents> {
  $DocumentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get storage =>
      $composableBuilder(column: $table.storage, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $FoldersAnnotationComposer get folder {
    final $FoldersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folder,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get uploader {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.uploader,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($AttachmentsAnnotationComposer a) f,
  ) {
    final $AttachmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.document,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttachmentsAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> absenceJustificationsRefs<T extends Object>(
    Expression<T> Function($AbsenceJustificationsAnnotationComposer a) f,
  ) {
    final $AbsenceJustificationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.absenceJustifications,
      getReferencedColumn: (t) => t.document,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AbsenceJustificationsAnnotationComposer(
            $db: $db,
            $table: $db.absenceJustifications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DocumentsTableManager
    extends
        RootTableManager<
          _$Database,
          Documents,
          Document,
          $DocumentsFilterComposer,
          $DocumentsOrderingComposer,
          $DocumentsAnnotationComposer,
          $DocumentsCreateCompanionBuilder,
          $DocumentsUpdateCompanionBuilder,
          (Document, $DocumentsReferences),
          Document,
          PrefetchHooks Function({
            bool folder,
            bool uploader,
            bool attachmentsRefs,
            bool absenceJustificationsRefs,
          })
        > {
  $DocumentsTableManager(_$Database db, Documents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DocumentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DocumentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DocumentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> folder = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> mime = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String> storage = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> uploader = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                name: name,
                folder: folder,
                type: type,
                mime: mime,
                size: size,
                storage: storage,
                status: status,
                note: note,
                uploader: uploader,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String folder,
                required String type,
                required String mime,
                required int size,
                required String storage,
                Value<String> status = const Value.absent(),
                Value<String> note = const Value.absent(),
                required String uploader,
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                name: name,
                folder: folder,
                type: type,
                mime: mime,
                size: size,
                storage: storage,
                status: status,
                note: note,
                uploader: uploader,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Documents, Document>(table),
                  $DocumentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                folder = false,
                uploader = false,
                attachmentsRefs = false,
                absenceJustificationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (attachmentsRefs) db.attachments,
                    if (absenceJustificationsRefs) db.absenceJustifications,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (folder) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.folder,
                            referencedTable: $DocumentsReferences._folderTable(
                              db,
                            ),
                            referencedColumn: $DocumentsReferences
                                ._folderTable(db)
                                .id,
                          ) as T;
                        }
                        if (uploader) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.uploader,
                            referencedTable: $DocumentsReferences
                                ._uploaderTable(db),
                            referencedColumn: $DocumentsReferences
                                ._uploaderTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (attachmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Document,
                          Documents,
                          Attachment,
                          Attachments
                        >(
                          currentTable: table,
                          referencedTable: $DocumentsReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) => $DocumentsReferences(
                            db,
                            table,
                            p0,
                          ).attachmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'document',
                          typedResults: items,
                        ),
                      if (absenceJustificationsRefs)
                        await $_getPrefetchedDataByColumns<
                          Document,
                          Documents,
                          AbsenceJustification,
                          AbsenceJustifications
                        >(
                          currentTable: table,
                          referencedTable: $DocumentsReferences
                              ._absenceJustificationsRefsTable(db),
                          managerFromTypedResult: (p0) => $DocumentsReferences(
                            db,
                            table,
                            p0,
                          ).absenceJustificationsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'document',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $DocumentsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Documents,
      Document,
      $DocumentsFilterComposer,
      $DocumentsOrderingComposer,
      $DocumentsAnnotationComposer,
      $DocumentsCreateCompanionBuilder,
      $DocumentsUpdateCompanionBuilder,
      (Document, $DocumentsReferences),
      Document,
      PrefetchHooks Function({
        bool folder,
        bool uploader,
        bool attachmentsRefs,
        bool absenceJustificationsRefs,
      })
    >;
typedef $DocumentTemplatesCreateCompanionBuilder =
    DocumentTemplatesCompanion Function({
      required String id,
      required String name,
      required String documentsJson,
      required String fieldsJson,
      Value<int> archived,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $DocumentTemplatesUpdateCompanionBuilder =
    DocumentTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> documentsJson,
      Value<String> fieldsJson,
      Value<int> archived,
      Value<int> revision,
      Value<int> rowid,
    });

final class $DocumentTemplatesReferences
    extends BaseReferences<_$Database, DocumentTemplates, DocumentTemplate> {
  $DocumentTemplatesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Students, List<Student>> _studentsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.students,
    aliasName: 'document_templates__id__students__template',
  );

  $StudentsProcessedTableManager get studentsRefs {
    final manager = $StudentsTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.template.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Courses, List<Course>> _coursesRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.courses,
    aliasName: 'document_templates__id__courses__template',
  );

  $CoursesProcessedTableManager get coursesRefs {
    final manager = $CoursesTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.template.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_coursesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $DocumentTemplatesFilterComposer
    extends Composer<_$Database, DocumentTemplates> {
  $DocumentTemplatesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentsJson => $composableBuilder(
    column: $table.documentsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studentsRefs(
    Expression<bool> Function($StudentsFilterComposer f) f,
  ) {
    final $StudentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.template,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> coursesRefs(
    Expression<bool> Function($CoursesFilterComposer f) f,
  ) {
    final $CoursesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.template,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DocumentTemplatesOrderingComposer
    extends Composer<_$Database, DocumentTemplates> {
  $DocumentTemplatesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentsJson => $composableBuilder(
    column: $table.documentsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DocumentTemplatesAnnotationComposer
    extends Composer<_$Database, DocumentTemplates> {
  $DocumentTemplatesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get documentsJson => $composableBuilder(
    column: $table.documentsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  Expression<T> studentsRefs<T extends Object>(
    Expression<T> Function($StudentsAnnotationComposer a) f,
  ) {
    final $StudentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.template,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> coursesRefs<T extends Object>(
    Expression<T> Function($CoursesAnnotationComposer a) f,
  ) {
    final $CoursesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.template,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DocumentTemplatesTableManager
    extends
        RootTableManager<
          _$Database,
          DocumentTemplates,
          DocumentTemplate,
          $DocumentTemplatesFilterComposer,
          $DocumentTemplatesOrderingComposer,
          $DocumentTemplatesAnnotationComposer,
          $DocumentTemplatesCreateCompanionBuilder,
          $DocumentTemplatesUpdateCompanionBuilder,
          (DocumentTemplate, $DocumentTemplatesReferences),
          DocumentTemplate,
          PrefetchHooks Function({bool studentsRefs, bool coursesRefs})
        > {
  $DocumentTemplatesTableManager(_$Database db, DocumentTemplates table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DocumentTemplatesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DocumentTemplatesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DocumentTemplatesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> documentsJson = const Value.absent(),
                Value<String> fieldsJson = const Value.absent(),
                Value<int> archived = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTemplatesCompanion(
                id: id,
                name: name,
                documentsJson: documentsJson,
                fieldsJson: fieldsJson,
                archived: archived,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String documentsJson,
                required String fieldsJson,
                Value<int> archived = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTemplatesCompanion.insert(
                id: id,
                name: name,
                documentsJson: documentsJson,
                fieldsJson: fieldsJson,
                archived: archived,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DocumentTemplates, DocumentTemplate>(table),
                  $DocumentTemplatesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentsRefs = false, coursesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studentsRefs) db.students,
                if (coursesRefs) db.courses,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studentsRefs)
                    await $_getPrefetchedDataByColumns<
                      DocumentTemplate,
                      DocumentTemplates,
                      Student,
                      Students
                    >(
                      currentTable: table,
                      referencedTable: $DocumentTemplatesReferences
                          ._studentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $DocumentTemplatesReferences(
                            db,
                            table,
                            p0,
                          ).studentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'template',
                      typedResults: items,
                    ),
                  if (coursesRefs)
                    await $_getPrefetchedDataByColumns<
                      DocumentTemplate,
                      DocumentTemplates,
                      Course,
                      Courses
                    >(
                      currentTable: table,
                      referencedTable: $DocumentTemplatesReferences
                          ._coursesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $DocumentTemplatesReferences(
                            db,
                            table,
                            p0,
                          ).coursesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'template',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $DocumentTemplatesProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      DocumentTemplates,
      DocumentTemplate,
      $DocumentTemplatesFilterComposer,
      $DocumentTemplatesOrderingComposer,
      $DocumentTemplatesAnnotationComposer,
      $DocumentTemplatesCreateCompanionBuilder,
      $DocumentTemplatesUpdateCompanionBuilder,
      (DocumentTemplate, $DocumentTemplatesReferences),
      DocumentTemplate,
      PrefetchHooks Function({bool studentsRefs, bool coursesRefs})
    >;
typedef $StudentsCreateCompanionBuilder = StudentsCompanion Function({
  required String id,
  required String name,
  Value<String?> registration,
  Value<String> birthDate,
  Value<String> sex,
  Value<String> socialName,
  Value<String> birthplace,
  Value<String> nationality,
  Value<String> parentage,
  Value<String> address,
  Value<String> guardian,
  Value<String> phone,
  Value<String> email,
  Value<String> notes,
  Value<String> extraJson,
  Value<String?> template,
  Value<String> templateFieldsJson,
  required String folder,
  required String created,
  required String updated,
  Value<int> revision,
  Value<int> rowid,
});
typedef $StudentsUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> registration,
  Value<String> birthDate,
  Value<String> sex,
  Value<String> socialName,
  Value<String> birthplace,
  Value<String> nationality,
  Value<String> parentage,
  Value<String> address,
  Value<String> guardian,
  Value<String> phone,
  Value<String> email,
  Value<String> notes,
  Value<String> extraJson,
  Value<String?> template,
  Value<String> templateFieldsJson,
  Value<String> folder,
  Value<String> created,
  Value<String> updated,
  Value<int> revision,
  Value<int> rowid,
});

final class $StudentsReferences
    extends BaseReferences<_$Database, Students, Student> {
  $StudentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static DocumentTemplates _templateTable(_$Database db) => db.documentTemplates
      .createAlias('students__template__document_templates__id');

  $DocumentTemplatesProcessedTableManager? get template {
    final $_column = $_itemColumn<String>('template');
    if ($_column == null) return null;
    final manager = $DocumentTemplatesTableManager(
      $_db,
      $_db.documentTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Folders _folderTable(_$Database db) =>
      db.folders.createAlias('students__folder__folders__id');

  $FoldersProcessedTableManager get folder {
    final $_column = $_itemColumn<String>('folder')!;

    final manager = $FoldersTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Requests, List<Request>> _requestsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.requests,
    aliasName: 'students__id__requests__student',
  );

  $RequestsProcessedTableManager get requestsRefs {
    final manager = $RequestsTableManager(
      $_db,
      $_db.requests,
    ).filter((f) => f.student.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Requirements, List<Requirement>>
  _requirementsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.requirements,
    aliasName: 'students__id__requirements__student',
  );

  $RequirementsProcessedTableManager get requirementsRefs {
    final manager = $RequirementsTableManager(
      $_db,
      $_db.requirements,
    ).filter((f) => f.student.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_requirementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<StudentAccess, List<StudentAccessData>>
  _studentAccessRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.studentAccess,
    aliasName: 'students__id__student_access__student',
  );

  $StudentAccessProcessedTableManager get studentAccessRefs {
    final manager = $StudentAccessTableManager(
      $_db,
      $_db.studentAccess,
    ).filter((f) => f.student.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentAccessRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Enrollments, List<Enrollment>>
  _enrollmentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.enrollments,
    aliasName: 'students__id__enrollments__student',
  );

  $EnrollmentsProcessedTableManager get enrollmentsRefs {
    final manager = $EnrollmentsTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.student.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_enrollmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $StudentsFilterComposer extends Composer<_$Database, Students> {
  $StudentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registration => $composableBuilder(
    column: $table.registration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get socialName => $composableBuilder(
    column: $table.socialName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthplace => $composableBuilder(
    column: $table.birthplace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentage => $composableBuilder(
    column: $table.parentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guardian => $composableBuilder(
    column: $table.guardian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateFieldsJson => $composableBuilder(
    column: $table.templateFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $DocumentTemplatesFilterComposer get template {
    final $DocumentTemplatesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.documentTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTemplatesFilterComposer(
            $db: $db,
            $table: $db.documentTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FoldersFilterComposer get folder {
    final $FoldersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folder,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> requestsRefs(
    Expression<bool> Function($RequestsFilterComposer f) f,
  ) {
    final $RequestsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsFilterComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> requirementsRefs(
    Expression<bool> Function($RequirementsFilterComposer f) f,
  ) {
    final $RequirementsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requirements,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequirementsFilterComposer(
            $db: $db,
            $table: $db.requirements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studentAccessRefs(
    Expression<bool> Function($StudentAccessFilterComposer f) f,
  ) {
    final $StudentAccessFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentAccess,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentAccessFilterComposer(
            $db: $db,
            $table: $db.studentAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> enrollmentsRefs(
    Expression<bool> Function($EnrollmentsFilterComposer f) f,
  ) {
    final $EnrollmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $StudentsOrderingComposer extends Composer<_$Database, Students> {
  $StudentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registration => $composableBuilder(
    column: $table.registration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get socialName => $composableBuilder(
    column: $table.socialName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthplace => $composableBuilder(
    column: $table.birthplace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentage => $composableBuilder(
    column: $table.parentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guardian => $composableBuilder(
    column: $table.guardian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateFieldsJson => $composableBuilder(
    column: $table.templateFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $DocumentTemplatesOrderingComposer get template {
    final $DocumentTemplatesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.documentTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTemplatesOrderingComposer(
            $db: $db,
            $table: $db.documentTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FoldersOrderingComposer get folder {
    final $FoldersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folder,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersOrderingComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $StudentsAnnotationComposer extends Composer<_$Database, Students> {
  $StudentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get registration => $composableBuilder(
    column: $table.registration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get socialName => $composableBuilder(
    column: $table.socialName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthplace => $composableBuilder(
    column: $table.birthplace,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nationality => $composableBuilder(
    column: $table.nationality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentage =>
      $composableBuilder(column: $table.parentage, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get guardian =>
      $composableBuilder(column: $table.guardian, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get extraJson =>
      $composableBuilder(column: $table.extraJson, builder: (column) => column);

  GeneratedColumn<String> get templateFieldsJson => $composableBuilder(
    column: $table.templateFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $DocumentTemplatesAnnotationComposer get template {
    final $DocumentTemplatesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.documentTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTemplatesAnnotationComposer(
            $db: $db,
            $table: $db.documentTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FoldersAnnotationComposer get folder {
    final $FoldersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folder,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoldersAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> requestsRefs<T extends Object>(
    Expression<T> Function($RequestsAnnotationComposer a) f,
  ) {
    final $RequestsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsAnnotationComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> requirementsRefs<T extends Object>(
    Expression<T> Function($RequirementsAnnotationComposer a) f,
  ) {
    final $RequirementsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requirements,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequirementsAnnotationComposer(
            $db: $db,
            $table: $db.requirements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studentAccessRefs<T extends Object>(
    Expression<T> Function($StudentAccessAnnotationComposer a) f,
  ) {
    final $StudentAccessAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentAccess,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentAccessAnnotationComposer(
            $db: $db,
            $table: $db.studentAccess,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> enrollmentsRefs<T extends Object>(
    Expression<T> Function($EnrollmentsAnnotationComposer a) f,
  ) {
    final $EnrollmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.student,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $StudentsTableManager
    extends
        RootTableManager<
          _$Database,
          Students,
          Student,
          $StudentsFilterComposer,
          $StudentsOrderingComposer,
          $StudentsAnnotationComposer,
          $StudentsCreateCompanionBuilder,
          $StudentsUpdateCompanionBuilder,
          (Student, $StudentsReferences),
          Student,
          PrefetchHooks Function({
            bool template,
            bool folder,
            bool requestsRefs,
            bool requirementsRefs,
            bool studentAccessRefs,
            bool enrollmentsRefs,
          })
        > {
  $StudentsTableManager(_$Database db, Students table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $StudentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $StudentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $StudentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> registration = const Value.absent(),
                Value<String> birthDate = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String> socialName = const Value.absent(),
                Value<String> birthplace = const Value.absent(),
                Value<String> nationality = const Value.absent(),
                Value<String> parentage = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> guardian = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> extraJson = const Value.absent(),
                Value<String?> template = const Value.absent(),
                Value<String> templateFieldsJson = const Value.absent(),
                Value<String> folder = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                name: name,
                registration: registration,
                birthDate: birthDate,
                sex: sex,
                socialName: socialName,
                birthplace: birthplace,
                nationality: nationality,
                parentage: parentage,
                address: address,
                guardian: guardian,
                phone: phone,
                email: email,
                notes: notes,
                extraJson: extraJson,
                template: template,
                templateFieldsJson: templateFieldsJson,
                folder: folder,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> registration = const Value.absent(),
                Value<String> birthDate = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String> socialName = const Value.absent(),
                Value<String> birthplace = const Value.absent(),
                Value<String> nationality = const Value.absent(),
                Value<String> parentage = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> guardian = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> extraJson = const Value.absent(),
                Value<String?> template = const Value.absent(),
                Value<String> templateFieldsJson = const Value.absent(),
                required String folder,
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                name: name,
                registration: registration,
                birthDate: birthDate,
                sex: sex,
                socialName: socialName,
                birthplace: birthplace,
                nationality: nationality,
                parentage: parentage,
                address: address,
                guardian: guardian,
                phone: phone,
                email: email,
                notes: notes,
                extraJson: extraJson,
                template: template,
                templateFieldsJson: templateFieldsJson,
                folder: folder,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Students, Student>(table),
                  $StudentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                template = false,
                folder = false,
                requestsRefs = false,
                requirementsRefs = false,
                studentAccessRefs = false,
                enrollmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (requestsRefs) db.requests,
                    if (requirementsRefs) db.requirements,
                    if (studentAccessRefs) db.studentAccess,
                    if (enrollmentsRefs) db.enrollments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (template) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.template,
                            referencedTable: $StudentsReferences._templateTable(
                              db,
                            ),
                            referencedColumn: $StudentsReferences
                                ._templateTable(db)
                                .id,
                          ) as T;
                        }
                        if (folder) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.folder,
                            referencedTable: $StudentsReferences._folderTable(
                              db,
                            ),
                            referencedColumn: $StudentsReferences
                                ._folderTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (requestsRefs)
                        await $_getPrefetchedDataByColumns<
                          Student,
                          Students,
                          Request,
                          Requests
                        >(
                          currentTable: table,
                          referencedTable: $StudentsReferences
                              ._requestsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $StudentsReferences(db, table, p0).requestsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'student',
                          typedResults: items,
                        ),
                      if (requirementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Student,
                          Students,
                          Requirement,
                          Requirements
                        >(
                          currentTable: table,
                          referencedTable: $StudentsReferences
                              ._requirementsRefsTable(db),
                          managerFromTypedResult: (p0) => $StudentsReferences(
                            db,
                            table,
                            p0,
                          ).requirementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'student',
                          typedResults: items,
                        ),
                      if (studentAccessRefs)
                        await $_getPrefetchedDataByColumns<
                          Student,
                          Students,
                          StudentAccessData,
                          StudentAccess
                        >(
                          currentTable: table,
                          referencedTable: $StudentsReferences
                              ._studentAccessRefsTable(db),
                          managerFromTypedResult: (p0) => $StudentsReferences(
                            db,
                            table,
                            p0,
                          ).studentAccessRefs,
                          currentColumn: 'id',
                          referencedColumn: 'student',
                          typedResults: items,
                        ),
                      if (enrollmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Student,
                          Students,
                          Enrollment,
                          Enrollments
                        >(
                          currentTable: table,
                          referencedTable: $StudentsReferences
                              ._enrollmentsRefsTable(db),
                          managerFromTypedResult: (p0) => $StudentsReferences(
                            db,
                            table,
                            p0,
                          ).enrollmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'student',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $StudentsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Students,
      Student,
      $StudentsFilterComposer,
      $StudentsOrderingComposer,
      $StudentsAnnotationComposer,
      $StudentsCreateCompanionBuilder,
      $StudentsUpdateCompanionBuilder,
      (Student, $StudentsReferences),
      Student,
      PrefetchHooks Function({
        bool template,
        bool folder,
        bool requestsRefs,
        bool requirementsRefs,
        bool studentAccessRefs,
        bool enrollmentsRefs,
      })
    >;
typedef $RequestsCreateCompanionBuilder = RequestsCompanion Function({
  required String id,
  required String protocol,
  required String service,
  required String subject,
  required String description,
  required String requester,
  required String department,
  required String state,
  Value<String> result,
  required String operation,
  Value<String?> student,
  required String created,
  required String updated,
  Value<int> revision,
  Value<int> rowid,
});
typedef $RequestsUpdateCompanionBuilder = RequestsCompanion Function({
  Value<String> id,
  Value<String> protocol,
  Value<String> service,
  Value<String> subject,
  Value<String> description,
  Value<String> requester,
  Value<String> department,
  Value<String> state,
  Value<String> result,
  Value<String> operation,
  Value<String?> student,
  Value<String> created,
  Value<String> updated,
  Value<int> revision,
  Value<int> rowid,
});

final class $RequestsReferences
    extends BaseReferences<_$Database, Requests, Request> {
  $RequestsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _requesterTable(_$Database db) =>
      db.users.createAlias('requests__requester__users__id');

  $UsersProcessedTableManager get requester {
    final $_column = $_itemColumn<String>('requester')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requesterTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Students _studentTable(_$Database db) =>
      db.students.createAlias('requests__student__students__id');

  $StudentsProcessedTableManager? get student {
    final $_column = $_itemColumn<String>('student');
    if ($_column == null) return null;
    final manager = $StudentsTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Events, List<Event>> _eventsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'requests__id__events__request',
  );

  $EventsProcessedTableManager get eventsRefs {
    final manager = $EventsTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.request.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Attachments, List<Attachment>>
  _attachmentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: 'requests__id__attachments__request',
  );

  $AttachmentsProcessedTableManager get attachmentsRefs {
    final manager = $AttachmentsTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.request.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $RequestsFilterComposer extends Composer<_$Database, Requests> {
  $RequestsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get requester {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requester,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $StudentsFilterComposer get student {
    final $StudentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventsRefs(
    Expression<bool> Function($EventsFilterComposer f) f,
  ) {
    final $EventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.request,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EventsFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($AttachmentsFilterComposer f) f,
  ) {
    final $AttachmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.request,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttachmentsFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RequestsOrderingComposer extends Composer<_$Database, Requests> {
  $RequestsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get requester {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requester,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $StudentsOrderingComposer get student {
    final $StudentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $RequestsAnnotationComposer extends Composer<_$Database, Requests> {
  $RequestsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get protocol =>
      $composableBuilder(column: $table.protocol, builder: (column) => column);

  GeneratedColumn<String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $UsersAnnotationComposer get requester {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requester,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $StudentsAnnotationComposer get student {
    final $StudentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($EventsAnnotationComposer a) f,
  ) {
    final $EventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.request,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EventsAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($AttachmentsAnnotationComposer a) f,
  ) {
    final $AttachmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.request,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttachmentsAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RequestsTableManager
    extends
        RootTableManager<
          _$Database,
          Requests,
          Request,
          $RequestsFilterComposer,
          $RequestsOrderingComposer,
          $RequestsAnnotationComposer,
          $RequestsCreateCompanionBuilder,
          $RequestsUpdateCompanionBuilder,
          (Request, $RequestsReferences),
          Request,
          PrefetchHooks Function({
            bool requester,
            bool student,
            bool eventsRefs,
            bool attachmentsRefs,
          })
        > {
  $RequestsTableManager(_$Database db, Requests table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RequestsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RequestsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RequestsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> protocol = const Value.absent(),
                Value<String> service = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> requester = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> student = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequestsCompanion(
                id: id,
                protocol: protocol,
                service: service,
                subject: subject,
                description: description,
                requester: requester,
                department: department,
                state: state,
                result: result,
                operation: operation,
                student: student,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String protocol,
                required String service,
                required String subject,
                required String description,
                required String requester,
                required String department,
                required String state,
                Value<String> result = const Value.absent(),
                required String operation,
                Value<String?> student = const Value.absent(),
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequestsCompanion.insert(
                id: id,
                protocol: protocol,
                service: service,
                subject: subject,
                description: description,
                requester: requester,
                department: department,
                state: state,
                result: result,
                operation: operation,
                student: student,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Requests, Request>(table),
                  $RequestsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                requester = false,
                student = false,
                eventsRefs = false,
                attachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (eventsRefs) db.events,
                    if (attachmentsRefs) db.attachments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (requester) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.requester,
                            referencedTable: $RequestsReferences
                                ._requesterTable(db),
                            referencedColumn: $RequestsReferences
                                ._requesterTable(db)
                                .id,
                          ) as T;
                        }
                        if (student) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.student,
                            referencedTable: $RequestsReferences._studentTable(
                              db,
                            ),
                            referencedColumn: $RequestsReferences
                                ._studentTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Request,
                          Requests,
                          Event,
                          Events
                        >(
                          currentTable: table,
                          referencedTable: $RequestsReferences._eventsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $RequestsReferences(db, table, p0).eventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'request',
                          typedResults: items,
                        ),
                      if (attachmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Request,
                          Requests,
                          Attachment,
                          Attachments
                        >(
                          currentTable: table,
                          referencedTable: $RequestsReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) => $RequestsReferences(
                            db,
                            table,
                            p0,
                          ).attachmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'request',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $RequestsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Requests,
      Request,
      $RequestsFilterComposer,
      $RequestsOrderingComposer,
      $RequestsAnnotationComposer,
      $RequestsCreateCompanionBuilder,
      $RequestsUpdateCompanionBuilder,
      (Request, $RequestsReferences),
      Request,
      PrefetchHooks Function({
        bool requester,
        bool student,
        bool eventsRefs,
        bool attachmentsRefs,
      })
    >;
typedef $EventsCreateCompanionBuilder = EventsCompanion Function({
  required String id,
  required String request,
  required String actor,
  required String text$,
  required String created,
  Value<int> rowid,
});
typedef $EventsUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  Value<String> request,
  Value<String> actor,
  Value<String> text$,
  Value<String> created,
  Value<int> rowid,
});

final class $EventsReferences
    extends BaseReferences<_$Database, Events, Event> {
  $EventsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Requests _requestTable(_$Database db) =>
      db.requests.createAlias('events__request__requests__id');

  $RequestsProcessedTableManager get request {
    final $_column = $_itemColumn<String>('request')!;

    final manager = $RequestsTableManager(
      $_db,
      $_db.requests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requestTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _actorTable(_$Database db) =>
      db.users.createAlias('events__actor__users__id');

  $UsersProcessedTableManager get actor {
    final $_column = $_itemColumn<String>('actor')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $EventsFilterComposer extends Composer<_$Database, Events> {
  $EventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  $RequestsFilterComposer get request {
    final $RequestsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.request,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsFilterComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get actor {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EventsOrderingComposer extends Composer<_$Database, Events> {
  $EventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text$ => $composableBuilder(
    column: $table.text$,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  $RequestsOrderingComposer get request {
    final $RequestsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.request,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsOrderingComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get actor {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EventsAnnotationComposer extends Composer<_$Database, Events> {
  $EventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get text$ =>
      $composableBuilder(column: $table.text$, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  $RequestsAnnotationComposer get request {
    final $RequestsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.request,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsAnnotationComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get actor {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EventsTableManager
    extends
        RootTableManager<
          _$Database,
          Events,
          Event,
          $EventsFilterComposer,
          $EventsOrderingComposer,
          $EventsAnnotationComposer,
          $EventsCreateCompanionBuilder,
          $EventsUpdateCompanionBuilder,
          (Event, $EventsReferences),
          Event,
          PrefetchHooks Function({bool request, bool actor})
        > {
  $EventsTableManager(_$Database db, Events table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> request = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String> text$ = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                request: request,
                actor: actor,
                text$: text$,
                created: created,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String request,
                required String actor,
                required String text$,
                required String created,
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                request: request,
                actor: actor,
                text$: text$,
                created: created,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Events, Event>(table),
                  $EventsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({request = false, actor = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (request) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.request,
                        referencedTable: $EventsReferences._requestTable(db),
                        referencedColumn: $EventsReferences
                            ._requestTable(db)
                            .id,
                      ) as T;
                    }
                    if (actor) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.actor,
                        referencedTable: $EventsReferences._actorTable(db),
                        referencedColumn: $EventsReferences._actorTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $EventsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Events,
      Event,
      $EventsFilterComposer,
      $EventsOrderingComposer,
      $EventsAnnotationComposer,
      $EventsCreateCompanionBuilder,
      $EventsUpdateCompanionBuilder,
      (Event, $EventsReferences),
      Event,
      PrefetchHooks Function({bool request, bool actor})
    >;
typedef $AttachmentsCreateCompanionBuilder = AttachmentsCompanion Function({
  required String request,
  required String document,
  Value<int> rowid,
});
typedef $AttachmentsUpdateCompanionBuilder = AttachmentsCompanion Function({
  Value<String> request,
  Value<String> document,
  Value<int> rowid,
});

final class $AttachmentsReferences
    extends BaseReferences<_$Database, Attachments, Attachment> {
  $AttachmentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Requests _requestTable(_$Database db) =>
      db.requests.createAlias('attachments__request__requests__id');

  $RequestsProcessedTableManager get request {
    final $_column = $_itemColumn<String>('request')!;

    final manager = $RequestsTableManager(
      $_db,
      $_db.requests,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requestTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Documents _documentTable(_$Database db) =>
      db.documents.createAlias('attachments__document__documents__id');

  $DocumentsProcessedTableManager get document {
    final $_column = $_itemColumn<String>('document')!;

    final manager = $DocumentsTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AttachmentsFilterComposer extends Composer<_$Database, Attachments> {
  $AttachmentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $RequestsFilterComposer get request {
    final $RequestsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.request,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsFilterComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DocumentsFilterComposer get document {
    final $DocumentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.document,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AttachmentsOrderingComposer extends Composer<_$Database, Attachments> {
  $AttachmentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $RequestsOrderingComposer get request {
    final $RequestsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.request,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsOrderingComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DocumentsOrderingComposer get document {
    final $DocumentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.document,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AttachmentsAnnotationComposer extends Composer<_$Database, Attachments> {
  $AttachmentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $RequestsAnnotationComposer get request {
    final $RequestsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.request,
      referencedTable: $db.requests,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RequestsAnnotationComposer(
            $db: $db,
            $table: $db.requests,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DocumentsAnnotationComposer get document {
    final $DocumentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.document,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AttachmentsTableManager
    extends
        RootTableManager<
          _$Database,
          Attachments,
          Attachment,
          $AttachmentsFilterComposer,
          $AttachmentsOrderingComposer,
          $AttachmentsAnnotationComposer,
          $AttachmentsCreateCompanionBuilder,
          $AttachmentsUpdateCompanionBuilder,
          (Attachment, $AttachmentsReferences),
          Attachment,
          PrefetchHooks Function({bool request, bool document})
        > {
  $AttachmentsTableManager(_$Database db, Attachments table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AttachmentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AttachmentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AttachmentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> request = const Value.absent(),
                Value<String> document = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                request: request,
                document: document,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String request,
                required String document,
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                request: request,
                document: document,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Attachments, Attachment>(table),
                  $AttachmentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({request = false, document = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (request) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.request,
                        referencedTable: $AttachmentsReferences._requestTable(
                          db,
                        ),
                        referencedColumn: $AttachmentsReferences
                            ._requestTable(db)
                            .id,
                      ) as T;
                    }
                    if (document) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.document,
                        referencedTable: $AttachmentsReferences._documentTable(
                          db,
                        ),
                        referencedColumn: $AttachmentsReferences
                            ._documentTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AttachmentsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Attachments,
      Attachment,
      $AttachmentsFilterComposer,
      $AttachmentsOrderingComposer,
      $AttachmentsAnnotationComposer,
      $AttachmentsCreateCompanionBuilder,
      $AttachmentsUpdateCompanionBuilder,
      (Attachment, $AttachmentsReferences),
      Attachment,
      PrefetchHooks Function({bool request, bool document})
    >;
typedef $RequirementsCreateCompanionBuilder = RequirementsCompanion Function({
  required String id,
  required String student,
  required String type,
  Value<int> rowid,
});
typedef $RequirementsUpdateCompanionBuilder = RequirementsCompanion Function({
  Value<String> id,
  Value<String> student,
  Value<String> type,
  Value<int> rowid,
});

final class $RequirementsReferences
    extends BaseReferences<_$Database, Requirements, Requirement> {
  $RequirementsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Students _studentTable(_$Database db) =>
      db.students.createAlias('requirements__student__students__id');

  $StudentsProcessedTableManager get student {
    final $_column = $_itemColumn<String>('student')!;

    final manager = $StudentsTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $RequirementsFilterComposer extends Composer<_$Database, Requirements> {
  $RequirementsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $StudentsFilterComposer get student {
    final $StudentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $RequirementsOrderingComposer extends Composer<_$Database, Requirements> {
  $RequirementsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $StudentsOrderingComposer get student {
    final $StudentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $RequirementsAnnotationComposer
    extends Composer<_$Database, Requirements> {
  $RequirementsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $StudentsAnnotationComposer get student {
    final $StudentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $RequirementsTableManager
    extends
        RootTableManager<
          _$Database,
          Requirements,
          Requirement,
          $RequirementsFilterComposer,
          $RequirementsOrderingComposer,
          $RequirementsAnnotationComposer,
          $RequirementsCreateCompanionBuilder,
          $RequirementsUpdateCompanionBuilder,
          (Requirement, $RequirementsReferences),
          Requirement,
          PrefetchHooks Function({bool student})
        > {
  $RequirementsTableManager(_$Database db, Requirements table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RequirementsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RequirementsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RequirementsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> student = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequirementsCompanion(
                id: id,
                student: student,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String student,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => RequirementsCompanion.insert(
                id: id,
                student: student,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Requirements, Requirement>(table),
                  $RequirementsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({student = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (student) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.student,
                        referencedTable: $RequirementsReferences._studentTable(
                          db,
                        ),
                        referencedColumn: $RequirementsReferences
                            ._studentTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $RequirementsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Requirements,
      Requirement,
      $RequirementsFilterComposer,
      $RequirementsOrderingComposer,
      $RequirementsAnnotationComposer,
      $RequirementsCreateCompanionBuilder,
      $RequirementsUpdateCompanionBuilder,
      (Requirement, $RequirementsReferences),
      Requirement,
      PrefetchHooks Function({bool student})
    >;
typedef $CredentialsCreateCompanionBuilder = CredentialsCompanion Function({
  required String user,
  required String login,
  required String salt,
  required String passwordHash,
  Value<int> enabled,
  Value<int> revision,
  Value<int> rowid,
});
typedef $CredentialsUpdateCompanionBuilder = CredentialsCompanion Function({
  Value<String> user,
  Value<String> login,
  Value<String> salt,
  Value<String> passwordHash,
  Value<int> enabled,
  Value<int> revision,
  Value<int> rowid,
});

final class $CredentialsReferences
    extends BaseReferences<_$Database, Credentials, Credential> {
  $CredentialsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userTable(_$Database db) =>
      db.users.createAlias('credentials__user__users__id');

  $UsersProcessedTableManager get user {
    final $_column = $_itemColumn<String>('user')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $CredentialsFilterComposer extends Composer<_$Database, Credentials> {
  $CredentialsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get login => $composableBuilder(
    column: $table.login,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get user {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CredentialsOrderingComposer extends Composer<_$Database, Credentials> {
  $CredentialsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get login => $composableBuilder(
    column: $table.login,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get user {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CredentialsAnnotationComposer extends Composer<_$Database, Credentials> {
  $CredentialsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get login =>
      $composableBuilder(column: $table.login, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $UsersAnnotationComposer get user {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CredentialsTableManager
    extends
        RootTableManager<
          _$Database,
          Credentials,
          Credential,
          $CredentialsFilterComposer,
          $CredentialsOrderingComposer,
          $CredentialsAnnotationComposer,
          $CredentialsCreateCompanionBuilder,
          $CredentialsUpdateCompanionBuilder,
          (Credential, $CredentialsReferences),
          Credential,
          PrefetchHooks Function({bool user})
        > {
  $CredentialsTableManager(_$Database db, Credentials table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CredentialsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CredentialsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CredentialsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> user = const Value.absent(),
                Value<String> login = const Value.absent(),
                Value<String> salt = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<int> enabled = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CredentialsCompanion(
                user: user,
                login: login,
                salt: salt,
                passwordHash: passwordHash,
                enabled: enabled,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String user,
                required String login,
                required String salt,
                required String passwordHash,
                Value<int> enabled = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CredentialsCompanion.insert(
                user: user,
                login: login,
                salt: salt,
                passwordHash: passwordHash,
                enabled: enabled,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Credentials, Credential>(table),
                  $CredentialsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({user = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (user) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.user,
                        referencedTable: $CredentialsReferences._userTable(db),
                        referencedColumn: $CredentialsReferences
                            ._userTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $CredentialsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Credentials,
      Credential,
      $CredentialsFilterComposer,
      $CredentialsOrderingComposer,
      $CredentialsAnnotationComposer,
      $CredentialsCreateCompanionBuilder,
      $CredentialsUpdateCompanionBuilder,
      (Credential, $CredentialsReferences),
      Credential,
      PrefetchHooks Function({bool user})
    >;
typedef $SessionsCreateCompanionBuilder = SessionsCompanion Function({
  required String tokenHash,
  required String user,
  required String expires,
  Value<int> rowid,
});
typedef $SessionsUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> tokenHash,
  Value<String> user,
  Value<String> expires,
  Value<int> rowid,
});

final class $SessionsReferences
    extends BaseReferences<_$Database, Sessions, Session> {
  $SessionsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userTable(_$Database db) =>
      db.users.createAlias('sessions__user__users__id');

  $UsersProcessedTableManager get user {
    final $_column = $_itemColumn<String>('user')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $SessionsFilterComposer extends Composer<_$Database, Sessions> {
  $SessionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expires => $composableBuilder(
    column: $table.expires,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get user {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SessionsOrderingComposer extends Composer<_$Database, Sessions> {
  $SessionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expires => $composableBuilder(
    column: $table.expires,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get user {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SessionsAnnotationComposer extends Composer<_$Database, Sessions> {
  $SessionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<String> get expires =>
      $composableBuilder(column: $table.expires, builder: (column) => column);

  $UsersAnnotationComposer get user {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SessionsTableManager
    extends
        RootTableManager<
          _$Database,
          Sessions,
          Session,
          $SessionsFilterComposer,
          $SessionsOrderingComposer,
          $SessionsAnnotationComposer,
          $SessionsCreateCompanionBuilder,
          $SessionsUpdateCompanionBuilder,
          (Session, $SessionsReferences),
          Session,
          PrefetchHooks Function({bool user})
        > {
  $SessionsTableManager(_$Database db, Sessions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SessionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SessionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SessionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tokenHash = const Value.absent(),
                Value<String> user = const Value.absent(),
                Value<String> expires = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                tokenHash: tokenHash,
                user: user,
                expires: expires,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tokenHash,
                required String user,
                required String expires,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                tokenHash: tokenHash,
                user: user,
                expires: expires,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Sessions, Session>(table),
                  $SessionsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({user = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (user) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.user,
                        referencedTable: $SessionsReferences._userTable(db),
                        referencedColumn: $SessionsReferences._userTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $SessionsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Sessions,
      Session,
      $SessionsFilterComposer,
      $SessionsOrderingComposer,
      $SessionsAnnotationComposer,
      $SessionsCreateCompanionBuilder,
      $SessionsUpdateCompanionBuilder,
      (Session, $SessionsReferences),
      Session,
      PrefetchHooks Function({bool user})
    >;
typedef $StudentAccessCreateCompanionBuilder = StudentAccessCompanion Function({
  required String student,
  required String user,
  Value<int> rowid,
});
typedef $StudentAccessUpdateCompanionBuilder = StudentAccessCompanion Function({
  Value<String> student,
  Value<String> user,
  Value<int> rowid,
});

final class $StudentAccessReferences
    extends BaseReferences<_$Database, StudentAccess, StudentAccessData> {
  $StudentAccessReferences(super.$_db, super.$_table, super.$_typedResult);

  static Students _studentTable(_$Database db) =>
      db.students.createAlias('student_access__student__students__id');

  $StudentsProcessedTableManager get student {
    final $_column = $_itemColumn<String>('student')!;

    final manager = $StudentsTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _userTable(_$Database db) =>
      db.users.createAlias('student_access__user__users__id');

  $UsersProcessedTableManager get user {
    final $_column = $_itemColumn<String>('user')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $StudentAccessFilterComposer extends Composer<_$Database, StudentAccess> {
  $StudentAccessFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $StudentsFilterComposer get student {
    final $StudentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get user {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $StudentAccessOrderingComposer
    extends Composer<_$Database, StudentAccess> {
  $StudentAccessOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $StudentsOrderingComposer get student {
    final $StudentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get user {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $StudentAccessAnnotationComposer
    extends Composer<_$Database, StudentAccess> {
  $StudentAccessAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $StudentsAnnotationComposer get student {
    final $StudentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get user {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $StudentAccessTableManager
    extends
        RootTableManager<
          _$Database,
          StudentAccess,
          StudentAccessData,
          $StudentAccessFilterComposer,
          $StudentAccessOrderingComposer,
          $StudentAccessAnnotationComposer,
          $StudentAccessCreateCompanionBuilder,
          $StudentAccessUpdateCompanionBuilder,
          (StudentAccessData, $StudentAccessReferences),
          StudentAccessData,
          PrefetchHooks Function({bool student, bool user})
        > {
  $StudentAccessTableManager(_$Database db, StudentAccess table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $StudentAccessFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $StudentAccessOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $StudentAccessAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> student = const Value.absent(),
                Value<String> user = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentAccessCompanion(
                student: student,
                user: user,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String student,
                required String user,
                Value<int> rowid = const Value.absent(),
              }) => StudentAccessCompanion.insert(
                student: student,
                user: user,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<StudentAccess, StudentAccessData>(table),
                  $StudentAccessReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({student = false, user = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (student) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.student,
                        referencedTable: $StudentAccessReferences._studentTable(
                          db,
                        ),
                        referencedColumn: $StudentAccessReferences
                            ._studentTable(db)
                            .id,
                      ) as T;
                    }
                    if (user) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.user,
                        referencedTable: $StudentAccessReferences._userTable(
                          db,
                        ),
                        referencedColumn: $StudentAccessReferences
                            ._userTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $StudentAccessProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      StudentAccess,
      StudentAccessData,
      $StudentAccessFilterComposer,
      $StudentAccessOrderingComposer,
      $StudentAccessAnnotationComposer,
      $StudentAccessCreateCompanionBuilder,
      $StudentAccessUpdateCompanionBuilder,
      (StudentAccessData, $StudentAccessReferences),
      StudentAccessData,
      PrefetchHooks Function({bool student, bool user})
    >;
typedef $CoursesCreateCompanionBuilder = CoursesCompanion Function({
  required String id,
  required String name,
  required String modality,
  Value<String> durationLabel,
  Value<String?> template,
  Value<int> archived,
  Value<int> revision,
  Value<int> rowid,
});
typedef $CoursesUpdateCompanionBuilder = CoursesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> modality,
  Value<String> durationLabel,
  Value<String?> template,
  Value<int> archived,
  Value<int> revision,
  Value<int> rowid,
});

final class $CoursesReferences
    extends BaseReferences<_$Database, Courses, Course> {
  $CoursesReferences(super.$_db, super.$_table, super.$_typedResult);

  static DocumentTemplates _templateTable(_$Database db) => db.documentTemplates
      .createAlias('courses__template__document_templates__id');

  $DocumentTemplatesProcessedTableManager? get template {
    final $_column = $_itemColumn<String>('template');
    if ($_column == null) return null;
    final manager = $DocumentTemplatesTableManager(
      $_db,
      $_db.documentTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<ClassGroups, List<ClassGroup>>
  _classGroupsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.classGroups,
    aliasName: 'courses__id__class_groups__course',
  );

  $ClassGroupsProcessedTableManager get classGroupsRefs {
    final manager = $ClassGroupsTableManager(
      $_db,
      $_db.classGroups,
    ).filter((f) => f.course.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_classGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Enrollments, List<Enrollment>>
  _enrollmentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.enrollments,
    aliasName: 'courses__id__enrollments__course',
  );

  $EnrollmentsProcessedTableManager get enrollmentsRefs {
    final manager = $EnrollmentsTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.course.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_enrollmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CourseComponents, List<CourseComponent>>
  _courseComponentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.courseComponents,
    aliasName: 'courses__id__course_components__course',
  );

  $CourseComponentsProcessedTableManager get courseComponentsRefs {
    final manager = $CourseComponentsTableManager(
      $_db,
      $_db.courseComponents,
    ).filter((f) => f.course.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _courseComponentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CoursesFilterComposer extends Composer<_$Database, Courses> {
  $CoursesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durationLabel => $composableBuilder(
    column: $table.durationLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $DocumentTemplatesFilterComposer get template {
    final $DocumentTemplatesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.documentTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTemplatesFilterComposer(
            $db: $db,
            $table: $db.documentTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> classGroupsRefs(
    Expression<bool> Function($ClassGroupsFilterComposer f) f,
  ) {
    final $ClassGroupsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.course,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsFilterComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> enrollmentsRefs(
    Expression<bool> Function($EnrollmentsFilterComposer f) f,
  ) {
    final $EnrollmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.course,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> courseComponentsRefs(
    Expression<bool> Function($CourseComponentsFilterComposer f) f,
  ) {
    final $CourseComponentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.course,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsFilterComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CoursesOrderingComposer extends Composer<_$Database, Courses> {
  $CoursesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durationLabel => $composableBuilder(
    column: $table.durationLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $DocumentTemplatesOrderingComposer get template {
    final $DocumentTemplatesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.documentTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTemplatesOrderingComposer(
            $db: $db,
            $table: $db.documentTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CoursesAnnotationComposer extends Composer<_$Database, Courses> {
  $CoursesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get modality =>
      $composableBuilder(column: $table.modality, builder: (column) => column);

  GeneratedColumn<String> get durationLabel => $composableBuilder(
    column: $table.durationLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $DocumentTemplatesAnnotationComposer get template {
    final $DocumentTemplatesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.template,
      referencedTable: $db.documentTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentTemplatesAnnotationComposer(
            $db: $db,
            $table: $db.documentTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> classGroupsRefs<T extends Object>(
    Expression<T> Function($ClassGroupsAnnotationComposer a) f,
  ) {
    final $ClassGroupsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.course,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsAnnotationComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> enrollmentsRefs<T extends Object>(
    Expression<T> Function($EnrollmentsAnnotationComposer a) f,
  ) {
    final $EnrollmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.course,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> courseComponentsRefs<T extends Object>(
    Expression<T> Function($CourseComponentsAnnotationComposer a) f,
  ) {
    final $CourseComponentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.course,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsAnnotationComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CoursesTableManager
    extends
        RootTableManager<
          _$Database,
          Courses,
          Course,
          $CoursesFilterComposer,
          $CoursesOrderingComposer,
          $CoursesAnnotationComposer,
          $CoursesCreateCompanionBuilder,
          $CoursesUpdateCompanionBuilder,
          (Course, $CoursesReferences),
          Course,
          PrefetchHooks Function({
            bool template,
            bool classGroupsRefs,
            bool enrollmentsRefs,
            bool courseComponentsRefs,
          })
        > {
  $CoursesTableManager(_$Database db, Courses table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CoursesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CoursesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CoursesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> modality = const Value.absent(),
                Value<String> durationLabel = const Value.absent(),
                Value<String?> template = const Value.absent(),
                Value<int> archived = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesCompanion(
                id: id,
                name: name,
                modality: modality,
                durationLabel: durationLabel,
                template: template,
                archived: archived,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String modality,
                Value<String> durationLabel = const Value.absent(),
                Value<String?> template = const Value.absent(),
                Value<int> archived = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesCompanion.insert(
                id: id,
                name: name,
                modality: modality,
                durationLabel: durationLabel,
                template: template,
                archived: archived,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Courses, Course>(table),
                  $CoursesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                template = false,
                classGroupsRefs = false,
                enrollmentsRefs = false,
                courseComponentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (classGroupsRefs) db.classGroups,
                    if (enrollmentsRefs) db.enrollments,
                    if (courseComponentsRefs) db.courseComponents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (template) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.template,
                            referencedTable: $CoursesReferences._templateTable(
                              db,
                            ),
                            referencedColumn: $CoursesReferences
                                ._templateTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (classGroupsRefs)
                        await $_getPrefetchedDataByColumns<
                          Course,
                          Courses,
                          ClassGroup,
                          ClassGroups
                        >(
                          currentTable: table,
                          referencedTable: $CoursesReferences
                              ._classGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CoursesReferences(db, table, p0).classGroupsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'course',
                          typedResults: items,
                        ),
                      if (enrollmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Course,
                          Courses,
                          Enrollment,
                          Enrollments
                        >(
                          currentTable: table,
                          referencedTable: $CoursesReferences
                              ._enrollmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CoursesReferences(db, table, p0).enrollmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'course',
                          typedResults: items,
                        ),
                      if (courseComponentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Course,
                          Courses,
                          CourseComponent,
                          CourseComponents
                        >(
                          currentTable: table,
                          referencedTable: $CoursesReferences
                              ._courseComponentsRefsTable(db),
                          managerFromTypedResult: (p0) => $CoursesReferences(
                            db,
                            table,
                            p0,
                          ).courseComponentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'course',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CoursesProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Courses,
      Course,
      $CoursesFilterComposer,
      $CoursesOrderingComposer,
      $CoursesAnnotationComposer,
      $CoursesCreateCompanionBuilder,
      $CoursesUpdateCompanionBuilder,
      (Course, $CoursesReferences),
      Course,
      PrefetchHooks Function({
        bool template,
        bool classGroupsRefs,
        bool enrollmentsRefs,
        bool courseComponentsRefs,
      })
    >;
typedef $ClassGroupsCreateCompanionBuilder = ClassGroupsCompanion Function({
  required String id,
  required String course,
  required String name,
  required int schoolYear,
  required String periodLabel,
  required String grade,
  required String shift,
  required int capacity,
  Value<int> archived,
  required String created,
  required String updated,
  Value<int> revision,
  Value<int> rowid,
});
typedef $ClassGroupsUpdateCompanionBuilder = ClassGroupsCompanion Function({
  Value<String> id,
  Value<String> course,
  Value<String> name,
  Value<int> schoolYear,
  Value<String> periodLabel,
  Value<String> grade,
  Value<String> shift,
  Value<int> capacity,
  Value<int> archived,
  Value<String> created,
  Value<String> updated,
  Value<int> revision,
  Value<int> rowid,
});

final class $ClassGroupsReferences
    extends BaseReferences<_$Database, ClassGroups, ClassGroup> {
  $ClassGroupsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Courses _courseTable(_$Database db) =>
      db.courses.createAlias('class_groups__course__courses__id');

  $CoursesProcessedTableManager get course {
    final $_column = $_itemColumn<String>('course')!;

    final manager = $CoursesTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Enrollments, List<Enrollment>>
  _enrollmentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.enrollments,
    aliasName: 'class_groups__id__enrollments__class_group',
  );

  $EnrollmentsProcessedTableManager get enrollmentsRefs {
    final manager = $EnrollmentsTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.classGroup.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_enrollmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Journals, List<Journal>> _journalsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.journals,
    aliasName: 'class_groups__id__journals__class_group',
  );

  $JournalsProcessedTableManager get journalsRefs {
    final manager = $JournalsTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.classGroup.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ClassGroupsFilterComposer extends Composer<_$Database, ClassGroups> {
  $ClassGroupsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodLabel => $composableBuilder(
    column: $table.periodLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $CoursesFilterComposer get course {
    final $CoursesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> enrollmentsRefs(
    Expression<bool> Function($EnrollmentsFilterComposer f) f,
  ) {
    final $EnrollmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.classGroup,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalsRefs(
    Expression<bool> Function($JournalsFilterComposer f) f,
  ) {
    final $JournalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.classGroup,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ClassGroupsOrderingComposer extends Composer<_$Database, ClassGroups> {
  $ClassGroupsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodLabel => $composableBuilder(
    column: $table.periodLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $CoursesOrderingComposer get course {
    final $CoursesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ClassGroupsAnnotationComposer extends Composer<_$Database, ClassGroups> {
  $ClassGroupsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get periodLabel => $composableBuilder(
    column: $table.periodLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<int> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $CoursesAnnotationComposer get course {
    final $CoursesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> enrollmentsRefs<T extends Object>(
    Expression<T> Function($EnrollmentsAnnotationComposer a) f,
  ) {
    final $EnrollmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.classGroup,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalsRefs<T extends Object>(
    Expression<T> Function($JournalsAnnotationComposer a) f,
  ) {
    final $JournalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.classGroup,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ClassGroupsTableManager
    extends
        RootTableManager<
          _$Database,
          ClassGroups,
          ClassGroup,
          $ClassGroupsFilterComposer,
          $ClassGroupsOrderingComposer,
          $ClassGroupsAnnotationComposer,
          $ClassGroupsCreateCompanionBuilder,
          $ClassGroupsUpdateCompanionBuilder,
          (ClassGroup, $ClassGroupsReferences),
          ClassGroup,
          PrefetchHooks Function({
            bool course,
            bool enrollmentsRefs,
            bool journalsRefs,
          })
        > {
  $ClassGroupsTableManager(_$Database db, ClassGroups table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ClassGroupsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ClassGroupsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ClassGroupsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> course = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> schoolYear = const Value.absent(),
                Value<String> periodLabel = const Value.absent(),
                Value<String> grade = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<int> capacity = const Value.absent(),
                Value<int> archived = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassGroupsCompanion(
                id: id,
                course: course,
                name: name,
                schoolYear: schoolYear,
                periodLabel: periodLabel,
                grade: grade,
                shift: shift,
                capacity: capacity,
                archived: archived,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String course,
                required String name,
                required int schoolYear,
                required String periodLabel,
                required String grade,
                required String shift,
                required int capacity,
                Value<int> archived = const Value.absent(),
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassGroupsCompanion.insert(
                id: id,
                course: course,
                name: name,
                schoolYear: schoolYear,
                periodLabel: periodLabel,
                grade: grade,
                shift: shift,
                capacity: capacity,
                archived: archived,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ClassGroups, ClassGroup>(table),
                  $ClassGroupsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                course = false,
                enrollmentsRefs = false,
                journalsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (enrollmentsRefs) db.enrollments,
                    if (journalsRefs) db.journals,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (course) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.course,
                            referencedTable: $ClassGroupsReferences
                                ._courseTable(db),
                            referencedColumn: $ClassGroupsReferences
                                ._courseTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (enrollmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          ClassGroup,
                          ClassGroups,
                          Enrollment,
                          Enrollments
                        >(
                          currentTable: table,
                          referencedTable: $ClassGroupsReferences
                              ._enrollmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ClassGroupsReferences(
                                db,
                                table,
                                p0,
                              ).enrollmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'class_group',
                          typedResults: items,
                        ),
                      if (journalsRefs)
                        await $_getPrefetchedDataByColumns<
                          ClassGroup,
                          ClassGroups,
                          Journal,
                          Journals
                        >(
                          currentTable: table,
                          referencedTable: $ClassGroupsReferences
                              ._journalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $ClassGroupsReferences(
                                db,
                                table,
                                p0,
                              ).journalsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'class_group',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $ClassGroupsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      ClassGroups,
      ClassGroup,
      $ClassGroupsFilterComposer,
      $ClassGroupsOrderingComposer,
      $ClassGroupsAnnotationComposer,
      $ClassGroupsCreateCompanionBuilder,
      $ClassGroupsUpdateCompanionBuilder,
      (ClassGroup, $ClassGroupsReferences),
      ClassGroup,
      PrefetchHooks Function({
        bool course,
        bool enrollmentsRefs,
        bool journalsRefs,
      })
    >;
typedef $EnrollmentsCreateCompanionBuilder = EnrollmentsCompanion Function({
  required String id,
  required String student,
  required String classGroup,
  required String course,
  required int schoolYear,
  required String periodLabel,
  required String state,
  required String created,
  required String updated,
  Value<int> revision,
  Value<int> rowid,
});
typedef $EnrollmentsUpdateCompanionBuilder = EnrollmentsCompanion Function({
  Value<String> id,
  Value<String> student,
  Value<String> classGroup,
  Value<String> course,
  Value<int> schoolYear,
  Value<String> periodLabel,
  Value<String> state,
  Value<String> created,
  Value<String> updated,
  Value<int> revision,
  Value<int> rowid,
});

final class $EnrollmentsReferences
    extends BaseReferences<_$Database, Enrollments, Enrollment> {
  $EnrollmentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Students _studentTable(_$Database db) =>
      db.students.createAlias('enrollments__student__students__id');

  $StudentsProcessedTableManager get student {
    final $_column = $_itemColumn<String>('student')!;

    final manager = $StudentsTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static ClassGroups _classGroupTable(_$Database db) =>
      db.classGroups.createAlias('enrollments__class_group__class_groups__id');

  $ClassGroupsProcessedTableManager get classGroup {
    final $_column = $_itemColumn<String>('class_group')!;

    final manager = $ClassGroupsTableManager(
      $_db,
      $_db.classGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classGroupTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Courses _courseTable(_$Database db) =>
      db.courses.createAlias('enrollments__course__courses__id');

  $CoursesProcessedTableManager get course {
    final $_column = $_itemColumn<String>('course')!;

    final manager = $CoursesTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<EnrollmentEvents, List<EnrollmentEvent>>
  _enrollmentEventsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.enrollmentEvents,
    aliasName: 'enrollments__id__enrollment_events__enrollment',
  );

  $EnrollmentEventsProcessedTableManager get enrollmentEventsRefs {
    final manager = $EnrollmentEventsTableManager(
      $_db,
      $_db.enrollmentEvents,
    ).filter((f) => f.enrollment.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _enrollmentEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Attendance, List<AttendanceData>>
  _attendanceRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: 'enrollments__id__attendance__enrollment',
  );

  $AttendanceProcessedTableManager get attendanceRefs {
    final manager = $AttendanceTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.enrollment.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Grades, List<Grade>> _gradesRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.grades,
    aliasName: 'enrollments__id__grades__enrollment',
  );

  $GradesProcessedTableManager get gradesRefs {
    final manager = $GradesTableManager(
      $_db,
      $_db.grades,
    ).filter((f) => f.enrollment.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gradesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $EnrollmentsFilterComposer extends Composer<_$Database, Enrollments> {
  $EnrollmentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodLabel => $composableBuilder(
    column: $table.periodLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $StudentsFilterComposer get student {
    final $StudentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ClassGroupsFilterComposer get classGroup {
    final $ClassGroupsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classGroup,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsFilterComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CoursesFilterComposer get course {
    final $CoursesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> enrollmentEventsRefs(
    Expression<bool> Function($EnrollmentEventsFilterComposer f) f,
  ) {
    final $EnrollmentEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollmentEvents,
      getReferencedColumn: (t) => t.enrollment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentEventsFilterComposer(
            $db: $db,
            $table: $db.enrollmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($AttendanceFilterComposer f) f,
  ) {
    final $AttendanceFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.enrollment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttendanceFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gradesRefs(
    Expression<bool> Function($GradesFilterComposer f) f,
  ) {
    final $GradesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grades,
      getReferencedColumn: (t) => t.enrollment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $GradesFilterComposer(
            $db: $db,
            $table: $db.grades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $EnrollmentsOrderingComposer extends Composer<_$Database, Enrollments> {
  $EnrollmentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodLabel => $composableBuilder(
    column: $table.periodLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $StudentsOrderingComposer get student {
    final $StudentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ClassGroupsOrderingComposer get classGroup {
    final $ClassGroupsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classGroup,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsOrderingComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CoursesOrderingComposer get course {
    final $CoursesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnrollmentsAnnotationComposer extends Composer<_$Database, Enrollments> {
  $EnrollmentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get periodLabel => $composableBuilder(
    column: $table.periodLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $StudentsAnnotationComposer get student {
    final $StudentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.student,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $StudentsAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ClassGroupsAnnotationComposer get classGroup {
    final $ClassGroupsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classGroup,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsAnnotationComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CoursesAnnotationComposer get course {
    final $CoursesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> enrollmentEventsRefs<T extends Object>(
    Expression<T> Function($EnrollmentEventsAnnotationComposer a) f,
  ) {
    final $EnrollmentEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollmentEvents,
      getReferencedColumn: (t) => t.enrollment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentEventsAnnotationComposer(
            $db: $db,
            $table: $db.enrollmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($AttendanceAnnotationComposer a) f,
  ) {
    final $AttendanceAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.enrollment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttendanceAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gradesRefs<T extends Object>(
    Expression<T> Function($GradesAnnotationComposer a) f,
  ) {
    final $GradesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grades,
      getReferencedColumn: (t) => t.enrollment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $GradesAnnotationComposer(
            $db: $db,
            $table: $db.grades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $EnrollmentsTableManager
    extends
        RootTableManager<
          _$Database,
          Enrollments,
          Enrollment,
          $EnrollmentsFilterComposer,
          $EnrollmentsOrderingComposer,
          $EnrollmentsAnnotationComposer,
          $EnrollmentsCreateCompanionBuilder,
          $EnrollmentsUpdateCompanionBuilder,
          (Enrollment, $EnrollmentsReferences),
          Enrollment,
          PrefetchHooks Function({
            bool student,
            bool classGroup,
            bool course,
            bool enrollmentEventsRefs,
            bool attendanceRefs,
            bool gradesRefs,
          })
        > {
  $EnrollmentsTableManager(_$Database db, Enrollments table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EnrollmentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EnrollmentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EnrollmentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> student = const Value.absent(),
                Value<String> classGroup = const Value.absent(),
                Value<String> course = const Value.absent(),
                Value<int> schoolYear = const Value.absent(),
                Value<String> periodLabel = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentsCompanion(
                id: id,
                student: student,
                classGroup: classGroup,
                course: course,
                schoolYear: schoolYear,
                periodLabel: periodLabel,
                state: state,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String student,
                required String classGroup,
                required String course,
                required int schoolYear,
                required String periodLabel,
                required String state,
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentsCompanion.insert(
                id: id,
                student: student,
                classGroup: classGroup,
                course: course,
                schoolYear: schoolYear,
                periodLabel: periodLabel,
                state: state,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Enrollments, Enrollment>(table),
                  $EnrollmentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                student = false,
                classGroup = false,
                course = false,
                enrollmentEventsRefs = false,
                attendanceRefs = false,
                gradesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (enrollmentEventsRefs) db.enrollmentEvents,
                    if (attendanceRefs) db.attendance,
                    if (gradesRefs) db.grades,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (student) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.student,
                            referencedTable: $EnrollmentsReferences
                                ._studentTable(db),
                            referencedColumn: $EnrollmentsReferences
                                ._studentTable(db)
                                .id,
                          ) as T;
                        }
                        if (classGroup) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.classGroup,
                            referencedTable: $EnrollmentsReferences
                                ._classGroupTable(db),
                            referencedColumn: $EnrollmentsReferences
                                ._classGroupTable(db)
                                .id,
                          ) as T;
                        }
                        if (course) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.course,
                            referencedTable: $EnrollmentsReferences
                                ._courseTable(db),
                            referencedColumn: $EnrollmentsReferences
                                ._courseTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (enrollmentEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Enrollment,
                          Enrollments,
                          EnrollmentEvent,
                          EnrollmentEvents
                        >(
                          currentTable: table,
                          referencedTable: $EnrollmentsReferences
                              ._enrollmentEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $EnrollmentsReferences(
                                db,
                                table,
                                p0,
                              ).enrollmentEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'enrollment',
                          typedResults: items,
                        ),
                      if (attendanceRefs)
                        await $_getPrefetchedDataByColumns<
                          Enrollment,
                          Enrollments,
                          AttendanceData,
                          Attendance
                        >(
                          currentTable: table,
                          referencedTable: $EnrollmentsReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $EnrollmentsReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRefs,
                          currentColumn: 'id',
                          referencedColumn: 'enrollment',
                          typedResults: items,
                        ),
                      if (gradesRefs)
                        await $_getPrefetchedDataByColumns<
                          Enrollment,
                          Enrollments,
                          Grade,
                          Grades
                        >(
                          currentTable: table,
                          referencedTable: $EnrollmentsReferences
                              ._gradesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $EnrollmentsReferences(db, table, p0).gradesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'enrollment',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $EnrollmentsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Enrollments,
      Enrollment,
      $EnrollmentsFilterComposer,
      $EnrollmentsOrderingComposer,
      $EnrollmentsAnnotationComposer,
      $EnrollmentsCreateCompanionBuilder,
      $EnrollmentsUpdateCompanionBuilder,
      (Enrollment, $EnrollmentsReferences),
      Enrollment,
      PrefetchHooks Function({
        bool student,
        bool classGroup,
        bool course,
        bool enrollmentEventsRefs,
        bool attendanceRefs,
        bool gradesRefs,
      })
    >;
typedef $EnrollmentEventsCreateCompanionBuilder =
    EnrollmentEventsCompanion Function({
      required String id,
      required String enrollment,
      required String actor,
      required String message,
      required String created,
      Value<int> rowid,
    });
typedef $EnrollmentEventsUpdateCompanionBuilder =
    EnrollmentEventsCompanion Function({
      Value<String> id,
      Value<String> enrollment,
      Value<String> actor,
      Value<String> message,
      Value<String> created,
      Value<int> rowid,
    });

final class $EnrollmentEventsReferences
    extends BaseReferences<_$Database, EnrollmentEvents, EnrollmentEvent> {
  $EnrollmentEventsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Enrollments _enrollmentTable(_$Database db) => db.enrollments
      .createAlias('enrollment_events__enrollment__enrollments__id');

  $EnrollmentsProcessedTableManager get enrollment {
    final $_column = $_itemColumn<String>('enrollment')!;

    final manager = $EnrollmentsTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enrollmentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _actorTable(_$Database db) =>
      db.users.createAlias('enrollment_events__actor__users__id');

  $UsersProcessedTableManager get actor {
    final $_column = $_itemColumn<String>('actor')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $EnrollmentEventsFilterComposer
    extends Composer<_$Database, EnrollmentEvents> {
  $EnrollmentEventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  $EnrollmentsFilterComposer get enrollment {
    final $EnrollmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get actor {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnrollmentEventsOrderingComposer
    extends Composer<_$Database, EnrollmentEvents> {
  $EnrollmentEventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  $EnrollmentsOrderingComposer get enrollment {
    final $EnrollmentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsOrderingComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get actor {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnrollmentEventsAnnotationComposer
    extends Composer<_$Database, EnrollmentEvents> {
  $EnrollmentEventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  $EnrollmentsAnnotationComposer get enrollment {
    final $EnrollmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get actor {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnrollmentEventsTableManager
    extends
        RootTableManager<
          _$Database,
          EnrollmentEvents,
          EnrollmentEvent,
          $EnrollmentEventsFilterComposer,
          $EnrollmentEventsOrderingComposer,
          $EnrollmentEventsAnnotationComposer,
          $EnrollmentEventsCreateCompanionBuilder,
          $EnrollmentEventsUpdateCompanionBuilder,
          (EnrollmentEvent, $EnrollmentEventsReferences),
          EnrollmentEvent,
          PrefetchHooks Function({bool enrollment, bool actor})
        > {
  $EnrollmentEventsTableManager(_$Database db, EnrollmentEvents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EnrollmentEventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EnrollmentEventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EnrollmentEventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> enrollment = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentEventsCompanion(
                id: id,
                enrollment: enrollment,
                actor: actor,
                message: message,
                created: created,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String enrollment,
                required String actor,
                required String message,
                required String created,
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentEventsCompanion.insert(
                id: id,
                enrollment: enrollment,
                actor: actor,
                message: message,
                created: created,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<EnrollmentEvents, EnrollmentEvent>(table),
                  $EnrollmentEventsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({enrollment = false, actor = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (enrollment) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.enrollment,
                        referencedTable: $EnrollmentEventsReferences
                            ._enrollmentTable(db),
                        referencedColumn: $EnrollmentEventsReferences
                            ._enrollmentTable(db)
                            .id,
                      ) as T;
                    }
                    if (actor) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.actor,
                        referencedTable: $EnrollmentEventsReferences
                            ._actorTable(db),
                        referencedColumn: $EnrollmentEventsReferences
                            ._actorTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $EnrollmentEventsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      EnrollmentEvents,
      EnrollmentEvent,
      $EnrollmentEventsFilterComposer,
      $EnrollmentEventsOrderingComposer,
      $EnrollmentEventsAnnotationComposer,
      $EnrollmentEventsCreateCompanionBuilder,
      $EnrollmentEventsUpdateCompanionBuilder,
      (EnrollmentEvent, $EnrollmentEventsReferences),
      EnrollmentEvent,
      PrefetchHooks Function({bool enrollment, bool actor})
    >;
typedef $SubjectsCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String name,
  Value<String> code,
  Value<int> revision,
  Value<int> rowid,
});
typedef $SubjectsUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> code,
  Value<int> revision,
  Value<int> rowid,
});

final class $SubjectsReferences
    extends BaseReferences<_$Database, Subjects, Subject> {
  $SubjectsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<CourseComponents, List<CourseComponent>>
  _courseComponentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.courseComponents,
    aliasName: 'subjects__id__course_components__subject',
  );

  $CourseComponentsProcessedTableManager get courseComponentsRefs {
    final manager = $CourseComponentsTableManager(
      $_db,
      $_db.courseComponents,
    ).filter((f) => f.subject.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _courseComponentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $SubjectsFilterComposer extends Composer<_$Database, Subjects> {
  $SubjectsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> courseComponentsRefs(
    Expression<bool> Function($CourseComponentsFilterComposer f) f,
  ) {
    final $CourseComponentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.subject,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsFilterComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SubjectsOrderingComposer extends Composer<_$Database, Subjects> {
  $SubjectsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SubjectsAnnotationComposer extends Composer<_$Database, Subjects> {
  $SubjectsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  Expression<T> courseComponentsRefs<T extends Object>(
    Expression<T> Function($CourseComponentsAnnotationComposer a) f,
  ) {
    final $CourseComponentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.subject,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsAnnotationComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SubjectsTableManager
    extends
        RootTableManager<
          _$Database,
          Subjects,
          Subject,
          $SubjectsFilterComposer,
          $SubjectsOrderingComposer,
          $SubjectsAnnotationComposer,
          $SubjectsCreateCompanionBuilder,
          $SubjectsUpdateCompanionBuilder,
          (Subject, $SubjectsReferences),
          Subject,
          PrefetchHooks Function({bool courseComponentsRefs})
        > {
  $SubjectsTableManager(_$Database db, Subjects table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SubjectsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SubjectsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SubjectsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                name: name,
                code: code,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> code = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                name: name,
                code: code,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Subjects, Subject>(table),
                  $SubjectsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({courseComponentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (courseComponentsRefs) db.courseComponents,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (courseComponentsRefs)
                    await $_getPrefetchedDataByColumns<
                      Subject,
                      Subjects,
                      CourseComponent,
                      CourseComponents
                    >(
                      currentTable: table,
                      referencedTable: $SubjectsReferences
                          ._courseComponentsRefsTable(db),
                      managerFromTypedResult: (p0) => $SubjectsReferences(
                        db,
                        table,
                        p0,
                      ).courseComponentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'subject',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $SubjectsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Subjects,
      Subject,
      $SubjectsFilterComposer,
      $SubjectsOrderingComposer,
      $SubjectsAnnotationComposer,
      $SubjectsCreateCompanionBuilder,
      $SubjectsUpdateCompanionBuilder,
      (Subject, $SubjectsReferences),
      Subject,
      PrefetchHooks Function({bool courseComponentsRefs})
    >;
typedef $CourseComponentsCreateCompanionBuilder =
    CourseComponentsCompanion Function({
      required String id,
      required String course,
      required String phase,
      required String subject,
      required int hours,
      required int lessonMinutes,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $CourseComponentsUpdateCompanionBuilder =
    CourseComponentsCompanion Function({
      Value<String> id,
      Value<String> course,
      Value<String> phase,
      Value<String> subject,
      Value<int> hours,
      Value<int> lessonMinutes,
      Value<int> revision,
      Value<int> rowid,
    });

final class $CourseComponentsReferences
    extends BaseReferences<_$Database, CourseComponents, CourseComponent> {
  $CourseComponentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Courses _courseTable(_$Database db) =>
      db.courses.createAlias('course_components__course__courses__id');

  $CoursesProcessedTableManager get course {
    final $_column = $_itemColumn<String>('course')!;

    final manager = $CoursesTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Subjects _subjectTable(_$Database db) =>
      db.subjects.createAlias('course_components__subject__subjects__id');

  $SubjectsProcessedTableManager get subject {
    final $_column = $_itemColumn<String>('subject')!;

    final manager = $SubjectsTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Journals, List<Journal>> _journalsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.journals,
    aliasName: 'course_components__id__journals__component',
  );

  $JournalsProcessedTableManager get journalsRefs {
    final manager = $JournalsTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.component.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CourseComponentsFilterComposer
    extends Composer<_$Database, CourseComponents> {
  $CourseComponentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonMinutes => $composableBuilder(
    column: $table.lessonMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $CoursesFilterComposer get course {
    final $CoursesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $SubjectsFilterComposer get subject {
    final $SubjectsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subject,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SubjectsFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> journalsRefs(
    Expression<bool> Function($JournalsFilterComposer f) f,
  ) {
    final $JournalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.component,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CourseComponentsOrderingComposer
    extends Composer<_$Database, CourseComponents> {
  $CourseComponentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonMinutes => $composableBuilder(
    column: $table.lessonMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $CoursesOrderingComposer get course {
    final $CoursesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $SubjectsOrderingComposer get subject {
    final $SubjectsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subject,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SubjectsOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CourseComponentsAnnotationComposer
    extends Composer<_$Database, CourseComponents> {
  $CourseComponentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<int> get lessonMinutes => $composableBuilder(
    column: $table.lessonMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $CoursesAnnotationComposer get course {
    final $CoursesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.course,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CoursesAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $SubjectsAnnotationComposer get subject {
    final $SubjectsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subject,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SubjectsAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> journalsRefs<T extends Object>(
    Expression<T> Function($JournalsAnnotationComposer a) f,
  ) {
    final $JournalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.component,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CourseComponentsTableManager
    extends
        RootTableManager<
          _$Database,
          CourseComponents,
          CourseComponent,
          $CourseComponentsFilterComposer,
          $CourseComponentsOrderingComposer,
          $CourseComponentsAnnotationComposer,
          $CourseComponentsCreateCompanionBuilder,
          $CourseComponentsUpdateCompanionBuilder,
          (CourseComponent, $CourseComponentsReferences),
          CourseComponent,
          PrefetchHooks Function({bool course, bool subject, bool journalsRefs})
        > {
  $CourseComponentsTableManager(_$Database db, CourseComponents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CourseComponentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CourseComponentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CourseComponentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> course = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<int> hours = const Value.absent(),
                Value<int> lessonMinutes = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CourseComponentsCompanion(
                id: id,
                course: course,
                phase: phase,
                subject: subject,
                hours: hours,
                lessonMinutes: lessonMinutes,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String course,
                required String phase,
                required String subject,
                required int hours,
                required int lessonMinutes,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CourseComponentsCompanion.insert(
                id: id,
                course: course,
                phase: phase,
                subject: subject,
                hours: hours,
                lessonMinutes: lessonMinutes,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CourseComponents, CourseComponent>(table),
                  $CourseComponentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({course = false, subject = false, journalsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (journalsRefs) db.journals],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (course) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.course,
                            referencedTable: $CourseComponentsReferences
                                ._courseTable(db),
                            referencedColumn: $CourseComponentsReferences
                                ._courseTable(db)
                                .id,
                          ) as T;
                        }
                        if (subject) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.subject,
                            referencedTable: $CourseComponentsReferences
                                ._subjectTable(db),
                            referencedColumn: $CourseComponentsReferences
                                ._subjectTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalsRefs)
                        await $_getPrefetchedDataByColumns<
                          CourseComponent,
                          CourseComponents,
                          Journal,
                          Journals
                        >(
                          currentTable: table,
                          referencedTable: $CourseComponentsReferences
                              ._journalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CourseComponentsReferences(
                                db,
                                table,
                                p0,
                              ).journalsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'component',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CourseComponentsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      CourseComponents,
      CourseComponent,
      $CourseComponentsFilterComposer,
      $CourseComponentsOrderingComposer,
      $CourseComponentsAnnotationComposer,
      $CourseComponentsCreateCompanionBuilder,
      $CourseComponentsUpdateCompanionBuilder,
      (CourseComponent, $CourseComponentsReferences),
      CourseComponent,
      PrefetchHooks Function({bool course, bool subject, bool journalsRefs})
    >;
typedef $JournalsCreateCompanionBuilder = JournalsCompanion Function({
  required String id,
  required String classGroup,
  required String subject,
  required String teacher,
  Value<String?> component,
  Value<int> revision,
  Value<int> rowid,
});
typedef $JournalsUpdateCompanionBuilder = JournalsCompanion Function({
  Value<String> id,
  Value<String> classGroup,
  Value<String> subject,
  Value<String> teacher,
  Value<String?> component,
  Value<int> revision,
  Value<int> rowid,
});

final class $JournalsReferences
    extends BaseReferences<_$Database, Journals, Journal> {
  $JournalsReferences(super.$_db, super.$_table, super.$_typedResult);

  static ClassGroups _classGroupTable(_$Database db) =>
      db.classGroups.createAlias('journals__class_group__class_groups__id');

  $ClassGroupsProcessedTableManager get classGroup {
    final $_column = $_itemColumn<String>('class_group')!;

    final manager = $ClassGroupsTableManager(
      $_db,
      $_db.classGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classGroupTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _teacherTable(_$Database db) =>
      db.users.createAlias('journals__teacher__users__id');

  $UsersProcessedTableManager get teacher {
    final $_column = $_itemColumn<String>('teacher')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static CourseComponents _componentTable(_$Database db) => db.courseComponents
      .createAlias('journals__component__course_components__id');

  $CourseComponentsProcessedTableManager? get component {
    final $_column = $_itemColumn<String>('component');
    if ($_column == null) return null;
    final manager = $CourseComponentsTableManager(
      $_db,
      $_db.courseComponents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Lessons, List<Lesson>> _lessonsRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.lessons,
    aliasName: 'journals__id__lessons__journal',
  );

  $LessonsProcessedTableManager get lessonsRefs {
    final manager = $LessonsTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.journal.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<TimetableSlots, List<TimetableSlot>>
  _timetableSlotsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.timetableSlots,
    aliasName: 'journals__id__timetable_slots__journal',
  );

  $TimetableSlotsProcessedTableManager get timetableSlotsRefs {
    final manager = $TimetableSlotsTableManager(
      $_db,
      $_db.timetableSlots,
    ).filter((f) => f.journal.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timetableSlotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Assessments, List<Assessment>>
  _assessmentsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.assessments,
    aliasName: 'journals__id__assessments__journal',
  );

  $AssessmentsProcessedTableManager get assessmentsRefs {
    final manager = $AssessmentsTableManager(
      $_db,
      $_db.assessments,
    ).filter((f) => f.journal.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_assessmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $JournalsFilterComposer extends Composer<_$Database, Journals> {
  $JournalsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $ClassGroupsFilterComposer get classGroup {
    final $ClassGroupsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classGroup,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsFilterComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get teacher {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacher,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CourseComponentsFilterComposer get component {
    final $CourseComponentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.component,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsFilterComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> lessonsRefs(
    Expression<bool> Function($LessonsFilterComposer f) f,
  ) {
    final $LessonsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.journal,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timetableSlotsRefs(
    Expression<bool> Function($TimetableSlotsFilterComposer f) f,
  ) {
    final $TimetableSlotsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.journal,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TimetableSlotsFilterComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assessmentsRefs(
    Expression<bool> Function($AssessmentsFilterComposer f) f,
  ) {
    final $AssessmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.journal,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsFilterComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $JournalsOrderingComposer extends Composer<_$Database, Journals> {
  $JournalsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $ClassGroupsOrderingComposer get classGroup {
    final $ClassGroupsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classGroup,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsOrderingComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get teacher {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacher,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CourseComponentsOrderingComposer get component {
    final $CourseComponentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.component,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsOrderingComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $JournalsAnnotationComposer extends Composer<_$Database, Journals> {
  $JournalsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $ClassGroupsAnnotationComposer get classGroup {
    final $ClassGroupsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classGroup,
      referencedTable: $db.classGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClassGroupsAnnotationComposer(
            $db: $db,
            $table: $db.classGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get teacher {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacher,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CourseComponentsAnnotationComposer get component {
    final $CourseComponentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.component,
      referencedTable: $db.courseComponents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CourseComponentsAnnotationComposer(
            $db: $db,
            $table: $db.courseComponents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> lessonsRefs<T extends Object>(
    Expression<T> Function($LessonsAnnotationComposer a) f,
  ) {
    final $LessonsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.journal,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timetableSlotsRefs<T extends Object>(
    Expression<T> Function($TimetableSlotsAnnotationComposer a) f,
  ) {
    final $TimetableSlotsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timetableSlots,
      getReferencedColumn: (t) => t.journal,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TimetableSlotsAnnotationComposer(
            $db: $db,
            $table: $db.timetableSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> assessmentsRefs<T extends Object>(
    Expression<T> Function($AssessmentsAnnotationComposer a) f,
  ) {
    final $AssessmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.journal,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsAnnotationComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $JournalsTableManager
    extends
        RootTableManager<
          _$Database,
          Journals,
          Journal,
          $JournalsFilterComposer,
          $JournalsOrderingComposer,
          $JournalsAnnotationComposer,
          $JournalsCreateCompanionBuilder,
          $JournalsUpdateCompanionBuilder,
          (Journal, $JournalsReferences),
          Journal,
          PrefetchHooks Function({
            bool classGroup,
            bool teacher,
            bool component,
            bool lessonsRefs,
            bool timetableSlotsRefs,
            bool assessmentsRefs,
          })
        > {
  $JournalsTableManager(_$Database db, Journals table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $JournalsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $JournalsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $JournalsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> classGroup = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> teacher = const Value.absent(),
                Value<String?> component = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalsCompanion(
                id: id,
                classGroup: classGroup,
                subject: subject,
                teacher: teacher,
                component: component,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String classGroup,
                required String subject,
                required String teacher,
                Value<String?> component = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalsCompanion.insert(
                id: id,
                classGroup: classGroup,
                subject: subject,
                teacher: teacher,
                component: component,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Journals, Journal>(table),
                  $JournalsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                classGroup = false,
                teacher = false,
                component = false,
                lessonsRefs = false,
                timetableSlotsRefs = false,
                assessmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lessonsRefs) db.lessons,
                    if (timetableSlotsRefs) db.timetableSlots,
                    if (assessmentsRefs) db.assessments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (classGroup) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.classGroup,
                            referencedTable: $JournalsReferences
                                ._classGroupTable(db),
                            referencedColumn: $JournalsReferences
                                ._classGroupTable(db)
                                .id,
                          ) as T;
                        }
                        if (teacher) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.teacher,
                            referencedTable: $JournalsReferences._teacherTable(
                              db,
                            ),
                            referencedColumn: $JournalsReferences
                                ._teacherTable(db)
                                .id,
                          ) as T;
                        }
                        if (component) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.component,
                            referencedTable: $JournalsReferences
                                ._componentTable(db),
                            referencedColumn: $JournalsReferences
                                ._componentTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lessonsRefs)
                        await $_getPrefetchedDataByColumns<
                          Journal,
                          Journals,
                          Lesson,
                          Lessons
                        >(
                          currentTable: table,
                          referencedTable: $JournalsReferences
                              ._lessonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $JournalsReferences(db, table, p0).lessonsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'journal',
                          typedResults: items,
                        ),
                      if (timetableSlotsRefs)
                        await $_getPrefetchedDataByColumns<
                          Journal,
                          Journals,
                          TimetableSlot,
                          TimetableSlots
                        >(
                          currentTable: table,
                          referencedTable: $JournalsReferences
                              ._timetableSlotsRefsTable(db),
                          managerFromTypedResult: (p0) => $JournalsReferences(
                            db,
                            table,
                            p0,
                          ).timetableSlotsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'journal',
                          typedResults: items,
                        ),
                      if (assessmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Journal,
                          Journals,
                          Assessment,
                          Assessments
                        >(
                          currentTable: table,
                          referencedTable: $JournalsReferences
                              ._assessmentsRefsTable(db),
                          managerFromTypedResult: (p0) => $JournalsReferences(
                            db,
                            table,
                            p0,
                          ).assessmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'journal',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $JournalsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Journals,
      Journal,
      $JournalsFilterComposer,
      $JournalsOrderingComposer,
      $JournalsAnnotationComposer,
      $JournalsCreateCompanionBuilder,
      $JournalsUpdateCompanionBuilder,
      (Journal, $JournalsReferences),
      Journal,
      PrefetchHooks Function({
        bool classGroup,
        bool teacher,
        bool component,
        bool lessonsRefs,
        bool timetableSlotsRefs,
        bool assessmentsRefs,
      })
    >;
typedef $LessonsCreateCompanionBuilder = LessonsCompanion Function({
  required String id,
  required String journal,
  required String date,
  required int units,
  required String content,
  required String state,
  Value<int> revision,
  required String created,
  required String updated,
  Value<int> rowid,
});
typedef $LessonsUpdateCompanionBuilder = LessonsCompanion Function({
  Value<String> id,
  Value<String> journal,
  Value<String> date,
  Value<int> units,
  Value<String> content,
  Value<String> state,
  Value<int> revision,
  Value<String> created,
  Value<String> updated,
  Value<int> rowid,
});

final class $LessonsReferences
    extends BaseReferences<_$Database, Lessons, Lesson> {
  $LessonsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Journals _journalTable(_$Database db) =>
      db.journals.createAlias('lessons__journal__journals__id');

  $JournalsProcessedTableManager get journal {
    final $_column = $_itemColumn<String>('journal')!;

    final manager = $JournalsTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journalTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Attendance, List<AttendanceData>>
  _attendanceRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: 'lessons__id__attendance__lesson',
  );

  $AttendanceProcessedTableManager get attendanceRefs {
    final manager = $AttendanceTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.lesson.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<LessonEvents, List<LessonEvent>>
  _lessonEventsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.lessonEvents,
    aliasName: 'lessons__id__lesson_events__lesson',
  );

  $LessonEventsProcessedTableManager get lessonEventsRefs {
    final manager = $LessonEventsTableManager(
      $_db,
      $_db.lessonEvents,
    ).filter((f) => f.lesson.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $LessonsFilterComposer extends Composer<_$Database, Lessons> {
  $LessonsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  $JournalsFilterComposer get journal {
    final $JournalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($AttendanceFilterComposer f) f,
  ) {
    final $AttendanceFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.lesson,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttendanceFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> lessonEventsRefs(
    Expression<bool> Function($LessonEventsFilterComposer f) f,
  ) {
    final $LessonEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonEvents,
      getReferencedColumn: (t) => t.lesson,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonEventsFilterComposer(
            $db: $db,
            $table: $db.lessonEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $LessonsOrderingComposer extends Composer<_$Database, Lessons> {
  $LessonsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  $JournalsOrderingComposer get journal {
    final $JournalsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsOrderingComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $LessonsAnnotationComposer extends Composer<_$Database, Lessons> {
  $LessonsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  $JournalsAnnotationComposer get journal {
    final $JournalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($AttendanceAnnotationComposer a) f,
  ) {
    final $AttendanceAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.lesson,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AttendanceAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> lessonEventsRefs<T extends Object>(
    Expression<T> Function($LessonEventsAnnotationComposer a) f,
  ) {
    final $LessonEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lessonEvents,
      getReferencedColumn: (t) => t.lesson,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonEventsAnnotationComposer(
            $db: $db,
            $table: $db.lessonEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $LessonsTableManager
    extends
        RootTableManager<
          _$Database,
          Lessons,
          Lesson,
          $LessonsFilterComposer,
          $LessonsOrderingComposer,
          $LessonsAnnotationComposer,
          $LessonsCreateCompanionBuilder,
          $LessonsUpdateCompanionBuilder,
          (Lesson, $LessonsReferences),
          Lesson,
          PrefetchHooks Function({
            bool journal,
            bool attendanceRefs,
            bool lessonEventsRefs,
          })
        > {
  $LessonsTableManager(_$Database db, Lessons table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $LessonsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $LessonsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $LessonsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> journal = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> units = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                journal: journal,
                date: date,
                units: units,
                content: content,
                state: state,
                revision: revision,
                created: created,
                updated: updated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String journal,
                required String date,
                required int units,
                required String content,
                required String state,
                Value<int> revision = const Value.absent(),
                required String created,
                required String updated,
                Value<int> rowid = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                journal: journal,
                date: date,
                units: units,
                content: content,
                state: state,
                revision: revision,
                created: created,
                updated: updated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Lessons, Lesson>(table),
                  $LessonsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                journal = false,
                attendanceRefs = false,
                lessonEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (attendanceRefs) db.attendance,
                    if (lessonEventsRefs) db.lessonEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (journal) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.journal,
                            referencedTable: $LessonsReferences._journalTable(
                              db,
                            ),
                            referencedColumn: $LessonsReferences
                                ._journalTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (attendanceRefs)
                        await $_getPrefetchedDataByColumns<
                          Lesson,
                          Lessons,
                          AttendanceData,
                          Attendance
                        >(
                          currentTable: table,
                          referencedTable: $LessonsReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $LessonsReferences(db, table, p0).attendanceRefs,
                          currentColumn: 'id',
                          referencedColumn: 'lesson',
                          typedResults: items,
                        ),
                      if (lessonEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Lesson,
                          Lessons,
                          LessonEvent,
                          LessonEvents
                        >(
                          currentTable: table,
                          referencedTable: $LessonsReferences
                              ._lessonEventsRefsTable(db),
                          managerFromTypedResult: (p0) => $LessonsReferences(
                            db,
                            table,
                            p0,
                          ).lessonEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'lesson',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $LessonsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Lessons,
      Lesson,
      $LessonsFilterComposer,
      $LessonsOrderingComposer,
      $LessonsAnnotationComposer,
      $LessonsCreateCompanionBuilder,
      $LessonsUpdateCompanionBuilder,
      (Lesson, $LessonsReferences),
      Lesson,
      PrefetchHooks Function({
        bool journal,
        bool attendanceRefs,
        bool lessonEventsRefs,
      })
    >;
typedef $AttendanceCreateCompanionBuilder = AttendanceCompanion Function({
  required String lesson,
  required String enrollment,
  required String status,
  Value<int> rowid,
});
typedef $AttendanceUpdateCompanionBuilder = AttendanceCompanion Function({
  Value<String> lesson,
  Value<String> enrollment,
  Value<String> status,
  Value<int> rowid,
});

final class $AttendanceReferences
    extends BaseReferences<_$Database, Attendance, AttendanceData> {
  $AttendanceReferences(super.$_db, super.$_table, super.$_typedResult);

  static Lessons _lessonTable(_$Database db) =>
      db.lessons.createAlias('attendance__lesson__lessons__id');

  $LessonsProcessedTableManager get lesson {
    final $_column = $_itemColumn<String>('lesson')!;

    final manager = $LessonsTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Enrollments _enrollmentTable(_$Database db) =>
      db.enrollments.createAlias('attendance__enrollment__enrollments__id');

  $EnrollmentsProcessedTableManager get enrollment {
    final $_column = $_itemColumn<String>('enrollment')!;

    final manager = $EnrollmentsTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enrollmentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AttendanceFilterComposer extends Composer<_$Database, Attendance> {
  $AttendanceFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $LessonsFilterComposer get lesson {
    final $LessonsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lesson,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnrollmentsFilterComposer get enrollment {
    final $EnrollmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AttendanceOrderingComposer extends Composer<_$Database, Attendance> {
  $AttendanceOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $LessonsOrderingComposer get lesson {
    final $LessonsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lesson,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnrollmentsOrderingComposer get enrollment {
    final $EnrollmentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsOrderingComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AttendanceAnnotationComposer extends Composer<_$Database, Attendance> {
  $AttendanceAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $LessonsAnnotationComposer get lesson {
    final $LessonsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lesson,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnrollmentsAnnotationComposer get enrollment {
    final $EnrollmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AttendanceTableManager
    extends
        RootTableManager<
          _$Database,
          Attendance,
          AttendanceData,
          $AttendanceFilterComposer,
          $AttendanceOrderingComposer,
          $AttendanceAnnotationComposer,
          $AttendanceCreateCompanionBuilder,
          $AttendanceUpdateCompanionBuilder,
          (AttendanceData, $AttendanceReferences),
          AttendanceData,
          PrefetchHooks Function({bool lesson, bool enrollment})
        > {
  $AttendanceTableManager(_$Database db, Attendance table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AttendanceFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AttendanceOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AttendanceAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> lesson = const Value.absent(),
                Value<String> enrollment = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceCompanion(
                lesson: lesson,
                enrollment: enrollment,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lesson,
                required String enrollment,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => AttendanceCompanion.insert(
                lesson: lesson,
                enrollment: enrollment,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Attendance, AttendanceData>(table),
                  $AttendanceReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lesson = false, enrollment = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lesson) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.lesson,
                        referencedTable: $AttendanceReferences._lessonTable(db),
                        referencedColumn: $AttendanceReferences
                            ._lessonTable(db)
                            .id,
                      ) as T;
                    }
                    if (enrollment) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.enrollment,
                        referencedTable: $AttendanceReferences._enrollmentTable(
                          db,
                        ),
                        referencedColumn: $AttendanceReferences
                            ._enrollmentTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AttendanceProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Attendance,
      AttendanceData,
      $AttendanceFilterComposer,
      $AttendanceOrderingComposer,
      $AttendanceAnnotationComposer,
      $AttendanceCreateCompanionBuilder,
      $AttendanceUpdateCompanionBuilder,
      (AttendanceData, $AttendanceReferences),
      AttendanceData,
      PrefetchHooks Function({bool lesson, bool enrollment})
    >;
typedef $LessonEventsCreateCompanionBuilder = LessonEventsCompanion Function({
  required String id,
  required String lesson,
  required String actor,
  required String message,
  required String created,
  Value<int> rowid,
});
typedef $LessonEventsUpdateCompanionBuilder = LessonEventsCompanion Function({
  Value<String> id,
  Value<String> lesson,
  Value<String> actor,
  Value<String> message,
  Value<String> created,
  Value<int> rowid,
});

final class $LessonEventsReferences
    extends BaseReferences<_$Database, LessonEvents, LessonEvent> {
  $LessonEventsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Lessons _lessonTable(_$Database db) =>
      db.lessons.createAlias('lesson_events__lesson__lessons__id');

  $LessonsProcessedTableManager get lesson {
    final $_column = $_itemColumn<String>('lesson')!;

    final manager = $LessonsTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _actorTable(_$Database db) =>
      db.users.createAlias('lesson_events__actor__users__id');

  $UsersProcessedTableManager get actor {
    final $_column = $_itemColumn<String>('actor')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $LessonEventsFilterComposer extends Composer<_$Database, LessonEvents> {
  $LessonEventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  $LessonsFilterComposer get lesson {
    final $LessonsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lesson,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get actor {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $LessonEventsOrderingComposer extends Composer<_$Database, LessonEvents> {
  $LessonEventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  $LessonsOrderingComposer get lesson {
    final $LessonsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lesson,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get actor {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $LessonEventsAnnotationComposer
    extends Composer<_$Database, LessonEvents> {
  $LessonEventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  $LessonsAnnotationComposer get lesson {
    final $LessonsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lesson,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LessonsAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get actor {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $LessonEventsTableManager
    extends
        RootTableManager<
          _$Database,
          LessonEvents,
          LessonEvent,
          $LessonEventsFilterComposer,
          $LessonEventsOrderingComposer,
          $LessonEventsAnnotationComposer,
          $LessonEventsCreateCompanionBuilder,
          $LessonEventsUpdateCompanionBuilder,
          (LessonEvent, $LessonEventsReferences),
          LessonEvent,
          PrefetchHooks Function({bool lesson, bool actor})
        > {
  $LessonEventsTableManager(_$Database db, LessonEvents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $LessonEventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $LessonEventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $LessonEventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lesson = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonEventsCompanion(
                id: id,
                lesson: lesson,
                actor: actor,
                message: message,
                created: created,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lesson,
                required String actor,
                required String message,
                required String created,
                Value<int> rowid = const Value.absent(),
              }) => LessonEventsCompanion.insert(
                id: id,
                lesson: lesson,
                actor: actor,
                message: message,
                created: created,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<LessonEvents, LessonEvent>(table),
                  $LessonEventsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lesson = false, actor = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lesson) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.lesson,
                        referencedTable: $LessonEventsReferences._lessonTable(
                          db,
                        ),
                        referencedColumn: $LessonEventsReferences
                            ._lessonTable(db)
                            .id,
                      ) as T;
                    }
                    if (actor) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.actor,
                        referencedTable: $LessonEventsReferences._actorTable(
                          db,
                        ),
                        referencedColumn: $LessonEventsReferences
                            ._actorTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $LessonEventsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      LessonEvents,
      LessonEvent,
      $LessonEventsFilterComposer,
      $LessonEventsOrderingComposer,
      $LessonEventsAnnotationComposer,
      $LessonEventsCreateCompanionBuilder,
      $LessonEventsUpdateCompanionBuilder,
      (LessonEvent, $LessonEventsReferences),
      LessonEvent,
      PrefetchHooks Function({bool lesson, bool actor})
    >;
typedef $TeacherProfilesCreateCompanionBuilder =
    TeacherProfilesCompanion Function({
      required String user,
      Value<String?> staffCode,
      Value<String> qualification,
      Value<String> phone,
      Value<String> email,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $TeacherProfilesUpdateCompanionBuilder =
    TeacherProfilesCompanion Function({
      Value<String> user,
      Value<String?> staffCode,
      Value<String> qualification,
      Value<String> phone,
      Value<String> email,
      Value<int> revision,
      Value<int> rowid,
    });

final class $TeacherProfilesReferences
    extends BaseReferences<_$Database, TeacherProfiles, TeacherProfile> {
  $TeacherProfilesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Users _userTable(_$Database db) =>
      db.users.createAlias('teacher_profiles__user__users__id');

  $UsersProcessedTableManager get user {
    final $_column = $_itemColumn<String>('user')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $TeacherProfilesFilterComposer
    extends Composer<_$Database, TeacherProfiles> {
  $TeacherProfilesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get staffCode => $composableBuilder(
    column: $table.staffCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get user {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TeacherProfilesOrderingComposer
    extends Composer<_$Database, TeacherProfiles> {
  $TeacherProfilesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get staffCode => $composableBuilder(
    column: $table.staffCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get user {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TeacherProfilesAnnotationComposer
    extends Composer<_$Database, TeacherProfiles> {
  $TeacherProfilesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get staffCode =>
      $composableBuilder(column: $table.staffCode, builder: (column) => column);

  GeneratedColumn<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $UsersAnnotationComposer get user {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TeacherProfilesTableManager
    extends
        RootTableManager<
          _$Database,
          TeacherProfiles,
          TeacherProfile,
          $TeacherProfilesFilterComposer,
          $TeacherProfilesOrderingComposer,
          $TeacherProfilesAnnotationComposer,
          $TeacherProfilesCreateCompanionBuilder,
          $TeacherProfilesUpdateCompanionBuilder,
          (TeacherProfile, $TeacherProfilesReferences),
          TeacherProfile,
          PrefetchHooks Function({bool user})
        > {
  $TeacherProfilesTableManager(_$Database db, TeacherProfiles table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TeacherProfilesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TeacherProfilesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TeacherProfilesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> user = const Value.absent(),
                Value<String?> staffCode = const Value.absent(),
                Value<String> qualification = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeacherProfilesCompanion(
                user: user,
                staffCode: staffCode,
                qualification: qualification,
                phone: phone,
                email: email,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String user,
                Value<String?> staffCode = const Value.absent(),
                Value<String> qualification = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeacherProfilesCompanion.insert(
                user: user,
                staffCode: staffCode,
                qualification: qualification,
                phone: phone,
                email: email,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<TeacherProfiles, TeacherProfile>(table),
                  $TeacherProfilesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({user = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (user) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.user,
                        referencedTable: $TeacherProfilesReferences._userTable(
                          db,
                        ),
                        referencedColumn: $TeacherProfilesReferences
                            ._userTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $TeacherProfilesProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      TeacherProfiles,
      TeacherProfile,
      $TeacherProfilesFilterComposer,
      $TeacherProfilesOrderingComposer,
      $TeacherProfilesAnnotationComposer,
      $TeacherProfilesCreateCompanionBuilder,
      $TeacherProfilesUpdateCompanionBuilder,
      (TeacherProfile, $TeacherProfilesReferences),
      TeacherProfile,
      PrefetchHooks Function({bool user})
    >;
typedef $TimetableSlotsCreateCompanionBuilder =
    TimetableSlotsCompanion Function({
      required String id,
      required String journal,
      required int weekday,
      required int startMinute,
      required int endMinute,
      required String validFrom,
      required String validTo,
      Value<String> room,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $TimetableSlotsUpdateCompanionBuilder =
    TimetableSlotsCompanion Function({
      Value<String> id,
      Value<String> journal,
      Value<int> weekday,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<String> validFrom,
      Value<String> validTo,
      Value<String> room,
      Value<int> revision,
      Value<int> rowid,
    });

final class $TimetableSlotsReferences
    extends BaseReferences<_$Database, TimetableSlots, TimetableSlot> {
  $TimetableSlotsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Journals _journalTable(_$Database db) =>
      db.journals.createAlias('timetable_slots__journal__journals__id');

  $JournalsProcessedTableManager get journal {
    final $_column = $_itemColumn<String>('journal')!;

    final manager = $JournalsTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journalTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $TimetableSlotsFilterComposer
    extends Composer<_$Database, TimetableSlots> {
  $TimetableSlotsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $JournalsFilterComposer get journal {
    final $JournalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TimetableSlotsOrderingComposer
    extends Composer<_$Database, TimetableSlots> {
  $TimetableSlotsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $JournalsOrderingComposer get journal {
    final $JournalsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsOrderingComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TimetableSlotsAnnotationComposer
    extends Composer<_$Database, TimetableSlots> {
  $TimetableSlotsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $JournalsAnnotationComposer get journal {
    final $JournalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TimetableSlotsTableManager
    extends
        RootTableManager<
          _$Database,
          TimetableSlots,
          TimetableSlot,
          $TimetableSlotsFilterComposer,
          $TimetableSlotsOrderingComposer,
          $TimetableSlotsAnnotationComposer,
          $TimetableSlotsCreateCompanionBuilder,
          $TimetableSlotsUpdateCompanionBuilder,
          (TimetableSlot, $TimetableSlotsReferences),
          TimetableSlot,
          PrefetchHooks Function({bool journal})
        > {
  $TimetableSlotsTableManager(_$Database db, TimetableSlots table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TimetableSlotsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TimetableSlotsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TimetableSlotsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> journal = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<String> validFrom = const Value.absent(),
                Value<String> validTo = const Value.absent(),
                Value<String> room = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimetableSlotsCompanion(
                id: id,
                journal: journal,
                weekday: weekday,
                startMinute: startMinute,
                endMinute: endMinute,
                validFrom: validFrom,
                validTo: validTo,
                room: room,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String journal,
                required int weekday,
                required int startMinute,
                required int endMinute,
                required String validFrom,
                required String validTo,
                Value<String> room = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimetableSlotsCompanion.insert(
                id: id,
                journal: journal,
                weekday: weekday,
                startMinute: startMinute,
                endMinute: endMinute,
                validFrom: validFrom,
                validTo: validTo,
                room: room,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<TimetableSlots, TimetableSlot>(table),
                  $TimetableSlotsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journal = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journal) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.journal,
                        referencedTable: $TimetableSlotsReferences
                            ._journalTable(db),
                        referencedColumn: $TimetableSlotsReferences
                            ._journalTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $TimetableSlotsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      TimetableSlots,
      TimetableSlot,
      $TimetableSlotsFilterComposer,
      $TimetableSlotsOrderingComposer,
      $TimetableSlotsAnnotationComposer,
      $TimetableSlotsCreateCompanionBuilder,
      $TimetableSlotsUpdateCompanionBuilder,
      (TimetableSlot, $TimetableSlotsReferences),
      TimetableSlot,
      PrefetchHooks Function({bool journal})
    >;
typedef $AssessmentsCreateCompanionBuilder = AssessmentsCompanion Function({
  required String id,
  required String journal,
  required String label,
  required String stage,
  required String heldOn,
  required double maxScore,
  required double weight,
  required String state,
  Value<int> revision,
  required String updated,
  Value<int> rowid,
});
typedef $AssessmentsUpdateCompanionBuilder = AssessmentsCompanion Function({
  Value<String> id,
  Value<String> journal,
  Value<String> label,
  Value<String> stage,
  Value<String> heldOn,
  Value<double> maxScore,
  Value<double> weight,
  Value<String> state,
  Value<int> revision,
  Value<String> updated,
  Value<int> rowid,
});

final class $AssessmentsReferences
    extends BaseReferences<_$Database, Assessments, Assessment> {
  $AssessmentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Journals _journalTable(_$Database db) =>
      db.journals.createAlias('assessments__journal__journals__id');

  $JournalsProcessedTableManager get journal {
    final $_column = $_itemColumn<String>('journal')!;

    final manager = $JournalsTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journalTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Grades, List<Grade>> _gradesRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.grades,
    aliasName: 'assessments__id__grades__assessment',
  );

  $GradesProcessedTableManager get gradesRefs {
    final manager = $GradesTableManager(
      $_db,
      $_db.grades,
    ).filter((f) => f.assessment.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gradesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<AssessmentEvents, List<AssessmentEvent>>
  _assessmentEventsRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.assessmentEvents,
    aliasName: 'assessments__id__assessment_events__assessment',
  );

  $AssessmentEventsProcessedTableManager get assessmentEventsRefs {
    final manager = $AssessmentEventsTableManager(
      $_db,
      $_db.assessmentEvents,
    ).filter((f) => f.assessment.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _assessmentEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AssessmentsFilterComposer extends Composer<_$Database, Assessments> {
  $AssessmentsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heldOn => $composableBuilder(
    column: $table.heldOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxScore => $composableBuilder(
    column: $table.maxScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  $JournalsFilterComposer get journal {
    final $JournalsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gradesRefs(
    Expression<bool> Function($GradesFilterComposer f) f,
  ) {
    final $GradesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grades,
      getReferencedColumn: (t) => t.assessment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $GradesFilterComposer(
            $db: $db,
            $table: $db.grades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assessmentEventsRefs(
    Expression<bool> Function($AssessmentEventsFilterComposer f) f,
  ) {
    final $AssessmentEventsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessmentEvents,
      getReferencedColumn: (t) => t.assessment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentEventsFilterComposer(
            $db: $db,
            $table: $db.assessmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AssessmentsOrderingComposer extends Composer<_$Database, Assessments> {
  $AssessmentsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heldOn => $composableBuilder(
    column: $table.heldOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxScore => $composableBuilder(
    column: $table.maxScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  $JournalsOrderingComposer get journal {
    final $JournalsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsOrderingComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AssessmentsAnnotationComposer extends Composer<_$Database, Assessments> {
  $AssessmentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<String> get heldOn =>
      $composableBuilder(column: $table.heldOn, builder: (column) => column);

  GeneratedColumn<double> get maxScore =>
      $composableBuilder(column: $table.maxScore, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  $JournalsAnnotationComposer get journal {
    final $JournalsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journal,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalsAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gradesRefs<T extends Object>(
    Expression<T> Function($GradesAnnotationComposer a) f,
  ) {
    final $GradesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grades,
      getReferencedColumn: (t) => t.assessment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $GradesAnnotationComposer(
            $db: $db,
            $table: $db.grades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> assessmentEventsRefs<T extends Object>(
    Expression<T> Function($AssessmentEventsAnnotationComposer a) f,
  ) {
    final $AssessmentEventsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessmentEvents,
      getReferencedColumn: (t) => t.assessment,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentEventsAnnotationComposer(
            $db: $db,
            $table: $db.assessmentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AssessmentsTableManager
    extends
        RootTableManager<
          _$Database,
          Assessments,
          Assessment,
          $AssessmentsFilterComposer,
          $AssessmentsOrderingComposer,
          $AssessmentsAnnotationComposer,
          $AssessmentsCreateCompanionBuilder,
          $AssessmentsUpdateCompanionBuilder,
          (Assessment, $AssessmentsReferences),
          Assessment,
          PrefetchHooks Function({
            bool journal,
            bool gradesRefs,
            bool assessmentEventsRefs,
          })
        > {
  $AssessmentsTableManager(_$Database db, Assessments table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AssessmentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AssessmentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AssessmentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> journal = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<String> heldOn = const Value.absent(),
                Value<double> maxScore = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssessmentsCompanion(
                id: id,
                journal: journal,
                label: label,
                stage: stage,
                heldOn: heldOn,
                maxScore: maxScore,
                weight: weight,
                state: state,
                revision: revision,
                updated: updated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String journal,
                required String label,
                required String stage,
                required String heldOn,
                required double maxScore,
                required double weight,
                required String state,
                Value<int> revision = const Value.absent(),
                required String updated,
                Value<int> rowid = const Value.absent(),
              }) => AssessmentsCompanion.insert(
                id: id,
                journal: journal,
                label: label,
                stage: stage,
                heldOn: heldOn,
                maxScore: maxScore,
                weight: weight,
                state: state,
                revision: revision,
                updated: updated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Assessments, Assessment>(table),
                  $AssessmentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                journal = false,
                gradesRefs = false,
                assessmentEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gradesRefs) db.grades,
                    if (assessmentEventsRefs) db.assessmentEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (journal) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.journal,
                            referencedTable: $AssessmentsReferences
                                ._journalTable(db),
                            referencedColumn: $AssessmentsReferences
                                ._journalTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gradesRefs)
                        await $_getPrefetchedDataByColumns<
                          Assessment,
                          Assessments,
                          Grade,
                          Grades
                        >(
                          currentTable: table,
                          referencedTable: $AssessmentsReferences
                              ._gradesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $AssessmentsReferences(db, table, p0).gradesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'assessment',
                          typedResults: items,
                        ),
                      if (assessmentEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Assessment,
                          Assessments,
                          AssessmentEvent,
                          AssessmentEvents
                        >(
                          currentTable: table,
                          referencedTable: $AssessmentsReferences
                              ._assessmentEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $AssessmentsReferences(
                                db,
                                table,
                                p0,
                              ).assessmentEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'assessment',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $AssessmentsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Assessments,
      Assessment,
      $AssessmentsFilterComposer,
      $AssessmentsOrderingComposer,
      $AssessmentsAnnotationComposer,
      $AssessmentsCreateCompanionBuilder,
      $AssessmentsUpdateCompanionBuilder,
      (Assessment, $AssessmentsReferences),
      Assessment,
      PrefetchHooks Function({
        bool journal,
        bool gradesRefs,
        bool assessmentEventsRefs,
      })
    >;
typedef $GradesCreateCompanionBuilder = GradesCompanion Function({
  required String assessment,
  required String enrollment,
  Value<double?> score,
  required String status,
  Value<String> note,
  Value<int> rowid,
});
typedef $GradesUpdateCompanionBuilder = GradesCompanion Function({
  Value<String> assessment,
  Value<String> enrollment,
  Value<double?> score,
  Value<String> status,
  Value<String> note,
  Value<int> rowid,
});

final class $GradesReferences
    extends BaseReferences<_$Database, Grades, Grade> {
  $GradesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Assessments _assessmentTable(_$Database db) =>
      db.assessments.createAlias('grades__assessment__assessments__id');

  $AssessmentsProcessedTableManager get assessment {
    final $_column = $_itemColumn<String>('assessment')!;

    final manager = $AssessmentsTableManager(
      $_db,
      $_db.assessments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assessmentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Enrollments _enrollmentTable(_$Database db) =>
      db.enrollments.createAlias('grades__enrollment__enrollments__id');

  $EnrollmentsProcessedTableManager get enrollment {
    final $_column = $_itemColumn<String>('enrollment')!;

    final manager = $EnrollmentsTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enrollmentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $GradesFilterComposer extends Composer<_$Database, Grades> {
  $GradesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $AssessmentsFilterComposer get assessment {
    final $AssessmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assessment,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsFilterComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnrollmentsFilterComposer get enrollment {
    final $EnrollmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $GradesOrderingComposer extends Composer<_$Database, Grades> {
  $GradesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $AssessmentsOrderingComposer get assessment {
    final $AssessmentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assessment,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsOrderingComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnrollmentsOrderingComposer get enrollment {
    final $EnrollmentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsOrderingComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $GradesAnnotationComposer extends Composer<_$Database, Grades> {
  $GradesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $AssessmentsAnnotationComposer get assessment {
    final $AssessmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assessment,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsAnnotationComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnrollmentsAnnotationComposer get enrollment {
    final $EnrollmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollment,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnrollmentsAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $GradesTableManager
    extends
        RootTableManager<
          _$Database,
          Grades,
          Grade,
          $GradesFilterComposer,
          $GradesOrderingComposer,
          $GradesAnnotationComposer,
          $GradesCreateCompanionBuilder,
          $GradesUpdateCompanionBuilder,
          (Grade, $GradesReferences),
          Grade,
          PrefetchHooks Function({bool assessment, bool enrollment})
        > {
  $GradesTableManager(_$Database db, Grades table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GradesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GradesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GradesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> assessment = const Value.absent(),
                Value<String> enrollment = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GradesCompanion(
                assessment: assessment,
                enrollment: enrollment,
                score: score,
                status: status,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String assessment,
                required String enrollment,
                Value<double?> score = const Value.absent(),
                required String status,
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GradesCompanion.insert(
                assessment: assessment,
                enrollment: enrollment,
                score: score,
                status: status,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Grades, Grade>(table),
                  $GradesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assessment = false, enrollment = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (assessment) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.assessment,
                        referencedTable: $GradesReferences._assessmentTable(db),
                        referencedColumn: $GradesReferences
                            ._assessmentTable(db)
                            .id,
                      ) as T;
                    }
                    if (enrollment) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.enrollment,
                        referencedTable: $GradesReferences._enrollmentTable(db),
                        referencedColumn: $GradesReferences
                            ._enrollmentTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $GradesProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      Grades,
      Grade,
      $GradesFilterComposer,
      $GradesOrderingComposer,
      $GradesAnnotationComposer,
      $GradesCreateCompanionBuilder,
      $GradesUpdateCompanionBuilder,
      (Grade, $GradesReferences),
      Grade,
      PrefetchHooks Function({bool assessment, bool enrollment})
    >;
typedef $AssessmentEventsCreateCompanionBuilder =
    AssessmentEventsCompanion Function({
      required String id,
      required String assessment,
      required String actor,
      required String message,
      required String created,
      Value<int> rowid,
    });
typedef $AssessmentEventsUpdateCompanionBuilder =
    AssessmentEventsCompanion Function({
      Value<String> id,
      Value<String> assessment,
      Value<String> actor,
      Value<String> message,
      Value<String> created,
      Value<int> rowid,
    });

final class $AssessmentEventsReferences
    extends BaseReferences<_$Database, AssessmentEvents, AssessmentEvent> {
  $AssessmentEventsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Assessments _assessmentTable(_$Database db) => db.assessments
      .createAlias('assessment_events__assessment__assessments__id');

  $AssessmentsProcessedTableManager get assessment {
    final $_column = $_itemColumn<String>('assessment')!;

    final manager = $AssessmentsTableManager(
      $_db,
      $_db.assessments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assessmentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _actorTable(_$Database db) =>
      db.users.createAlias('assessment_events__actor__users__id');

  $UsersProcessedTableManager get actor {
    final $_column = $_itemColumn<String>('actor')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AssessmentEventsFilterComposer
    extends Composer<_$Database, AssessmentEvents> {
  $AssessmentEventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  $AssessmentsFilterComposer get assessment {
    final $AssessmentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assessment,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsFilterComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get actor {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AssessmentEventsOrderingComposer
    extends Composer<_$Database, AssessmentEvents> {
  $AssessmentEventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  $AssessmentsOrderingComposer get assessment {
    final $AssessmentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assessment,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsOrderingComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get actor {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AssessmentEventsAnnotationComposer
    extends Composer<_$Database, AssessmentEvents> {
  $AssessmentEventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  $AssessmentsAnnotationComposer get assessment {
    final $AssessmentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assessment,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AssessmentsAnnotationComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get actor {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actor,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AssessmentEventsTableManager
    extends
        RootTableManager<
          _$Database,
          AssessmentEvents,
          AssessmentEvent,
          $AssessmentEventsFilterComposer,
          $AssessmentEventsOrderingComposer,
          $AssessmentEventsAnnotationComposer,
          $AssessmentEventsCreateCompanionBuilder,
          $AssessmentEventsUpdateCompanionBuilder,
          (AssessmentEvent, $AssessmentEventsReferences),
          AssessmentEvent,
          PrefetchHooks Function({bool assessment, bool actor})
        > {
  $AssessmentEventsTableManager(_$Database db, AssessmentEvents table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AssessmentEventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AssessmentEventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AssessmentEventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assessment = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssessmentEventsCompanion(
                id: id,
                assessment: assessment,
                actor: actor,
                message: message,
                created: created,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assessment,
                required String actor,
                required String message,
                required String created,
                Value<int> rowid = const Value.absent(),
              }) => AssessmentEventsCompanion.insert(
                id: id,
                assessment: assessment,
                actor: actor,
                message: message,
                created: created,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AssessmentEvents, AssessmentEvent>(table),
                  $AssessmentEventsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assessment = false, actor = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (assessment) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.assessment,
                        referencedTable: $AssessmentEventsReferences
                            ._assessmentTable(db),
                        referencedColumn: $AssessmentEventsReferences
                            ._assessmentTable(db)
                            .id,
                      ) as T;
                    }
                    if (actor) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.actor,
                        referencedTable: $AssessmentEventsReferences
                            ._actorTable(db),
                        referencedColumn: $AssessmentEventsReferences
                            ._actorTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AssessmentEventsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      AssessmentEvents,
      AssessmentEvent,
      $AssessmentEventsFilterComposer,
      $AssessmentEventsOrderingComposer,
      $AssessmentEventsAnnotationComposer,
      $AssessmentEventsCreateCompanionBuilder,
      $AssessmentEventsUpdateCompanionBuilder,
      (AssessmentEvent, $AssessmentEventsReferences),
      AssessmentEvent,
      PrefetchHooks Function({bool assessment, bool actor})
    >;
typedef $AbsenceJustificationsCreateCompanionBuilder =
    AbsenceJustificationsCompanion Function({
      required String id,
      required String lesson,
      required String enrollment,
      required String requester,
      required String reason,
      Value<String?> document,
      required String state,
      Value<String> response,
      Value<String?> reviewer,
      required String created,
      required String updated,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $AbsenceJustificationsUpdateCompanionBuilder =
    AbsenceJustificationsCompanion Function({
      Value<String> id,
      Value<String> lesson,
      Value<String> enrollment,
      Value<String> requester,
      Value<String> reason,
      Value<String?> document,
      Value<String> state,
      Value<String> response,
      Value<String?> reviewer,
      Value<String> created,
      Value<String> updated,
      Value<int> revision,
      Value<int> rowid,
    });

final class $AbsenceJustificationsReferences
    extends
        BaseReferences<
          _$Database,
          AbsenceJustifications,
          AbsenceJustification
        > {
  $AbsenceJustificationsReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static Users _requesterTable(_$Database db) =>
      db.users.createAlias('absence_justifications__requester__users__id');

  $UsersProcessedTableManager get requester {
    final $_column = $_itemColumn<String>('requester')!;

    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requesterTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Documents _documentTable(_$Database db) => db.documents.createAlias(
    'absence_justifications__document__documents__id',
  );

  $DocumentsProcessedTableManager? get document {
    final $_column = $_itemColumn<String>('document');
    if ($_column == null) return null;
    final manager = $DocumentsTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Users _reviewerTable(_$Database db) =>
      db.users.createAlias('absence_justifications__reviewer__users__id');

  $UsersProcessedTableManager? get reviewer {
    final $_column = $_itemColumn<String>('reviewer');
    if ($_column == null) return null;
    final manager = $UsersTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reviewerTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AbsenceJustificationsFilterComposer
    extends Composer<_$Database, AbsenceJustifications> {
  $AbsenceJustificationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lesson => $composableBuilder(
    column: $table.lesson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enrollment => $composableBuilder(
    column: $table.enrollment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get response => $composableBuilder(
    column: $table.response,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $UsersFilterComposer get requester {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requester,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DocumentsFilterComposer get document {
    final $DocumentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.document,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersFilterComposer get reviewer {
    final $UsersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reviewer,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AbsenceJustificationsOrderingComposer
    extends Composer<_$Database, AbsenceJustifications> {
  $AbsenceJustificationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lesson => $composableBuilder(
    column: $table.lesson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enrollment => $composableBuilder(
    column: $table.enrollment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get response => $composableBuilder(
    column: $table.response,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updated => $composableBuilder(
    column: $table.updated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $UsersOrderingComposer get requester {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requester,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DocumentsOrderingComposer get document {
    final $DocumentsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.document,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersOrderingComposer get reviewer {
    final $UsersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reviewer,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AbsenceJustificationsAnnotationComposer
    extends Composer<_$Database, AbsenceJustifications> {
  $AbsenceJustificationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lesson =>
      $composableBuilder(column: $table.lesson, builder: (column) => column);

  GeneratedColumn<String> get enrollment => $composableBuilder(
    column: $table.enrollment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get response =>
      $composableBuilder(column: $table.response, builder: (column) => column);

  GeneratedColumn<String> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get updated =>
      $composableBuilder(column: $table.updated, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $UsersAnnotationComposer get requester {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requester,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DocumentsAnnotationComposer get document {
    final $DocumentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.document,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DocumentsAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsersAnnotationComposer get reviewer {
    final $UsersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reviewer,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsersAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AbsenceJustificationsTableManager
    extends
        RootTableManager<
          _$Database,
          AbsenceJustifications,
          AbsenceJustification,
          $AbsenceJustificationsFilterComposer,
          $AbsenceJustificationsOrderingComposer,
          $AbsenceJustificationsAnnotationComposer,
          $AbsenceJustificationsCreateCompanionBuilder,
          $AbsenceJustificationsUpdateCompanionBuilder,
          (AbsenceJustification, $AbsenceJustificationsReferences),
          AbsenceJustification,
          PrefetchHooks Function({bool requester, bool document, bool reviewer})
        > {
  $AbsenceJustificationsTableManager(_$Database db, AbsenceJustifications table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AbsenceJustificationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AbsenceJustificationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AbsenceJustificationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lesson = const Value.absent(),
                Value<String> enrollment = const Value.absent(),
                Value<String> requester = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> document = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> response = const Value.absent(),
                Value<String?> reviewer = const Value.absent(),
                Value<String> created = const Value.absent(),
                Value<String> updated = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbsenceJustificationsCompanion(
                id: id,
                lesson: lesson,
                enrollment: enrollment,
                requester: requester,
                reason: reason,
                document: document,
                state: state,
                response: response,
                reviewer: reviewer,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lesson,
                required String enrollment,
                required String requester,
                required String reason,
                Value<String?> document = const Value.absent(),
                required String state,
                Value<String> response = const Value.absent(),
                Value<String?> reviewer = const Value.absent(),
                required String created,
                required String updated,
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AbsenceJustificationsCompanion.insert(
                id: id,
                lesson: lesson,
                enrollment: enrollment,
                requester: requester,
                reason: reason,
                document: document,
                state: state,
                response: response,
                reviewer: reviewer,
                created: created,
                updated: updated,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AbsenceJustifications, AbsenceJustification>(
                    table,
                  ),
                  $AbsenceJustificationsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({requester = false, document = false, reviewer = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (requester) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.requester,
                            referencedTable: $AbsenceJustificationsReferences
                                ._requesterTable(db),
                            referencedColumn: $AbsenceJustificationsReferences
                                ._requesterTable(db)
                                .id,
                          ) as T;
                        }
                        if (document) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.document,
                            referencedTable: $AbsenceJustificationsReferences
                                ._documentTable(db),
                            referencedColumn: $AbsenceJustificationsReferences
                                ._documentTable(db)
                                .id,
                          ) as T;
                        }
                        if (reviewer) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reviewer,
                            referencedTable: $AbsenceJustificationsReferences
                                ._reviewerTable(db),
                            referencedColumn: $AbsenceJustificationsReferences
                                ._reviewerTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $AbsenceJustificationsProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      AbsenceJustifications,
      AbsenceJustification,
      $AbsenceJustificationsFilterComposer,
      $AbsenceJustificationsOrderingComposer,
      $AbsenceJustificationsAnnotationComposer,
      $AbsenceJustificationsCreateCompanionBuilder,
      $AbsenceJustificationsUpdateCompanionBuilder,
      (AbsenceJustification, $AbsenceJustificationsReferences),
      AbsenceJustification,
      PrefetchHooks Function({bool requester, bool document, bool reviewer})
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $UsersTableManager get users => $UsersTableManager(_db, _db.users);
  $FoldersTableManager get folders => $FoldersTableManager(_db, _db.folders);
  $DocumentsTableManager get documents =>
      $DocumentsTableManager(_db, _db.documents);
  $DocumentTemplatesTableManager get documentTemplates =>
      $DocumentTemplatesTableManager(_db, _db.documentTemplates);
  $StudentsTableManager get students =>
      $StudentsTableManager(_db, _db.students);
  $RequestsTableManager get requests =>
      $RequestsTableManager(_db, _db.requests);
  $EventsTableManager get events => $EventsTableManager(_db, _db.events);
  $AttachmentsTableManager get attachments =>
      $AttachmentsTableManager(_db, _db.attachments);
  $RequirementsTableManager get requirements =>
      $RequirementsTableManager(_db, _db.requirements);
  $CredentialsTableManager get credentials =>
      $CredentialsTableManager(_db, _db.credentials);
  $SessionsTableManager get sessions =>
      $SessionsTableManager(_db, _db.sessions);
  $StudentAccessTableManager get studentAccess =>
      $StudentAccessTableManager(_db, _db.studentAccess);
  $CoursesTableManager get courses => $CoursesTableManager(_db, _db.courses);
  $ClassGroupsTableManager get classGroups =>
      $ClassGroupsTableManager(_db, _db.classGroups);
  $EnrollmentsTableManager get enrollments =>
      $EnrollmentsTableManager(_db, _db.enrollments);
  $EnrollmentEventsTableManager get enrollmentEvents =>
      $EnrollmentEventsTableManager(_db, _db.enrollmentEvents);
  $SubjectsTableManager get subjects =>
      $SubjectsTableManager(_db, _db.subjects);
  $CourseComponentsTableManager get courseComponents =>
      $CourseComponentsTableManager(_db, _db.courseComponents);
  $JournalsTableManager get journals =>
      $JournalsTableManager(_db, _db.journals);
  $LessonsTableManager get lessons => $LessonsTableManager(_db, _db.lessons);
  $AttendanceTableManager get attendance =>
      $AttendanceTableManager(_db, _db.attendance);
  $LessonEventsTableManager get lessonEvents =>
      $LessonEventsTableManager(_db, _db.lessonEvents);
  $TeacherProfilesTableManager get teacherProfiles =>
      $TeacherProfilesTableManager(_db, _db.teacherProfiles);
  $TimetableSlotsTableManager get timetableSlots =>
      $TimetableSlotsTableManager(_db, _db.timetableSlots);
  $AssessmentsTableManager get assessments =>
      $AssessmentsTableManager(_db, _db.assessments);
  $GradesTableManager get grades => $GradesTableManager(_db, _db.grades);
  $AssessmentEventsTableManager get assessmentEvents =>
      $AssessmentEventsTableManager(_db, _db.assessmentEvents);
  $AbsenceJustificationsTableManager get absenceJustifications =>
      $AbsenceJustificationsTableManager(_db, _db.absenceJustifications);
}
