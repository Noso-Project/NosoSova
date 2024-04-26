abstract class RPCEvents {}

class StartServer extends RPCEvents {
  final String address;
  final String ignoreMethods;

  StartServer(this.address, this.ignoreMethods);
}

class StopServer extends RPCEvents {}

class InitBlocRPC extends RPCEvents {}