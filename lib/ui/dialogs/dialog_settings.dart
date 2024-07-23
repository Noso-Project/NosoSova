import 'package:flutter/material.dart';
import 'package:nososova/configs/social_links.dart';
import 'package:nososova/models/address_wallet.dart';
import 'package:nososova/ui/tiles/tile_wallet_address.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../configs/author.dart';
import '../../configs/interpreters.dart';
import '../../dependency_injection.dart';
import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/enum.dart';
import '../config/responsive.dart';
import '../notifer/address_tile_style_notifer.dart';
import '../notifer/app_settings_notifer.dart';
import '../theme/style/button_style.dart';
import '../theme/style/icons_style.dart';
import '../theme/style/sizes.dart';
import '../theme/style/text_style.dart';

class DialogSettings {
  static void showDialogSettings(BuildContext context) {
    const double pagePadding = 16.0;
    const double pageBreakpoint = 768.0;
    final pageIndexNotifier = ValueNotifier(0);
    final appSettings = locator<AppSettings>();
    final AddressStyleNotifier settingsStyleAddressTile =
        locator<AddressStyleNotifier>();

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
              AppButtonStyle.buttonDefault(
                  context,
                  AppLocalizations.of(context)!.openSettings,
                  () => pageIndexNotifier.value = pageIndexNotifier.value + 1)
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
                  Row(children: [
                    Text(
                      "${AppLocalizations.of(context)!.developer}: ",
                      style: AppTextStyles.infoItemTitle,
                    ),
                    const AuthorLink()
                  ]),
                  const SizedBox(height: 20),

                  Text(AppLocalizations.of(context)!.socialLinks,
                      style: AppTextStyles.dialogTitle),
                  Row(children: [
                    IconButton(
                        onPressed: () => openLink(SocialLinks.discord),
                        icon: AppIconsStyle.icon3x2NoColor(
                            Assets.iconsSocDiscord)),
                    IconButton(
                        onPressed: () => openLink(SocialLinks.telegram),
                        icon: AppIconsStyle.icon3x2NoColor(
                            Assets.iconsSocTelegram)),
                    IconButton(
                        onPressed: () => openLink(SocialLinks.github),
                        icon: AppIconsStyle.icon3x2NoColor(
                            Assets.iconsSocGithub)),
                    IconButton(
                        onPressed: () => openLink(SocialLinks.reddit),
                        icon: AppIconsStyle.icon3x2NoColor(
                            Assets.iconsSocReddit)),
                  ]),
                  ExpansionTile(
                    tilePadding:  const EdgeInsets.all(0),
                    title: Text(
                      AppLocalizations.of(context)!.thanksTranslate,
                      style: AppTextStyles.dialogTitle,
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${Interpreters.getInterpreters}",
                          style: AppTextStyles.infoItemTitle.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ])),
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
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.interface,
                                  style: AppTextStyles.dialogTitle,
                                )),
                            ListTile(
                                title: Text(
                                  AppLocalizations.of(context)!.viewAddressItem,
                                  style: AppTextStyles.itemMedium,
                                ),
                                subtitle: Text(
                                  settingsStyleAddressTile
                                              .getStyleAddressTile ==
                                          AddressTileStyle.sCustom
                                      ? "Custom"
                                      : "Default",
                                  style: AppTextStyles.textHiddenSmall(context),
                                ),
                                onTap: () {
                                  pageIndexNotifier.value =
                                      pageIndexNotifier.value + 2;
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
                                        ? AppTextStyles.infoItemValue.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                        : AppTextStyles.infoItemTitle,
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

    ///TODO In the future, it is better to work out the choice of the address display style
    SliverWoltModalSheetPage pageDisplayAddress(
        BuildContext modalSheetContext, TextTheme textTheme) {
      Widget buildItemStyleAddress(Address mAddress, Function(int) select,
          int value, String title, AddressTileStyle style) {
        return Column(children: [
          ListTile(
            leading: Radio<int>(
              value: value,
              groupValue: settingsStyleAddressTile.getStyleAddressTile ==
                      AddressTileStyle.sDefault
                  ? 0
                  : 1,
              onChanged: (value) => select(value ?? 0),
            ),
            title: Text(title),
            onTap: () => select(value),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: AddressListTile(
                address: mAddress, onLong: null, onTap: null, style: style),
          )
        ]);
      }

      var mAddress = Address(
          hash: 'Hash',
          publicKey: '',
          privateKey: '',
          custom: "Alias",
          description: "Description (In other cases alias/hash)");

      return SliverWoltModalSheetPage(
        enableDrag: false,
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              pageIndexNotifier.value = pageIndexNotifier.value - 2,
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
                                  AppLocalizations.of(context)!.viewAddressItem,
                                  style: AppTextStyles.dialogTitle,
                                )),
                            buildItemStyleAddress(mAddress, (sel) {
                              settingsStyleAddressTile.setStyleAddressTile(0);
                              pageIndexNotifier.value =
                                  pageIndexNotifier.value - 2;
                            }, 0, "Default", AddressTileStyle.sDefault),
                            buildItemStyleAddress(mAddress, (sel) {
                              settingsStyleAddressTile.setStyleAddressTile(1);
                              pageIndexNotifier.value =
                                  pageIndexNotifier.value - 2;
                            }, 1, "Custom", AddressTileStyle.sCustom),
                            const SizedBox(height: 30),
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
          pageDisplayAddress(modalSheetContext, textTheme),
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
        Navigator.of(context).pop();
        pageIndexNotifier.value = 0;
      },
      maxDialogWidth: 700,
      minDialogWidth: 500,
    );
  }
}
