import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/theme/style/colors.dart';
import '../ui/theme/style/text_style.dart';

class AuthorLink extends StatelessWidget {
  final String url = "https://github.com/pasichDev";

  const AuthorLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      },
      child: Text(
        "@pasichDev (Noso-Project)",
        style: AppTextStyles.infoItemValue.copyWith(
          color: CustomColors.positiveBalance,
        ),
      ),
    );
  }
}
