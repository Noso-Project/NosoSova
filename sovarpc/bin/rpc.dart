import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:settings_yaml/settings_yaml.dart';

const String _nameConfigFile = "rpc_config.yaml";
final _logger = Logger('rpc');

Future<void> main(List<String> arguments) async {
  PrintAppender.setupLogging();
  final ArgParser argParser = ArgParser()
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show available commands')
    ..addFlag('run', negatable: false, help: 'Start RPC mode')
    ..addFlag('config', negatable: false, help: 'Check configuration');

  final ArgResults args = argParser.parse(arguments);
  if (args['help'] as bool) {
    print('Available commands:\n'
        '--help (-h): Show available commands\n'
        '--run: Start RPC mode\n'
        '--config: Check configuration');

    return;
  }

  if (args['run'] as bool) {
    _logger.info('RPC mode started.');
    await runRpcMode();
  }

  if (args['config'] as bool) {
    print('Checking configuration...');
    return await checkConfig();
  }
  _logger.warning('Bad command');
}

Future<void> runRpcMode() async {
  // Додайте код для запуску режиму RPC тут
  // Цей код буде виконуватися асинхронно
}

Future<void> checkConfig() async {
  final File configFile = File(_nameConfigFile);

  if (!configFile.existsSync()) {
    _logger.info('Config file not found. Creating a new one...');
    try {
      var settings = SettingsYaml.load(pathToSettings: _nameConfigFile);

      settings['ip'] = 'localhost';
      settings['port'] = 8078;
      settings['ignoreMethods'] = '';

      settings.save();

      _logger.info('$_nameConfigFile created.');
      return;
    } catch (e) {
      _logger.warning('Error creating config file: $e');
      return;
    }
  }
  var settings = SettingsYaml.load(pathToSettings: _nameConfigFile);

  var ip = settings['ip'] as String;
  var port = settings['port'] as int;
  var ignoreMethods = settings['ignoreMethods'] as String;
  print('Config:\n'
      'ip@port: $ip:$port\n'
      'ignore methods: $ignoreMethods');
}
