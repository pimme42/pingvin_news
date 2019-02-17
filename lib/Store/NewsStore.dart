import 'package:pingvin_news/Store/Status.dart';
import 'package:pingvin_news/Store/SubscriptionsManager.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

class NewsStore {
  final NewsPaper paper;
  final Status status;
  final SubscriptionsManager subManager;

  NewsStore(this.paper, this.status, this.subManager);

  factory NewsStore.initial() => NewsStore(NewsPaper.empty(), Status.initial(), SubscriptionsManager.initial());
}