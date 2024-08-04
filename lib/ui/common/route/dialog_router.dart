import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/address_object.dart';
import 'package:nososova/blocs/contacts_bloc.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/ui/dialogs/address_action/dialog_view_keyspair.dart';
import 'package:nososova/ui/dialogs/dialog_info_node.dart';
import 'package:nososova/ui/dialogs/dialog_sel_contact.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../blocs/app_data_bloc.dart';
import '../../../blocs/debug_bloc.dart';
import '../../../blocs/wallet_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../models/address_wallet.dart';
import '../../../models/contact.dart';
import '../../config/responsive.dart';
import '../../dialogs/address_action/dialog_address_info.dart';
import '../../dialogs/address_action/dialog_custom_name.dart';
import '../../dialogs/address_action/dialog_description_address.dart';
import '../../dialogs/address_action/dialog_view_qr.dart';
import '../../dialogs/dialog_debug.dart';
import '../../dialogs/dialog_info_network.dart';
import '../../dialogs/dialog_pending_transactions.dart';
import '../../dialogs/dialog_sel_address.dart';
import '../../dialogs/dialog_wallet_actions.dart';
import '../../dialogs/import_export/dialog_import_address.dart';
import '../../dialogs/import_export/dialog_import_keys_pair.dart';
import '../../dialogs/import_export/dialog_scanner_qr.dart';
import '../../theme/style/dialog_style.dart';
import '../../theme/style/text_style.dart';
import '../widgets/exchange_list.dart';

