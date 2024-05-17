import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:sovarpc/cli/cli_wallet_handler.dart';
import 'package:sovarpc/cli/comands.dart';
import 'package:sovarpc/cli/exit.dart';
import 'package:sovarpc/cli/pen.dart';

Future<void> main(List<String> arguments) async {
  CliExit.exitListener(AppType.wallet);
  final ArgParser argParser = ArgParser()
    ..addFlag(CliCommands.help,
        abbr: 'h', negatable: false, help: 'Show all wallet commands')
    ..addOption(CliCommands.import,
        abbr: 'i',
        help:
            'Import your addresses from a .pkw file, use the <file_name.pkw> parameter. Before using, place the file in the same folder as the wallet.exe executable file')
    ..addFlag(CliCommands.export,
        abbr: 'e', negatable: false, help: 'Export your addresses in .pkw file')
    ..addFlag(CliCommands.wInfo,
        negatable: false,
        abbr: 'w',
        help: 'Returns information about the wallet')
    ..addFlag(CliCommands.list,
        abbr: 'a', negatable: false, help: 'Returns list all addresses')
    ..addFlag(CliCommands.fullList,
        abbr: 'f',
        negatable: false,
        help: 'Returns a list of all addresses with a key pair in json format')
    ..addFlag(CliCommands.genAddress,
        abbr: 'n',
        negatable: false,
        help:
            'Create a new address, can be used with the --no-save flag then this address will not be saved locally')
    ..addFlag(CliCommands.nosSave,
        help: 'Disables saving address for local database', negatable: false)
    ..addOption(CliCommands.lisLocal,
        abbr: "l",
        help: 'Checks if the address is saved locally, use <hash> parameter')
    ..addOption(CliCommands.setPaymentAddress,
        abbr: 'p',
        help: 'Sets the default payment address use <hash> parameter');

  var walletHandler = CliWalletHandler();

  try {
    final ArgResults args = argParser.parse(arguments);

    if (args.wasParsed(CliCommands.genAddress)) {
      walletHandler.getNewAddress(args.wasParsed(CliCommands.nosSave));

      return;
    }

    if (args.wasParsed(CliCommands.lisLocal)) {
      final String? hash = args[CliCommands.lisLocal];

      if (hash != null && NosoUtility.isValidHashNoso(hash)) {
        await walletHandler.isLocalAddress(hash);
      } else {
        stdout.writeln(Pen().red('Invalid parameter or value to set'));
      }
      return;
    }

    if (args[CliCommands.help] as bool) {
      walletHandler.help(argParser.usage);
      return;
    }

    if (args.wasParsed(CliCommands.import)) {
      final String? walletName = args[CliCommands.import];

      if (walletName != null) {
        walletHandler.importAddresses(walletName);
      } else {
        stdout.writeln(Pen().red('File address to import was not provided'));
      }

      return;
    }

    if (args.wasParsed(CliCommands.export)) {
      walletHandler.exportWallet();
      return;
    }

    if (args.wasParsed(CliCommands.wInfo)) {
      await walletHandler.getWalletInfo();
      return;
    }

    if (args.wasParsed(CliCommands.list)) {
      await walletHandler.getListAddress();
      return;
    }

    if (args.wasParsed(CliCommands.fullList)) {
      await walletHandler.getListAddressFull();
      return;
    }

    if (args.wasParsed(CliCommands.setPaymentAddress)) {
      final String? hash = args[CliCommands.setPaymentAddress];

      if (hash != null && NosoUtility.isValidHashNoso(hash)) {
        await walletHandler.setPaymentAddress(hash);
      } else {
        stdout.writeln(Pen().red('Invalid parameter or value to set'));
      }

      return;
    }
  } catch (_) {}

  stdout.writeln(Pen().red(
      'Error: Command or parameter not found. Please use --help to see available options.'));
}
