import 'package:nososova/services/shared_service.dart';

class SharedRepository {
  final SharedService _sharedService;

  SharedRepository(this._sharedService);

  Future<void> saveLastSeed(String ipPort) async {
    await _sharedService.saveLastSeed(ipPort);
  }

  Future<String?> loadLastSeed() async {
    return _sharedService.loadLastSeed();
  }

  Future<void> saveLastBlock(int block) async {
    await _sharedService.saveLastBlock(block);
  }

  Future<int?> loadLastBlock() async {
    return _sharedService.loadLastBlock();
  }

  Future<void> saveNodesList(String nodesList) async {
    await _sharedService.saveListNodes(nodesList);
  }

  Future<String?> loadNodesList() async {
    return _sharedService.loadNodesList();
  }

  Future<void> saveDelaySync(int nodesList) async {
    await _sharedService.saveDelaySync(nodesList);
  }

  Future<int?> loadDelaySync() async {
    return _sharedService.loadDelaySync();
  }

  Future<void> saveRPCStatus(bool value) async {
    await _sharedService.saveRPCStatus(value);
  }

  Future<bool?> loadRPCStatus() async {
    return _sharedService.loadRPCStatus();
  }

  Future<void> saveRPCAddress(String value) async {
    await _sharedService.saveRPCAddress(value);
  }

  Future<String?> loadRPCAddress() async {
    return _sharedService.loadRPCAddress();
  }
}
