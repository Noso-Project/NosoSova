import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/database/address.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/address_wallet.dart';
import '../models/contact.dart';
import 'contact.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Addresses, Contact])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

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
      },
    );
  }

  Stream<List<Address>> fetchAddresses() => select(addresses).watch();

  Stream<List<ContactModel>> fetchContacts() => select(contact).watch();

  Future<void> addAddress(AddressObject value) async {
    await batch((batch) {
      batch.insert(
          addresses,
          AddressesCompanion(
            publicKey: Value(value.publicKey),
            privateKey: Value(value.privateKey),
            hash: Value(value.hash),
          ));
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
      batch.insertAll(addresses, insertable);
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
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() {
  var nameDatabase = 'db.sqlite';

  Future<void> moveDatabase() async {
    try {
      var pathDestin = Platform.isMacOS
          ? await getLibraryDirectory()
          : await getApplicationSupportDirectory();
      String destinationPath = "${pathDestin.path}/database";
      var path = await getApplicationDocumentsDirectory();
      final newFile = File('$destinationPath/$nameDatabase');
      File sourceFile = File(p.join("${path.path}/NosoSova", nameDatabase));

      if (kDebugMode) {
        print(sourceFile.existsSync());
      }
      if (!newFile.existsSync() && sourceFile.existsSync()) {
        File destinationFile = await newFile.create(recursive: true);
        await sourceFile.copy(destinationFile.path);

        if (kDebugMode) {
          print('File successfully moved to $destinationPath.');
        }
      } else {
        if (kDebugMode) {
          print('SKIP NOT FOUND DB');
        }
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error move database $e");
      }
    }
  }

  return LazyDatabase(() async {
    String dbFolder;

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      await moveDatabase();
      var path = Platform.isMacOS
          ? await getLibraryDirectory()
          : await getApplicationSupportDirectory();
      dbFolder = "${path.path}/database";
    } else {
      var path = await getApplicationSupportDirectory();
      dbFolder = path.path;
    }

    final file = File(p.join(dbFolder, nameDatabase));

    return NativeDatabase.createInBackground(file);
  });
}
