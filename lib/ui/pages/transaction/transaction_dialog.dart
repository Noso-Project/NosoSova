import 'package:flutter/material.dart';
import 'package:noso_rest_api/models/transaction.dart';
import 'package:nososova/ui/pages/transaction/screen/widget_transaction.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/style/text_style.dart';

class TransactionDialog {
  WoltModalSheetPage showDialog(BuildContext modalSheetContext, Transaction transaction, bool isReceiver) {
    return WoltModalSheetPage(
    backgroundColor: Theme.of(modalSheetContext).colorScheme.surface,
        hasSabGradient: false,
        topBarTitle: Text(AppLocalizations.of(modalSheetContext)!.transactionInfo, textAlign: TextAlign.center, style: AppTextStyles.dialogTitle),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(20),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: TransactionWidgetInfo(
          transaction: transaction,
          isReceiver: isReceiver,
        ));
  }

}