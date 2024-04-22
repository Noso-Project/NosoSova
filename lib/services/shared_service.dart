import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static const String lastSeed = "lastSeed";
  static const String lastBlock = "lastBlock";
  static const String listNodes = "nodesList";
  static const String delaySync = "delaySync";
  static const String rpcStatus = "RPCEnable";
  static const String rpcAddress = "RPCAddress";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  Future<void> saveRPCStatus(bool value) async {
    _prefs.then((SharedPreferences prefs) {
      return prefs.setBool(rpcStatus, value);
    });
  }

  Future<bool?> loadRPCStatus() async {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getBool(rpcStatus);
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
}
