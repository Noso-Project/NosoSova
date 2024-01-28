import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nososova/blocs/app_data_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/status_api.dart';
import '../../../theme/style/colors.dart';
import '../../../theme/style/text_style.dart';

class ItemTotalPrice extends StatelessWidget {
  final double totalPrice;

  const ItemTotalPrice({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppDataState>(builder: (context, state) {
      var diff = state.statisticsCoin.getDiff;
      var priceDif = ((((state.statisticsCoin.getCurrentPrice * totalPrice) -
          state.statisticsCoin.getLastPrice * totalPrice)));

      var totalUsdtBalance = totalPrice * state.statisticsCoin.getCurrentPrice;

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          AppLocalizations.of(context)!.infoTotalPriceUst,
          style: AppTextStyles.titleMin
              .copyWith(color: Colors.white.withOpacity(0.5), fontSize: 16),
        ),
        if (state.statisticsCoin.apiStatus == ApiStatus.connected) ...[
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "${totalUsdtBalance.toStringAsFixed(2)} USDT",
              style: AppTextStyles.titleMin
                  .copyWith(color: Colors.white.withOpacity(0.8)),
            ),
            const SizedBox(width: 10),
            Tooltip(
                message: AppLocalizations.of(context)!.pnlDay,
                child: Text(
                  "${state.statisticsCoin.getDiff < 0 ? "" : "+"}${priceDif.toStringAsFixed(2)} USDT",
                  style: AppTextStyles.titleMin.copyWith(
                      color: diff == 0
                          ? Colors.white.withOpacity(0.4)
                          : diff < 0
                              ? CustomColors.negativeBalance
                              : CustomColors.positiveBalance,
                      fontSize: 16),
                )),
          ])
        ],
        if (state.statisticsCoin.apiStatus == ApiStatus.loading)
          LoadingAnimationWidget.prograssiveDots(
            color: Colors.white.withOpacity(0.5),
            size: 30,
          ),
        if (state.statisticsCoin.apiStatus == ApiStatus.error)
          Text(
            "${AppLocalizations.of(context)!.priceInfoErrorServer} ",
            style: AppTextStyles.itemStyle
                .copyWith(color: Colors.white.withOpacity(0.8), fontSize: 16),
          ),
      ]);
    });
  }
}
