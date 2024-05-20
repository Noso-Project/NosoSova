import 'dart:math';

import 'package:noso_dart/models/noso/seed.dart';

final class NetworkObject {
  static const List<String> seedsVerification = [
    // "63.227.69.162",
    "20.199.50.27",
    // "107.172.21.121",
    "107.172.214.53",
    //   "198.23.134.105",
    "107.173.210.55",
    //  "5.230.55.203",
    "4.233.61.8",
    // "195.201.70.89" //pasichDev
  ];

  static const int durationTimeOut = 3;
  static const int delaySync = 30;

  static String getRandomNode(String? inputString) {
    List<String> elements = (inputString ?? "").split(',');
    int elementCount = elements.length;
    if (elementCount > 0 && inputString != null && inputString.isNotEmpty) {
      int randomIndex = Random().nextInt(elementCount);
      var targetSeed = elements[randomIndex].split("|")[0];
      return targetSeed;
    } else {
      var devNode = NetworkObject.getVerificationSeedList();
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
