import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/text_style.dart';
import 'package:nososova/utils/other_utils.dart';

import '../../generated/assets.dart';
import '../../models/address_wallet.dart';
import '../theme/anim/blinkin_widget.dart';
import '../theme/style/icons_style.dart';

class AddressNodeTile extends StatefulWidget {
  final Address address;

  const AddressNodeTile({Key? key, required this.address}) : super(key: key);

  @override
  AddressListTileState createState() => AddressListTileState();
}

class AddressListTileState extends State<AddressNodeTile> {
  Widget _iconAddress() {
    if (widget.address.nodeStatusOn) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsNodeI),
          startBlinking: true,
          duration: 500);
    }

    return AppIconsStyle.icon3x2(Assets.iconsNodeStop);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: _iconAddress(),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                OtherUtils.hashObfuscation(widget.address.hash),
                style: AppTextStyles.walletAddress,
              ),
            ]));
  }
}
