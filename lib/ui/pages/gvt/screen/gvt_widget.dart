import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../config/responsive.dart';
import '../../../theme/decoration/gvt/gvt_gradient_decoration.dart';
import '../../../theme/decoration/gvt/gvt_gradient_decoration_round.dart';
import '../../../theme/style/text_style.dart';

class GvtCardHead extends StatelessWidget {
  final int gvtsTotal;

  const GvtCardHead({super.key, required this.gvtsTotal});

  @override
  Widget build(BuildContext context) {
    return !Responsive.isMobile(context)
        ? Container(
            height: 350,
            width: double.infinity,
            decoration: const GvtGradientDecoration(),
            child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: _gvtBody(context))
                ])))
        : Container(
            width: double.infinity,
            decoration: const GvtGradientDecorationRound(),
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: _gvtBody(context))));
  }

  _gvtBody(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.balance,
              style: AppTextStyles.infoItemValue
                  .copyWith(color: Colors.white.withOpacity(0.5))),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(gvtsTotal.toString(), style: AppTextStyles.gvtBalance),
                Text("/100",
                    style: AppTextStyles.gvtBalance
                        .copyWith(color: Colors.white.withOpacity(0.4))),
              ]),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.whatGvt,
              style: AppTextStyles.infoItemValue
                  .copyWith(color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.gvtAbout,
            style: AppTextStyles.infoItemTitle
                .copyWith(color: Colors.white.withOpacity(1), fontSize: 14),
          ),
          const SizedBox(height: 30),
        ]);
  }
}
