import 'package:pingvin_news/Misc/Constants.dart';

class Status {
  final List<int> openedNewsItems;
  final bool loading;
  final String errorMsg;
  final String urlToShow;

  Status(this.openedNewsItems, this.loading, this.errorMsg, this.urlToShow);

  factory Status.initial() => Status(
      List.unmodifiable(List.from(List<int>())), false, Constants.emptyString, Constants.emptyString);

  bool isNewsItemSelected(int nid) =>
      (this.openedNewsItems.where((int item) => item == nid).length) > 0;

  @override
  String toString() {
    return "List: ${this.openedNewsItems.toString()}\n"
        "Loading: $loading\n"
        "Error message: $errorMsg";
  }


}
