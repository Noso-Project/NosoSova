import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../dialogs/dialog_info_network.dart';
import '../../../dialogs/dialog_settings.dart';
import '../../../dialogs/dialog_wallet_actions.dart';
import '../../../theme/style/sizes.dart';
import '../../../theme/style/text_style.dart';

class SideRightBarDesktop extends StatelessWidget {
  const SideRightBarDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                const Card(child: DialogInfoNetwork()),
                const SizedBox(height: 10),
                const Card(child: DialogWalletActions()),
                const SizedBox(height: 10),
                Card(
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: CustomSizes.paddingDialogVertical),
                        title: Text(AppLocalizations.of(context)!.settings,
                            style: AppTextStyles.dialogTitle),
                        onTap: () => DialogSettings.showDialogSettings(context),
                        trailing: Icon(Icons.navigate_next,
                            size: 28,
                            color: Theme.of(context).colorScheme.onSurface)))
              ]))),
    );
  }
}
