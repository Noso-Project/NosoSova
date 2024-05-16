import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:sovarpc/cli/cli_wallet_handler.dart';
import 'package:sovarpc/cli/pen.dart';

Future<void> main(List<String> arguments) async {
  final ArgParser argParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show all wallet commands')
    ..addOption('import',
        abbr: 'i',
        help:
            'Import your addresses from a .pkw file, use the <file_name.pkw> parameter. Before using, place the file in the same folder as the wallet.exe executable file')
    ..addFlag('export',
        abbr: 'e',
        negatable: false,
        help:
            'Export your addresses in .pkw file, use with the <file_name.pkw> parameter.')
    ..addFlag('getWalletInfo',
        negatable: false, abbr: 'w', help: 'Information about the wallet');

  var walletHandler = CliWalletHandler();

  try {
    final ArgResults args = argParser.parse(arguments);

    if (args['help'] as bool) {
      walletHandler.help(argParser.usage);
      return;
    }

    if (args.wasParsed('import')) {
      final String? walletName = args['import'];

      if (walletName != null) {
        walletHandler.importAddresses(walletName);
      } else {
        stdout.writeln(Pen().red('File address to import was not provided'));
      }

      return;
    }

    if (args.wasParsed('export')) {
      // Обробка операції експорту
      return;
    }

    if (args.wasParsed('getWalletInfo')) {
      // Обробка операції отримання інформації про гаманець
      return;
    }
  } catch (e) {
    stdout.writeln(Pen().red(e));
    return;
  }

  stdout.writeln('Bad command');
}
