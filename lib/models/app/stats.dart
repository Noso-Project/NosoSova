import 'package:noso_dart/models/halving.dart';

import '../../utils/network_const.dart';
import '../rest_api/price_dat.dart';

class StatisticsCoin {
  double totalCoin;
  int totalNodes;
  int lastBlock;
  int lastTimeUpdatePrice;
  double reward;
  List<PriceData>? historyCoin;
  ApiStatus apiStatus;

  StatisticsCoin({
    this.totalCoin = 0,
    this.totalNodes = 0,
    this.lastBlock = 0,
    this.lastTimeUpdatePrice = 0,
    this.reward = 0.15,
    this.historyCoin,
    this.apiStatus = ApiStatus.loading,
  });

  double get getCurrentPrice => historyCoin?.reversed.toList().first.price ?? 0;

  Halving get getHalvingTimer => lastBlock == 0 ? Halving(days: 0) : Halving().getHalvingTimer(lastBlock);

  get getTotalCoin => totalCoin;

  get getCoinLockNoso => totalNodes * 10500;

  get getMarketCap => totalCoin * getCurrentPrice;

  get getCoinLockPrice => getCoinLockNoso * getCurrentPrice;

  get getBlockSummaryReward => reward * totalNodes;

  get getBlockOneNodeReward => reward;

  get getBlockDayNodeReward => reward * 144;

  get getBlockWeekNodeReward => reward * 1008;

  get getBlockMonthNodeReward => reward * 4320;

  get getLastPrice => historyCoin?.reversed.toList().last.price ?? 0.0000000;

  get getDiff => getCurrentPrice != 0 && getLastPrice != 0
      ? (((getCurrentPrice - getLastPrice) / getLastPrice) * 100)
      : 0;

  /// Method that returns a list of prices with a given interval
  List<PriceData> getIntervalPrices(int minutes) {
    List<PriceData> lastTenWithInterval = [];
    var dtPrice = historyCoin?.toList() ?? [];

    for (PriceData priceData in dtPrice) {
      DateTime targetTime = DateTime.parse(priceData.timestamp);
      DateTime lastTime = DateTime.parse(lastTenWithInterval.isEmpty
          ? "2023-12-17 17:39:00"
          : lastTenWithInterval.last.timestamp);

      if (lastTenWithInterval.isEmpty ||
          lastTime.difference(targetTime).inMinutes < minutes) {
        lastTenWithInterval.add(priceData);
      }
    }

    return lastTenWithInterval;
  }

  StatisticsCoin copyWith({
    double? totalCoin,
    int? totalNodes,
    int? lastBlock,
    int? lastTimeUpdatePrice,
    double? reward,
    ApiStatus? apiStatus,
    List<PriceData>? historyCoin,
  }) {
    return StatisticsCoin(
      totalCoin: totalCoin ?? this.totalCoin,
      totalNodes: totalNodes ?? this.totalNodes,
      lastBlock: lastBlock ?? this.lastBlock,
      lastTimeUpdatePrice: lastTimeUpdatePrice ?? this.lastTimeUpdatePrice,
      reward: reward ?? this.reward,
      apiStatus: apiStatus ?? this.apiStatus,
      historyCoin: historyCoin ?? this.historyCoin,
    );
  }
}
