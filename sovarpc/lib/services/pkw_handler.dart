import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:noso_dart/handlers/files_handler.dart';
import 'package:nososova/models/address_wallet.dart';

class PkwHandler {
  static void isolateImport(SendPort mainSendPort) async {
    ReceivePort childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for (var message in childReceivePort) {
      var path = message[0];
      var replyPort = message[1];
      try {
        var bytes = await readBytesFromPlatformFile(path);
        var listAddress =
            FileHandler.readExternalWallet(bytes, isIngoreVerification: true) ??
                [];
        final bool listNotEmpty = listAddress.isNotEmpty;
        replyPort.send([
          listNotEmpty ? listAddress.length : 0,
          listNotEmpty ? true : false,
          listNotEmpty ? listAddress : []
        ]);
      } catch (e) {
        replyPort.send([0, false, []]);
      }
    }
  }

  static void isolateExport(SendPort mainSendPort) async {
    ReceivePort childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for (var message in childReceivePort) {
      var serializedAddresses = message[0];
      var path = message[1];
      var replyPort = message[2];

      try {
        var exportTrue = await saveWallet(serializedAddresses, path);
        replyPort.send([exportTrue, serializedAddresses.length]);
      } catch (e) {
        replyPort.send([false, 0]);
      }
    }
  }

  static Future<bool> saveWallet(
      List<Address> listAddresses, String filePath) async {
    try {
      File walletFile = await File(filePath).create(recursive: true);
      List<int>? bytes = FileHandler.writeWalletFile(listAddresses);

      if (bytes == null) {
        return false;
      }
      walletFile.writeAsBytesSync(Uint8List.fromList(bytes));

      if (kDebugMode) {
        print('Wallet file written - OK');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Unable to export wallet file - ERR $e');
      }
      return false;
    }
  }

  static Future<Uint8List> readBytesFromPlatformFile(String path) async {
    try {
      File file = File(path);
      final byteData = await file.readAsBytes();
      return byteData.buffer.asUint8List();
    } catch (e) {
      if (kDebugMode) {
        print('Error reading file: $e');
      }
      return Uint8List(0);
    }
  }
}
