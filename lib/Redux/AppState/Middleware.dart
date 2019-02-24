import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'dart:async';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppStore>> appStoreMiddleware() => [
      TypedMiddleware<AppStore, ShowFloatingMessageAction>(
          _showFloatingMessage),
      TypedMiddleware<AppStore, ReadSubscriptionsFromPrefsAction>(
          _readSubscriptionsPrefs),
      TypedMiddleware<AppStore, SaveSubscriptionsToPrefsAction>(
          _saveSubscriptionsPrefs),
    ];

Future _showFloatingMessage(Store<AppStore> store,
    ShowFloatingMessageAction action, NextDispatcher next) async {
  Log.doLog("_showFloatingMessage ${action.msg}", logLevel.DEBUG);
  next(action);
  await new Future.delayed(Constants.floatingMessageDuration);
  store.dispatch(FloatMessageShownAction());
}

Future _readSubscriptionsPrefs(Store<AppStore> store,
    ReadSubscriptionsFromPrefsAction action, NextDispatcher next) async {
  Log.doLog("_readSubscriptionsPrefs in Middleware", logLevel.DEBUG);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  store.dispatch(
      SubscribeToNewsNotificationsAction(prefs.getBool('News') ?? true));
  store.dispatch(
      SubscribeToMensNotificationsAction(prefs.getBool('MensScore') ?? false));
  store.dispatch(SubscribeToWomensNotificationsAction(
      prefs.getBool('WomensScore') ?? false));
}

Future _saveSubscriptionsPrefs(Store<AppStore> store,
    SaveSubscriptionsToPrefsAction action, NextDispatcher next) async {
  Log.doLog("_saveSubscriptionsPrefs in Middleware", logLevel.DEBUG);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('News', store.state.subManager.news);
  await prefs.setBool('MensScore', store.state.subManager.mensScores);
  await prefs.setBool('WomensScore', store.state.subManager.womensScores);
}
