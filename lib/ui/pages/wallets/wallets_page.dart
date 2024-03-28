import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/l10n/app_localizations.dart';
import 'package:nososova/ui/pages/wallets/screens/card_header.dart';
import 'package:nososova/ui/pages/wallets/screens/list_addresses.dart';
import 'package:nososova/ui/pages/wallets/widgets/side_right_bar.dart';
import 'package:nososova/ui/theme/style/icons_style.dart';

import '../../../blocs/events/wallet_events.dart';
import '../../../generated/assets.dart';
import '../../../utils/enum.dart';
import '../../common/responses_util/response_widget_id.dart';
import '../../common/responses_util/snackbar_message.dart';
import '../../common/route/dialog_router.dart';
import '../../config/responsive.dart';
import '../../theme/style/text_style.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key});

  @override
  WalletsPageState createState() => WalletsPageState();
}

class WalletsPageState extends State<WalletsPage> {
  late WalletBloc walletBloc;
  late StreamSubscription listenResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
    _responseListener();
  }

  void _responseListener() {
    listenResponse =
        walletBloc.getResponseStatusStream.listen((response) async {
      if (mounted &&
          ResponseWidgetsIds.idsPageWallet.contains(response.idWidget)) {
        if (response.action == ActionsFileWallet.walletOpen) {
          DialogRouter.showDialogImportFile(context, response.actionValue);
          return;
        }

        if (response.action == ActionsFileWallet.walletExportDialog) {
          String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Please select an wallet file:',
              fileName: response.actionValue);

          if (outputFile != null) {
            walletBloc.add(ExportWallet(outputFile));
          }

          return;
        }

        await Future.delayed(const Duration(milliseconds: 200));
        SnackBarWidgetResponse(
                context: GlobalKey<ScaffoldMessengerState>().currentContext ??
                    context,
                response: response)
            .get();
      }
    });
  }

  @override
  void dispose() {
    listenResponse.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        key: _scaffoldKey,
        appBar: null,
        body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: Column(children: [
                    const CardHeader(),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.myAddresses,
                                  style: AppTextStyles.categoryStyle),
                              Row(children: [
                                if (Responsive.isMobile(context))
                                  IconButton(
                                      icon: AppIconsStyle.icon2x4(
                                          Assets.iconsMenu,
                                          colorCustom: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      onPressed: () =>
                                          DialogRouter.showDialogActionWallet(
                                              context, _scaffoldKey))
                              ])
                            ])),
                    ListAddresses(scaffoldKey: _scaffoldKey)
                  ])),
              if (!Responsive.isMobile(context)) const SideRightBarDesktop()
            ]));
  }
}
