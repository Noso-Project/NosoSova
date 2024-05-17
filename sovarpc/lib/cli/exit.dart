import 'dart:async';
import 'dart:io';

import 'package:sovarpc/blocs/rpc_bloc.dart';
import 'package:sovarpc/blocs/rpc_events.dart';
import 'package:sovarpc/cli/pen.dart';
import 'package:sovarpc/di.dart';

enum AppType { wallet, rpc }

class CliExit {
  static exitListener(AppType typeApp) {
    stopApp() {
      stdout.write('\b\b  \b\b');
      stdout.writeln(Pen().redBg(
          '\r${typeApp == AppType.wallet ? "Wallet" : "RPC"} is stopped!'));
      if (AppType.rpc == typeApp) {
        locatorRpc<RpcBloc>().add(ExitServer());
      }
      exit(0);
    }

    runZoned(() {
      ProcessSignal.sigint.watch().listen((_) async => stopApp());
      ProcessSignal.sigterm.watch().listen((_) async => stopApp());
    });
  }
}
