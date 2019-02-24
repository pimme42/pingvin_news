import 'package:pingvin_news/Store/News/NewsStatus.dart';
import 'package:pingvin_news/Store/AppState/SubscriptionsManager.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

class NewsStore {
  final NewsPaper paper;
  final NewsStatus newsStatus;

  NewsStore(this.paper, this.newsStatus);

  factory NewsStore.initial() => NewsStore(
        NewsPaper.empty(),
        NewsStatus.initial(),
      );
}
