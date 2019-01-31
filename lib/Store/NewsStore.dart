import 'package:pingvin_news/Store/Status.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

class NewsStore {
  final NewsPaper paper;
  final Status status;

  NewsStore(this.paper, this.status);

  factory NewsStore.initial() => NewsStore(NewsPaper.empty(), Status.initial());
}