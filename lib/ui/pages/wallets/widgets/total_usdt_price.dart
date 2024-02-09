import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nososova/blocs/coininfo_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/network_const.dart';
import '../../../theme/style/colors.dart';
import '../../../theme/style/text_style.dart';

class ItemTotalPrice extends StatelessWidget {
  final double totalPrice;

  const ItemTotalPrice({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinInfoBloc, CoinInfoState>(builder: (context, state) {
      var diff = state.statisticsCoin.getDiff;
      var priceDif = ((((state.statisticsCoin.getCurrentPrice * totalPrice) -
          state.statisticsCoin.getLastPrice * totalPrice)));

      var totalUsdtBalance = totalPrice * state.statisticsCoin.getCurrentPrice;

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          AppLocalizations.of(context)!.infoTotalPriceUst,
          style: AppTextStyles.infoItemValue
              .copyWith(color: Colors.white.withOpacity(0.5), fontSize: 14),
        ),
        if (state.statisticsCoin.apiStatus != ApiStatus.error) ...[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${totalUsdtBalance.toStringAsFixed(2)} USDT",
                style: AppTextStyles.infoItemValue.copyWith(
                    color: Colors.white.withOpacity(0.8), fontSize: 20)),
            const SizedBox(width: 10),
            Row(children: [
              Tooltip(
                  message: AppLocalizations.of(context)!.pnlDay,
                  child: Text(
                      "${state.statisticsCoin.getDiff < 0 ? "" : "+"}${priceDif.toStringAsFixed(2)} USDT",
                      style: AppTextStyles.infoItemValue.copyWith(
                          color: diff == 0
                              ? Colors.white.withOpacity(0.4)
                              : diff < 0
                                  ? CustomColors.negativeBalance
                                  : CustomColors.positiveBalance,
                          fontSize: 14))),
              const SizedBox(width: 10),
              if (state.statisticsCoin.apiStatus == ApiStatus.loading)
                LoadingAnimationWidget.prograssiveDots(
                    color: Colors.white.withOpacity(0.5), size: 16)
            ])
          ])
        ],
        if (state.statisticsCoin.apiStatus == ApiStatus.error)
          Text("${AppLocalizations.of(context)!.priceInfoErrorServer} ",
              style: AppTextStyles.infoItemTitle
                  .copyWith(color: Colors.white.withOpacity(0.8), fontSize: 16))
      ]);
    });
  }
}
