import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/l10n/app_localizations.dart';

import '../../blocs/events/app_data_events.dart';
import '../../configs/network_config.dart';
import '../../generated/assets.dart';
import '../../ui/tiles/seed_tile.dart';
import '../../utils/date_utils.dart';
import '../../utils/enum.dart';
import '../common/route/dialog_router.dart';
import '../common/widgets/custom/dialog_title_dropdown.dart';
import '../common/widgets/item_info_widget.dart';
import '../common/widgets/node_status.dart';
import '../config/responsive.dart';
import '../theme/style/colors.dart';
import '../theme/style/icons_style.dart';
import '../theme/style/text_style.dart';

class DialogInfoNetwork extends StatefulWidget {
  final bool isVisibleDropInfo;

  const DialogInfoNetwork({super.key, this.isVisibleDropInfo = false});

  @override
  DialogInfoNetworkState createState() => DialogInfoNetworkState();
}

class DialogInfoNetworkState extends State<DialogInfoNetwork> {
  bool isVisibleAction = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppDataState>(builder: (context, state) {
      var onShimmer = state.statusConnected == StatusConnectNodes.searchNode ||
          state.statusConnected == StatusConnectNodes.sync ||
          state.statusConnected == StatusConnectNodes.consensus;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isVisibleDropInfo)
            DialogTitleDropdown(
                titleDialog: AppLocalizations.of(context)!.titleInfoNetwork,
                activeMobile: !Responsive.isMobile(context),
                isVisible: isVisibleAction,
                setVisible: () => setState(() {
                      isVisibleAction = !isVisibleAction;
                    })),
          if (!widget.isVisibleDropInfo) const SizedBox(height: 20),
          if (Responsive.isMobile(context) || isVisibleAction)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SeedListItem(
                        seed: state.node.seed,
                        statusConnected: state.statusConnected,
                      ),
                    ),
                    if (state.statusConnected != StatusConnectNodes.error)
                      IconButton(
                          tooltip: AppLocalizations.of(context)!.updateInfo,
                          icon: const Icon(Icons.restart_alt_outlined),
                          onPressed: () {
                            return context
                                .read<AppDataBloc>()
                                .add(ReconnectSeed(true));
                          }),
                    IconButton(
                        tooltip: AppLocalizations.of(context)!.chanceNode,
                        icon: const Icon(Icons.navigate_next),
                        onPressed: () {
                          return context
                              .read<AppDataBloc>()
                              .add(ReconnectSeed(false));
                        }),
                    const SizedBox(width: 10)
                  ],
                ),
                if (state.statusConnected == StatusConnectNodes.error)
                  Tooltip(
                      message: AppLocalizations.of(context)!.hintConnectStop,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  CustomColors.negativeBalance.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: CustomColors.negativeBalance),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Text(
                                AppLocalizations.of(context)!.errorStopSync,
                                style: AppTextStyles.snackBarMessage.copyWith(
                                    color: CustomColors.negativeBalance),
                              ),
                            ),
                          ))),
                ListTile(
                  leading: AppIconsStyle.icon3x2(Assets.iconsDebugI),
                  title: Text(
                    AppLocalizations.of(context)!.debugInfo,
                    style: AppTextStyles.infoItemTitle,
                  ),
                  onTap: () => DialogRouter.showDialogDebug(context),
                ),
                if (state.statusConnected != StatusConnectNodes.error) ...[
                  ItemInfoWidget(
                      nameItem: AppLocalizations.of(context)!.status,
                      value: NodeStatusUi.getNodeDescriptionString(
                          context, state.statusConnected, state.node.seed)),
                ],
                if (state.statusConnected != StatusConnectNodes.error) ...[
                  ItemInfoWidget(
                      nameItem: AppLocalizations.of(context)!.nodeType,
                      value: getNetworkType(state.node),
                      onShimmer: onShimmer),
                  ItemInfoWidget(
                      nameItem: AppLocalizations.of(context)!.lastBlock,
                      value: state.node.lastblock.toString(),
                      onShimmer: onShimmer),
                  ItemInfoWidget(
                      nameItem: AppLocalizations.of(context)!.version,
                      value: state.node.version.toString(),
                      onShimmer: onShimmer),
                  ItemInfoWidget(
                      nameItem: AppLocalizations.of(context)!.utcTime,
                      value: DateUtil.getUtcTime(state.node.utcTime),
                      onShimmer: onShimmer),
                ],
                const SizedBox(height: 20),
              ],
            )
        ],
      );
    });
  }

  String getNetworkType(Node node) {
    bool isDev = NetworkConfig.getVerificationSeedList()
        .any((item) => item.toTokenizer == node.seed.toTokenizer);
    return isDev ? "Verified node" : "Custom node";
  }
}
