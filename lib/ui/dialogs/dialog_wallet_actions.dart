import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nososova/blocs/wallet_bloc.dart';
import 'package:nososova/generated/assets.dart';
import 'package:nososova/l10n/app_localizations.dart';
import 'package:nososova/ui/theme/style/icons_style.dart';
import 'package:nososova/ui/tiles/dialog_tile.dart';

import '../../blocs/events/wallet_events.dart';
import '../../utils/files_const.dart';
import '../common/route/dialog_router.dart';
import '../common/widgets/custom/dialog_title_dropdown.dart';
import '../config/responsive.dart';
import '../theme/style/text_style.dart';

class DialogWalletActions extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DialogWalletActions({super.key, this.scaffoldKey});

  @override
  State createState() => _DialogWalletActionsState();
}

class _DialogWalletActionsState extends State<DialogWalletActions> {
  late WalletBloc walletBloc;
  bool isVisibleAction = false;

  @override
  void initState() {
    super.initState();
    walletBloc = BlocProvider.of<WalletBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      var isEnableExport = state.wallet.address.isNotEmpty;
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DialogTitleDropdown(
              titleDialog: AppLocalizations.of(context)!.actionWallet,
              activeMobile: !Responsive.isMobile(context),
              isVisible: isVisibleAction,
              setVisible: () => setState(
                () {
                  isVisibleAction = !isVisibleAction;
                },
              ),
            ),
            if (Responsive.isMobile(context) || isVisibleAction)
              SingleChildScrollView(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  buildListTileSvg(
                      Assets.iconsWallet,
                      AppLocalizations.of(context)!.genNewKeyPair,
                      () => _createNewAddress(context)),
                  buildListTileSvg(
                      Assets.iconsText,
                      AppLocalizations.of(context)!.importKeysPair,
                      () => _importToKeysPair(context)),
                  if (Platform.isAndroid || Platform.isIOS)
                    buildListTileSvg(
                        Assets.iconsScan,
                        AppLocalizations.of(context)!.scanQrCode,
                        () => DialogRouter.showDialogScanQr(context)),
                  if (Responsive.isMobile(context))
                    ListTile(
                        title: Text(AppLocalizations.of(context)!.fileWallet,
                            style: AppTextStyles.dialogTitle)),
                  ListTile(
                      leading: AppIconsStyle.icon3x2(Assets.iconsImport),
                      title: Text(AppLocalizations.of(context)!.importFile,
                          style: AppTextStyles.infoItemValue),
                      subtitle: Text(
                          AppLocalizations.of(context)!.importFileSubtitle,
                          style:
                              AppTextStyles.textHiddenSmall(context)),
                      onTap: () => _importWalletFile(context)),
                  ListTile(
                      enabled: isEnableExport,
                      leading: AppIconsStyle.icon3x2(Assets.iconsExport),
                      title: Text(AppLocalizations.of(context)!.exportFile,
                          style: AppTextStyles.infoItemValue),
                      subtitle: Text(
                          AppLocalizations.of(context)!.exportFileSubtitle,
                          style:
                              AppTextStyles.textHiddenSmall(context)),
                      onTap: () =>
                          _exportWalletFile(context, FormatWalletFile.pkw)),
                  const SizedBox(height: 10)
                ],
              )),
          ]);
    });
  }

  void _createNewAddress(BuildContext context) async {
    walletBloc.add(CreateNewAddress());
    if (Responsive.isMobile(context)) Navigator.pop(context);
  }

  void _importToKeysPair(BuildContext context) async {
    if (Responsive.isMobile(context)) Navigator.pop(context);
    DialogRouter.showDialogImportAddressFromKeysPair(
        widget.scaffoldKey?.currentContext ?? context);
  }

  void _importWalletFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (!context.mounted) return;
    if (Responsive.isMobile(context)) Navigator.pop(context);
    if (result != null) {
      walletBloc.add(ImportWalletFile(result));
    }
  }

  void _exportWalletFile(
      BuildContext context, FormatWalletFile formatFile) async {
    walletBloc.add(ExportWalletDialog(formatFile));
    if (!context.mounted) return;
    if (Responsive.isMobile(context)) Navigator.pop(context);
  }
}
