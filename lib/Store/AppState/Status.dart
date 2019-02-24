import 'package:pingvin_news/Misc/Constants.dart';

class Status {
  final bool loading;
  final String floatMsg;

  Status(this.loading, this.floatMsg);

  factory Status.initial() => Status(false, Constants.emptyString);
}
