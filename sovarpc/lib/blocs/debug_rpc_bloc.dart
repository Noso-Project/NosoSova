import 'package:bloc/bloc.dart';

import '../models/debug_rpc.dart';

class DebugRPCState {
  final List<DebugRpcString> debugList;

  DebugRPCState({
    List<DebugRpcString>? debugList,
  }) : debugList = debugList ?? [];

  DebugRPCState copyWith({
    List<DebugRpcString>? debugList,
  }) {
    return DebugRPCState(
      debugList: debugList ?? this.debugList,
    );
  }
}

class DebugRPCBloc extends Bloc<DebugEventRPC, DebugRPCState> {
  DebugRPCBloc() : super(DebugRPCState()) {
    on<AddStringDebug>(_addToDebug);
  }

  /// A method that adds an event to the console
  _addToDebug(event, emit) {
    final DateTime now = DateTime.now();
    var list = state.debugList;
    list = list.length >= 500 ? [] : list;
    var string = DebugRpcString(
        time:
            "${now.hour}:${now.minute < 10 ? '0${now.minute}' : now.minute.toString()}:${now.second < 10 ? '0${now.second}' : now.second.toString()}",
        message: event.value,
        type: event.type,
        source: event.source);
    list.add(string);

    emit(state.copyWith(debugList: list));
  }
}

abstract class DebugEventRPC {}

class AddStringDebug extends DebugEventRPC {
  final String value;
  final DebugType type;
  final StatusReport source;

  AddStringDebug(this.value,
      [this.source = StatusReport.Node, this.type = DebugType.inform]);
}
