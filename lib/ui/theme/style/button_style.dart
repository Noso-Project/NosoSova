import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../config/responsive.dart';
import 'icons_style.dart';

class AppButtonStyle {
  static const double _heightButton = 56.0;
  static const double _buttonRadius = 20.0;

  static buttonDefault(BuildContext context, String text, Function onTap,
      {bool isEnabled = true, bool isCancel = false}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_buttonRadius),
      ),
      color: isEnabled && !isCancel ? Theme.of(context).colorScheme.primary : Colors.grey,
      onPressed: () => isEnabled ? onTap() : null,
      child: SizedBox(
        height: _heightButton,
        width: double.infinity,
        child: Center(
            child: Text(text, style: AppTextStyles.buttonTextDefault(context))),
      ),
    );
  }

  static buttonOutlined(BuildContext context, String text, Function onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          )),
      onPressed: () => onTap(),
      child: SizedBox(
        height: _heightButton,
        width: double.infinity,
        child: Center(
            child: Text(text,
                style: AppTextStyles.buttonTextDefault(context)
                    .copyWith(color: Theme.of(context).colorScheme.primary))),
      ),
    );
  }

  static buttonAction(
      BuildContext context, String icon, String title, Function methodAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: OutlinedButton(
        onPressed: () => methodAction(),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: BorderSide(
            color: const Color(0xFF621359).withOpacity(0.9),
          ),
          backgroundColor: const Color(0xFF621359).withOpacity(0.3),
        ),
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.symmetric(horizontal: 3, vertical: 5)
              : const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            children: [
              AppIconsStyle.icon2x4(icon,
                  colorCustom: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.infoItemValue.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
