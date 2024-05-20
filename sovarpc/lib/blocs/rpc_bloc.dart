import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:sovarpc/blocs/rpc_events.dart';
import 'package:sovarpc/services/settings_yaml.dart';

import '../const.dart';
import '../di.dart';
import '../models/debug_rpc.dart';
import '../repository/repositories_rpc.dart';
import '../services/rpc/rpc_service.dart';
import 'debug_rpc_bloc.dart';

class RpcState {
  final bool rpcRunnable;
  final String rpcAddress;
  final String ignoreMethods;

  RpcState({
    bool? rpcRunnable,
    String? rpcAddress,
    String? ignoreMethods,
  })  : rpcRunnable = rpcRunnable ?? false,
        rpcAddress =
            rpcAddress ?? "${Const.DEFAULT_HOST}:${Const.DEFAULT_PORT}",
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
  final RepositoriesRpc _repositories;
  HttpServer? rpcServer;
  final DebugRPCBloc _debugBloc;

  RpcBloc({
    required RepositoriesRpc repositories,
    required DebugRPCBloc debugBloc,
  })  : _repositories = repositories,
        _debugBloc = debugBloc,
        super(RpcState()) {
    on<StartServer>(_startServer);
    on<StopServer>(_stopServer);
    on<InitBlocRPC>(_initRPCBloc);
    on<ExitServer>(_exitEvent);
  }

  void _initRPCBloc(event, emit) async {
    var config = locatorRpc<SettingsYamlHandler>();
    var iMethods = await config.getSet(SettingsKeys.ignoreMethods);
    var ip = await config.getSet(SettingsKeys.ip);
    var port = await config.getSet(SettingsKeys.port);
    var address =
        "${ip.isEmpty ? Const.DEFAULT_HOST : ip}:${port.isEmpty ? Const.DEFAULT_PORT : port}";
    emit(state.copyWith(
        rpcAddress: address, ignoreMethods: iMethods, rpcRunnable: false));
  }

  void _startServer(event, emit) async {
    try {
      var address = event.address;
      var ignoreMethods = event.ignoreMethods;
      var addressArray = address.split(":");
      var config = locatorRpc<SettingsYamlHandler>();
      await config.writeSet(SettingsKeys.ip, addressArray[0]);
      await config.writeSet(SettingsKeys.port, addressArray[1]);
      await config.writeSet(SettingsKeys.ignoreMethods, ignoreMethods);

      if (rpcServer != null) {
        await rpcServer!.close(force: true);
        rpcServer = null;
      }
      rpcServer = await shelf_io.serve(
          ServiceRPC(_repositories, ignoreMethods).handler,
          addressArray[0],
          int.parse(addressArray[1]));

      _debugBloc.add(AddStringDebug(
          "Start RPC at http://${rpcServer?.address.host}:${rpcServer?.port}",
          StatusReport.RPC,
          DebugType.success));
      emit(state.copyWith(
          rpcAddress: address,
          rpcRunnable: true,
          ignoreMethods: ignoreMethods));
    } catch (e) {
      _debugBloc
          .add(AddStringDebug(e.toString(), StatusReport.RPC, DebugType.error));
      emit(state.copyWith(rpcRunnable: false));
    }
  }

  void _stopServer(event, emit) async {
    _debugBloc.add(
        AddStringDebug("Stop RPC Server", StatusReport.RPC, DebugType.error));

    rpcServer?.close(force: true);
    rpcServer = null;
    emit(state.copyWith(rpcRunnable: false));
  }

  void _exitEvent(event, emit) async {
    add(StopServer());
    close();
  }

  @override
  Future<void> close() async {
    try {
      await rpcServer?.close(force: true);
      rpcServer = null;
    } catch (_) {}
    return super.close();
  }
}
