import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:noso_dart/models/noso/address_object.dart';

import '../path_app_rpc.dart';

class BackupService {
  static Future<void> writeBackup(List<AddressObject> data) async {
    List<Map<String, dynamic>> mappedData =
        data.map((address) => _toJson(address)).toList();
    await _writeBackupInIsolate(mappedData);
  }

  static Future<void> _writeBackupInIsolate(
      List<Map<String, dynamic>> data) async {
    String backupDirPath = '${PathAppRpcUtil.getAppPath()}/backups';
    String backupFilePath = '$backupDirPath/backup_addresses.json';

    // Create the backup directory if it doesn't exist
    await Directory(backupDirPath).create(recursive: true);

    // Check if the backup file exists
    File backupFile = File(backupFilePath);
    bool fileExists = await backupFile.exists();

    List<dynamic> existingData = [];
    if (fileExists) {
      try {
        String existingContent = await backupFile.readAsString();
        existingData = jsonDecode(existingContent);
      } catch (e) {
        // if (kDebugMode) {
        print('Error reading or parsing existing content: $e');
        //  }
      }
    }

    List<dynamic> newData = data.map((mapData) => mapData).toList();

    List<dynamic> combinedData = [...existingData, ...newData];

    String jsonData = jsonEncode(combinedData);

    await backupFile.writeAsString(jsonData);
  }

  static Map<String, dynamic> _toJson(AddressObject addressObject) {
    return {
      "hash": addressObject.hash,
      "public": addressObject.publicKey,
      "private": addressObject.privateKey,
    };
  }
}
