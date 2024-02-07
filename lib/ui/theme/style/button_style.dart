import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

class AppButtonStyle {
  static const double _heightButton = 56.0;

  static buttonDefault(BuildContext context, String text, Function onTap,
      {bool isEnabled = true}) {
    return MaterialButton(
      color: isEnabled ? Theme.of(context).colorScheme.primary : Colors.grey,
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
            borderRadius: BorderRadius.circular(15.0),
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
}
