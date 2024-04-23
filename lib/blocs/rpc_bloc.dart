import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/repositories/repositories.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import '../services/rpc/rpc_service.dart';
import 'events/rpc_events.dart';

class RpcState {
  final bool rpcRunnable;
  final String rpcAddress;
  final String ignoreMethods;

  RpcState({
    bool? rpcRunnable,
    String? rpcAddress,
    String? ignoreMethods,
  })  : rpcRunnable = rpcRunnable ?? false,
        rpcAddress = rpcAddress ?? "localhost:8080",
        ignoreMethods = ignoreMethods ?? "";

  RpcState copyWith({
    bool? rpcRunnable,
    String? rpcAddress,
    String? ignoreMethods,
  }) {
    return RpcState(
        rpcRunnable: rpcRunnable ?? this.rpcRunnable,
        rpcAddress: rpcAddress ?? this.rpcAddress,
        ignoreMethods: ignoreMethods ?? this.ignoreMethods);
  }
}

class RpcBloc extends Bloc<RPCEvents, RpcState> {
  final WalletBloc walletBloc;
  final AppDataBloc appDataBloc;
  final Repositories _repositories;
  HttpServer? rpcServer;

  RpcBloc({
    required Repositories repositories,
    required this.walletBloc,
    required this.appDataBloc,
  })  : _repositories = repositories,
        super(RpcState()) {
    on<StartServer>(_startServer);
    on<StopServer>(_stopServer);
    on<InitBlocRPC>(_initRPCBloc);
  }

  factory RpcBloc.create(Repositories repositories, WalletBloc walletBloc,
      AppDataBloc appDataBloc) {
    return RpcBloc(
      repositories: repositories,
      walletBloc: walletBloc,
      appDataBloc: appDataBloc,
    );
  }

  void _initRPCBloc(event, emit) async {
    var rpcAddress = await _repositories.sharedRepository.loadRPCAddress();
    var ignoreMethods =
        await _repositories.sharedRepository.loadRPCMethodsIgnored();
    emit(state.copyWith(
        rpcAddress: rpcAddress,
        ignoreMethods: ignoreMethods,
        rpcRunnable: false));
  }

  void _startServer(event, emit) async {
    try {
      var address = event.address;
      var ignoreMethods = event.ignoreMethods;
      var addressArray = address.split(":");
      await _repositories.sharedRepository.saveRPCStatus(true);
      await _repositories.sharedRepository.saveRPCAddress(address);

      await _repositories.sharedRepository.saveRPCMethodsIgnored(ignoreMethods);

      if (rpcServer != null) {
        await rpcServer!.close(force: true);
        rpcServer = null;
      }
      rpcServer = await shelf_io.serve(
          ServiceRPC(_repositories, ignoreMethods).handler,
          addressArray[0],
          int.parse(addressArray[1]));

      print('Serving at http://${rpcServer?.address.host}:${rpcServer?.port}');
      emit(state.copyWith(
          rpcAddress: address,
          rpcRunnable: true,
          ignoreMethods: ignoreMethods));
    } catch (e) {
      emit(state.copyWith(rpcRunnable: false));
      print('Server startup impossible error');
    }
  }

  void _stopServer(event, emit) async {
    await _repositories.sharedRepository.saveRPCStatus(false);
    print('Stop server');
    rpcServer?.close(force: true);
    rpcServer = null;
    emit(state.copyWith(rpcRunnable: false));
  }
}
