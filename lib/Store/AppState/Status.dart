import 'package:pingvin_news/Misc/Constants.dart';

class Status {
  final int loading;
  final String floatMsg;

  Status(this.loading, this.floatMsg);

  factory Status.initial() => Status(0, Constants.emptyString);
}
