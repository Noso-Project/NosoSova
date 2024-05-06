import 'package:flutter/foundation.dart';

class WatchTime {
  Stopwatch _stopwatch = Stopwatch();

  void startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void stopTimer() {
    _stopwatch.stop();
    if (kDebugMode) {
      print('Execution time: ${_stopwatch.elapsedMilliseconds / 1000} seconds');
    }
    _stopwatch.reset();
  }
}
