import 'package:flutter/material.dart';
import 'package:noso_dart/models/noso/gvt.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../generated/assets.dart';
import '../theme/style/icons_style.dart';

class GvtMyTile extends StatefulWidget {
  final Gvt gvt;

  const GvtMyTile({Key? key, required this.gvt}) : super(key: key);

  @override
  State createState() => _GvtStateTile();
}

class _GvtStateTile extends State<GvtMyTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: AppIconsStyle.icon3x2(Assets.iconsGvt),
        title: Text(
          widget.gvt.addressHash,
          style: AppTextStyles.walletHash,
        ),
        trailing: Text(
          "#${widget.gvt.numer}",
          style: AppTextStyles.walletHash.copyWith(fontSize: 24),
        ),
        subtitle: Text(
          widget.gvt.hashGvt,
          style: AppTextStyles.infoItemTitle.copyWith(fontSize: 14),
        ));
  }
}
