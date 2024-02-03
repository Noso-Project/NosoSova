import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../generated/assets.dart';
import '../theme/style/colors.dart';
import '../theme/style/text_style.dart';

class DialogSettings {
  static void showDialogSettings(BuildContext context) {
    const double _pagePadding = 16.0;
    const double _pageBreakpoint = 768.0;
    final pageIndexNotifier = ValueNotifier(0);

    SliverWoltModalSheetPage pageHomeInformation(
        BuildContext modalSheetContext, TextTheme textTheme) {
      return WoltModalSheetPage(
        hasSabGradient: false,
        enableDrag: false,
        stickyActionBar: Padding(
          padding: const EdgeInsets.all(_pagePadding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: CustomColors.primaryColor,
                ),
                onPressed: () =>
                    pageIndexNotifier.value = pageIndexNotifier.value + 1,
                child: SizedBox(
                  height: 56.0,
                  width: double.infinity,
                  child: Center(
                      child: Text('Open Settings',
                          style: AppTextStyles.dialogTitle
                              .copyWith(fontSize: 22, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
        topBarTitle: Text('Settings',
            style: AppTextStyles.dialogTitle.copyWith(fontSize: 22)),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
              _pagePadding,
              _pagePadding,
              _pagePadding,
              100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Information",
                  style: AppTextStyles.dialogTitle.copyWith(fontSize: 22),
                ),
                Text(
                  "App version: v.0.2.4-beta",
                  style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
                ),
                Text(
                  "Developer: @pasichDev (Noso-Project)",
                  style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  "Social Links",
                  style: AppTextStyles.dialogTitle.copyWith(fontSize: 22),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsSocDiscord,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsSocTelegram,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsSocGithub,
                          width: 32,
                          height: 32,
                        )),
                  ],
                )
              ],
            )),
      );
    }

    SliverWoltModalSheetPage pageSettings(
        BuildContext modalSheetContext, TextTheme textTheme) {
      return SliverWoltModalSheetPage(
        enableDrag: false,
        pageTitle: Padding(
          padding: const EdgeInsets.all(_pagePadding),
          child: Text(
            'App Settings',
            style: AppTextStyles.dialogTitle.copyWith(fontSize: 22),
          ),
        ),
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              pageIndexNotifier.value = pageIndexNotifier.value - 1,
        ),
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(modalSheetContext).pop();
            pageIndexNotifier.value = 0;
          },
        ),
        mainContentSlivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (_, index) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General",
                        style: AppTextStyles.dialogTitle.copyWith(fontSize: 24),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Dark Theme",
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
                        ),
                        trailing:
                            Switch(value: false, onChanged: (value) => {}),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Select language",
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      Text(
                        "Expert",
                        style: AppTextStyles.dialogTitle.copyWith(fontSize: 24),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Update List Seeds",
                          style: AppTextStyles.walletAddress
                              .copyWith(fontSize: 20),
                        ),
                        subtitle: Text(
                          "Refreshing the list of nodes, use when the app is not connected to the network.",
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Restore start session",
                          style: AppTextStyles.walletAddress
                              .copyWith(fontSize: 20),
                        ),
                        subtitle: Text(
                          "When you launch the application, a backup copy of your wallet is created, so you can restore to the beginning of the session.",
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ),
          )
        ],
      );
    }

    WoltModalSheet.show<void>(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilder: (modalSheetContext) {
        final textTheme = Theme.of(context).textTheme;
        return [
          pageHomeInformation(modalSheetContext, textTheme),
          pageSettings(modalSheetContext, textTheme),
        ];
      },
      modalTypeBuilder: (context) {
        final size = MediaQuery.of(context).size.width;
        if (size < _pageBreakpoint) {
          return WoltModalType.bottomSheet;
        } else {
          return WoltModalType.dialog;
        }
      },
      onModalDismissedWithBarrierTap: () {
        debugPrint('Closed modal sheet with barrier tap');
        Navigator.of(context).pop();
        pageIndexNotifier.value = 0;
      },
      maxDialogWidth: 700,
      minDialogWidth: 500,
    );
  }
}
