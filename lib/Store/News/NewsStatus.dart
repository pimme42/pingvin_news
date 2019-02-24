import 'package:pingvin_news/Misc/Constants.dart';

class NewsStatus {
  final List<int> openedNewsItems;
  final String urlToShow;

  NewsStatus(
    this.openedNewsItems,
    this.urlToShow,
  );

  factory NewsStatus.initial() => NewsStatus(
        List.unmodifiable(List.from(List<int>())),
        Constants.emptyString,
      );

  bool isNewsItemSelected(int nid) =>
      (this.openedNewsItems.where((int item) => item == nid).length) > 0;
}
