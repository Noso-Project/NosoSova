import 'dart:math';

import 'package:noso_dart/models/noso/seed.dart';

final class NetworkObject {
  static const List<String> seedsVerification = [
    "20.199.50.27",
    "84.247.143.153",
    "64.69.43.225",
    "4.233.61.8",
    "141.11.192.215",
    "23.95.216.80",
    "142.171.231.9"
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
