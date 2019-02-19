import 'package:pingvin_news/Redux/Actions.dart';
import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Store/SubscriptionsManager.dart';
import 'package:pingvin_news/Store/Status.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:redux/redux.dart';

NewsStore newsReducer(NewsStore state, action) => NewsStore(
      entryReducer(state.paper, action),
      statusReducer(state.status, action),
      subscriptionsReducer(state.subManager, action),
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

final Reducer<Status> statusReducer = combineReducers([
  TypedReducer<Status, SelectNewsItemAction>(_addShowingNewsItem),
  TypedReducer<Status, DeSelectNewsItemAction>(_removeShowingNewsItem),
  TypedReducer<Status, StartLoadingAction>(_startLoading),
  TypedReducer<Status, StopLoadingAction>(_stopLoading),
  TypedReducer<Status, CouldNotReadRESTAction>(_noRESTData),
  TypedReducer<Status, NewNewsItemNotificationAction>(_newNewsItem),
  TypedReducer<Status, FloatMessageShownAction>(_floatMsgShown),
  TypedReducer<Status, SelectUrlToShowAction>(_displayWebView),
  TypedReducer<Status, CloseWebViewAction>(_closeWebView),
]);

Status _addShowingNewsItem(
        Status status, SelectNewsItemAction action) =>
    Status(
        List.unmodifiable(
            List.from(status.openedNewsItems)..add(action.newsId)),
        status.loading,
        status.floatMsg,
        status.urlToShow);

Status _removeShowingNewsItem(Status status, DeSelectNewsItemAction action) =>
    Status(
        List.unmodifiable(
            List.from(status.openedNewsItems)..remove(action.newsId)),
        status.loading,
        status.floatMsg,
        status.urlToShow);

Status _startLoading(Status status, StartLoadingAction action) =>
    Status(status.openedNewsItems, true, status.floatMsg, status.urlToShow);

Status _stopLoading(Status status, StopLoadingAction action) =>
    Status(status.openedNewsItems, false, status.floatMsg, status.urlToShow);

Status _noRESTData(Status status, CouldNotReadRESTAction action) => Status(
    status.openedNewsItems, status.loading, action.msg, status.urlToShow);

Status _newNewsItem(Status status, NewNewsItemNotificationAction action) =>
    Status(
        status.openedNewsItems, status.loading, action.msg, status.urlToShow);

Status _floatMsgShown(Status status, FloatMessageShownAction action) {
  return Status(status.openedNewsItems, status.loading, Constants.emptyString,
      status.urlToShow);
}

Status _displayWebView(Status status, SelectUrlToShowAction action) {
  return Status(
      status.openedNewsItems, status.loading, status.floatMsg, action.url);
}

Status _closeWebView(Status status, CloseWebViewAction action) {
  return Status(status.openedNewsItems, status.loading, status.floatMsg,
      Constants.emptyString);
}

final Reducer<SubscriptionsManager> subscriptionsReducer = combineReducers([
  TypedReducer<SubscriptionsManager, SubscribeToNewsNotificationsAction>(
      _subscribeNewsNotif),
  TypedReducer<SubscriptionsManager, SubscribeToMensNotificationsAction>(
      _subscribeMensNotif),
  TypedReducer<SubscriptionsManager, SubscribeToWomensNotificationsAction>(
      _subscribeWomensNotif),
]);

SubscriptionsManager _subscribeNewsNotif(
    SubscriptionsManager manager, SubscribeToNewsNotificationsAction action) {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  Log.doLog(
      "_subscribeNewsNotif value: ${action.value.toString()}", logLevel.DEBUG);
  if (action.value)
    _firebaseMessaging.subscribeToTopic('News');
  else
    _firebaseMessaging.unsubscribeFromTopic('News');
  return SubscriptionsManager(
      action.value, manager.mensScores, manager.womensScores);
}

SubscriptionsManager _subscribeMensNotif(
    SubscriptionsManager manager, SubscribeToMensNotificationsAction action) {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  _firebaseMessaging.subscribeToTopic('MensScores');
  return SubscriptionsManager(manager.news, action.value, manager.womensScores);
}

SubscriptionsManager _subscribeWomensNotif(
    SubscriptionsManager manager, SubscribeToWomensNotificationsAction action) {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  _firebaseMessaging.subscribeToTopic('WomensScores');
  return SubscriptionsManager(manager.news, manager.mensScores, action.value);
}
