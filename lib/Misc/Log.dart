import 'package:pingvin_news/Misc/Constants.dart';

enum logLevel { DEBUG, ERROR }

class Log {
  static doLog(String text, logLevel level) {
    if (!Constants.isProduction) print("Level: $level => log: $text");
  }
}
