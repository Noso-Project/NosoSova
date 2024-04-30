class WatchTime {
// Оголосіть Stopwatch на рівні класу для глобального доступу
  Stopwatch _stopwatch = Stopwatch();

// Метод для засікання часу виконання
  void startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void stopTimer() {
    _stopwatch.stop();
    print('Execution time: ${_stopwatch.elapsedMilliseconds / 1000} seconds');
    // Зупинка таймера і обнулення для наступного виклику
    _stopwatch.reset();
  }
}
