import '../generated/assets.dart';
import 'enum.dart';

final class CheckConnectUi {
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
