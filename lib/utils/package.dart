import 'package:package_info_plus/package_info_plus.dart';

class Package {
  late PackageInfo packageInfo;

  Package() {
    sync();
  }

  sync() async {
    PackageInfo  packageInfo = await PackageInfo.fromPlatform();
  }

  get version => packageInfo.version;
}
