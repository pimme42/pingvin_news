enum logLevel {DEBUG, ERROR}

class Log {
  static doLog(String text, logLevel level) {
    print("Level: $level => log: $text");
  }
}