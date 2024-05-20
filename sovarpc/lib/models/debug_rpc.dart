class DebugRpcString {
  String time;
  String message;
  DebugType type;
  final StatusReport source;

  DebugRpcString(
      {this.time = "",
      this.message = "",
      this.source = StatusReport.Node,
      this.type = DebugType.inform});
}

enum StatusReport { Node, RPC, ALL }

enum DebugType { error, inform, success }
