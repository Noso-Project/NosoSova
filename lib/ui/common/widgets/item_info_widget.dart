import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/style/text_style.dart';
import 'custom/shimmer.dart';

class ItemInfoWidget extends StatelessWidget {
  final String nameItem;
  final String value;
  final bool onShimmer;
  final bool isBoldTitle;

  const ItemInfoWidget({
    super.key,
    required this.nameItem,
    required this.value,
    this.onShimmer = false,
    this.isBoldTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: Text(nameItem,
                  style: isBoldTitle
                      ? AppTextStyles.infoItemValue
                      : AppTextStyles.infoItemTitle)),
          if (onShimmer)
            Container(
              margin: EdgeInsets.zero,
              child: ShimmerPro.sized(
                depth: 16,
                scaffoldBackgroundColor: Colors.grey.shade100.withOpacity(0.5),
                width: 100,
                borderRadius: 3,
                height: 20,
              ),
            )
          else
            Text(
              value,
              style: AppTextStyles.infoItemValue,
            ),
        ],
      ),
    );
  }
}

class ItemInfoWidgetVertical extends StatelessWidget {
  final String nameItem;
  final String value;
  final bool copy;
  final bool isBoldTitle;

  const ItemInfoWidgetVertical({
    super.key,
    required this.nameItem,
    required this.value,
    this.copy = false,
    this.isBoldTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nameItem,
            style: AppTextStyles.textHiddenSmall(context),
          ),
          if (copy) ...[
            InkWell(
                onTap: () => Clipboard.setData(ClipboardData(text: value)),
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
                       Icon(
                        Icons.copy,
                        size: 22,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ]))
          ] else ...[
            Row(children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.infoItemValue,
                  )),
            ]),
          ]
        ],
      ),
    );
  }
}
