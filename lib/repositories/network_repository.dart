import 'package:noso_dart/models/noso/seed.dart';
import 'package:nososova/services/explorer_stats_service.dart';
import 'package:nososova/services/node_service.dart';

import '../models/responses/response_api.dart';
import '../models/responses/response_node.dart';

class NetworkRepository {
  final NodeService _nodeService;
  final ExplorerStatsService _explorerStatsService;

  NetworkRepository(this._nodeService, this._explorerStatsService);

  /// Node Service
  Future<ResponseNode<List<int>>> fetchNode(String command, Seed seed) {
    return _nodeService.fetchNode(command, seed);
  }

  Future<ResponseNode<List<int>>> getRandomDevNode() {
    return _nodeService.getRandomDevNode();
  }

  /// Api REST
  /// https://api.nosocoin.com/docs/
  Future<ResponseApi> fetchHistoryTransactions(String hashAddress) {
    return _explorerStatsService.fetchHistoryTransactions(hashAddress);
  }

  Future<ResponseApi> fetchHistoryPrice() {
    return _explorerStatsService.fetchHistoryPrice();
  }

  Future<ResponseApi> fetchLastBlockInfo() {
    return _explorerStatsService.fetchLastBlockInfo();
  }

  Future<ResponseApi> fetchNodeStatus(String targetHash) {
    return _explorerStatsService.fetchNodeStatus(targetHash);
  }

  Future<ResponseApi> fetchExchangeList() {
    return _explorerStatsService.fetchExchangeList();
  }

  Future<ResponseApi> fetchHeathCheck() {
    return _explorerStatsService.fetchHeathCheck();
  }
}
