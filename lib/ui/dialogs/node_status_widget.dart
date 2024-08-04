import 'package:flutter/material.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:noso_dart/node_request.dart';
import 'package:nososova/blocs/app_data_bloc.dart';

import '../../dependency_injection.dart';
import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../../models/app/test_seed.dart';
import '../../repositories/repositories.dart';
import '../config/responsive.dart';
import '../theme/style/colors.dart';
import '../theme/style/icons_style.dart';
import '../theme/style/sizes.dart';
import '../theme/style/text_style.dart';

class NodeStatusWidget extends StatefulWidget {
  const NodeStatusWidget({super.key});

  @override
  State createState() => _NodeStatusWidget();
}

class _NodeStatusWidget extends State<NodeStatusWidget> {
  late List<SeedTest> items = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    items = await locator<AppDataBloc>().defaultSeeds.getTestsSeeds();
    _fetchSeedsStatus();
  }

  Future<void> _fetchSeedsStatus() async {
    for (var seed in items) {
      if (mounted) {
        setState(() {
          seed.status = StatusSeed.test;
        });
      }
      await Future.delayed(const Duration(seconds: 2));
      var status = await locator<Repositories>()
          .networkRepository
          .fetchNode(NodeRequest.getNodeStatus, Seed(ip: seed.name));
      if (mounted) {
        setState(() {
          seed.status =
              status.errors == null ? StatusSeed.success : StatusSeed.fail;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context)
                ? CustomSizes.paddingDialogMobile
                : CustomSizes.paddingDialogDesktop,
            horizontal: CustomSizes.paddingDialogVertical,
          ),
          child: Text(
            AppLocalizations.of(context)!.verfNodes,
            style: AppTextStyles.dialogTitle,
          )),
      SizedBox(
          height: 350,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return ListTile(
                    leading: AppIconsStyle.icon3x2(Assets.iconsNode),
                    trailing: SizedBox(
                        height: 18,
                        width: 18,
                        child: item.status == StatusSeed.test
                            ? const CircularProgressIndicator()
                            : item.status == StatusSeed.none
                                ? null
                                : item.status == StatusSeed.success
                                    ? Text("O",
                                        style: AppTextStyles.statusSeed
                                            .copyWith(
                                                color: CustomColors
                                                    .positiveBalance))
                                    : Text("X",
                                        style: AppTextStyles.statusSeed
                                            .copyWith(
                                                color: CustomColors
                                                    .negativeBalance))),
                    title: Text(item.name));
              })),
    ]);
  }
}
