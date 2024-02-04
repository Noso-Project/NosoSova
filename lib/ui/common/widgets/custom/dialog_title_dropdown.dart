import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/sizes.dart';

import '../../../config/responsive.dart';
import '../../../theme/style/text_style.dart';

class DialogTitleDropdown extends StatefulWidget {
  final Function() setVisible;
  final String titleDialog;
  final bool activeMobile;
  final bool isVisible;
  final bool isDark;

  const DialogTitleDropdown({
    Key? key,
    required this.titleDialog,
    this.activeMobile = true,
    this.isVisible = false,
    this.isDark = true,
    required this.setVisible,
  }) : super(key: key);

  @override
  State createState() => _DialogTitleDropdownState();
}

class _DialogTitleDropdownState extends State<DialogTitleDropdown> {
  bool isVisibleAction = true;

  @override
  void initState() {
    isVisibleAction = widget.isVisible;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
          vertical: Responsive.isMobile(context) ? CustomSizes.paddingDialogMobile : CustomSizes.paddingDialogDesktop,
          horizontal: CustomSizes.paddingDialogVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.titleDialog,
            style: AppTextStyles.dialogTitle.copyWith(color: widget.isDark ? Colors.black : Colors.white),
          ),
          if (widget.activeMobile)
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  isVisibleAction = !isVisibleAction;
                });
                widget.setVisible();
              },
              icon: Icon(
                isVisibleAction
                    ? Icons.expand_less
                    : Icons.expand_more_outlined,
                size: 28,
                color: widget.isDark ? Colors.black : Colors.white.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }
}