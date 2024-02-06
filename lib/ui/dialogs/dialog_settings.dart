import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nososova/utils/social_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../dependency_injection.dart';
import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../config/responsive.dart';
import '../notifer/app_settings_notifer.dart';
import '../theme/style/sizes.dart';
import '../theme/style/text_style.dart';

class DialogSettings {
  static void showDialogSettings(BuildContext context) {
    const double pagePadding = 16.0;
    const double pageBreakpoint = 768.0;
    final pageIndexNotifier = ValueNotifier(0);
    final appSettings = locator<AppSettings>();

    openLink(String valLink) async {
      var link = Uri.parse(valLink);
      if (await canLaunchUrl(link)) {
        await launchUrl(link);
      } else {
        throw 'Could not launch $link';
      }
    }

    SliverWoltModalSheetPage pageHomeInformation(
        BuildContext modalSheetContext, TextTheme textTheme) {
      return WoltModalSheetPage(
        hasSabGradient: false,
        enableDrag: false,
        stickyActionBar: Padding(
          padding: const EdgeInsets.all(pagePadding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () =>
                    pageIndexNotifier.value = pageIndexNotifier.value + 1,
                child: SizedBox(
                  height: 56.0,
                  width: double.infinity,
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.openSettings,
                          style: AppTextStyles.dialogTitle.copyWith(
                              fontSize: 16.sp,
                              color: Theme.of(context).colorScheme.onPrimary))),
                ),
              ),
            ],
          ),
        ),
        topBarTitle: Text(AppLocalizations.of(context)!.settings,
            style: AppTextStyles.dialogTitle),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
              pagePadding,
              pagePadding,
              pagePadding,
              100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.information,
                  style: AppTextStyles.dialogTitle,
                ),
                Text(
                  "${AppLocalizations.of(context)!.appVersions}: ${appSettings.getAppVersion}",
                  style: AppTextStyles.infoItemTitle,
                ),
                Text(
                  "${AppLocalizations.of(context)!.developer}: @pasichDev (Noso-Project)",
                  style: AppTextStyles.infoItemTitle,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.socialLinks,
                  style: AppTextStyles.dialogTitle.copyWith(fontSize: 22),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => openLink(SocialLinks.discord),
                        icon: SvgPicture.asset(
                          Assets.iconsSocDiscord,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () => openLink(SocialLinks.telegram),
                        icon: SvgPicture.asset(
                          Assets.iconsSocTelegram,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () => openLink(SocialLinks.github),
                        icon: SvgPicture.asset(
                          Assets.iconsSocGithub,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () => openLink(SocialLinks.reddit),
                        icon: SvgPicture.asset(
                          Assets.iconsSocReddit,
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
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              pageIndexNotifier.value = pageIndexNotifier.value - 1,
        ),
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
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
                  padding: const EdgeInsets.all(0),
                  child: ListenableBuilder(
                      listenable: appSettings,
                      builder: (BuildContext context, Widget? child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.mainSet,
                                  style: AppTextStyles.dialogTitle,
                                )),
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.darkTheme,
                                style: AppTextStyles.itemMedium,
                              ),
                              trailing: Switch(
                                  value: appSettings.isDarkTheme,
                                  onChanged: (value) => {
                                        appSettings.setThemeMode(),
                                      }),
                            ),
                            ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.selLanguage,
                                  style: AppTextStyles.itemMedium,
                                ),
                                subtitle: Text(
                                  appSettings.getSelectLanguage,
                                  style: AppTextStyles.textHiddenSmall(context),
                                ),
                                onTap: () {
                                  pageIndexNotifier.value =
                                      pageIndexNotifier.value + 1;
                                }),
                            const SizedBox(height: 10)
                          ],
                        );
                      })),
            ),
          )
        ],
      );
    }

    SliverWoltModalSheetPage pageSetLocale(
        BuildContext modalSheetContext, TextTheme textTheme) {
      return SliverWoltModalSheetPage(
        enableDrag: false,
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              pageIndexNotifier.value = pageIndexNotifier.value - 1,
        ),
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
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
                  padding: const EdgeInsets.all(0),
                  child: ListenableBuilder(
                      listenable: appSettings,
                      builder: (BuildContext context, Widget? child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Responsive.isMobile(context)
                                        ? CustomSizes.paddingDialogMobile
                                        : CustomSizes.paddingDialogDesktop,
                                    horizontal:
                                        CustomSizes.paddingDialogVertical),
                                child: Text(
                                  AppLocalizations.of(context)!.selLanguage,
                                  style: AppTextStyles.dialogTitle,
                                )),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: appSettings.localeList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final locale = appSettings.localeList.keys
                                    .elementAt(index);
                                final languageName =
                                    appSettings.localeList[locale]!;
                                var isSelected =
                                    appSettings.selectLanguage == locale;
                                return ListTile(
                                  leading:
                                      const Icon(Icons.label_important_outline),
                                  title: Text(
                                    languageName,
                                    style: isSelected
                                        ? AppTextStyles.walletAddress
                                            .copyWith(fontSize: 20)
                                        : AppTextStyles.itemStyle
                                            .copyWith(fontSize: 20),
                                  ),
                                  onTap: () {
                                    appSettings.setLanguage(locale);
                                    pageIndexNotifier.value =
                                        pageIndexNotifier.value - 1;
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      })),
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
          pageSetLocale(modalSheetContext, textTheme),
        ];
      },
      modalTypeBuilder: (context) {
        final size = MediaQuery.of(context).size.width;
        if (size < pageBreakpoint) {
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
