import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/package.dart';
import '../theme/style/text_style.dart';

class DialogSettings extends StatefulWidget {
  const DialogSettings({Key? key}) : super(key: key);

  @override
  State createState() => _DialogSettingsState();
}

class _DialogSettingsState extends State<DialogSettings> {
  late PackageInfo packageInfo;

  @override
  void initState() {
    sync();
    super.initState();
  }

  sync() async {
    packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.version);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  SizedBox(height: 10),
          Text(
            "App version: v.0.2.4-beta",
            style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
          ),
          Text(
            "Developer: @pasichDev (Noso-Project)",
            style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
          ),
          SizedBox(height: 10),
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
            trailing: Switch(value: false, onChanged: (value) => {}),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Select language",
              style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
            ),
            //    trailing: Switch(value: false, onChanged: (value) => {}),
          ),
          Text(
            "Expert",
            style: AppTextStyles.dialogTitle.copyWith(fontSize: 24),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Update List Seeds",
              style: AppTextStyles.walletAddress.copyWith(fontSize: 20),
            ),
            subtitle: Text(
              "Refreshing the list of nodes, use when the app is not connected to the network.",
              style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
            ),

            //    trailing: Switch(value: false, onChanged: (value) => {}),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Restore start session",
              style: AppTextStyles.walletAddress.copyWith(fontSize: 20),
            ),
            subtitle: Text(
              "When you launch the application, a backup copy of your wallet is created, so you can restore to the beginning of the session.",
              style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
            ),
            //    trailing: Switch(value: false, onChanged: (value) => {}),
          ),
          /*  Text(
              AppLocalizations.of(context)!.debugInfo,
              style: AppTextStyles.dialogTitle,
            ),
            const SizedBox(height: 20),

           */
        ],
      ),
    );
  }
}
