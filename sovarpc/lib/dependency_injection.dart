import 'package:get_it/get_it.dart';
import 'package:nososova/database/database.dart';
import 'package:nososova/repositories/file_repository.dart';
import 'package:nososova/repositories/local_repository.dart';
import 'package:nososova/repositories/network_repository.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:nososova/repositories/shared_repository.dart';
import 'package:nososova/services/explorer_stats_service.dart';
import 'package:nososova/services/file_service.dart';
import 'package:nososova/services/node_service.dart';
import 'package:nososova/services/shared_service.dart';
import 'package:nososova/ui/notifer/app_settings_notifer.dart';
import 'package:sovarpc/blocs/debug_rpc_bloc.dart';
import 'package:sovarpc/blocs/noso_network_bloc.dart';
import 'package:sovarpc/blocs/rpc_bloc.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  /// shared & drift(sql)
  locator.registerLazySingleton<SharedService>(() => SharedService());
  locator.registerLazySingleton<MyDatabase>(() => MyDatabase());
  locator.registerLazySingleton<AppSettings>(() => AppSettings());

  /// repo && services
  locator.registerLazySingleton<FileService>(
      () => FileService(nameFileSummary: "summaryRPC.psk"));
  locator.registerLazySingleton<ExplorerStatsService>(
      () => ExplorerStatsService());
  locator.registerLazySingleton<FileRepository>(
      () => FileRepository(locator<FileService>()));
  locator.registerLazySingleton<NodeService>(() => NodeService());
  locator.registerLazySingleton<NetworkRepository>(() => NetworkRepository(
      locator<NodeService>(), locator<ExplorerStatsService>()));
  locator.registerLazySingleton<LocalRepository>(
      () => LocalRepository(locator<MyDatabase>()));
  locator.registerLazySingleton<SharedRepository>(
      () => SharedRepository(locator<SharedService>()));
  locator.registerLazySingleton<Repositories>(() => Repositories(
      localRepository: locator<LocalRepository>(),
      networkRepository: locator<NetworkRepository>(),
      sharedRepository: locator<SharedRepository>(),
      fileRepository: locator<FileRepository>()));

  /// Blocs
  locator.registerLazySingleton<RpcBloc>(() => RpcBloc(
      repositories: locator<Repositories>(),
      debugBloc: locator<DebugRPCBloc>()));
  locator.registerLazySingleton<DebugRPCBloc>(() => DebugRPCBloc());
  locator.registerLazySingleton<NosoNetworkBloc>(() => NosoNetworkBloc(
      repositories: locator<Repositories>(),
      debugBloc: locator<DebugRPCBloc>()));
}
