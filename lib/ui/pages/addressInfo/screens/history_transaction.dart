import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nososova/blocs/history_transactions_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/address_wallet.dart';
import '../../../../models/rest_api/transaction_history.dart';
import '../../../../utils/network_const.dart';
import '../../../common/route/page_router.dart';
import '../../../common/widgets/empty_list_widget.dart';
import '../../../common/widgets/loading.dart';
import '../../../theme/style/text_style.dart';
import '../../../tiles/tile_transaction.dart';

class HistoryTransactionsWidget extends StatefulWidget {
  final Address address;
  final bool activeMobile;
  final Function() setVisible;

  const HistoryTransactionsWidget({
    super.key,
    required this.address,
    this.activeMobile = true,
    required this.setVisible,
  });

  @override
  State createState() => _HistoryTransactionWidgetsState();
}

class _HistoryTransactionWidgetsState extends State<HistoryTransactionsWidget> {
  final GlobalKey<_HistoryTransactionWidgetsState> _historyKey = GlobalKey();
  bool isVisibleAction = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BlocBuilder<HistoryTransactionsBloc, HistoryTransactionsBState>(
          key: _historyKey,
          builder: (context, state) {
            var listHistory = state.transactions;
            listHistory.sort((a, b) => b.blockId.compareTo(a.blockId));

            if (state.apiStatus == ApiStatus.error) {
              return getStackMessage(EmptyWidget(
                  title: AppLocalizations.of(context)!.unknownError,
                  descrpt: AppLocalizations.of(context)!.errorConnectionApi));
            }

            if (listHistory.isEmpty && state.apiStatus != ApiStatus.loading) {
              return getStackMessage(EmptyWidget(
                  title: AppLocalizations.of(context)!.empty,
                  descrpt: AppLocalizations.of(context)!
                      .errorEmptyHistoryTransactions));
            }
            if (state.apiStatus == ApiStatus.loading) {
              return getStackMessage(const LoadingWidget());
            }

            return Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surface,
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .catHistoryTransaction,
                                style: AppTextStyles.categoryStyle),
                            if (widget.activeMobile)
                              IconButton(
                                  tooltip: isVisibleAction
                                      ? AppLocalizations.of(context)!.hideMoreInfo
                                      : AppLocalizations.of(context)!.showMoreInfo,
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
                                      size: 24,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface))
                          ])),
                  if (state.apiStatus == ApiStatus.connected) ...[
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: listHistory.length,
                            itemBuilder: (context, index) {
                              final transaction = listHistory[index];
                              var isReceiver =
                                  widget.address.hash == transaction.receiver;

                              if (index == 0 ||
                                  _isDifferentDate(
                                      listHistory[index - 1], transaction)) {
                                return Column(children: [
                                  ListTile(
                                      title: Text(
                                          _getFormattedDate(
                                              transaction.timestamp),
                                          style: AppTextStyles.infoItemValue.copyWith(color:  Theme.of(context).colorScheme.onBackground.withOpacity(0.7)))),
                                  TransactionTile(
                                      transactionHistory: transaction,
                                      receiver: isReceiver,
                                      onTap: () =>
                                          PageRouter.showTransactionInfo(
                                              context, transaction, isReceiver))
                                ]);
                              } else {
                                return TransactionTile(
                                    transactionHistory: transaction,
                                    receiver: isReceiver,
                                    onTap: () => PageRouter.showTransactionInfo(
                                        context, transaction, isReceiver));
                              }
                            }))
                  ]
                ]));
          })
    ]);
  }

  getStackMessage(Widget widgetQ) {
    return Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        AppLocalizations.of(context)!
                            .catHistoryTransaction,
                        style: AppTextStyles.categoryStyle),
                    if (widget.activeMobile)
                      IconButton(
                          tooltip: isVisibleAction
                              ? AppLocalizations.of(context)!.hideMoreInfo
                              : AppLocalizations.of(context)!.showMoreInfo,
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
                              size: 24,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface))
                  ])),
          widgetQ
        ]));
  }

  bool _isDifferentDate(TransactionHistory prevTransaction,
      TransactionHistory currentTransaction) {
    final prevDate = DateTime.parse(prevTransaction.timestamp).toLocal();
    final currentDate = DateTime.parse(currentTransaction.timestamp).toLocal();
    return prevDate.day != currentDate.day ||
        prevDate.month != currentDate.month ||
        prevDate.year != currentDate.year;
  }

  String _getFormattedDate(String timestamp) {
    final date = DateTime.parse(timestamp).toLocal();
    final currentDate = DateTime.now().toLocal();

    if (date.year == currentDate.year) {
      String dayMonth =
          DateFormat('d MMMM', Localizations.localeOf(context).toString())
              .format(date);
      if (date.day == currentDate.day &&
          date.month == currentDate.month &&
          date.year == currentDate.year) {
        return AppLocalizations.of(context)!.today;
      } else if (date.day == currentDate.day - 1 &&
          date.month == currentDate.month &&
          date.year == currentDate.year) {
        return AppLocalizations.of(context)!.yesterday;
      } else {
        return dayMonth;
      }
    } else {
      return DateFormat(
              'd MMMM yyyy', Localizations.localeOf(context).toString())
          .format(date);
    }
  }
}
