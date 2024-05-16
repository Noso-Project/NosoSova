import 'dart:io';

import 'package:settings_yaml/settings_yaml.dart';

import '../const.dart';

class SettingsYamlHandler {
  String pathApp;

  SettingsYamlHandler(this.pathApp);

  Future<SettingsYaml> loadConfig() async {
    String backupDirPath = '$pathApp/${Const.BACK_CONFIG_FILE}';
    final File configFile = File(backupDirPath);
    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (!configFile.existsSync()) {
      settings['nodesList'] = "";
      settings['lastSeed'] = "";
      settings.save();
      return settings;
    }

    return settings;
  }

  Future<void> saveConfig({String nodesList = "", String lastSeed = ""}) async {
    String backupDirPath = '$pathApp/${Const.BACK_CONFIG_FILE}';

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
