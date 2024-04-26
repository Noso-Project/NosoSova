import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:nososova/ui/common/widgets/custom/shimmer.dart';
import 'package:nososova/ui/common/widgets/item_info_widget.dart';
import 'package:nososova/ui/theme/style/text_style.dart';
import 'package:nososova/utils/date_utils.dart';
import 'package:nososova/utils/enum.dart';

import '../blocs/network_events.dart';
import '../blocs/noso_network_bloc.dart';

class NetworkWidget extends StatefulWidget {
  const NetworkWidget({super.key});

  @override
  State createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NosoNetworkBloc, NosoNetworksState>(
        builder: (context, state) {
      var onShimmer = state.statusConnected == StatusConnectNodes.searchNode ||
          state.statusConnected == StatusConnectNodes.sync ||
          state.statusConnected == StatusConnectNodes.consensus;
      return Expanded(
        flex: 4,
        child: Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Noso Network",
                style: AppTextStyles.dialogTitle.copyWith(
                  fontSize: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.statusConnected ==
                              StatusConnectNodes.searchNode)
                            Container(
                              margin: EdgeInsets.zero,
                              child: ShimmerPro.sized(
                                depth: 16,
                                scaffoldBackgroundColor:
                                    Colors.grey.shade100.withOpacity(0.5),
                                width: 110,
                                borderRadius: 3,
                                height: 16,
                              ),
                            )
                          else
                            Text(
                              state.node.seed.toTokenizer,
                              style: AppTextStyles.walletHash,
                            ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (state.statusConnected != StatusConnectNodes.error)
                        IconButton(
                            tooltip: "Refresh Network",
                            icon: const Icon(Icons.restart_alt_outlined),
                            onPressed: () {
                              return context
                                  .read<NosoNetworkBloc>()
                                  .add(ReconnectSeed(true));
                            }),
                      IconButton(
                          tooltip: "Change node",
                          icon: const Icon(Icons.navigate_next),
                          onPressed: () {
                            return context
                                .read<NosoNetworkBloc>()
                                .add(ReconnectSeed(false));
                          }),
                      const SizedBox(width: 10)
                    ],
                  ),
                ],
              ),
              if (state.statusConnected != StatusConnectNodes.error) ...[
                ItemInfoWidget(
                    nameItem: "Network Status",
                    value: getNodeDescriptionString(
                        context, state.statusConnected, state.node.seed)),
              ],
              ItemInfoWidget(
                  nameItem: "Current Block",
                  value: state.node.lastblock.toString(),
                  onShimmer: onShimmer),
              ItemInfoWidget(
                  nameItem: "Time",
                  value: DateUtil.getUtcTime(state.node.utcTime),
                  onShimmer: onShimmer),
            ])),
      );
    });
  }

  static String getNodeDescriptionString(
    BuildContext context,
    StatusConnectNodes statusConnected,
    Seed seed,
  ) {
    switch (statusConnected) {
      case StatusConnectNodes.error:
        return "Error connection";
      case StatusConnectNodes.searchNode:
        return "Search Node";
      case StatusConnectNodes.sync:
        return "Synchronization";
      case StatusConnectNodes.consensus:
        return "Network verification";
      case StatusConnectNodes.connected:
        return 'Connected (${seed.ping.toString()} ms)';

      default:
        break;
    }

    return "";
  }
}
