import 'package:pingvin_news/Redux/News/Reducers.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Store/AppState/SubscriptionsManager.dart';
import 'package:pingvin_news/Store/AppState/Status.dart';
import 'package:pingvin_news/Store/AppState/VersionInfo.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Redux/Teams/Reducers.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:redux/redux.dart';

// We create the State reducer by combining many smaller reducers into one!
AppStore appReducer(AppStore state, action) {
  return AppStore(
    newsStore: newsReducer(state.newsStore, action),
    status: statusReducer(state.status, action),
    subManager: subscriptionsReducer(state.subManager, action),
    teamState: teamReducer(state.teamState, action),
    versionInfo: versionReducer(state.versionInfo, action),
  );
}

final Reducer<Status> statusReducer = combineReducers([
  TypedReducer<Status, StartLoadingAction>(_startLoading),
  TypedReducer<Status, StopLoadingAction>(_stopLoading),
  TypedReducer<Status, ShowSnackBarAction>(_addSnackBarItem),
]);

Status _startLoading(Status status, StartLoadingAction action) =>
    Status(status.loading + 1, status.snackBarItems);

Status _stopLoading(Status status, StopLoadingAction action) =>
    Status(status.loading - 1, status.snackBarItems);

Status _addSnackBarItem(Status status, ShowSnackBarAction action) => Status(
      status.loading,
      status.snackBarItems..add(action),
    );

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

final Reducer<VersionInfo> versionReducer = combineReducers([
  TypedReducer<VersionInfo, SetVersionInfoAction>(_setVersionInfo),
]);

VersionInfo _setVersionInfo(
        VersionInfo versionInfo, SetVersionInfoAction action) =>
    VersionInfo(
      version: action.version,
      packageName: action.packageName,
      buildNumber: action.buildNumber,
      appName: action.appName,
    );
