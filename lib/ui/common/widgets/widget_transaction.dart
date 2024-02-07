import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noso_dart/const.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/icons_style.dart';

import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/rest_api/transaction_history.dart';
import '../../../utils/other_utils.dart';
import '../../config/responsive.dart';
import '../../theme/style/text_style.dart';
import 'custom/dasher_divider.dart';

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
                    style: AppTextStyles.balance),
                const SizedBox(height: 20),
                Text(
                    "${AppLocalizations.of(context)!.block}: ${widget.transaction.blockId.toString()}",
                    style: AppTextStyles.infoItemValue),
                const SizedBox(height: 10),
                if (!widget.isProcess) ...[
                  Text(widget.transaction.timestamp,
                      style:
                          AppTextStyles.textHiddenMedium(context)),
                ] else ...[
                  Text(AppLocalizations.of(context)!.sendProcess,
                      style: AppTextStyles.textHiddenMedium(context)),
                ],
                const SizedBox(height: 20),
                const DasherDivider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                itemInfo(AppLocalizations.of(context)!.orderId,
                    widget.transaction.id,
                    copy: true),
                if (!widget.isReceiver && !isCustom)
                  itemInfo(
                      AppLocalizations.of(context)!.receiver,
                      !Responsive.isMobile(context)
                          ? widget.transaction.receiver
                          : OtherUtils.hashObfuscation(
                              widget.transaction.receiver)),
                if (widget.isReceiver)
                  itemInfo(
                      AppLocalizations.of(context)!.sender,
                      !Responsive.isMobile(context)
                          ? widget.transaction.sender
                          : OtherUtils.hashObfuscation(
                              widget.transaction.sender)),
                if (!widget.isReceiver)
                  itemInfo(AppLocalizations.of(context)!.commission,
                      "${widget.transaction.fee} ${NosoConst.coinName}"),
                if (isCustom)
                  itemInfo(AppLocalizations.of(context)!.message, "CUSTOM"),
              ],
            )),
      ],
    );
  }

  itemInfo(String nameItem, String value, {bool copy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nameItem,
            style: AppTextStyles.textHiddenMedium(context),
          ),
          if (copy) ...[
            InkWell(
                onTap: () => Clipboard.setData(
                    ClipboardData(text: widget.transaction.id)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          value,
                          style: AppTextStyles.infoItemValue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.copy,
                        size: 22,
                      ),
                    ]))
          ] else ...[
            Row(children: [
              Text(
                value,
                textAlign: TextAlign.start,
                style: AppTextStyles.infoItemValue,
              ),
            ]),
          ]
        ],
      ),
    );
  }
}
