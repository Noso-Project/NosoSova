import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:sovarpc/blocs/network_events.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';
import 'package:sovarpc/blocs/rpc_bloc.dart';
import 'package:sovarpc/blocs/rpc_events.dart';
import 'package:sovarpc/const.dart';
import 'package:sovarpc/di.dart';
import 'package:sovarpc/models/config_app.dart';
import 'package:sovarpc/models/log_level.dart';
import 'package:sovarpc/path_app_rpc.dart';

final _logger = Logger("");
HttpServer? rpcServer;

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
        '--config: Check/create configuration file');

    return;
  }

  if (args['run'] as bool) {
    _logger.info('RPC mode started.');
    return await runRpcMode();
  }

  if (args['config'] as bool) {
    print('Checking configuration...');
    return await _checkCommandConfig();
  }
  _logger.warning('Bad command');
}

Future<void> _checkCommandConfig() async {
  var settings = await checkConfig();
  if (settings == null) {
    print('${Const.NAME_CONFIG_FILE} not found...');
    return;
  }
  print('${Const.NAME_CONFIG_FILE}:\n'
      'ip@port: ${settings.ip}:${settings.port}\n'
      'ignore methods: ${settings.ignoreMethods}\n'
      'logs level:  ${settings.logsLevel}');
}

Future<void> runRpcMode() async {
  var settings = await checkConfig();
  if (settings == null) {
    print('${Const.NAME_CONFIG_FILE} not found...');
    print('Please use: --config: Create/Check configuration');
    return;
  }

  await setupDiRPC(PathAppRPCUtil.getAppPath(),
      logger: _logger, logLevel: LogLevel(level: settings.logsLevel));
  locator<NosoNetworkBloc>().add(InitialConnect());

  locator<RpcBloc>().add(
      StartServer("${settings.ip}:${settings.port}", settings.ignoreMethods));
}

Future<ConfigApp?> checkConfig() async {
  final File configFile = File(Const.NAME_CONFIG_FILE);

  if (!configFile.existsSync()) {
    _logger.info('Config file not found. Creating a new one...');
    try {
      var settings = SettingsYaml.load(pathToSettings: Const.NAME_CONFIG_FILE);

      settings['ip'] = Const.DEFAULT_HOST;
      settings['port'] = Const.DEFAULT_PORT;
      settings['ignoreMethods'] = '';
      settings['logsLevel'] = "Release";

      settings.save();

      _logger.info('${Const.NAME_CONFIG_FILE} created.');
      return ConfigApp.copyYamlConfig(settings);
    } catch (e) {
      _logger.warning('Error creating config file: $e');
      return null;
    }
  }
  var settings = ConfigApp.copyYamlConfig(
      SettingsYaml.load(pathToSettings: Const.NAME_CONFIG_FILE));

  return settings;
}
