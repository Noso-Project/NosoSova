import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:noso_rest_api/api_service.dart';
import 'package:nososova/database/database.dart';
import 'package:nososova/repositories/local_repository.dart';
import 'package:nososova/repositories/noso_network_repository.dart';
import 'package:nososova/services/noso_network_service.dart';
import 'package:sovarpc/blocs/debug_rpc_bloc.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';
import 'package:sovarpc/blocs/rpc_bloc.dart';
import 'package:sovarpc/repository/file_repository.dart';
import 'package:sovarpc/repository/repositories_rpc.dart';
import 'package:sovarpc/services/file_service_rpc.dart';
import 'package:sovarpc/services/settings_yaml.dart';

import 'models/log_level.dart';

final GetIt locatorRpc = GetIt.instance;

typedef AppPath = String;

Future<void> setupDiRPC(AppPath pathApp,
    {Logger? logger, LogLevel? logLevel}) async {
  /// AppPath
  locatorRpc.registerLazySingleton<AppPath>(() => pathApp);
  locatorRpc.registerLazySingleton<LogLevel>(
      () => logLevel ?? LogLevel(level: "Debug"));
  locatorRpc
      .registerLazySingleton<SettingsYamlHandler>(() => SettingsYamlHandler());

  /// shared & drift(sql)
  locatorRpc.registerLazySingleton<MyDatabase>(() => MyDatabase(pathApp));

  /// repo && services

  locatorRpc.registerLazySingleton<RepositoriesRpc>(() => RepositoriesRpc(
      localRepository: LocalRepository(locatorRpc<MyDatabase>()),
      networkRepository: NosoNetworkRepository(NosoNetworkService()),
      fileRepository: FileRepositoryRpc(
          FileServiceRpc(pathApp, nameFileSummary: "summaryRPC.psk")),
      nosoApiService: NosoApiService()));

  /// Blocs
  locatorRpc.registerLazySingleton<RpcBloc>(() => RpcBloc(
      repositories: locatorRpc<RepositoriesRpc>(),
      debugBloc: locatorRpc<DebugRPCBloc>()));
  locatorRpc
      .registerLazySingleton<DebugRPCBloc>(() => DebugRPCBloc(logger: logger));
  locatorRpc.registerLazySingleton<NosoNetworkBloc>(() => NosoNetworkBloc(
      repositories: locatorRpc<RepositoriesRpc>(),
      debugBloc: locatorRpc<DebugRPCBloc>()));
}
