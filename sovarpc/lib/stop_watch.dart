class WatchTime {
  Stopwatch _stopwatch = Stopwatch();

  void startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void stopTimer() {
    _stopwatch.stop();
    print('Execution time: ${_stopwatch.elapsedMilliseconds / 1000} seconds');
    _stopwatch.reset();
  }
}
