enum logLevel { DEBUG, ERROR }

class Log {
  static doLog(String text, logLevel level) {
    if (level == logLevel.ERROR) print("Level: $level => log: $text");
  }
}
