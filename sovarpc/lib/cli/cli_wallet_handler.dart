import 'dart:io';

import 'package:noso_dart/handlers/address_handler.dart';
import 'package:noso_dart/handlers/files_handler.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/database/database.dart';
import 'package:sovarpc/cli/loading.dart';
import 'package:sovarpc/cli/pen.dart';
import 'package:sovarpc/services/pkw_handler.dart';

import '../services/settings_yaml.dart';
import '../utils/path_app_rpc.dart';

class CliWalletHandler {
  help(String usage) {
    stdout.writeln('Wallet commands:\n$usage');
  }

  importAddresses(String walletName) async {
    stdout.writeln('Importing addresses from: $walletName');
    var loading = LoadingCli.loading();
    await Future.delayed(const Duration(seconds: 5));

    File file = File(walletName);
    final byteData = await file.readAsBytes();
    final listAddress = FileHandler.readExternalWallet(
            byteData.buffer.asUint8List(),
            isIngoreVerification: true) ??
        [];

    var database = MyDatabase(PathAppRpcUtil.getAppPath());

    await database.addAddresses(listAddress);
    database.close();

    if (listAddress.isNotEmpty) {
      stdout.writeln('\rImported ${listAddress.length} addresses!');
    } else {
      stdout.writeln('\rError importing addresses!');
    }

    loading.cancel();

    return;
  }

  exportWallet() async {
    var fileName = "walletBackup_${DateTime.now().millisecondsSinceEpoch ~/ 1000}.pkw";
    stdout.writeln('Export addresses from: $fileName');

    var database = MyDatabase(PathAppRpcUtil.getAppPath());
    var listAddresses = await database.fetchTotalAddresses();
    database.close();

    if (listAddresses.isEmpty) {
      stdout.writeln(Pen().red('\rAddress export error, no addresses in the database'));
      return;
    }

    var loading = LoadingCli.loading();
    await Future.delayed(const Duration(seconds: 5));



    var exportTrue = await PkwHandler.saveWallet(listAddresses, fileName);


    if (exportTrue) {
      stdout.writeln(Pen().greenText('\rExported ${listAddresses.length} addresses, from $fileName'));
    } else {
      stdout.writeln(Pen().red('\rAddress export error'));
    }

    loading.cancel();

    return;
  }

  Future<void> setPaymentAddress(String paymentHash) async {
    var settings =
        await SettingsYamlHandler(PathAppRpcUtil.getAppPath()).checkConfig();
    if (settings == null) {
      stdout.writeln('${PathAppRpcUtil.shared_config} not found...');
      stdout.writeln('Please use: --config: Create/Check configuration');
      return;
    }

    var database = MyDatabase(PathAppRpcUtil.getAppPath());
    var isLocalAddress = await database.isLocalAddress(paymentHash);

    if (isLocalAddress) {
      SettingsYamlHandler(PathAppRpcUtil.getAppPath())
          .saveDefaultPaymentAddress(paymentHash);
      stdout.writeln(
          Pen().greenText('Billing address has been updated: $paymentHash'));
    } else {
      stdout.writeln(Pen().red('Address is not local, changes have been made'));
    }

    database.close();
    return;
  }

  Future<void> getWalletInfo() async {
    var database = MyDatabase(PathAppRpcUtil.getAppPath());
    var listAddress = await database.fetchTotalAddresses();

    var defaultAddress = await SettingsYamlHandler(PathAppRpcUtil.getAppPath())
        .loadDefaultPaymentAddress();

    stdout.writeln(Pen().greenText('Wallet info:\n'
        'Count addresses: ${listAddress.length} \n'
        'Payment Address: $defaultAddress'));

    database.close();
    return;
  }

  Future<void> getListAddress() async {
    var database = MyDatabase(PathAppRpcUtil.getAppPath());
    var listAddress = await database.fetchTotalAddressHashes();

    stdout.writeln(Pen().greenBg('All local Noso addresses:'));
    stdout.writeln(listAddress.toString());

    database.close();
    return;
  }

  Future<void> getListAddressFull() async {
    var database = MyDatabase(PathAppRpcUtil.getAppPath());
    var listAddress = await database.fetchTotalAddresses();

    stdout.writeln(Pen().greenBg('All local Noso addresses:'));
    stdout.writeln(listAddress
        .map((address) => {
              "hash": address.hash,
              "public": address.publicKey,
              "private": address.privateKey,
            })
        .toList());

    database.close();
    return;
  }

  Future<void> getNewAddress(bool isSave) async {
    AddressObject address = AddressHandler.createNewAddress();
    if (!isSave) {
      var database = MyDatabase(PathAppRpcUtil.getAppPath());
      await database.addAddress(address);
      database.close();
    }
    try {
      stdout.writeln(Pen().greenText({
        'hash': address.hash,
        'publicKey': address.publicKey,
        'privateKey': address.privateKey,
      }));
      return;
    } catch (e) {
      stdout.writeln(Pen().red('Error creating a new address'));
      return;
    }
  }

  Future<void> isLocalAddress(String hash) async {
    var database = MyDatabase(PathAppRpcUtil.getAppPath());
    var isLocal = await database.isLocalAddress(hash);

    if (isLocal) {
      stdout.writeln(Pen().greenText('$hash available in the local wallet'));
    } else {
      stdout.writeln(Pen().red('$hash not in the local wallet'));
    }

    database.close();
    return;
  }
}
