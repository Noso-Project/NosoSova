import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/database/address.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/address_wallet.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Addresses])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  Stream<List<Address>> fetchAddresses() => select(addresses).watch();

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
    // await into(addresses).insertOnConflictUpdate(insertable);
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

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    String dbFolder;
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      var path = await getApplicationDocumentsDirectory();
      dbFolder = "${path.path}/NosoSova";
    } else {
      var path = await getApplicationDocumentsDirectory();
      dbFolder = path.path;
    }
    final file = File(p.join(dbFolder, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
