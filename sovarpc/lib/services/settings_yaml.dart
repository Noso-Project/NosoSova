import 'dart:io';

import 'package:settings_yaml/settings_yaml.dart';

import '../const.dart';
import '../di.dart';

class SettingsYamlHandler {
  Future<SettingsYaml?> loadConfig() async {
    String backupDirPath = '${locator<AppPath>()}/${Const.BACK_CONFIG_FILE}';
    final File configFile = File(backupDirPath);
    if (!configFile.existsSync()) {
      try {
        Directory directory = Directory(locator<AppPath>());
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        var settings = SettingsYaml.load(pathToSettings: backupDirPath);
        settings['nodesList'] = "";
        settings['lastSeed'] = "";
        settings.save();
        return settings;
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  Future<void> saveConfig({String nodesList = "", String lastSeed = ""}) async {
    Directory directory = Directory(locator<AppPath>());
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String backupDirPath = '${locator<AppPath>()}/${Const.BACK_CONFIG_FILE}';

    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (nodesList.isNotEmpty) {
      settings['nodesList'] = nodesList;
    }
    if (lastSeed.isNotEmpty) {
      settings['lastSeed'] = lastSeed;
    }
    settings.save();
  }
}
