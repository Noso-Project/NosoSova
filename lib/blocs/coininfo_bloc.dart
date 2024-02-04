import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:nososova/models/rest_api/block_info.dart';

import '../models/app/stats.dart';
import '../repositories/repositories.dart';
import '../utils/network_const.dart';
import 'debug_bloc.dart';
import 'events/coininfo_events.dart';

class CoinInfoState {
  final StatisticsCoin statisticsCoin;

  CoinInfoState({
    StatisticsCoin? statisticsCoin,
  }) : statisticsCoin = statisticsCoin ?? StatisticsCoin();

  CoinInfoState copyWith({
    StatisticsCoin? statisticsCoin,
  }) {
    return CoinInfoState(
      statisticsCoin: statisticsCoin ?? this.statisticsCoin,
    );
  }
}

class CoinInfoBloc extends Bloc<CoinInfoEvent, CoinInfoState> {
  final Repositories _repositories;
  Timer? _timerSyncPriceHistory;

  CoinInfoBloc({
    required Repositories repositories,
    required DebugBloc debugBloc,
  })  : _repositories = repositories,
        super(CoinInfoState()) {
    on<LoadPriceHistory>(_updatePriceHistory);
    on<UpdateSupply>(_updateSupply);
    on<InitBloc>(_initBloc);
    on<UpdateCoinInfo>(_updateCoinInfo);
  }

  Future<void> _updateCoinInfo(
    event,
    emit,
  ) async {
    BlockInfo blockInfo = event.blockInfo;

    print(blockInfo.blockId);
    emit(state.copyWith(
        statisticsCoin: state.statisticsCoin.copyWith(
            lastBlock: blockInfo.blockId,
            reward: blockInfo.reward,
            totalNodes: blockInfo.count)));
  }

  Future<void> _initBloc(
    event,
    emit,
  ) async {
    _startTimerSyncPriceHistory();
    add(LoadPriceHistory());
  }

  Future<void> _updateSupply(
    event,
    emit,
  ) async {
    emit(state.copyWith(
        statisticsCoin:
            state.statisticsCoin.copyWith(totalCoin: event.supply)));
  }

  Future<void> _updatePriceHistory(
    event,
    emit,
  ) async {
    emit(state.copyWith(
        statisticsCoin:
            state.statisticsCoin.copyWith(apiStatus: ApiStatus.loading)));
    var responsePriceHistory =
        await _repositories.networkRepository.fetchHistoryPrice();

    var lastblock = 0;
    if (responsePriceHistory.errors == null) {
      emit(state.copyWith(
          statisticsCoin: state.statisticsCoin.copyWith(
              historyCoin: responsePriceHistory.value,
              lastBlock: lastblock,
              apiStatus: ApiStatus.connected,
              lastTimeUpdatePrice: DateTime.now().millisecondsSinceEpoch)));
    } else if (state.statisticsCoin.apiStatus == ApiStatus.loading) {
      emit(state.copyWith(
          statisticsCoin: state.statisticsCoin
              .copyWith(lastBlock: lastblock, apiStatus: ApiStatus.error)));
    }
  }

  void _startTimerSyncPriceHistory() {
    _timerSyncPriceHistory ??=
        Timer.periodic(const Duration(seconds: 60), (timer) async {
      add(LoadPriceHistory());
    });
  }

  void _stopSyncPriceHistory() {
    _timerSyncPriceHistory?.cancel();
    _timerSyncPriceHistory = null;
  }

  @override
  Future<void> close() {
    _stopSyncPriceHistory();
    return super.close();
  }
}
