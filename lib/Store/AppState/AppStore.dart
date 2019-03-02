import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Store/AppState/SubscriptionsManager.dart';
import 'package:pingvin_news/Store/AppState/Status.dart';
import 'package:pingvin_news/Store/AppState/VersionInfo.dart';
import 'package:pingvin_news/Store/Teams/TeamState.dart';

class AppStore {
  final NewsStore newsStore;
  final SubscriptionsManager subManager;
  final Status status;
  final TeamState teamState;
  final VersionInfo versionInfo;

  AppStore({
    this.newsStore,
    this.status,
    this.subManager,
    this.teamState,
    this.versionInfo,
  });

  factory AppStore.initial() => AppStore(
        newsStore: NewsStore.initial(),
        status: Status.initial(),
        subManager: SubscriptionsManager.initial(),
        teamState: TeamState.initial(),
        versionInfo: VersionInfo.initial(),
      );
}
