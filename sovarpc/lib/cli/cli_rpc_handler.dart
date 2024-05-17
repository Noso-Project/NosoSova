import 'dart:io';

import 'package:logging/logging.dart';
import 'package:sovarpc/cli/pen.dart';

import '../blocs/network_events.dart';
import '../blocs/noso_network_bloc.dart';
import '../blocs/rpc_bloc.dart';
import '../blocs/rpc_events.dart';
import '../di.dart';
import '../models/log_level.dart';
import '../services/settings_yaml.dart';
import '../utils/path_app_rpc.dart';

class CliRpcHandler {
  help(String usage) {
    stdout.writeln('Available commands:\n$usage');
  }

  checkConfig() async {
    var settings = await SettingsYamlHandler(PathAppRpcUtil.getAppPath()).checkConfig();
    if (settings == null) {
      stdout.writeln('${PathAppRpcUtil.shared_config} not found...');
      return;
    }

    stdout.writeln(Pen().greenBg('${PathAppRpcUtil.shared_config}:'));
    stdout.writeln('ip@port: ${settings.ip}:${settings.port}\n'
        'ignore methods: ${settings.ignoreMethods}\n'
        'logs level:  ${settings.logsLevel}');
  }

  Future<void> runRpcMode(Logger logger) async {
    var settings = await SettingsYamlHandler(PathAppRpcUtil.getAppPath()).checkConfig();
    if (settings == null) {
      stdout.writeln('${PathAppRpcUtil.shared_config} not found...');
      stdout.writeln('Please use: --config: Create/Check configuration');
      return;
    }

    await setupDiRPC(PathAppRpcUtil.getAppPath(),
        logger: logger, logLevel: LogLevel(level: settings.logsLevel));
    locatorRpc<NosoNetworkBloc>().add(InitialConnect());
    locatorRpc<RpcBloc>().add(StartServer(
          "${settings.ip}:${settings.port}", settings.ignoreMethods));
  }


}
