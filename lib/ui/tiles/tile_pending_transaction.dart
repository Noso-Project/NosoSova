import 'package:flutter/material.dart';
import 'package:noso_dart/models/noso/pending.dart';
import 'package:nososova/ui/theme/style/text_style.dart';
import 'package:nososova/utils/other_utils.dart';

import '../../generated/assets.dart';
import '../theme/style/icons_style.dart';

class TilePendingTransaction extends StatefulWidget {
  final VoidCallback onTap;
  final Pending pending;

  const TilePendingTransaction({
    Key? key,
    required this.pending,
    required this.onTap,
  }) : super(key: key);

  @override
  State createState() => _TilePendingTransactionState();
}

class _TilePendingTransactionState extends State<TilePendingTransaction> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 15),
        leading: AppIconsStyle.icon3x2(Assets.iconsPendingTransaction,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OtherUtils.hashObfuscation(widget.pending.orderId),
                  style: AppTextStyles.walletAddress.copyWith(fontSize: 18),
                ),
                Text(
                  "Sender: ${widget.pending.sender}",
                  style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
                ),
                Text(
                  "Receiver: ${widget.pending.receiver}",
                  style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
                ),
                Text(
                  "Amount: ${widget.pending.amountTransfer}",
                  style: AppTextStyles.walletAddress.copyWith(fontSize: 18),
                )
              ],
            ),
          ],
        ),
        onTap: widget.onTap);
  }
}
