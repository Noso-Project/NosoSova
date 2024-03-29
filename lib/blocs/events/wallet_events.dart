import 'package:file_picker/file_picker.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:noso_dart/models/noso/pending.dart';

import '../../models/address_wallet.dart';
import '../../utils/enum.dart';

abstract class WalletEvent {}

/// Event for synchronizing the balance
class SyncBalance extends WalletEvent {
  final List<Pending> pendings;

  SyncBalance(this.pendings);
}

/// Event that deletes an address from the wallet
class DeleteAddress extends WalletEvent {
  final Address address;

  DeleteAddress(this.address);
}

/// Event that adds an address to the wallet
class AddAddress extends WalletEvent {
  final Address address;

  AddAddress(this.address);
}

/// Event that adds an address to the wallet
class AddAddresses extends WalletEvent {
  final List<AddressObject> addresses;

  AddAddresses(this.addresses);
}

/// Event that generates new addresses
class CreateNewAddress extends WalletEvent {
  CreateNewAddress();
}

/// Event that passes a wallet file for further parsing
class ImportWalletFile extends WalletEvent {
  final FilePickerResult? filePickerResult;

  ImportWalletFile(this.filePickerResult);
}

class ImportWalletQr extends WalletEvent {
  final String? addressKeys;

  ImportWalletQr(this.addressKeys);
}

class FetchHistoryAddress extends WalletEvent {
  final String value;

  FetchHistoryAddress(this.value);
}

class CleanDataAddress extends WalletEvent {}

class SetAlias extends WalletEvent {
  final String alias;
  final Address address;
  final int widgetId;

  SetAlias(this.alias, this.address, this.widgetId);
}

class SendOrder extends WalletEvent {
  final String receiver;
  final String message;
  final double amount;
  final Address address;
  final int widgetId;

  SendOrder(
      this.receiver, this.message, this.amount, this.address, this.widgetId);
}

class CalculateBalance extends WalletEvent {
  final List<Address>? address;
  final bool checkConsensus;

  CalculateBalance(this.checkConsensus, this.address);
}

class ErrorSync extends WalletEvent {
  ErrorSync();
}

class ExportWalletDialog extends WalletEvent {
  final FormatWalletFile formatFile;

  ExportWalletDialog(this.formatFile);
}

class ExportWallet extends WalletEvent {
  final String pathFile;

  ExportWallet(this.pathFile);
}
