import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nososova/dependency_injection.dart';
import 'package:nososova/models/address_wallet.dart';
import 'package:nososova/ui/common/widgets/empty_list_widget.dart';

import '../../l10n/app_localizations.dart';
import '../../models/rest_api/node_info.dart';
import '../../repositories/network_repository.dart';
import '../../utils/enum.dart';
import '../../configs/network_config.dart';
import '../common/widgets/item_info_widget.dart';
import '../theme/style/icons_style.dart';
import '../theme/style/text_style.dart';

class DialogInfoNode extends StatefulWidget {
  final Address address;

  const DialogInfoNode({Key? key, required this.address}) : super(key: key);

  @override
  State createState() => _DialogInfoNodeState();
}

class _DialogInfoNodeState extends State<DialogInfoNode> {
  Future<NodeInfo> fetchStatusNode() async {
    final restApi = locator<NetworkRepository>();
    var response = await restApi.fetchNodeStatus(widget.address.hash);
    if (response.errors == null) {
      return response.value;
    } else {
      throw Exception('Failed to load nodeInfo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: FutureBuilder<NodeInfo>(
            future: fetchStatusNode(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    child: Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primary,
                      size: 80,
                    )));
              } else if (snapshot.hasError || snapshot.data == null) {
                return EmptyWidget(
                  title: AppLocalizations.of(context)!.errorLoading,
                  descrpt:
                      "Our api is not available for maintenance. \n Please try again later",
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: AppIconsStyle.icon3x2(
                          CheckConnect.getStatusConnected(
                              StatusConnectNodes.connected)),
                      title: Text(
                        widget.address.seedNodeOn,
                        style: AppTextStyles.walletHash,
                      ),
                      subtitle: Text(
                        snapshot.data!.address,
                        style: AppTextStyles.textHiddenSmall(context),
                      ),
                      onTap: null,
                    ),
                    ItemInfoWidget(
                        nameItem: AppLocalizations.of(context)!.block,
                        value: snapshot.data!.blockId),
                    ItemInfoWidget(
                        nameItem: AppLocalizations.of(context)!.status,
                        value: snapshot.data!.status.toUpperCase()),
                    ItemInfoWidget(
                        nameItem:
                            AppLocalizations.of(context)!.consecutivePayments,
                        value: snapshot.data!.consecutivePayments),
                    ItemInfoWidget(
                        nameItem: AppLocalizations.of(context)!.uptimePercent,
                        value: "${snapshot.data!.uptimePercent}%"),
                    ItemInfoWidget(
                        nameItem: AppLocalizations.of(context)!.monthlyEarning,
                        value: "${snapshot.data!.monthlyEarning} NOSO"),
                    ItemInfoWidget(
                        nameItem:
                            "${AppLocalizations.of(context)!.monthlyEarning} (USDT)",
                        value: "${snapshot.data!.monthlyEarningUsdt} USDT"),
                  ],
                );
              }
            }));
  }
}
