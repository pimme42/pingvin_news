import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Store/News/NewsStatus.dart';
import 'package:pingvin_news/Store/AppState/SubscriptionsManager.dart';
import 'package:pingvin_news/Store/AppState/Status.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:redux/redux.dart';

NewsStore newsReducer(NewsStore state, action) => NewsStore(
      entryReducer(state.paper, action),
      statusReducer(state.newsStatus, action),
    );

final Reducer<NewsPaper> entryReducer = combineReducers([
  TypedReducer<NewsPaper, SetNewsAction>(_setNews),
]);

NewsPaper _setNews(NewsPaper paper, SetNewsAction action) {
  if (action.paper != null &&
      action.paper.entries != null &&
      action.paper.entries.length > 0)
    return NewsPaper(List.unmodifiable(List.from(action.paper.entries)));
  return paper;
}

final Reducer<NewsStatus> statusReducer = combineReducers([
  TypedReducer<NewsStatus, SelectNewsItemAction>(_addShowingNewsItem),
  TypedReducer<NewsStatus, DeSelectNewsItemAction>(_removeShowingNewsItem),
//  TypedReducer<NewsStatus, StartLoadingAction>(_startLoading),
//  TypedReducer<NewsStatus, StopLoadingAction>(_stopLoading),
//  TypedReducer<NewsStatus, CouldNotReadRESTAction>(_noRESTData),
//  TypedReducer<NewsStatus, NewNewsItemNotificationAction>(_newNewsItem),
//  TypedReducer<NewsStatus, FloatMessageShownAction>(_floatMsgShown),
  TypedReducer<NewsStatus, SelectUrlToShowAction>(_displayWebView),
  TypedReducer<NewsStatus, CloseWebViewAction>(_closeWebView),
]);

NewsStatus _addShowingNewsItem(
        NewsStatus status, SelectNewsItemAction action) =>
    NewsStatus(
      List.unmodifiable(List.from(status.openedNewsItems)..add(action.newsId)),
      status.urlToShow,
    );

NewsStatus _removeShowingNewsItem(
        NewsStatus status, DeSelectNewsItemAction action) =>
    NewsStatus(
      List.unmodifiable(
          List.from(status.openedNewsItems)..remove(action.newsId)),
      status.urlToShow,
    );

NewsStatus _displayWebView(NewsStatus status, SelectUrlToShowAction action) {
  return NewsStatus(status.openedNewsItems, action.url);
}

NewsStatus _closeWebView(NewsStatus status, CloseWebViewAction action) {
  return NewsStatus(status.openedNewsItems, Constants.emptyString);
}
