import 'dart:io';

import 'package:noso_dart/handlers/files_handler.dart';
import 'package:nososova/database/database.dart';
import 'package:sovarpc/cli/loading.dart';

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
    await Future.forEach(listAddress, (dynamic address) async {
      database.addAddress(address);
    });
    database.close();

    if (listAddress.isNotEmpty) {
      stdout.write('\rImported ${listAddress.length} addresses!');
    } else {
      stdout.write('\rError importing addresses!');
    }
    loading.cancel();
  //  stdout.close();
    return;
  }
}
