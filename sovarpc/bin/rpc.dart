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
import 'package:sovarpc/path_app_rpc.dart';

final _logger = Logger('rpc');
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
        '--config: Check/create configuration');

    return;
  }

  if (args['run'] as bool) {
    _logger.info('RPC mode started.');
    return await runRpcMode();
  }

  if (args['config'] as bool) {
    print('Checking configuration...');
    var settings = await checkConfig();
    if (settings == null) {
      print('${Const.NAME_CONFIG_FILE} not found...');
      return;
    }
    var ip = settings['ip'] as String;
    var port = settings['port'] as String;
    var ignoreMethods = settings['ignoreMethods'] as String;
    print('Config:\n'
        'ip@port: $ip:$port\n'
        'ignore methods: $ignoreMethods');
    return;
  }
  _logger.warning('Bad command');
}

Future<void> runRpcMode() async {
  setupDiRPC(logger: _logger, pathApp: PathAppRPCUtil.getAppPath());
  locator<NosoNetworkBloc>().add(InitialConnect());
  var settings = await checkConfig();
  if (settings == null) {
    print('${Const.NAME_CONFIG_FILE} not found...');
    print('Please use: --config: Create/Check configuration');
    return;
  }
  var ip = settings['ip'] as String;
  var port = settings['port'] as String;
  var ignoreMethods = settings['ignoreMethods'] as String;
  locator<RpcBloc>().add(StartServer("$ip:$port", ignoreMethods));
}

Future<SettingsYaml?> checkConfig() async {
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
      return settings;
    } catch (e) {
      _logger.warning('Error creating config file: $e');
      return null;
    }
  }
  var settings = SettingsYaml.load(pathToSettings: Const.NAME_CONFIG_FILE);

  return settings;
}
