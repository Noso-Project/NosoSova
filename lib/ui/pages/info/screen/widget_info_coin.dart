import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nososova/blocs/coininfo_bloc.dart';
import 'package:nososova/ui/theme/style/colors.dart';

import '../../../../blocs/events/coininfo_events.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/app/stats.dart';
import '../../../../utils/date_utils.dart';
import '../../../../utils/network_const.dart';
import '../../../common/widgets/custom/dasher_divider.dart';
import '../../../common/widgets/item_info_widget.dart';
import '../../../config/responsive.dart';
import '../../../theme/style/text_style.dart';

class WidgetInfoCoin extends StatefulWidget {
  const WidgetInfoCoin({super.key});

  @override
  State createState() => _WidgetInfoCoinState();
}

class _WidgetInfoCoinState extends State<WidgetInfoCoin>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectIndexTab = 0;
  bool isVisibleAction = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinInfoBloc, CoinInfoState>(builder: (context, state) {
      var infoCoin = state.statisticsCoin;
      var diff = infoCoin.getDiff;
      var gradient = [
        CustomColors.primaryColor,
        diff > 0 ? CustomColors.positiveBalance : CustomColors.negativeBalance
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nosoPrice,
                          style: AppTextStyles.textHiddenMedium(context),
                        ),
                        if (!Responsive.isMobile(context))
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                isVisibleAction = !isVisibleAction;
                              });
                            },
                            icon: Icon(
                              isVisibleAction
                                  ? Icons.expand_less
                                  : Icons.expand_more_outlined,
                              size: 22,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              infoCoin.getCurrentPrice.toStringAsFixed(6),
                              style:
                                  AppTextStyles.priceValue,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "USDT",
                              style: AppTextStyles.priceValue.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                        IconButton(
                            disabledColor: Colors.grey,
                            tooltip: AppLocalizations.of(context)!.updateInfo,
                            icon: const Icon(Icons.restart_alt_outlined),
                            onPressed: infoCoin.apiStatus == ApiStatus.loading
                                ? null
                                : () => context
                                    .read<CoinInfoBloc>()
                                    .add(LoadPriceHistory())),
                      ],
                    ),
                    Text(
                      "${diff < 0 ? "" : "+"}${diff.toStringAsFixed(2)}%",
                      style: AppTextStyles.priceValue.copyWith(
                          color: diff == 0
                              ? Theme.of(context).colorScheme.outline
                              : diff < 0
                                  ? CustomColors.negativeBalance
                                  : CustomColors.positiveBalance,
                          fontSize: 18),
                    ),
                    if (Responsive.isMobile(context) || isVisibleAction)
                      const SizedBox(height: 20),
                    if (Responsive.isMobile(context) || isVisibleAction)
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(
                              show: false,
                            ),
                            titlesData: const FlTitlesData(
                              show: false,
                            ),
                            lineTouchData: const LineTouchData(enabled: true),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: infoCoin
                                    .getIntervalPrices(30)
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.price,
                                  );
                                }).toList(),
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: gradient,
                                ),
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(
                                  show: false,
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: gradient
                                        .map((color) => color.withOpacity(0.3))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ])),
          if (infoCoin.apiStatus == ApiStatus.error) ...[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomColors.negativeBalance.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CustomColors.negativeBalance),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                      AppLocalizations.of(context)!.stopSync,
                      style: AppTextStyles.infoItemValue.copyWith(color: CustomColors.negativeBalance),
                    ),
                  ),
                )),
            const SizedBox(height: 10)
          ] else ...[
            if (Responsive.isMobile(context) || isVisibleAction)
              Tooltip(
                  message: AppLocalizations.of(context)!.updatePriceMinute,
                  child: ItemInfoWidget(
                      nameItem: AppLocalizations.of(context)!.updateTim,
                      value: DateUtil.getTime(infoCoin.lastTimeUpdatePrice),
                      onShimmer: infoCoin.apiStatus == ApiStatus.loading))
          ],
          if (!Responsive.isMobile(context)) ...[
            if (Responsive.isMobile(context) || isVisibleAction) ...[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DasherDivider(
                      color: Theme.of(context).colorScheme.outline)),
              ItemInfoWidget(
                  nameItem: AppLocalizations.of(context)!.numberOfMinedCoins,
                  value: NumberFormat.compact().format(infoCoin.getTotalCoin)),
              ItemInfoWidget(
                  nameItem: AppLocalizations.of(context)!.marketcap,
                  value:
                      "\$${NumberFormat.compact().format(infoCoin.getMarketCap)}"),
              ItemInfoWidget(
                  nameItem: AppLocalizations.of(context)!.activeNodes,
                  value: infoCoin.totalNodes.toString()),
              const SizedBox(
                height: 10,
              )
            ]
          ],
          if (Responsive.isMobile(context)) ...[
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              onTap: (index) {
                setState(() {
                  selectIndexTab = index;
                });
              },
              tabs: [
                Tab(
                  child: Text(

                    AppLocalizations.of(context)!.information,
                    style: selectIndexTab == 0
                        ? AppTextStyles.tabActive
                        : AppTextStyles.tabInActive,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.masternodes,
                    style: selectIndexTab == 1
                        ? AppTextStyles.tabActive
                        : AppTextStyles.tabInActive,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                information(infoCoin),
                masterNodes(infoCoin, 0),
              ],
            ))
          ],
        ],
      );
    });
  }

  information(StatisticsCoin infoCoin) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.daysUntilNextHalving,
            value: infoCoin.getHalvingTimer.days.toString()),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.numberOfMinedCoins,
            value:
                "${NumberFormat.compact().format(infoCoin.getTotalCoin)}/21M"),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.coinsLocked,
            value: NumberFormat.compact().format(infoCoin.getCoinLockNoso)),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.marketcap,
            value: "\$${NumberFormat.compact().format(infoCoin.getMarketCap)}"),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.tvl,
            value:
                "\$${NumberFormat.compact().format(infoCoin.getCoinLockPrice)}"),
      ],
    ));
  }

  masterNodes(StatisticsCoin infoCoin, int blockHeight) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.activeNodes,
            value: infoCoin.totalNodes.toString()),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.rewardNode,
            value: "",
            isBoldTitle: true),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.nbr,
            value: "${infoCoin.getBlockOneNodeReward.toStringAsFixed(5)} NOSO"),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.nr24,
            value: "${infoCoin.getBlockDayNodeReward.toStringAsFixed(5)} NOSO"),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.nr7,
            value:
                "${infoCoin.getBlockWeekNodeReward.toStringAsFixed(5)} NOSO"),
        ItemInfoWidget(
            nameItem: AppLocalizations.of(context)!.nr30,
            value:
                "${infoCoin.getBlockMonthNodeReward.toStringAsFixed(5)} NOSO")
      ],
    ));
  }
}
