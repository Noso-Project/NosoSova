import 'package:noso_rest_api/models/nodes_info.dart';

abstract class CoinInfoEvent {}

class UpdateCoinInfo extends CoinInfoEvent {
  final NodesInfo blockInfo;

  UpdateCoinInfo(this.blockInfo);
}

class UpdateSupply extends CoinInfoEvent {
  final double supply;

  UpdateSupply(this.supply);
}

class LoadPriceHistory extends CoinInfoEvent {
  LoadPriceHistory();
}

class InitBloc extends CoinInfoEvent {
  InitBloc();
}
