import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:sovarpc/cli/cli_rpc_handler.dart';
import 'package:sovarpc/cli/pen.dart';

final _logger = Logger("");

/*******
 *TODO Не працює втсановлення дефолт адреси
 */

/********
 *
 *
 * TODO Не працює втсановлення дефолт адреси
 */

Future<void> main(List<String> arguments) async {
  PrintAppender.setupLogging();
  final ArgParser argParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show all RPC commands')
    ..addFlag('run', abbr: 'r', negatable: false, help: 'Start RPC mode')
    ..addFlag('config',
        abbr: 'c',
        negatable: false,
        help:
            'Displays the contents of the configuration file, if it does not exist, it creates it.');

  var rpcHandler = CliRpcHandler();
  final ArgResults args = argParser.parse(arguments);
  if (args['help'] as bool) {
    rpcHandler.help(argParser.usage);
    return;
  }

  if (args['run'] as bool) {
    stdout.writeln(Pen().greenBg('RPC mode started'));
    await rpcHandler.runRpcMode(_logger);
    return;
  }

  if (args['config'] as bool) {
    stdout.writeln('Checking configuration...');
    await rpcHandler.checkConfig();
    return;
  }
  stdout.writeln('Bad command');
}
