abstract class AppDataEvent {}

class InitialConnect extends AppDataEvent {}

class FetchNodesList extends AppDataEvent {
  FetchNodesList();
}

class ReconnectSeed extends AppDataEvent {
  final bool lastNodeRun;
  final bool hasError;

  ReconnectSeed(this.lastNodeRun, {bool? hasError})
      : hasError = hasError ?? false;
}

class SyncSuccess extends AppDataEvent {
  SyncSuccess();
}

class UpdateSupply extends AppDataEvent {
  final double supply;

  UpdateSupply(this.supply);
}

class ReconnectFromError extends AppDataEvent {
  ReconnectFromError();
}

class LoadPriceHistory extends AppDataEvent {
  LoadPriceHistory();
}
