import 'dart:io';

import 'package:settings_yaml/settings_yaml.dart';
import 'package:sovarpc/cli/pen.dart';

import '../const.dart';
import '../di.dart';
import '../models/config_app.dart';
import '../utils/path_app_rpc.dart';

class SettingsYamlHandler {
  Future<ConfigApp?> checkConfig() async {
    final File configFile = File(PathAppRpcUtil.shared_config);

    if (!configFile.existsSync()) {
      stdout.writeln(Pen().red('Config file not found. Creating a new one...'));
      try {
        var settings =
            SettingsYaml.load(pathToSettings: PathAppRpcUtil.shared_config);

        settings['ip'] = Const.DEFAULT_HOST;
        settings['port'] = Const.DEFAULT_PORT;
        settings['ignoreMethods'] = '';
        settings['logsLevel'] = "Release";

        settings.save();

        stdout
            .writeln(Pen().greenText('${PathAppRpcUtil.shared_config} created.'));
        return ConfigApp.copyYamlConfig(settings);
      } catch (e) {
        stdout.writeln('Error creating config file: $e');
        return null;
      }
    }
    var settings = ConfigApp.copyYamlConfig(
        SettingsYaml.load(pathToSettings: PathAppRpcUtil.shared_config));

    return settings;
  }

  Future<SettingsYaml?> loadConfig() async {
    String backupDirPath =
        '${locator<AppPath>()}/${PathAppRpcUtil.app_config_system}';
    final File configFile = File(backupDirPath);
    Directory directory = Directory(locator<AppPath>());
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (!configFile.existsSync()) {
      try {
        settings['nodesList'] = "";
        settings['lastSeed'] = "";
        settings.save();
        return settings;
      } catch (e) {
        print(e);
      }
    }

    return settings;
  }

  Future<List<String>> loadRpcConfig() async {
    String backupDirPath =
        '${locator<AppPath>()}/${PathAppRpcUtil.app_config_system}';
    final File configFile = File(backupDirPath);
    Directory directory = Directory(locator<AppPath>());
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (!configFile.existsSync()) {
      try {
        settings['rpcAddress'] = "";
        settings['ignoreMethods'] = "";
        settings.save();
        return [
          settings['rpcAddress'] ??
              "${Const.DEFAULT_HOST}:${Const.DEFAULT_PORT}",
          settings['ignoreMethods'] ?? ""
        ];
      } catch (e) {
        print(e);
      }
    }

    return [
      settings['rpcAddress'] ?? "${Const.DEFAULT_HOST}:${Const.DEFAULT_PORT}",
      settings['ignoreMethods'] ?? ""
    ];
  }

  Future<void> saveAppConfig(
      {String nodesList = "", String lastSeed = ""}) async {
    Directory directory = Directory(locator<AppPath>());
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String backupDirPath =
        '${locator<AppPath>()}/${PathAppRpcUtil.app_config_system}';

    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (nodesList.isNotEmpty) {
      settings['nodesList'] = nodesList;
    }
    if (lastSeed.isNotEmpty) {
      settings['lastSeed'] = lastSeed;
    }
    settings.save();
  }

  Future<void> saveRpcConfig(
      {String rpcAddress = "", String ignoreMethods = ""}) async {
    Directory directory = Directory(locator<AppPath>());
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String backupDirPath =
        '${locator<AppPath>()}/${PathAppRpcUtil.app_config_system}';

    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (rpcAddress.isNotEmpty) {
      settings['rpcAddress'] = rpcAddress;
    }
    if (ignoreMethods.isNotEmpty) {
      settings['ignoreMethods'] = ignoreMethods;
    }
    settings.save();
  }
}
