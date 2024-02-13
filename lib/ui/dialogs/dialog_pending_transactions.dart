import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/ui/common/widgets/empty_list_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../tiles/tile_pending_transaction.dart';

class DialogPendingTransaction extends StatefulWidget {
  const DialogPendingTransaction({Key? key}) : super(key: key);

  @override
  State createState() => _DialogPendingTransactionState();
}

class _DialogPendingTransactionState extends State<DialogPendingTransaction> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      var listPendings = state.wallet.pendings;
      return listPendings.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: EmptyWidget(
                title: AppLocalizations.of(context)!.empty,
                descrpt:
                    AppLocalizations.of(context)!.displayPendingTransactions,
              ))
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  itemCount: listPendings.length,
                  itemBuilder: (context, index) {
                    final item = listPendings[index];

                    return TilePendingTransaction(
                      pending: item,
                      onTap: () => runExplorer(item.orderId),
                    );
                  },
                ),
              ],
            );
    });
  }

  runExplorer(String id) async {
    var urlShare = Uri.parse(
        "https://explorer.nosocoin.com/getordersinfo.html?orderid=$id");
    if (await canLaunchUrl(urlShare)) {
      await launchUrl(urlShare);
    } else {
      throw 'Could not launch $urlShare';
    }
  }
}
