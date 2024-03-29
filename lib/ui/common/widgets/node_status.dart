import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:nososova/ui/theme/style/colors.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/enum.dart';
import '../../theme/style/text_style.dart';

class NodeStatusUi {
  static Widget getNodeDescription(
      BuildContext context, StatusConnectNodes statusConnected, Seed seed) {
    if (statusConnected == StatusConnectNodes.error) {
      return Text(
        AppLocalizations.of(context)!.errorConnection,
        style: AppTextStyles.textHiddenSmall(context)
            .copyWith(color: CustomColors.negativeBalance),
      );
    } else if (statusConnected == StatusConnectNodes.searchNode) {
      return Text(
        AppLocalizations.of(context)!.connection,
        style: AppTextStyles.textHiddenSmall(context),
      );
    } else if (statusConnected == StatusConnectNodes.sync) {
      return Text(
        AppLocalizations.of(context)!.sync,
        style: AppTextStyles.textHiddenSmall(context),
      );
    } else if (statusConnected == StatusConnectNodes.consensus) {
      return Text(
        AppLocalizations.of(context)!.consensusCheck,
        style: AppTextStyles.textHiddenSmall(context),
      );
    }
    if (statusConnected == StatusConnectNodes.connected) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.activeConnect,
            style: AppTextStyles.textHiddenSmall(context),
          ),
          const SizedBox(width: 5),
          Text(
            "(${seed.ping.toString()} ${AppLocalizations.of(context)!.pingMs})",
            style: AppTextStyles.textHiddenSmall(context),
          )
        ],
      );
    }

    return Container();
  }

  static String getNodeDescriptionString(
    BuildContext context,
    StatusConnectNodes statusConnected,
    Seed seed,
  ) {
    switch (statusConnected) {
      case StatusConnectNodes.error:
        return AppLocalizations.of(context)!.errorConnection;
      case StatusConnectNodes.searchNode:
        return AppLocalizations.of(context)!.connection;
      case StatusConnectNodes.sync:
        return AppLocalizations.of(context)!.sync;
      case StatusConnectNodes.consensus:
        return AppLocalizations.of(context)!.consensusCheck;
      case StatusConnectNodes.connected:
        return '${AppLocalizations.of(context)!.activeConnect} (${seed.ping.toString()} ${AppLocalizations.of(context)!.pingMs})';

      default:
        break;
    }

    return "";
  }
}
