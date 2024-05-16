import 'package:settings_yaml/settings_yaml.dart';

import '../const.dart';

class ConfigApp {
  String ip;
  String port;
  String ignoreMethods;
  String logsLevel;

  ConfigApp({required this.ip, required this.port, required this.ignoreMethods, required this.logsLevel});

 static ConfigApp copyYamlConfig(SettingsYaml settings) {
    return ConfigApp(
      ip: settings['ip'] as String? ?? Const.DEFAULT_HOST,
      port: settings['port'] as String? ?? Const.DEFAULT_PORT,
      ignoreMethods: settings['ignoreMethods'] as String? ?? "",
      logsLevel: settings['logsLevel'] as String? ?? "Release",
    );
  }
}
