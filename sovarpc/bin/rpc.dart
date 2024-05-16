import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:sovarpc/blocs/network_events.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';
import 'package:sovarpc/blocs/rpc_bloc.dart';
import 'package:sovarpc/blocs/rpc_events.dart';
import 'package:sovarpc/di.dart';
import 'package:sovarpc/models/log_level.dart';
import 'package:sovarpc/path_app_rpc.dart';
import 'package:sovarpc/services/settings_yaml.dart';

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
  var settings = await SettingsYamlHandler().checkConfig(_logger);
  if (settings == null) {
    print('${PathAppRpcUtil.shared_config} not found...');
    return;
  }
  print('${PathAppRpcUtil.shared_config}:\n'
      'ip@port: ${settings.ip}:${settings.port}\n'
      'ignore methods: ${settings.ignoreMethods}\n'
      'logs level:  ${settings.logsLevel}');
}

Future<void> runRpcMode() async {
  var settings = await SettingsYamlHandler().checkConfig(_logger);
  if (settings == null) {
    print('${PathAppRpcUtil.shared_config} not found...');
    print('Please use: --config: Create/Check configuration');
    return;
  }

  await setupDiRPC(PathAppRpcUtil.getAppPath(),
      logger: _logger, logLevel: LogLevel(level: settings.logsLevel));
  locator<NosoNetworkBloc>().add(InitialConnect());

  locator<RpcBloc>().add(
      StartServer("${settings.ip}:${settings.port}", settings.ignoreMethods));
}
