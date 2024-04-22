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

  RpcState({
    bool? rpcRunnable,
    String? rpcAddress,
  })  : rpcRunnable = rpcRunnable ?? false,
        rpcAddress = rpcAddress ?? "localhost:8080";

  RpcState copyWith({
    bool? rpcRunnable,
    String? rpcAddress,
  }) {
    return RpcState(
        rpcRunnable: rpcRunnable ?? this.rpcRunnable,
        rpcAddress: rpcAddress ?? this.rpcAddress);
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
    _loadConfig();
    on<StartServer>(_startServer);
    on<StopServer>(_stopServer);
  }

  factory RpcBloc.create(Repositories repositories, WalletBloc walletBloc,
      AppDataBloc appDataBloc) {
    return RpcBloc(
      repositories: repositories,
      walletBloc: walletBloc,
      appDataBloc: appDataBloc,
    );
  }

  Future<void> _loadConfig() async {
    var rpcAddress = await _repositories.sharedRepository.loadRPCAddress();
 //   var rpcStatus = await _repositories.sharedRepository.loadRPCStatus();
    print('LoadConfig');
    emit(state.copyWith(rpcAddress: rpcAddress, rpcRunnable: false));
  }

  void _startServer(event, emit) async {
    var address = event.address;
    var addressArray = address.split(":");
    await _repositories.sharedRepository.saveRPCStatus(true);
    if (rpcServer != null) {

      await rpcServer!.close(force: true);
      rpcServer = null;
    }
     rpcServer = await shelf_io.serve(Service(_repositories).handler,
        addressArray[0], int.parse(addressArray[1]));

    print('Serving at http://${rpcServer?.address.host}:${rpcServer?.port}');
    emit(state.copyWith(rpcAddress: address, rpcRunnable: true));
  }

  void _stopServer(event, emit) async {
    await _repositories.sharedRepository.saveRPCStatus(false);
    print('Stop server');
    rpcServer?.close(force: true);
    rpcServer = null;
    emit(state.copyWith(rpcRunnable: false));
  }
}
