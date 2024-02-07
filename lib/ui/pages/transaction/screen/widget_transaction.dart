import 'package:flutter/material.dart';
import 'package:noso_dart/const.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/icons_style.dart';

import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/rest_api/transaction_history.dart';
import '../../../theme/style/text_style.dart';
import '../../../common/widgets/custom/dasher_divider.dart';
import '../../../common/widgets/item_info_widget.dart';

class TransactionWidgetInfo extends StatefulWidget {
  final TransactionHistory transaction;
  final bool isReceiver;
  final bool isProcess;

  const TransactionWidgetInfo(
      {Key? key,
      required this.transaction,
      required this.isReceiver,
      this.isProcess = false})
      : super(key: key);

  @override
  State createState() => _TransactionWidgetInfoState();
}

class _TransactionWidgetInfoState extends State<TransactionWidgetInfo> {
  bool isCustom = false;

  @override
  void initState() {
    super.initState();

    isCustom = widget.transaction.type == "CUSTOM";
  }

  @override
  Widget build(BuildContext context) {
    var amount = double.parse(widget.transaction.amount.replaceAll(' ', ''));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isCustom
                          ? Colors.grey.withOpacity(0.2)
                          : widget.isReceiver
                              ? const Color(0xffd6faeb)
                              : const Color(0xfff2d3ce),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: AppIconsStyle.icon8x0(
                        isCustom
                            ? Assets.iconsRename
                            : widget.isReceiver
                                ? Assets.iconsExport
                                : Assets.iconsImport,
                        colorCustom: isCustom
                            ? Theme.of(context).colorScheme.onSurface
                            : widget.isReceiver
                                ? CustomColors.positiveBalance
                                : CustomColors.negativeBalance)),
                const SizedBox(height: 20),
                Text(
                    isCustom
                        ? AppLocalizations.of(context)!.editCustom
                        : "${widget.isReceiver ? "+" : "-"}${amount.toStringAsFixed(5)} ${NosoConst.coinName}",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.balance.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 20),
                Text(
                    "${AppLocalizations.of(context)!.block}: ${widget.transaction.blockId.toString()}",
                    style: AppTextStyles.infoItemValue),
                const SizedBox(height: 10),
                if (!widget.isProcess) ...[
                  Text(widget.transaction.timestamp,
                      style: AppTextStyles.textHiddenMedium(context)),
                ] else ...[
                  Text(AppLocalizations.of(context)!.sendProcess,
                      style: AppTextStyles.textHiddenMedium(context)),
                ],
                const SizedBox(height: 20),
                const DasherDivider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                ItemInfoWidgetVertical(
                    nameItem: AppLocalizations.of(context)!.orderId,
                    value: widget.transaction.id,
                    copy: true),
                if (!widget.isReceiver && !isCustom)
                  ItemInfoWidgetVertical(
                      nameItem: AppLocalizations.of(context)!.receiver,
                      value: widget.transaction.receiver),
                if (widget.isReceiver)
                  ItemInfoWidgetVertical(
                      nameItem: AppLocalizations.of(context)!.sender,
                      value: widget.transaction.sender),
                if (!widget.isReceiver)
                  ItemInfoWidgetVertical(
                      nameItem: AppLocalizations.of(context)!.commission,
                      value: "${widget.transaction.fee} ${NosoConst.coinName}"),
                if (isCustom)
                  ItemInfoWidgetVertical(
                      nameItem: AppLocalizations.of(context)!.message,
                      value: "CUSTOM"),
              ],
            )),
      ],
    );
  }
}
