import 'package:flutter/material.dart';
import 'package:noso_rest_api/models/transaction.dart';
import 'package:nososova/ui/pages/transaction/screen/widget_transaction.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/style/button_style.dart';
import '../../theme/style/text_style.dart';

class TransactionPage extends StatefulWidget {
  final Transaction transaction;
  final bool isReceiver;

  const TransactionPage(
      {Key? key, required this.transaction, required this.isReceiver})
      : super(key: key);

  @override
  State createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isCustom = false;

  @override
  void initState() {
    super.initState();
    isCustom = widget.transaction.orderType == "CUSTOM";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.transactionInfo,
            style: AppTextStyles.dialogTitle,
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          TransactionWidgetInfo(
            transaction: widget.transaction,
            isReceiver: widget.isReceiver,
          ),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButtonStyle.buttonOutlined(
                  context,
                  AppLocalizations.of(context)!.openToExplorer,
                  () => runExplorer())),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButtonStyle.buttonOutlined(
                  context,
                  AppLocalizations.of(context)!.shareTransaction,
                  () => shareLinkExplorer())),
          const SizedBox(height: 20)
        ])));
  }

  runExplorer() async {
    var urlShare = Uri.parse(
        "https://explorer.nosocoin.com/getordersinfo.html?orderid=${widget.transaction.orderId}");
    if (await canLaunchUrl(urlShare)) {
      await launchUrl(urlShare);
    } else {
      throw 'Could not launch $urlShare';
    }
  }

  shareLinkExplorer() async {
    Share.share(
        "https://explorer.nosocoin.com/getordersinfo.html?orderid=${widget.transaction.orderId}");
  }
}
