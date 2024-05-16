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

final GetIt locator = GetIt.instance;

typedef AppPath = String;

Future<void> setupDiRPC({Logger? logger, required AppPath pathApp}) async {
  /// AppPath
  locator.registerLazySingleton<AppPath>(() => pathApp);
  locator.registerLazySingleton<SettingsYamlHandler>(
      () => SettingsYamlHandler(pathApp));

  /// shared & drift(sql)
  locator.registerLazySingleton<MyDatabase>(() => MyDatabase(pathApp));
  locator.registerLazySingleton<NosoApiService>(() => NosoApiService());

  /// repo && services
  locator.registerLazySingleton<FileServiceRpc>(
      () => FileServiceRpc(pathApp, nameFileSummary: "summaryRPC.psk"));
  locator.registerLazySingleton<FileRepositoryRpc>(
      () => FileRepositoryRpc(locator<FileServiceRpc>()));
  locator.registerLazySingleton<NosoNetworkService>(() => NosoNetworkService());
  locator.registerLazySingleton<NosoNetworkRepository>(
      () => NosoNetworkRepository(locator<NosoNetworkService>()));
  locator.registerLazySingleton<LocalRepository>(
      () => LocalRepository(locator<MyDatabase>()));
  locator.registerLazySingleton<RepositoriesRpc>(() => RepositoriesRpc(
      localRepository: locator<LocalRepository>(),
      networkRepository: locator<NosoNetworkRepository>(),
      fileRepository: locator<FileRepositoryRpc>(),
      nosoApiService: locator<NosoApiService>()));

  /// Blocs
  locator.registerLazySingleton<RpcBloc>(() => RpcBloc(
      repositories: locator<RepositoriesRpc>(),
      debugBloc: locator<DebugRPCBloc>()));
  locator
      .registerLazySingleton<DebugRPCBloc>(() => DebugRPCBloc(logger: logger));
  locator.registerLazySingleton<NosoNetworkBloc>(() => NosoNetworkBloc(
      repositories: locator<RepositoriesRpc>(),
      debugBloc: locator<DebugRPCBloc>()));
}
