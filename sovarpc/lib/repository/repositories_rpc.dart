import 'package:noso_rest_api/api_service.dart';
import 'package:nososova/repositories/local_repository.dart';
import 'package:nososova/repositories/noso_network_repository.dart';

import 'file_repository.dart';

class RepositoriesRpc {
  final LocalRepository localRepository;
  final NosoNetworkRepository networkRepository;
  final FileRepositoryRpc fileRepository;
  final NosoApiService nosoApiService;

  RepositoriesRpc({
    required this.localRepository,
    required this.networkRepository,
    required this.fileRepository,
    required this.nosoApiService,
  });
}
