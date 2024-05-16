import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:noso_dart/handlers/files_handler.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:nososova/models/address_wallet.dart';

class FileServiceRpc {
  String nameFileSummary;
  String pathApp;

  FileServiceRpc(this.pathApp, {this.nameFileSummary = "sumary.psk"});

  Future<bool> saveSummary(List<int> bytesValue) async {
    if (bytesValue.isEmpty) {
      return false;
    }

    final Uint8List bytes = Uint8List.fromList(bytesValue);

    try {
      int breakpoint = NosoUtility.removeZipHeaderPsk(bytes);

      if (breakpoint != 0) {
        final Uint8List modifiedBytes = bytes.sublist(breakpoint);
        var archive = ZipDecoder().decodeBytes(modifiedBytes);

        for (var file in archive.files) {
          if (file.isFile) {
            final outputStream =
                OutputFileStream('$pathApp/data/$nameFileSummary');
            file.writeContent(outputStream);
            outputStream.close();
          }
        }
        archive.clear();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Uint8List?> loadSummary() async {
    try {
      final filePsk = File("$pathApp/data/$nameFileSummary");
      if (filePsk.existsSync()) {
        return await filePsk.readAsBytes();
      } else {
        print('File not found');
      }
      return null;
    } catch (e) {
      print("Load Summary: $e");

      return null;
    }
  }

  Future<bool> saveWallet(List<Address> listAddresses, String filePath) async {
    try {
      File walletFile = await File(filePath).create(recursive: true);
      List<int>? bytes = FileHandler.writeWalletFile(listAddresses);

      if (bytes == null) {
        return false;
      }
      walletFile.writeAsBytesSync(Uint8List.fromList(bytes));

      print('Wallet file written - OK');

      return true;
    } catch (e) {
      print('Unable to export wallet file - ERR $e');

      return false;
    }
  }
}
