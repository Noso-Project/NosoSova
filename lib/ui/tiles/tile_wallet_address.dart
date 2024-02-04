import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/anim/blinkin_widget.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../../models/address_wallet.dart';
import '../theme/style/icons_style.dart';

class AddressListTile extends StatefulWidget {
  final VoidCallback onLong;
  final VoidCallback onTap;
  final Address address;

  const AddressListTile({
    Key? key,
    required this.address,
    required this.onLong,
    required this.onTap,
  }) : super(key: key);

  @override
  AddressListTileState createState() => AddressListTileState();
}

class AddressListTileState extends State<AddressListTile> {
  @override
  Widget build(BuildContext context) {
    double netAmount = widget.address.incoming - widget.address.outgoing;
    String netAmountText = netAmount.toStringAsFixed(5);
    Color netAmountColor = netAmount >= 0 ? Colors.green : Colors.red;
    return Tooltip(
        message: messageTooltip(),
        child: GestureDetector(
            onSecondaryTap: widget.onLong,
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 15),
                leading: _iconAddress(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.address.hashPublic,
                          style: AppTextStyles.walletAddress
                              .copyWith(fontSize: 18),
                        ),
                        if (widget.address.custom != null)
                          Text(
                            widget.address.custom ?? "",
                            style:
                                AppTextStyles.itemStyle.copyWith(fontSize: 16),
                          )
                      ],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.address.balance.toStringAsFixed(5),
                            style: AppTextStyles.walletAddress,
                          ),
                          const SizedBox(height: 5),
                          if (netAmount != 0)
                            Text(
                              "${netAmount >= 0 ? '+' : ''}$netAmountText",
                              style: AppTextStyles.walletAddress.copyWith(
                                  fontSize: 16, color: netAmountColor),
                            ),
                        ]),
                  ],
                ),
                onLongPress: widget.onLong,
                onTap: widget.onTap)));
  }

  Widget _iconAddress() {
    if (widget.address.nodeStatusOn) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsNodeI),
          startBlinking: true,
          duration: 500);
    }

    if (!widget.address.nodeStatusOn && widget.address.nodeStatusOn) {
      return AppIconsStyle.icon3x2(Assets.iconsNodeStop);
    }

    if (widget.address.incoming > 0) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsInput),
          startBlinking: true,
          duration: 500);
    }
    if (widget.address.outgoing > 0) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsOutput),
          startBlinking: true,
          duration: 500);
    }

    return AppIconsStyle.icon3x2(Assets.iconsCard);
  }

  messageTooltip() {
    if (widget.address.nodeStatusOn) {
      return AppLocalizations.of(context)!.hintStatusNodeRun;
    }

    if (!widget.address.nodeStatusOn) {
      return AppLocalizations.of(context)!.hintStatusNodeNonRun;
    }

    return "";
  }
}
