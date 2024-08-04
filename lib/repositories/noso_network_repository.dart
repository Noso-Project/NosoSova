import 'package:noso_dart/models/noso/seed.dart';
import 'package:nososova/services/noso_network_service.dart';

import '../models/responses/response_node.dart';

class NosoNetworkRepository {
  final NosoNetworkService _nodeService;

  NosoNetworkRepository(this._nodeService);

  Future<ResponseNode<List<int>>> fetchNode(String command, Seed seed) {
    return _nodeService.fetchNode(command, seed);
  }

  Future<ResponseNode<List<int>>> getRandomDevNode(List<Seed> seedsDefault) {
    return _nodeService.getRandomDevNode(seedsDefault);
  }
}
