import 'package:flutter/material.dart';
import 'package:nososova/ui/common/route/dialog_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/widgets/custom/dialog_title_dropdown.dart';
import '../../../config/responsive.dart';
import '../../../theme/style/sizes.dart';
import '../../../theme/style/text_style.dart';
import '../../info/screen/widget_info_coin.dart';
import '../../node/screens/body_stats_nodes.dart';

class SideLeftBarDesktop extends StatefulWidget {
  const SideLeftBarDesktop({Key? key}) : super(key: key);

  @override
  State createState() => _SideLeftBarDesktopState();
}

class _SideLeftBarDesktopState extends State<SideLeftBarDesktop> {
  bool isVisibleAction = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Card(child: WidgetInfoCoin()),
              const SizedBox(height: 10),
              Card(
                  child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: CustomSizes.paddingDialogVertical),
                      title: Text(AppLocalizations.of(context)!.exchanges,
                          style: AppTextStyles.dialogTitle),
                      onTap: () => DialogRouter.showExchangesList(context),
                      trailing: Icon(Icons.navigate_next,
                          size: 28,
                          color: Theme.of(context).colorScheme.onSurface))),
              const SizedBox(height: 10),
              Card(
                color: const Color(0xFF363957),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DialogTitleDropdown(
                      titleDialog: AppLocalizations.of(context)!.informMyNodes,
                      activeMobile: !Responsive.isMobile(context),
                      isDark: false,
                      isVisible: isVisibleAction,
                      setVisible: () {
                        setState(() {
                          isVisibleAction = !isVisibleAction;
                        });
                      },
                    ),
                    if (isVisibleAction)
                      const Padding(
                          padding: EdgeInsets.all(20), child: StatsNodesUser()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
