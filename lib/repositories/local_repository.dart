import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/database/database.dart';

import '../../models/address_wallet.dart';
import '../models/contact.dart';

class LocalRepository {
  final MyDatabase _database;

  LocalRepository(this._database);

  Stream<List<ContactModel>> fetchContacts() => _database.fetchContacts();

  Stream<List<Address>> fetchAddress() => _database.fetchAddresses();

  Future<void> deleteAddress(Address value) async {
    await _database.deleteWallet(value);
  }

  Future<void> addAddress(AddressObject value) async {
    await _database.addAddress(value);
  }

  Future<void> editDescription(String hash, String? newDescription) async {
    await _database.updateAddressDescription(hash,newDescription);
  }

  Future<void> addAddresses(List<AddressObject> value) async {
    await _database.addAddresses(value);
  }

  Future<void> addContact(ContactModel value) async {
    await _database.addContact(value);
  }

  Future<void> deleteContact(ContactModel value) async {
    await _database.deleteContact(value);
  }
}
