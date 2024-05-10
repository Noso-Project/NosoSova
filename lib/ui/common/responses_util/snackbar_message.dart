import 'package:flutter/material.dart';
import 'package:nososova/models/responses/response_page_listener.dart';
import 'package:nososova/ui/common/responses_util/responses_messages.dart';

import '../../config/responsive.dart';
import '../../theme/style/colors.dart';
import '../../theme/style/text_style.dart';

class SnackBarWidgetResponse {
  final BuildContext context;
  final ResponseListenerPage response;

  SnackBarWidgetResponse({
    required this.context,
    required this.response,
  });

  get() {
    Color snackBarBackgroundColor = response.snackBarType == SnackBarType.error
        ? CustomColors.negativeBalance
        : CustomColors.positiveBalance;

    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        ResponsesErrors.getCodeToTextMessages(context, response.codeMessage),
        style: AppTextStyles.snackBarMessage.copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor: snackBarBackgroundColor,
      elevation: 6.0,
      margin: EdgeInsets.only(
          bottom: 10,
          left: Responsive.isMobile(context)
              ? 10
              : MediaQuery.of(context).size.width - 500,
          right: 10),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
