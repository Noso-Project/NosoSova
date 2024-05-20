import 'dart:async';
import 'dart:io';

class LoadingCli {
  static Timer loading() {
    final loadingSymbols = ['-', '\\', '|', '/'];
    var index = 0;
    return Timer.periodic(const Duration(milliseconds: 100), (timer) {
      stdout.write('\rLoading ${loadingSymbols[index]}');
      index = (index + 1) % loadingSymbols.length;
    });
  }
}
