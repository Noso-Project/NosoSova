import 'dart:io';

import 'package:logging/logging.dart';
import 'package:settings_yaml/settings_yaml.dart';

import '../const.dart';
import '../di.dart';
import '../models/config_app.dart';
import '../path_app_rpc.dart';

class SettingsYamlHandler {
  Future<ConfigApp?> checkConfig(Logger logger) async {
    final File configFile = File(PathAppRpcUtil.shared_config);

    if (!configFile.existsSync()) {
      logger.info('Config file not found. Creating a new one...');
      try {
        var settings =
            SettingsYaml.load(pathToSettings: PathAppRpcUtil.shared_config);

        settings['ip'] = Const.DEFAULT_HOST;
        settings['port'] = Const.DEFAULT_PORT;
        settings['ignoreMethods'] = '';
        settings['logsLevel'] = "Release";

        settings.save();

        logger.info('${PathAppRpcUtil.shared_config} created.');
        return ConfigApp.copyYamlConfig(settings);
      } catch (e) {
        logger.warning('Error creating config file: $e');
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
