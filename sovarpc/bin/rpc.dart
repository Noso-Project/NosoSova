import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:sovarpc/blocs/network_events.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';
import 'package:sovarpc/const.dart';
import 'package:sovarpc/dependency_injection.dart';

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
  setupLocatorRPC(logger: _logger, pathApp: "sovaData/");
  var bloc = locator<NosoNetworkBloc>();
  bloc.add(InitialConnect());
}

Future<void> checkConfig() async {
  final File configFile = File(Const.NAME_CONFIG_FILE);

  if (!configFile.existsSync()) {
    _logger.info('Config file not found. Creating a new one...');
    try {
      var settings = SettingsYaml.load(pathToSettings: Const.NAME_CONFIG_FILE);

      settings['ip'] = Const.DEFAULT_HOST;
      settings['port'] = Const.DEFAULT_PORT;
      settings['ignoreMethods'] = '';

      settings.save();

      _logger.info('${Const.NAME_CONFIG_FILE} created.');
      return;
    } catch (e) {
      _logger.warning('Error creating config file: $e');
      return;
    }
  }
  var settings = SettingsYaml.load(pathToSettings: Const.NAME_CONFIG_FILE);

  var ip = settings['ip'] as String;
  var port = settings['port'] as int;
  var ignoreMethods = settings['ignoreMethods'] as String;
  print('Config:\n'
      'ip@port: $ip:$port\n'
      'ignore methods: $ignoreMethods');
}
