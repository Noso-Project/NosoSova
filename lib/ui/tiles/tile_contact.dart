import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../generated/assets.dart';
import '../../models/contact.dart';
import '../theme/style/icons_style.dart';

class ContactTile extends StatefulWidget {
  final ContactModel contact;
  final Function() onTap;

  const ContactTile({Key? key, required this.contact, required this.onTap})
      : super(key: key);

  @override
  State createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  Widget _iconAddress() {
    return AppIconsStyle.icon3x2(Assets.iconsCard);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _iconAddress(),
      title: Text(
        widget.contact.alias.toString(),
        style: AppTextStyles.walletHash,
      ),
      subtitle: Text(
        widget.contact.hash.toString(),
        style: AppTextStyles.textHiddenSmall(context),
      ),
      onTap: () => widget.onTap(),
    );
  }
}
