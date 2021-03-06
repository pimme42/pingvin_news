import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Store/AppState/SharedPrefs.dart';

import 'dart:async';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

List<Middleware<AppStore>> appStoreMiddleware() => [
      TypedMiddleware<AppStore, ShowSnackBarAction>(_showSnackBar),
      TypedMiddleware<AppStore, ReadSubscriptionsFromPrefsAction>(
          _readSubscriptionsPrefs),
      TypedMiddleware<AppStore, SaveSubscriptionsToPrefsAction>(
          _saveSubscriptionsPrefs),
      TypedMiddleware<AppStore, UpdateVersionInfoAction>(_updateVersionInfo),
      TypedMiddleware<AppStore, ReadSharedPrefs>(_readSharedPrefs),
      TypedMiddleware<AppStore, ToggleFavouriteLeague>(
          _toggleLeagueToFavourite),
    ];

Future _showSnackBar(Store<AppStore> store, ShowSnackBarAction action,
    NextDispatcher next) async {
  Log.doLog("_showSnackBar ${action.msg}", logLevel.DEBUG);
  next(action);
//  await new Future.delayed(Constants.standardSnackBarDuration);
//  store.dispatch(FloatMessageShownAction());
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

Future _updateVersionInfo(Store<AppStore> store, UpdateVersionInfoAction action,
    NextDispatcher next) async {
  Log.doLog("_updateVersionInfo in Middleware", logLevel.DEBUG);
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    store.dispatch(SetVersionInfoAction(
      packageInfo.appName,
      packageInfo.packageName,
      packageInfo.version,
      packageInfo.buildNumber,
    ));
  });
}

Future _toggleLeagueToFavourite(Store<AppStore> store,
    ToggleFavouriteLeague action, NextDispatcher next) async {
  Log.doLog(
      "_toggleLeagueToFavourite; Toggle ${action.leagueName}", logLevel.DEBUG);

  /// First execute the action, thus adding or removing the league to the
  /// state, then save it to Shared preferences
  next(action);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(
      'favouriteLeagues', store.state.sharedPrefs.favouriteLeagues);
}

Future _readSharedPrefs(
    Store<AppStore> store, ReadSharedPrefs action, NextDispatcher next) async {
  next(action);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  next(PopulateSharedPrefs(
      SharedPrefs(prefs.getStringList('favouriteLeagues') ?? List<String>())));
}
