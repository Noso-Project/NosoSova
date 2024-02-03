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
import '../../../common/components/info_item.dart';
import '../../../common/widgets/custom/dasher_divider.dart';
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
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
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
                              color:  Colors.black,
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
                              style: AppTextStyles.titleMin
                                  .copyWith(fontSize: 36, color: Colors.black),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "USDT",
                              style: AppTextStyles.titleMin
                                  .copyWith(color: Colors.black),
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
                      style: AppTextStyles.titleMin.copyWith(
                          color: diff == 0
                              ? Colors.black
                              : diff < 0
                                  ? CustomColors.negativeBalance
                                  : CustomColors.positiveBalance,
                          fontSize: 20),
                    ),

                    if(Responsive.isMobile(context) || isVisibleAction)  const SizedBox(height: 20),
                    if(Responsive.isMobile(context) || isVisibleAction)   SizedBox(
                      height: 120,
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
                      style: AppTextStyles.walletAddress.copyWith(
                          fontSize: 14, color: CustomColors.negativeBalance),
                    ),
                  ),
                )),
            const SizedBox(height: 10)
          ] else ...[
            if(Responsive.isMobile(context) || isVisibleAction)    Tooltip(
                message: AppLocalizations.of(context)!.updatePriceMinute,
                child: InfoItem().itemInfo(
                    AppLocalizations.of(context)!.updateTim,
                    DateUtil.getTime(infoCoin.lastTimeUpdatePrice),
                    srinkin: infoCoin.apiStatus == ApiStatus.loading))
          ],
          if (!Responsive.isMobile(context)) ...[
            if(Responsive.isMobile(context) || isVisibleAction) ...[     const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DasherDivider(color: Colors.grey)),
            InfoItem().itemInfo(
                AppLocalizations.of(context)!.numberOfMinedCoins,
                NumberFormat.compact().format(infoCoin.getTotalCoin)),
            InfoItem().itemInfo(AppLocalizations.of(context)!.marketcap,
                "\$${NumberFormat.compact().format(infoCoin.getMarketCap)}"),
            InfoItem().itemInfo(AppLocalizations.of(context)!.activeNodes,
                infoCoin.totalNodes.toString()),
            const SizedBox(
              height: 10,
            )
      ]
          ],
          if (Responsive.isMobile(context)) ...[
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DasherDivider(color: Colors.grey)),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF2B2F4F).withOpacity(0.4),
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
                        ? AppTextStyles.walletAddress
                            .copyWith(color: Colors.black, fontSize: 20)
                        : AppTextStyles.itemStyle
                            .copyWith(color: Colors.black, fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.masternodes,
                    style: selectIndexTab == 1
                        ? AppTextStyles.walletAddress
                            .copyWith(color: Colors.black, fontSize: 20)
                        : AppTextStyles.itemStyle
                            .copyWith(color: Colors.black, fontSize: 20),
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
        InfoItem().itemInfo(AppLocalizations.of(context)!.daysUntilNextHalving,
            infoCoin.getHalvingTimer.days.toString()),
        InfoItem().itemInfo(AppLocalizations.of(context)!.numberOfMinedCoins,
            NumberFormat.compact().format(infoCoin.getTotalCoin),
            twoValue: "21M"),
        InfoItem().itemInfo(AppLocalizations.of(context)!.coinsLocked,
            NumberFormat.compact().format(infoCoin.getCoinLockNoso)),
        InfoItem().itemInfo(AppLocalizations.of(context)!.marketcap,
            "\$${NumberFormat.compact().format(infoCoin.getMarketCap)}"),
        InfoItem().itemInfo(AppLocalizations.of(context)!.tvl,
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
        InfoItem().itemInfo(AppLocalizations.of(context)!.activeNodes,
            infoCoin.totalNodes.toString()),
        InfoItem().itemInfo(AppLocalizations.of(context)!.tmr,
            "${infoCoin.getBlockSummaryReward.toStringAsFixed(5)} NOSO"),
        InfoItem().itemInfo(AppLocalizations.of(context)!.nbr,
            "${infoCoin.getBlockOneNodeReward.toStringAsFixed(5)} NOSO"),
        InfoItem().itemInfo(AppLocalizations.of(context)!.nr24,
            "${infoCoin.getBlockDayNodeReward.toStringAsFixed(5)} NOSO"),
        InfoItem().itemInfo(AppLocalizations.of(context)!.nr7,
            "${infoCoin.getBlockWeekNodeReward.toStringAsFixed(5)} NOSO"),
        InfoItem().itemInfo(AppLocalizations.of(context)!.nr30,
            "${infoCoin.getBlockMonthNodeReward.toStringAsFixed(5)} NOSO")
      ],
    ));
  }
}
