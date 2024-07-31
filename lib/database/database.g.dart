// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AddressesTable extends Addresses
    with TableInfo<$AddressesTable, Address> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _publicKeyMeta =
      const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _privateKeyMeta =
      const VerificationMeta('privateKey');
  @override
  late final GeneratedColumn<String> privateKey = GeneratedColumn<String>(
      'private_key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _customMeta = const VerificationMeta('custom');
  @override
  late final GeneratedColumn<String> custom = GeneratedColumn<String>(
      'custom', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [publicKey, privateKey, hash, custom, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'addresses';
  @override
  VerificationContext validateIntegrity(Insertable<Address> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('private_key')) {
      context.handle(
          _privateKeyMeta,
          privateKey.isAcceptableOrUnknown(
              data['private_key']!, _privateKeyMeta));
    } else if (isInserting) {
      context.missing(_privateKeyMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('custom')) {
      context.handle(_customMeta,
          custom.isAcceptableOrUnknown(data['custom']!, _customMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hash};
  @override
  Address map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Address(
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
      custom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom']),
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key'])!,
      privateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}private_key'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $AddressesTable createAlias(String alias) {
    return $AddressesTable(attachedDatabase, alias);
  }
}

class AddressesCompanion extends UpdateCompanion<Address> {
  final Value<String> publicKey;
  final Value<String> privateKey;
  final Value<String> hash;
  final Value<String?> custom;
  final Value<String?> description;
  final Value<int> rowid;
  const AddressesCompanion({
    this.publicKey = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.hash = const Value.absent(),
    this.custom = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AddressesCompanion.insert({
    required String publicKey,
    required String privateKey,
    required String hash,
    this.custom = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : publicKey = Value(publicKey),
        privateKey = Value(privateKey),
        hash = Value(hash);
  static Insertable<Address> createCustom({
    Expression<String>? publicKey,
    Expression<String>? privateKey,
    Expression<String>? hash,
    Expression<String>? custom,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (publicKey != null) 'public_key': publicKey,
      if (privateKey != null) 'private_key': privateKey,
      if (hash != null) 'hash': hash,
      if (custom != null) 'custom': custom,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AddressesCompanion copyWith(
      {Value<String>? publicKey,
      Value<String>? privateKey,
      Value<String>? hash,
      Value<String?>? custom,
      Value<String?>? description,
      Value<int>? rowid}) {
    return AddressesCompanion(
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
      hash: hash ?? this.hash,
      custom: custom ?? this.custom,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (privateKey.present) {
      map['private_key'] = Variable<String>(privateKey.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (custom.present) {
      map['custom'] = Variable<String>(custom.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddressesCompanion(')
          ..write('publicKey: $publicKey, ')
          ..write('privateKey: $privateKey, ')
          ..write('hash: $hash, ')
          ..write('custom: $custom, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactTable extends Contact
    with TableInfo<$ContactTable, ContactModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, alias, hash];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact';
  @override
  VerificationContext validateIntegrity(Insertable<ContactModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
    );
  }

  @override
  $ContactTable createAlias(String alias) {
    return $ContactTable(attachedDatabase, alias);
  }
}

class ContactCompanion extends UpdateCompanion<ContactModel> {
  final Value<int> id;
  final Value<String> alias;
  final Value<String> hash;
  const ContactCompanion({
    this.id = const Value.absent(),
    this.alias = const Value.absent(),
    this.hash = const Value.absent(),
  });
  ContactCompanion.insert({
    this.id = const Value.absent(),
    required String alias,
    required String hash,
  })  : alias = Value(alias),
        hash = Value(hash);
  static Insertable<ContactModel> custom({
    Expression<int>? id,
    Expression<String>? alias,
    Expression<String>? hash,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alias != null) 'alias': alias,
      if (hash != null) 'hash': hash,
    });
  }

  ContactCompanion copyWith(
      {Value<int>? id, Value<String>? alias, Value<String>? hash}) {
    return ContactCompanion(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactCompanion(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $AddressesTable addresses = $AddressesTable(this);
  late final $ContactTable contact = $ContactTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [addresses, contact];
}

typedef $$AddressesTableCreateCompanionBuilder = AddressesCompanion Function({
  required String publicKey,
  required String privateKey,
  required String hash,
  Value<String?> custom,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$AddressesTableUpdateCompanionBuilder = AddressesCompanion Function({
  Value<String> publicKey,
  Value<String> privateKey,
  Value<String> hash,
  Value<String?> custom,
  Value<String?> description,
  Value<int> rowid,
});

class $$AddressesTableTableManager extends RootTableManager<
    _$MyDatabase,
    $AddressesTable,
    Address,
    $$AddressesTableFilterComposer,
    $$AddressesTableOrderingComposer,
    $$AddressesTableCreateCompanionBuilder,
    $$AddressesTableUpdateCompanionBuilder> {
  $$AddressesTableTableManager(_$MyDatabase db, $AddressesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AddressesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AddressesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> publicKey = const Value.absent(),
            Value<String> privateKey = const Value.absent(),
            Value<String> hash = const Value.absent(),
            Value<String?> custom = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AddressesCompanion(
            publicKey: publicKey,
            privateKey: privateKey,
            hash: hash,
            custom: custom,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String publicKey,
            required String privateKey,
            required String hash,
            Value<String?> custom = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AddressesCompanion.insert(
            publicKey: publicKey,
            privateKey: privateKey,
            hash: hash,
            custom: custom,
            description: description,
            rowid: rowid,
          ),
        ));
}

class $$AddressesTableFilterComposer
    extends FilterComposer<_$MyDatabase, $AddressesTable> {
  $$AddressesTableFilterComposer(super.$state);
  ColumnFilters<String> get publicKey => $state.composableBuilder(
      column: $state.table.publicKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get privateKey => $state.composableBuilder(
      column: $state.table.privateKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hash => $state.composableBuilder(
      column: $state.table.hash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get custom => $state.composableBuilder(
      column: $state.table.custom,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AddressesTableOrderingComposer
    extends OrderingComposer<_$MyDatabase, $AddressesTable> {
  $$AddressesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get publicKey => $state.composableBuilder(
      column: $state.table.publicKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get privateKey => $state.composableBuilder(
      column: $state.table.privateKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hash => $state.composableBuilder(
      column: $state.table.hash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get custom => $state.composableBuilder(
      column: $state.table.custom,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ContactTableCreateCompanionBuilder = ContactCompanion Function({
  Value<int> id,
  required String alias,
  required String hash,
});
typedef $$ContactTableUpdateCompanionBuilder = ContactCompanion Function({
  Value<int> id,
  Value<String> alias,
  Value<String> hash,
});

class $$ContactTableTableManager extends RootTableManager<
    _$MyDatabase,
    $ContactTable,
    ContactModel,
    $$ContactTableFilterComposer,
    $$ContactTableOrderingComposer,
    $$ContactTableCreateCompanionBuilder,
    $$ContactTableUpdateCompanionBuilder> {
  $$ContactTableTableManager(_$MyDatabase db, $ContactTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ContactTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ContactTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<String> hash = const Value.absent(),
          }) =>
              ContactCompanion(
            id: id,
            alias: alias,
            hash: hash,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String alias,
            required String hash,
          }) =>
              ContactCompanion.insert(
            id: id,
            alias: alias,
            hash: hash,
          ),
        ));
}

class $$ContactTableFilterComposer
    extends FilterComposer<_$MyDatabase, $ContactTable> {
  $$ContactTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get alias => $state.composableBuilder(
      column: $state.table.alias,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hash => $state.composableBuilder(
      column: $state.table.hash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ContactTableOrderingComposer
    extends OrderingComposer<_$MyDatabase, $ContactTable> {
  $$ContactTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get alias => $state.composableBuilder(
      column: $state.table.alias,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hash => $state.composableBuilder(
      column: $state.table.hash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$AddressesTableTableManager get addresses =>
      $$AddressesTableTableManager(_db, _db.addresses);
  $$ContactTableTableManager get contact =>
      $$ContactTableTableManager(_db, _db.contact);
}
