import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:noso_dart/handlers/files_handler.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:nososova/models/address_wallet.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  String nameFileSummary = "sumary.psk";

  /// Saves a summary file by writing the provided [bytesValue] to the application support directory.
  /// The method checks for a ZIP header in the byte array, removes it, and then extracts the files
  /// from the modified byte array to the specified directory.
  ///
  /// Parameters:
  /// - `bytesValue`: The list of bytes representing the summary file.
  ///
  /// Returns:
  /// A boolean indicating whether the operation was successful.
  Future<bool> saveSummary(List<int> bytesValue) async {
    if (bytesValue.isEmpty) {
      return false;
    }

    final Uint8List bytes = Uint8List.fromList(bytesValue);

    try {
      final directory = await getApplicationSupportDirectory();
      int breakpoint = NosoUtility.removeZipHeaderPsk(bytes);

      if (breakpoint != 0) {
        final Uint8List modifiedBytes = bytes.sublist(breakpoint);
        var archive = ZipDecoder().decodeBytes(modifiedBytes);

        for (var file in archive.files) {
          if (file.isFile) {
            final outputStream =
                OutputFileStream('${directory.path}/${file.name}');
            file.writeContent(outputStream);
            outputStream.close();
          }
        }
        archive.clear();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Save Summary Exception: $e");
      }

      return false;
    }
  }

  /// Loads a summary file by reading its contents from the application support directory.
  ///
  /// Returns:
  /// A [Uint8List] containing the byte array of the loaded summary file, or null if the file is not found.
  Future<Uint8List?> loadSummary() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final filePsk = File("${directory.path}/data/$nameFileSummary");
      if (filePsk.existsSync()) {
        return await filePsk.readAsBytes();
      } else {
        if (kDebugMode) {
          print('File not found');
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Load Summary: $e");
      }
      return null;
    }
  }

  /// Saves a wallet file by writing the data of the provided [listAddresses] to the specified [filePath].
  ///
  /// Parameters:
  /// - `listAddresses`: The list of [Address] objects to be written to the wallet file.
  /// - `filePath`: The file path where the wallet file will be saved.
  ///
  /// Returns:
  /// A boolean indicating whether the operation was successful.
  Future<bool> saveWallet(List<Address> listAddresses, String filePath) async {
    try {
      File walletFile = File(filePath);
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

  /// Reads the byte data from the provided [platformFile].
  ///
  /// Parameters:
  /// - `platformFile`: The [PlatformFile] from which to read the byte data.
  ///
  /// Returns:
  /// A [Uint8List] containing the byte data of the read file.
  Future<Uint8List> readBytesFromPlatformFile(
      PlatformFile? platformFile) async {
    if (platformFile == null || platformFile.path == null) {
      return Uint8List(0);
    }
    try {
      File file = File(platformFile.path!);
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
