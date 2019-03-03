const bool isProduction = bool.fromEnvironment('dart.vm.product');

enum logLevel { DEBUG, ERROR }

class Log {
  static doLog(String text, logLevel level) {
    if (!isProduction) print("Level: $level => log: $text");
  }
}
