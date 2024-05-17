import 'dart:io';

import 'package:settings_yaml/settings_yaml.dart';
import 'package:sovarpc/cli/pen.dart';

import '../const.dart';
import '../models/config_app.dart';
import '../utils/path_app_rpc.dart';

class SettingsYamlHandler {
  final String _ip = "ip";
  final String _port = "port";
  final String _ignoreMethods = "ignoreMethods";
  final String _logsLevel = "logsLevel";
  final String _nodesList = "nodesList";
  final String _lastSeed = "lastSeed";
  final String _rpcAddress = "rpcAddress";
  final String _defaultPaymentAddress = "defaultPaymentAddress";
  final String appPath;

  SettingsYamlHandler(this.appPath);

  Future<ConfigApp?> checkConfig() async {
    final File configFile = File(PathAppRpcUtil.shared_config);

    if (!configFile.existsSync()) {
      stdout.writeln(Pen().red('Config file not found. Creating a new one...'));
      try {
        var settings =
            SettingsYaml.load(pathToSettings: PathAppRpcUtil.shared_config);

        settings[_ip] = Const.DEFAULT_HOST;
        settings[_port] = Const.DEFAULT_PORT;
        settings[_ignoreMethods] = '';
        settings[_logsLevel] = "Release";

        settings.save();

        stdout.writeln(
            Pen().greenText('${PathAppRpcUtil.shared_config} created.'));
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
    String backupDirPath = '$appPath/${PathAppRpcUtil.app_config_system}';
    final File configFile = File(backupDirPath);
    Directory directory = Directory(appPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (!configFile.existsSync()) {
      try {
        settings[_nodesList] = "";
        settings[_lastSeed] = "";
        settings.save();
        return settings;
      } catch (e) {
        print(e);
      }
    }

    return settings;
  }

  Future<List<String>> loadRpcConfig() async {
    String backupDirPath = '$appPath/${PathAppRpcUtil.app_config_system}';
    final File configFile = File(backupDirPath);
    Directory directory = Directory(appPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (!configFile.existsSync()) {
      try {
        settings[_rpcAddress] = "";
        settings[_ignoreMethods] = "";
        settings.save();
        return [
          settings[_rpcAddress] ??
              "${Const.DEFAULT_HOST}:${Const.DEFAULT_PORT}",
          settings[_ignoreMethods] ?? ""
        ];
      } catch (e) {
        print(e);
      }
    }
    return [
      settings[_rpcAddress] ?? "${Const.DEFAULT_HOST}:${Const.DEFAULT_PORT}",
      settings[_ignoreMethods] ?? ""
    ];
  }

  Future<String> loadDefaultPaymentAddress() async {
    final File configFile = File(PathAppRpcUtil.shared_config);

    var settings =
        SettingsYaml.load(pathToSettings: PathAppRpcUtil.shared_config);
    if (!configFile.existsSync()) {
      return "";
    }

    return settings[_defaultPaymentAddress];
  }

  Future<void> saveDefaultPaymentAddress(String address) async {
    var settings =
        SettingsYaml.load(pathToSettings: PathAppRpcUtil.shared_config);
    settings[_defaultPaymentAddress] = address;
    settings.save();
  }

  Future<void> saveAppConfig(
      {String nodesList = "", String lastSeed = ""}) async {
    Directory directory = Directory(appPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String backupDirPath = '$appPath/${PathAppRpcUtil.app_config_system}';

    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (nodesList.isNotEmpty) {
      settings[_nodesList] = nodesList;
    }
    if (lastSeed.isNotEmpty) {
      settings[_lastSeed] = lastSeed;
    }
    settings.save();
  }

  Future<void> saveRpcConfig(
      {String rpcAddress = "", String ignoreMethods = ""}) async {
    Directory directory = Directory(appPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String backupDirPath = '$appPath/${PathAppRpcUtil.app_config_system}';

    var settings = SettingsYaml.load(pathToSettings: backupDirPath);
    if (rpcAddress.isNotEmpty) {
      settings[rpcAddress] = rpcAddress;
    }
    if (ignoreMethods.isNotEmpty) {
      settings[ignoreMethods] = ignoreMethods;
    }
    settings.save();
  }
}
