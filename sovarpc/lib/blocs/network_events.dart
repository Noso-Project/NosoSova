abstract class NetworkNosoEvents {}

class InitialConnect extends NetworkNosoEvents {}

class FetchNodesList extends NetworkNosoEvents {
  FetchNodesList();
}

class ReconnectSeed extends NetworkNosoEvents {
  final bool lastNodeRun;
  final bool hasError;

  ReconnectSeed(this.lastNodeRun, {bool? hasError})
      : hasError = hasError ?? false;
}

class SyncSuccess extends NetworkNosoEvents {
  SyncSuccess();
}

class ReconnectFromError extends NetworkNosoEvents {
  ReconnectFromError();
}
