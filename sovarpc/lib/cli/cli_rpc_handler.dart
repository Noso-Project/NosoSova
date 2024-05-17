import 'dart:io';

import 'package:logging/logging.dart';
import 'package:noso_dart/utils/noso_utility.dart';
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

  methods() {
    stdout.writeln('JSON-RPC all methods:\n'
        '[getmainnetinfo,getpendingorders,getblockorders,getorderinfo,getaddressbalance,getnewaddress,getnewaddressfull,islocaladdress,getwalletbalance,setdefault,sendfunds,reset]\n'
        'Detail: https://github.com/Noso-Project/NosoSova/');
  }

  checkConfig() async {
    var settings =
        await SettingsYamlHandler(PathAppRpcUtil.getAppPath()).checkConfig();
    if (settings.isEmpty) {
      stdout.writeln('${PathAppRpcUtil.rpcConfigFilePath} not found...');
      return;
    }
    if (settings[2].isEmpty || !NosoUtility.isValidHashNoso(settings[2])) {
      stdout.writeln(
          Pen().red('Please note! The billing address is not specified.'));
    }
    stdout.writeln(Pen().greenBg('${PathAppRpcUtil.rpcConfigFilePath}:'));
    stdout.writeln('IP:PORT: ${settings[0]}\n'
        'LOG_LEVEL: ${settings[1]}\n'
        'PAYMENT ADDRESS:  ${settings[2].isEmpty ? "ERROR" : settings[2]}\n'
        'IGNORE METHODS RPC:  ${settings[3].isEmpty ? "NONE" : settings[3]}');
  }

  Future<void> runRpcMode(Logger logger) async {
    var settings =
        await SettingsYamlHandler(PathAppRpcUtil.getAppPath()).checkConfig();
    if (settings.isEmpty) {
      stdout.writeln('${PathAppRpcUtil.rpcConfigFilePath} not found...');
      stdout.writeln('Please use: --config: Create/Check configuration');
      return;
    }

    if (settings[2].isEmpty || !NosoUtility.isValidHashNoso(settings[2])) {
      stdout.writeln(
          Pen().red('Please note! The billing address is not specified.'));
    }

    await setupDiRPC(PathAppRpcUtil.getAppPath(),
        logger: logger, logLevel: LogLevel(level: settings[1]));
    locatorRpc<NosoNetworkBloc>().add(InitialConnect());
    await Future.delayed(const Duration(seconds: 5));
    locatorRpc<RpcBloc>().add(StartServer(settings[0], settings[3]));
  }
}
