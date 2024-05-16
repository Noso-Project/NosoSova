import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/path_app.dart';
import 'package:nososova/ui/config/size_config.dart';
import 'package:nososova/ui/theme/color_schemes.g.dart';
import 'package:sovarpc/blocs/debug_rpc_bloc.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';
import 'package:sovarpc/screens/rpc_page.dart';
import 'package:window_manager/window_manager.dart';

import 'blocs/network_events.dart';
import 'blocs/rpc_bloc.dart';
import 'blocs/rpc_events.dart';
import 'di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDiRPC(await PathAppUtil.getAppPath());
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 800),
      center: true,
      minimumSize: Size(1000, 800),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const SovaRPC());
}

class SovaRPC extends StatelessWidget {
  const SovaRPC({super.key});

  Future testWindowFunctions() async {}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SizeConfig.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.dark,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<RpcBloc>(create: (context) {
            var bloc = locator<RpcBloc>();
            bloc.add(InitBlocRPC());
            return bloc;
          }),
          BlocProvider<NosoNetworkBloc>(create: (context) {
            var bloc = locator<NosoNetworkBloc>();
            bloc.add(InitialConnect());
            return bloc;
          }),
          BlocProvider<DebugRPCBloc>(
            create: (context) => locator<DebugRPCBloc>(),
          ),
        ],
        child: const RpcPage(),
      ),
    );
  }
}
