import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/utils/noso_utility.dart';

import '../../../../blocs/events/wallet_events.dart';
import '../../../../blocs/wallet_bloc.dart';
import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/address_wallet.dart';
import '../../../common/route/dialog_router.dart';
import '../../../common/route/page_router.dart';
import '../../../theme/style/text_style.dart';
import '../../../tiles/dialog_tile.dart';
import '../../../tiles/tile_confirm.dart';

class AddressActionsWidget extends StatelessWidget {
  final Address address;

  const AddressActionsWidget({super.key, required this.address});


  @override
  Widget build(BuildContext context) {
    var walletBloc = BlocProvider.of<WalletBloc>(context);
    var isCustomPending = walletBloc.state.wallet.pendings
        .any((pending) => pending.sender == address.hash);
    return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              child: Text(AppLocalizations.of(context)!.catActionAddress,
                  style: AppTextStyles.categoryStyle)),
          buildListTileSvg(
              Assets.iconsOutput,
              AppLocalizations.of(context)!.sendFromAddress,
              () => PageRouter.routePaymentPage(context, address)),
          if (address.custom == null && !isCustomPending)
            buildListTileSvg(
                Assets.iconsRename,
                enabled: address.custom == null,
                AppLocalizations.of(context)!.customNameAdd,
                () => DialogRouter.showDialogCustomName(context, address)),
          buildListTileSvg(
              Assets.iconsLock,
              AppLocalizations.of(context)!.getKeysPair,
              () => DialogRouter.showDialogViewKeysPair(context, address)),
          if (address.balance >= NosoUtility.getCountMonetToRunNode())
            buildListTileSvg(
                Assets.iconsNodeI,
                AppLocalizations.of(context)!.openNodeInfo,
                () => DialogRouter.showDialogNodeInfo(context, address)),
          TileConfirmList(
              iconData: Assets.iconsDelete,
              title: AppLocalizations.of(context)!.removeAddress,
              confirm: AppLocalizations.of(context)!.confirmDelete,
              onClick: () {
                walletBloc.add(DeleteAddress(address));
                Navigator.pop(context);
              }),
        ])));
  }
}
