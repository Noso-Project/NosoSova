import 'package:nososova/models/rest_api/block_info.dart';

abstract class CoinInfoEvent {}

class UpdateCoinInfo extends CoinInfoEvent {
  final BlockInfo blockInfo;

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
