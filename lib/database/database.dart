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


      print(sourceFile.existsSync());
      if (!newFile.existsSync() && sourceFile.existsSync()) {
        File destinationFile = await newFile.create(recursive: true);
        await sourceFile.copy(destinationFile.path);

        print('File successfully moved to $destinationPath.');
      } else {
        print('SKIP NOT FOUND DB');
        return;
      }
    } catch (e) {
      print("Error move database $e");
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
      var path = await getApplicationDocumentsDirectory();
      dbFolder = path.path;
    }

    final file = File(p.join(dbFolder, nameDatabase));

    return NativeDatabase.createInBackground(file);
  });
}
