import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/contacts_bloc.dart';
import 'package:nososova/blocs/debug_bloc.dart';
import 'package:nososova/blocs/gvt_bloc.dart';
import 'package:nososova/blocs/rpc_bloc.dart';
import 'package:nososova/ui/pages/gvt/gvt_page.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/app_data_bloc.dart';
import '../../../blocs/events/gvt_events.dart';
import '../../../blocs/history_transactions_bloc.dart';
import '../../../blocs/wallet_bloc.dart';
import '../../../dependency_injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../models/address_wallet.dart';
import '../../../models/rest_api/transaction_history.dart';
import '../../../repositories/repositories.dart';
import '../../config/responsive.dart';
import '../../pages/addressInfo/address_info_page.dart';
import '../../pages/contacts/contacts_page.dart';
import '../../pages/contacts/screen/contacts_screen.dart';
import '../../pages/payment/payment_page.dart';
import '../../pages/payment/screen/screen_payment.dart';
import '../../pages/rpc/rpc_page.dart';
import '../../pages/transaction/transaction_dialog.dart';
import '../../pages/transaction/transaction_page.dart';
import '../../theme/style/text_style.dart';

class PageRouter {
  /// Page for sending payment
  static void routePaymentPage(BuildContext context, Address address,
      {String receiver = ""}) {
    if (Responsive.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<WalletBloc>(context),
            child: PaymentPage(address: address, receiver: receiver),
          ),
        ),
      );
    } else {
      WoltModalSheet.show(
        maxDialogWidth: 1100,
        minDialogWidth: 850,
        context: NavigationService.navigatorKey.currentContext ?? context,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                topBarTitle: Text(AppLocalizations.of(context)!.sendCoins,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.all(20),
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(_).pop,
                ),
                hasSabGradient: false,
                isTopBarLayerAlwaysVisible: true,
                child: BlocProvider.value(
                  value: BlocProvider.of<WalletBloc>(context),
                  child: PaymentScreen(address: address, receiver: receiver),
                ))
          ];
        },
      );
    }
  }

  /// Address information page
  static void routeAddressInfoPage(BuildContext context, Address address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: locator<WalletBloc>(),
            ),
            BlocProvider.value(
              value: locator<AppDataBloc>(),
            ),
            BlocProvider.value(
              value: locator<DebugBloc>(),
            ),
            BlocProvider<HistoryTransactionsBloc>(
              create: (BuildContext context) => HistoryTransactionsBloc.create(
                locator<Repositories>(),
                locator<WalletBloc>(),
              ),
            ),
          ],
          child: AddressInfoPage(hash: address.hash),
        ),
      ),
    );
  }

  /// Transaction information page
  static void showTransactionInfo(
      BuildContext context, TransactionHistory transaction, bool isReceiver) {
    if (Responsive.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TransactionPage(
            transaction: transaction,
            isReceiver: isReceiver,
          ),
        ),
      );
    } else {
      WoltModalSheet.show(
        context: NavigationService.navigatorKey.currentContext ?? context,
        minDialogWidth: 500,
        pageListBuilder: (BuildContext _) {
          return [
            TransactionDialog().showDialog(
              _,
              transaction,
              isReceiver,
            )
          ];
        },
      );
    }
  }

  static void routeContacts(BuildContext context) {
    if (Responsive.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: locator<WalletBloc>(),
              ),
              BlocProvider.value(
                value: locator<ContactsBloc>(),
              ),
            ],
            child: const ContactsPage(),
          ),
        ),
      );
    } else {
      WoltModalSheet.show(
        context: NavigationService.navigatorKey.currentContext ?? context,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                topBarTitle: Text(AppLocalizations.of(context)!.contact,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.all(20),
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(_).pop,
                ),
                hasSabGradient: false,
                isTopBarLayerAlwaysVisible: true,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: locator<WalletBloc>(),
                    ),
                    BlocProvider.value(
                      value: locator<ContactsBloc>(),
                    ),
                  ],
                  child: const ContactsScreen(),
                ))
          ];
        },
      );
    }
  }

  static void routeGvt(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: locator<WalletBloc>(),
            ),
            BlocProvider<GvtBloc>(create: (context) {
              var bloc = GvtBloc(
                  repositories: locator<Repositories>(),
                  walletBloc: locator<WalletBloc>());
              bloc.add(LoadGvts());
              return bloc;
            }),
          ],
          child: const GvtPage(),
        ),
      ),
    );
  }

  static void routeRpc(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: locator<RpcBloc>(),
            ),

          ],
          child: const RpcPage(),
        ),
      ),
    );
  }
}
