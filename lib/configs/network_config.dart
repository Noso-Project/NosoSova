import 'dart:math';

import 'package:noso_dart/models/app_info.dart';
import 'package:noso_dart/models/noso/seed.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../generated/assets.dart';
import '../utils/enum.dart';

final class NetworkConfig {
  static const List<String> seedsVerification = [
    "63.227.69.162",
    "20.199.50.27",
    "107.172.21.121",
    "107.172.214.53",
    "198.23.134.105",
    "107.173.210.55",
    "5.230.55.203",
    "4.233.61.8"
  ];

  String _appVersion = "";

  static const int durationTimeOut = 3;
  static const int delaySync = 30;

  get getAppInfo => AppInfo(appVersion: "NOSOSOVA_$_appVersion");

  NetworkConfig() {
    _load();
  }

  Future<void> _load() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
  }

  static String getRandomNode(String? inputString) {
    List<String> elements = (inputString ?? "").split(',');
    int elementCount = elements.length;
    if (elementCount > 0 && inputString != null && inputString.isNotEmpty) {
      int randomIndex = Random().nextInt(elementCount);
      var targetSeed = elements[randomIndex].split("|")[0];
      return targetSeed;
    } else {
      var devNode = NetworkConfig.getVerificationSeedList();
      int randomDev = Random().nextInt(devNode.length);
      return devNode[randomDev].toTokenizer;
    }
  }

  static List<Seed> getVerificationSeedList() {
    List<Seed> defSeed = [];
    for (String seed in seedsVerification) {
      defSeed.add(Seed(ip: seed));
    }
    return defSeed;
  }
}

final class CheckConnect {
  static String getStatusConnected(StatusConnectNodes status) {
    switch (status) {
      case StatusConnectNodes.connected:
        return Assets.iconsNodeI;
      case StatusConnectNodes.error:
        return Assets.iconsClose;
      default:
        return Assets.iconsNode;
    }
  }
}
