import '../../utils/network_const.dart';

class AppBlocConfig {
  late String? _lastSeed;
  late String? _nodesList;
  late int? _lastBlock;
  int _delaySync = NetworkConst.delaySync;
  bool _isOneStartup = true;
  late int? _countAttempsConnections = 0;

  AppBlocConfig({
    String? lastSeed,
    String? nodesList,
    int? lastBlock,
    int? delaySync,
    int? countAttempsConnections,
    bool? isOneStartup,
  }) {
    _lastSeed = lastSeed;
    _nodesList = nodesList;
    _lastBlock = lastBlock;
    _countAttempsConnections = countAttempsConnections;
    _delaySync = delaySync ?? NetworkConst.delaySync;
    _isOneStartup = isOneStartup ?? false;
  }

  String? get lastSeed => _lastSeed;

  String? get nodesList => _nodesList;

  int? get lastBlock => _lastBlock;

  int get delaySync => _delaySync;

  bool get isOneStartup => _isOneStartup;

  int? get getCountErrors => _countAttempsConnections;

  AppBlocConfig copyWith({
    String? lastSeed,
    String? nodesList,
    int? lastBlock,
    int? delaySync,
    int? countAttempsConnections,
    bool? isOneStartup,
  }) {
    return AppBlocConfig(
        lastSeed: lastSeed ?? _lastSeed,
        nodesList: nodesList ?? _nodesList,
        lastBlock: lastBlock ?? _lastBlock,
        countAttempsConnections:
            countAttempsConnections ?? _countAttempsConnections,
        delaySync: delaySync ?? _delaySync,
        isOneStartup: _isOneStartup = isOneStartup ?? false);
  }
}
