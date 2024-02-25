import 'package:flutter/material.dart';
import 'package:nososova/ui/pages/gvt/screen/gvt_widget.dart';
import 'package:nososova/ui/pages/payment/screen/screen_payment.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/address_wallet.dart';
import '../../config/responsive.dart';
import '../../theme/style/text_style.dart';

class GvtPage extends StatefulWidget {

  const GvtPage({Key? key})
      : super(key: key);

  @override
  State createState() => GvtPageState();
}

class GvtPageState extends State<GvtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        appBar: null,

      body:    Expanded(
          flex: 4,
          child: Column(children: [
            const GvtWidget(),

        ])));
  }
}
