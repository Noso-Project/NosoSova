import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/colors.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../generated/assets.dart';
import '../../models/app/gvt_owner.dart';
import '../theme/style/icons_style.dart';

class GvtOwnerTile extends StatefulWidget {
  final GvtOwner gvtOwner;

  const GvtOwnerTile({Key? key, required this.gvtOwner}) : super(key: key);

  @override
  State createState() => _GvtStateTile();
}

class _GvtStateTile extends State<GvtOwnerTile> {
  @override
  Widget build(BuildContext context) {
    double progressValue = widget.gvtOwner.gvts.length / 100.0;
    return ListTile(
        leading: AppIconsStyle.icon3x2(Assets.iconsGvt),
        title: Text(
          widget.gvtOwner.addressHash,
          style: AppTextStyles.walletHash,
        ),
        trailing: Text(
          widget.gvtOwner.gvts.length.toString(),
          style: AppTextStyles.walletHash.copyWith(fontSize: 22),
        ),
        subtitle: LinearProgressIndicator(
          color: CustomColors.primaryColor,
          value: progressValue,
        ));
  }
}
