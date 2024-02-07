import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noso_dart/const.dart';
import 'package:nososova/ui/common/route/dialog_router.dart';

import '../../../../blocs/wallet_bloc.dart';
import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/address_wallet.dart';
import '../../../common/route/page_router.dart';
import '../../../config/responsive.dart';
import '../../../theme/anim/blinkin_widget.dart';
import '../../../theme/decoration/standart_gradient_decoration.dart';
import '../../../theme/decoration/standart_gradient_decoration_round.dart';
import '../../../theme/style/button_style.dart';
import '../../../theme/style/colors.dart';
import '../../../theme/style/text_style.dart';
import '../widgets/total_usdt_price.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return !Responsive.isMobile(context)
        ? Container(
            height: 350,
            width: double.infinity,
            decoration: !Responsive.isMobile(context)
                ? const HomeGradientDecoration()
                : const HomeGradientDecorationRound(),
            child: const SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: CardBody())
                ],
              ),
            ),
          )
        : Container(
            width: double.infinity,
            decoration: !Responsive.isMobile(context)
                ? const HomeGradientDecoration()
                : const HomeGradientDecorationRound(),
            child: const SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: CardBody()),
            ),
          );
  }
}

class CardBody extends StatefulWidget {
  const CardBody({Key? key}) : super(key: key);

  @override
  State createState() => _CardBodyState();
}

class _CardBodyState extends State<CardBody> {
  bool isVisibleAction = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        var isOutgoing = state.wallet.totalOutgoing > 0;
        var isIncoming = state.wallet.totalIncoming > 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.balance,
              style: AppTextStyles.infoItemValue.copyWith(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.wallet.balanceTotal.toStringAsFixed(2),
                  style: AppTextStyles.balance,
                ),
                const SizedBox(width: 5),
                Text(
                  NosoConst.coinName,
                  style: AppTextStyles.nosoName,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ItemTotalPrice(totalPrice: state.wallet.balanceTotal),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.incoming,
                          style: AppTextStyles.infoItemValue.copyWith(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        BlinkingWidget(
                          widget: Text(
                            state.wallet.totalIncoming.toStringAsFixed(8),
                            style: AppTextStyles.infoItemValue.copyWith(
                              color: isIncoming
                                  ? CustomColors.positiveBalance
                                  : Colors.white.withOpacity(0.8),
                            ),
                          ),
                          startBlinking: isIncoming,
                          duration: 1000,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.outgoing,
                          style: AppTextStyles.infoItemValue.copyWith(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        BlinkingWidget(
                          widget: Text(
                            state.wallet.totalOutgoing.toStringAsFixed(8),
                            style: AppTextStyles.infoItemValue.copyWith(
                              color: isOutgoing
                                  ? CustomColors.negativeBalance
                                  : Colors.white.withOpacity(0.8),
                            ),
                          ),
                          startBlinking: isOutgoing,
                          duration: 1000,
                        ),
                      ],
                    ),
                  ],
                ),
                if (Responsive.isMobile(context))
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isVisibleAction = !isVisibleAction;
                        });
                      },
                      icon: Icon(
                        isVisibleAction
                            ? Icons.expand_less
                            : Icons.expand_more_outlined,
                        size: 32,
                        color: Colors.white.withOpacity(0.4),
                      ))
              ],
            ),
            const SizedBox(height: 20),
            if (!Responsive.isMobile(context) || isVisibleAction)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppButtonStyle.buttonAction(
                      context,
                      Assets.iconsOutput,
                      AppLocalizations.of(context)!.sendCoins,
                      () => PageRouter.routePaymentPage(
                        context,
                        Address(hash: "", publicKey: "", privateKey: ""),
                      ),
                    ),
                    const SizedBox(width: 20),
                    AppButtonStyle.buttonAction(
                      context,
                      Assets.iconsPendingTransaction,
                      AppLocalizations.of(context)!.pendingTransaction,
                      () => DialogRouter.showDialogPendingTransaction(context),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            if (Responsive.isMobile(context)) const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
