class LogLevel {
  String level;

  LogLevel({required this.level});

  get isDebug => level != "Release";
}
