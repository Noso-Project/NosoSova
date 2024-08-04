import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/blocs/coininfo_bloc.dart';
import 'package:nososova/blocs/debug_bloc.dart';
import 'package:nososova/blocs/events/coininfo_events.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/l10n/app_localizations.dart';
import 'package:nososova/path_app.dart';
import 'package:nososova/ui/notifer/app_settings_notifer.dart';
import 'package:nososova/ui/pages/main/main_page.dart';
import 'package:nososova/ui/theme/color_schemes.g.dart';
import 'package:window_manager/window_manager.dart';

import 'blocs/events/app_data_events.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(await PathAppUtil.getAppPath());
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
  runApp(NosoSova());
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class NosoSova extends StatelessWidget {
  NosoSova({super.key});

  final AppSettings _appSettings = locator<AppSettings>();

  Future testWindowFunctions() async {}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ListenableBuilder(
        listenable: _appSettings,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            darkTheme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            themeMode:
                _appSettings.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(_appSettings.selectLanguage),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<DebugBloc>(
                    create: (context) => locator<DebugBloc>()),
                BlocProvider<CoinInfoBloc>(create: (context) {
                  var bloc = locator<CoinInfoBloc>();
                  bloc.add(InitBloc());
                  return bloc;
                }),
                BlocProvider<WalletBloc>(
                  create: (context) => locator<WalletBloc>(),
                ),
                BlocProvider<AppDataBloc>(create: (context) {
                  final appDataBloc = locator<AppDataBloc>();
                  appDataBloc.add(InitialConnect());
                  return appDataBloc;
                }),
              ],
              child: const MainPage(),
            ),
          );
        });
  }
}
