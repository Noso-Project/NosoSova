import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathAppUtil {
  static getAppPath() async {
    print(await getLibraryDirectory());
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      var path = Platform.isMacOS
          ? await getLibraryDirectory()
          : await getApplicationSupportDirectory();
      return path.path;
    } else {
      var path = await getApplicationSupportDirectory();
      return path.path;
    }
  }
}
