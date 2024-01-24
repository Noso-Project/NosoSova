import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:nososova/models/address_wallet.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  String nameFileSummary = "sumary.psk";

  /// Save summary file
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
            final outputStream = OutputFileStream('${directory.path}/${file.name}');
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
        print("Save Summary: $e");
      }
      return null;
    }
  }

  Future<bool> saveWallet(List<Address> listAddresses, String filePath) async {
    return false;
  }

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
