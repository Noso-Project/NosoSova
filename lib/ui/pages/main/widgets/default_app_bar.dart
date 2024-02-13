import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nososova/ui/dialogs/dialog_settings.dart';

import '../../../../generated/assets.dart';
import '../../../common/route/dialog_router.dart';
import '../../../common/widgets/network_info.dart';
import '../../../config/responsive.dart';
import '../../../theme/style/icons_style.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isVisible;

  const DefaultAppBar({super.key, this.isVisible = false});

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context) || isVisible
        ? AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: false,
            title: NetworkInfo(
                nodeStatusDialog: () =>
                    DialogRouter.showDialogInfoNetwork(context)),
            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(children: [
                    if (Platform.isAndroid || Platform.isIOS)
                      IconButton(
                        icon: AppIconsStyle.icon3x2(Assets.iconsScan,
                            colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.7),
                                BlendMode.srcIn)),
                        onPressed: () => DialogRouter.showDialogScanQr(context),
                      ),
                    IconButton(
                      icon: AppIconsStyle.icon3x2(Assets.iconsSettings,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(0.7), BlendMode.srcIn)),
                      onPressed: () =>
                          DialogSettings.showDialogSettings(context),
                    )
                  ]))
            ],
            backgroundColor: Colors.transparent,
          )
        : const PreferredSize(
            preferredSize: Size.zero,
            child: SizedBox(),
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
