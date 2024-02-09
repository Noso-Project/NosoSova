import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/anim/blinkin_widget.dart';
import '../../../theme/style/colors.dart';
import '../../../theme/style/text_style.dart';

class PendingCard extends StatelessWidget {
  final double outgoing;
  final double incoming;

  const PendingCard(
      {super.key, required this.outgoing, required this.incoming});

  @override
  Widget build(BuildContext context) {
    var isOutgoing = outgoing > 0;
    var isIncoming = incoming > 0;

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppLocalizations.of(context)!.incoming,
            style: AppTextStyles.infoItemValue
                .copyWith(color: Colors.white.withOpacity(0.5))),
        BlinkingWidget(
            widget: Text(incoming.toStringAsFixed(5),
                style: AppTextStyles.infoItemValue.copyWith(
                    color: isIncoming
                        ? CustomColors.positiveBalance
                        : Colors.white.withOpacity(0.8))),
            startBlinking: isIncoming,
            duration: 1000)
      ]),
      const SizedBox(width: 20),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(AppLocalizations.of(context)!.outgoing,
            style: AppTextStyles.infoItemValue
                .copyWith(color: Colors.white.withOpacity(0.5))),
        BlinkingWidget(
            widget: Text(outgoing.toStringAsFixed(5),
                style: AppTextStyles.infoItemValue.copyWith(
                  color: isOutgoing
                      ? CustomColors.negativeBalance
                      : Colors.white.withOpacity(0.8),
                )),
            startBlinking: isOutgoing,
            duration: 1000)
      ])
    ]);
  }
}
