import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/node.dart';
import 'package:nososova/blocs/app_data_bloc.dart';
import 'package:nososova/l10n/app_localizations.dart';

import '../../blocs/events/app_data_events.dart';
import '../../generated/assets.dart';
import '../../ui/tiles/seed_tile.dart';
import '../../utils/date_utils.dart';
import '../../utils/network_const.dart';
import '../common/route/dialog_router.dart';
import '../common/widgets/node_status.dart';
import '../common/widgets/shimmer.dart';
import '../config/responsive.dart';
import '../theme/style/colors.dart';
import '../theme/style/icons_style.dart';
import '../theme/style/text_style.dart';

class DialogInfoNetwork extends StatefulWidget {
  const DialogInfoNetwork({super.key});

  @override
  DialogInfoNetworkState createState() => DialogInfoNetworkState();
}

class DialogInfoNetworkState extends State<DialogInfoNetwork> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppDataState>(builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Text(
                AppLocalizations.of(context)!.titleInfoNetwork,
                style: AppTextStyles.dialogTitle,
              )),
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
                        color: CustomColors.negativeBalance.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: CustomColors.negativeBalance),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Text(
                          AppLocalizations.of(context)!.errorStopSync,
                          style: AppTextStyles.walletAddress.copyWith(
                              fontSize: 14,
                              color: CustomColors.negativeBalance),
                        ),
                      ),
                    ))),
            ListTile(
              leading: AppIconsStyle.icon3x2(Assets.iconsDebugI),
              title: Text(
                AppLocalizations.of(context)!.debugInfo,
                style: AppTextStyles.itemStyle,
              ),
              onTap: () => DialogRouter.showDialogDebug(context),
            ),

            if (state.statusConnected != StatusConnectNodes.error) ...[
              itemInfo(
                  AppLocalizations.of(context)!.status,
                  NodeStatusUi.getNodeDescriptionString(
                      context, state.statusConnected, state.node.seed),
                  StatusConnectNodes.connected),
            ],

          if (state.statusConnected != StatusConnectNodes.error) ...[
            itemInfo(AppLocalizations.of(context)!.nodeType,
                getNetworkType(state.node), state.statusConnected),
            itemInfo(AppLocalizations.of(context)!.lastBlock,
                state.node.lastblock.toString(), state.statusConnected),
            itemInfo(AppLocalizations.of(context)!.version,
                state.node.version.toString(), state.statusConnected),
            itemInfo(AppLocalizations.of(context)!.utcTime,
                DateUtil.getUtcTime(state.node.utcTime), state.statusConnected),
          ],
          const SizedBox(height: 20),
        ],
      );
    });
  }

  String getNetworkType(Node node) {
    bool isDev = NetworkConst.getSeedList()
        .any((item) => item.toTokenizer == node.seed.toTokenizer);
    return isDev ? "Verified node" : "Custom node";
  }

  itemInfo(String nameItem, String value, StatusConnectNodes statusConnected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nameItem,
            style: AppTextStyles.itemStyle
                .copyWith(color: Colors.black.withOpacity(0.5), fontSize: 18),
          ),
          if (statusConnected == StatusConnectNodes.searchNode ||
              statusConnected == StatusConnectNodes.sync ||
              statusConnected == StatusConnectNodes.consensus)
            Container(
              margin: EdgeInsets.zero,
              child: ShimmerPro.sized(
                depth: 16,
                scaffoldBackgroundColor: Colors.grey.shade100.withOpacity(0.5),
                width: 100,
                borderRadius: 3,
                height: 20,
              ),
            )
          else
            Text(
              value,
              style: AppTextStyles.walletAddress
                  .copyWith(color: Colors.black, fontSize: 18),
            ),
        ],
      ),
    );
  }
}
