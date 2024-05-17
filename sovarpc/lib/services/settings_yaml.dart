import 'dart:io';

import 'package:settings_yaml/settings_yaml.dart';
import 'package:sovarpc/cli/pen.dart';

import '../const.dart';
import '../utils/path_app_rpc.dart';

class SettingsKeys {
  static String ip = "ip";
  static String port = "port";
  static String ignoreMethods = "ignoreMethods";
  static String logsLevel = "logsLevel";
  static String lastSeed = "lastSeed";
  static String rpcAddress = "rpcAddress";
  static String defaultPaymentAddress = "defaultPaymentAddress";
}

class SettingsYamlHandler {
  final String appPath;

  SettingsYamlHandler(this.appPath);

  Future<List<String>> checkConfig() async {
    final File configFile = File(PathAppRpcUtil.rpcConfigFilePath);
    var settings =
        SettingsYaml.load(pathToSettings: PathAppRpcUtil.rpcConfigFilePath);

    if (!configFile.existsSync()) {
      stdout.writeln(Pen().red('Config file not found. Creating a new one...'));
      try {
        settings[SettingsKeys.ip] = Const.DEFAULT_HOST;
        settings[SettingsKeys.port] = Const.DEFAULT_PORT;
        settings[SettingsKeys.ignoreMethods] = '';
        settings[SettingsKeys.logsLevel] = "release";
        settings[SettingsKeys.defaultPaymentAddress] = "";
        settings[SettingsKeys.lastSeed] = "";
        settings.save();
        stdout.writeln(
            Pen().greenText('${PathAppRpcUtil.rpcConfigFilePath} created.'));
      } catch (e) {
        stdout.writeln('Error creating config file: $e');
        return [];
      }
    }

    return [
      "${settings[SettingsKeys.ip]}:${settings[SettingsKeys.port]}",
      settings[SettingsKeys.logsLevel],
      settings[SettingsKeys.defaultPaymentAddress],
      settings[SettingsKeys.ignoreMethods],
    ];
  }

  writeSet(String key, String value) async {
    var settings =
        SettingsYaml.load(pathToSettings: PathAppRpcUtil.rpcConfigFilePath);
    settings[key] = value;
    await settings.save();
  }

  Future<String> getSet(String key) async {
    var settings =
        SettingsYaml.load(pathToSettings: PathAppRpcUtil.rpcConfigFilePath);
    return settings[key] ?? "";
  }

  Future<String> loadSeedFile() async {
    try {
      final filePsk = File(PathAppRpcUtil.seedFilePath);
      if (filePsk.existsSync()) {
        return String.fromCharCodes(await filePsk.readAsBytes());
      }
    } catch (_) {}

    return "";
  }

  Future<bool> writeSeedFile(String seeds) async {
    try {
      File walletFile =
          await File(PathAppRpcUtil.seedFilePath).create(recursive: true);
      walletFile.writeAsStringSync(seeds, mode: FileMode.write);

      return true;
    } catch (_) {}
    return false;
  }
}
