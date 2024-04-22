abstract class RPCEvents {}

class StartServer extends RPCEvents {
  final String address;

  StartServer(this.address);
}

class StopServer extends RPCEvents {}
