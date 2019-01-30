import 'package:pingvin_news/Data/NewsEntry.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

class NewsStore {
  final NewsPaper paper;

  NewsStore(this.paper);

  factory NewsStore.initial() => NewsStore(NewsPaper.empty());
}