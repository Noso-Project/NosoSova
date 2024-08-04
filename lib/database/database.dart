import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/database/address.dart';
import 'package:path/path.dart' as p;

import '../../models/address_wallet.dart';
import '../models/contact.dart';
import 'contact.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Addresses, Contact])
class MyDatabase extends _$MyDatabase {
  final String pathDatabase;

  MyDatabase(this.pathDatabase) : super(_openConnection(pathDatabase));

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from == 1 && to == 2) {
          const sql = """
          CREATE TABLE contact (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            alias TEXT CHECK(LENGTH(alias) >= 1 AND LENGTH(alias) <= 50),
            hash TEXT CHECK(LENGTH(hash) >= 1 AND LENGTH(hash) <= 100)
          );""";
          await m.issueCustomQuery(sql);
        }
        if (from <= 2 && to == 3) {
          await m.addColumn(
              addresses, addresses.description as GeneratedColumn<Object>);
        }
      },
    );
  }

  Stream<List<Address>> fetchAddresses() => select(addresses).watch();

  Stream<List<ContactModel>> fetchContacts() => select(contact).watch();

  Future<AddressObject?> fetchAddress(String hash) async {
    final addressesList =
        await (select(addresses)..where((t) => t.hash.equals(hash))).get();
    return addressesList.isNotEmpty ? addressesList.first : null;
  }

  Future<void> addAddress(AddressObject value) async {
    await batch((batch) {
      batch.insert(
          addresses,
          AddressesCompanion(
            publicKey: Value(value.publicKey),
            privateKey: Value(value.privateKey),
            hash: Value(value.hash),
          ),
          mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> addAddresses(List<AddressObject> value) async {
    var insertable = value.map((address) {
      return AddressesCompanion(
        publicKey: Value(address.publicKey),
        privateKey: Value(address.privateKey),
        hash: Value(address.hash),
      );
    }).toList();
    await batch((batch) {
      batch.insertAll(addresses, insertable, mode: InsertMode.insertOrIgnore);
    });
  }

  Future<void> deleteWallet(Address value) async {
    final insertable = AddressesCompanion(
      publicKey: Value(value.publicKey),
      privateKey: Value(value.privateKey),
      hash: Value(value.hash),
    );
    await delete(addresses).delete(insertable);
  }

  Future<void> updateAddressDescription(
      String hash, String? newDescription) async {
    await (update(addresses)..where((t) => t.hash.equals(hash))).write(
      AddressesCompanion(description: Value(newDescription)),
    );
  }

  Future<void> addContact(ContactModel value) async {
    await batch((batch) {
      batch.insert(contact,
          ContactCompanion(hash: Value(value.hash), alias: Value(value.alias)));
    });
  }

  Future<void> deleteContact(ContactModel value) async {
    await batch((batch) {
      batch.delete(
          contact,
          ContactCompanion(
              id: Value(value.id),
              hash: Value(value.hash),
              alias: Value(value.alias)));
    });
  }

  @override
  int get schemaVersion => 3;
}

LazyDatabase _openConnection(String connectionString) {
  var nameDatabase = 'db.sqlite';

  return LazyDatabase(() async {
    String dbFolder;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      dbFolder = "$connectionString/database";
    } else {
      dbFolder = connectionString;
    }

    final file = File(p.join(dbFolder, nameDatabase));

    return NativeDatabase.createInBackground(file);
  });
}