class DialogRouter {
  /// The dialog that displays the qr Codes scanner
  static void showDialogScanQr(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => BlocProvider.value(
          value: BlocProvider.of<WalletBloc>(context),
          child: const ScannerQrWidget()),
    );
  }

  /// The dialog that displays possible actions on the wallet
  static void showDialogActionWallet(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    WoltModalSheet.show(
      context: context,
      showDragHandle: false,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context).pop,
              ),
              topBarTitle: Text(AppLocalizations.of(context)!.actionWallet,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dialogTitle),
              isTopBarLayerAlwaysVisible: true,
              child: BlocProvider.value(
                value: BlocProvider.of<WalletBloc>(context),
                child: DialogWalletActions(scaffoldKey: scaffoldKey),
              ))
        ];
      },
    );
  }

  /// The dialog that displays the status of the network connection and actions on it
  static void showDialogInfoNetwork(BuildContext context) {
    WoltModalSheet.show(
        context: NavigationService.navigatorKey.currentContext ?? context,
        showDragHandle: false,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                hasSabGradient: false,
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.all(20),
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(_).pop,
                ),
                topBarTitle: Text(
                    AppLocalizations.of(context)!.titleInfoNetwork,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                isTopBarLayerAlwaysVisible: true,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                        value: BlocProvider.of<AppDataBloc>(context)),
                    BlocProvider.value(
                        value: BlocProvider.of<DebugBloc>(context))
                  ],
                  child: const DialogInfoNetwork(),
                ))
          ];
        });
  }

  /// The dialog that can be used to restore the address with a pair of keys
  static void showDialogImportAddressFromKeysPair(BuildContext context) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              topBarTitle: Text(AppLocalizations.of(context)!.importKeysPair,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dialogTitle),
              isTopBarLayerAlwaysVisible: true,
              child: BlocProvider.value(
                value: BlocProvider.of<WalletBloc>(context),
                child: const DialogImportKeysPair(),
              ))
        ];
      },
    );
  }

  /// A dialog in which actions on the address are provided
  static void showDialogAddressActions(BuildContext context, Address address,
      GlobalKey<ScaffoldState> scaffoldKey) {
    if (Responsive.isMobile(context)) {
      showModalBottomSheet(
          shape: DialogStyle.borderShape,
          context: context,
          builder: (_) => BlocProvider.value(
              value: BlocProvider.of<WalletBloc>(context),
              child: AddressInfo(
                address: address,
                scaffoldKey: scaffoldKey,
              )));
    } else {
      WoltModalSheet.show(
        context: context,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                hasSabGradient: false,
                topBarTitle: Text(address.hashPublic,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                isTopBarLayerAlwaysVisible: true,
                child: BlocProvider.value(
                    value: BlocProvider.of<WalletBloc>(context),
                    child: AddressInfo(
                      address: address,
                      scaffoldKey: scaffoldKey,
                    )))
          ];
        },
      );
    }
  }

  /// Dialog for viewing the qr code of the address
  static void showDialogViewQr(BuildContext context, Address address) {
    if (Responsive.isMobile(context)) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => SafeArea(child: DialogViewQrWidget(address: address)),
      );
    } else {
      WoltModalSheet.show(
        context: NavigationService.navigatorKey.currentContext ?? context,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                hasSabGradient: false,
                topBarTitle: Text(address.hashPublic,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.all(20),
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(_).pop,
                ),
                isTopBarLayerAlwaysVisible: true,
                child: DialogViewQrWidget(address: address))
          ];
        },
      );
    }
  }

  /// Dialog for setting alias
  static void showDialogCustomName(BuildContext context, Address address) {
    if (Responsive.isMobile(context)) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: DialogStyle.borderShape,
          context: context,
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: BlocProvider.of<WalletBloc>(context),
                  ),
                ],
                child: DialogCustomName(address: address),
              ));
    } else {
      WoltModalSheet.show(
        context: NavigationService.navigatorKey.currentContext ?? context,
        showDragHandle: false,
        minDialogWidth: 600,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                hasSabGradient: false,
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.all(20),
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(_).pop,
                ),
                topBarTitle: Text(AppLocalizations.of(context)!.customNameAdd,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                isTopBarLayerAlwaysVisible: true,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: BlocProvider.of<WalletBloc>(context),
                    ),
                  ],
                  child: DialogCustomName(address: address),
                ))
          ];
        },
      );
    }
  }

  /// Dialog in which debug information is displayed
  static void showDialogDebug(BuildContext context) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 700,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              topBarTitle: Text(AppLocalizations.of(context)!.debugInfo,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dialogTitle),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              child: BlocProvider.value(
                  value: BlocProvider.of<DebugBloc>(context),
                  child: const DialogDebug())),
        ];
      },
    );
  }

  /// Dialog in which list address to import file
  static void showDialogImportFile(
      BuildContext context, List<AddressObject> address) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 600,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            trailingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(20),
              icon: const Icon(Icons.close),
              onPressed: Navigator.of(_).pop,
            ),
            topBarTitle: Text(AppLocalizations.of(context)!.foundAddresses,
                textAlign: TextAlign.center, style: AppTextStyles.dialogTitle),
            isTopBarLayerAlwaysVisible: true,
            child: BlocProvider.value(
                value: BlocProvider.of<WalletBloc>(context),
                child: DialogImportAddress(address: address)),
          )
        ];
      },
    );
  }

  static void showDialogViewKeysPair(BuildContext context, Address address) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 600,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
            trailingNavBarWidget: IconButton(
              padding: const EdgeInsets.all(20),
              icon: const Icon(Icons.close),
              onPressed: Navigator.of(_).pop,
            ),
            hasSabGradient: false,
            topBarTitle: Text(AppLocalizations.of(context)!.secretKeys,
                textAlign: TextAlign.center, style: AppTextStyles.dialogTitle),
            isTopBarLayerAlwaysVisible: true,
            child: DialogViewKeysPair(address: address),
          )
        ];
      },
    );
  }

  static void showDialogPendingTransaction(BuildContext context) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 500,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              topBarTitle: Text(
                  AppLocalizations.of(context)!.pendingTransaction,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dialogTitle),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              child: BlocProvider.value(
                  value: BlocProvider.of<WalletBloc>(context),
                  child: const DialogPendingTransaction())),
        ];
      },
    );
  }

  static void showDialogNodeInfo(BuildContext context, Address targetAddress) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 500,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              topBarTitle: Text(AppLocalizations.of(context)!.nodeInfo,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dialogTitle),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              child: DialogInfoNode(address: targetAddress)),
        ];
      },
    );
  }

  static void showDialogSellAddress(
      BuildContext context, Address targetAddress, Function(Address) selected,
      {bool isReceiver = false}) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 500,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              topBarTitle: Text(
                isReceiver
                    ? AppLocalizations.of(context)!.receiver
                    : AppLocalizations.of(context)!.sender,
                style: AppTextStyles.dialogTitle,
              ),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              child: BlocProvider.value(
                  value: BlocProvider.of<WalletBloc>(context),
                  child: DialogSellAddress(
                    targetAddress: targetAddress,
                    selected: selected,
                  ))),
        ];
      },
    );
  }

  static void showDialogSellContact(
      BuildContext context, Function(ContactModel) selected) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 500,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              topBarTitle: Text(
                AppLocalizations.of(context)!.sellAddress,
                style: AppTextStyles.dialogTitle,
              ),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              child: BlocProvider.value(
                  value: locator<ContactsBloc>(),
                  child: DialogSellContact(
                    selected: (model) => selected(model),
                  ))),
        ];
      },
    );
  }

  static void showExchangesList(BuildContext context) {
    WoltModalSheet.show(
      context: NavigationService.navigatorKey.currentContext ?? context,
      showDragHandle: false,
      minDialogWidth: 500,
      pageListBuilder: (BuildContext _) {
        return [
          WoltModalSheetPage(
              hasSabGradient: false,
              topBarTitle: Text(
                AppLocalizations.of(context)!.exchanges,
                style: AppTextStyles.dialogTitle,
              ),
              isTopBarLayerAlwaysVisible: true,
              trailingNavBarWidget: IconButton(
                padding: const EdgeInsets.all(20),
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(_).pop,
              ),
              child: BlocProvider.value(
                  value: BlocProvider.of<WalletBloc>(context),
                  child: const ExchangeList())),
        ];
      },
    );
  }

  /// Dialog for setting Description
  static void showDialogEditDescription(BuildContext context, Address address) {
    if (Responsive.isMobile(context)) {
      showModalBottomSheet(
          isScrollControlled: true,
          shape: DialogStyle.borderShape,
          context: context,
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value:locator<WalletBloc>(),
                  ),
                ],
                child: DialogEditDescriptionAddress(address: address),
              ));
    } else {
      WoltModalSheet.show(
        context: NavigationService.navigatorKey.currentContext ?? context,
        showDragHandle: false,
        minDialogWidth: 600,
        pageListBuilder: (BuildContext _) {
          return [
            WoltModalSheetPage(
                hasSabGradient: false,
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.all(20),
                  icon: const Icon(Icons.close),
                  onPressed: Navigator.of(_).pop,
                ),
                topBarTitle: Text(
                    address.description == null
                        ? AppLocalizations.of(context)!.addDescription
                        : AppLocalizations.of(context)!.editDescription,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.dialogTitle),
                isTopBarLayerAlwaysVisible: true,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: locator<WalletBloc>(),
                    ),
                  ],
                  child: DialogEditDescriptionAddress(address: address),
                ))
          ];
        },
      );
    }
  }
}
