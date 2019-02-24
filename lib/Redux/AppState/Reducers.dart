import 'package:pingvin_news/Redux/News/Reducers.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Store/AppState/SubscriptionsManager.dart';
import 'package:pingvin_news/Store/AppState/Status.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:redux/redux.dart';

// We create the State reducer by combining many smaller reducers into one!
AppStore appReducer(AppStore state, action) {
  return AppStore(
    newsStore: newsReducer(state.newsStore, action),
    status: statusReducer(state.status, action),
    subManager: subscriptionsReducer(state.subManager, action),
  );
}

//AppStore appReducer(AppStore state, action) => AppStore(
//      newsReducer(state.newsStore, action),
//      subscriptionsReducer(state.subManager, action),
//      statusReducer(state.status, action),
//    );

final Reducer<Status> statusReducer = combineReducers([
  TypedReducer<Status, StartLoadingAction>(_startLoading),
  TypedReducer<Status, StopLoadingAction>(_stopLoading),
  TypedReducer<Status, CouldNotReadRESTAction>(_noRESTData),
  TypedReducer<Status, NewNewsItemNotificationAction>(_newNewsItem),
  TypedReducer<Status, FloatMessageShownAction>(_floatMsgShown),
]);

Status _startLoading(Status status, StartLoadingAction action) =>
    Status(true, status.floatMsg);

Status _stopLoading(Status status, StopLoadingAction action) =>
    Status(false, status.floatMsg);

Status _noRESTData(Status status, CouldNotReadRESTAction action) =>
    Status(status.loading, action.msg);

Status _newNewsItem(Status status, NewNewsItemNotificationAction action) =>
    Status(status.loading, action.msg);

Status _floatMsgShown(Status status, FloatMessageShownAction action) {
  return Status(status.loading, Constants.emptyString);
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
