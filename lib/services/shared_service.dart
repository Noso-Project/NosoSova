import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static const String lastSeed = "lastSeed";
  static const String lastBlock = "lastBlock";
  static const String listNodes = "nodesList";
  static const String delaySync = "delaySync";
  static const String rpcAddress = "RPCAddress";
  static const String rpcMethodsIgnored = "RPCMethodsIgnored";
  static const String rpcAddressDefault = "RPCDefaultAddress";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> removeLastSeed() async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.remove(lastSeed);
    });
  }

  Future<void> saveLastSeed(String value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setString(lastSeed, value);
    });
  }

  Future<String?> loadLastSeed() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString(lastSeed);
    });
  }

  Future<void> saveLastBlock(int value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setInt(lastBlock, value);
    });
  }

  Future<int?> loadLastBlock() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getInt(lastBlock);
    });
  }

  Future<void> saveListNodes(String value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setString(listNodes, value);
    });
  }

  Future<String?> loadNodesList() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString(listNodes);
    });
  }

  Future<void> saveDelaySync(int value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setInt(delaySync, value);
    });
  }

  Future<int?> loadDelaySync() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getInt(delaySync);
    });
  }

  Future<void> saveRPCAddress(String value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setString(rpcAddress, value);
    });
  }

  Future<String?> loadRPCAddress() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString(rpcAddress);
    });
  }

  Future<void> saveRPCMethodsIgnored(String value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setString(rpcMethodsIgnored, value);
    });
  }

  Future<String?> loadRPCMethodsIgnored() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString(rpcMethodsIgnored);
    });
  }

  Future<void> saveRPCDefaultAddress(String value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setString(rpcAddressDefault, value);
    });
  }

  Future<String?> loadRPCDefaultAddress() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString(rpcAddressDefault);
    });
  }

}
