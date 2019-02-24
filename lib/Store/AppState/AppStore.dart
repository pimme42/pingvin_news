import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Store/AppState/SubscriptionsManager.dart';
import 'package:pingvin_news/Store/AppState/Status.dart';

class AppStore {
  final NewsStore newsStore;
  final SubscriptionsManager subManager;
  final Status status;

  AppStore({
    this.newsStore,
    this.status,
    this.subManager,
  });

  factory AppStore.initial() => AppStore(
        newsStore: NewsStore.initial(),
        status: Status.initial(),
        subManager: SubscriptionsManager.initial(),
      );
}
