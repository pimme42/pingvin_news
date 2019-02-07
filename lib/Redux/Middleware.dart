import 'Actions.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Data/NewsHandler.dart';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<NewsStore>> createStoreMiddleware() => [
      TypedMiddleware<NewsStore, ReadNewsFromFileAction>(_readNewsFromFile),
      TypedMiddleware<NewsStore, ReadNewsFromRESTAction>(_readNewsFromREST),
      TypedMiddleware<NewsStore, SaveNewsAction>(_saveNews),
      TypedMiddleware<NewsStore, ShowFloatingMessageAction>(
          _showFloatingMessage),
      TypedMiddleware<NewsStore, ReadSubscriptionsFromPrefsAction>(
          _readSubscriptionsPrefs),
      TypedMiddleware<NewsStore, SaveSubscriptionsToPrefsAction>(
          _saveSubscriptionsPrefs),
    ];

Future _readNewsFromFile(Store<NewsStore> store, ReadNewsFromFileAction action,
    NextDispatcher next) async {
  Log.doLog("Reading from file in middleware", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());

//  FileHandler fh = FileHandler();
//  fh.deleteFile();

  NewsHandler nh = new NewsHandler();
  NewsPaper paperFromFile = await nh.getNewsFromFile();
  store.dispatch(StopLoadingAction());
  store.dispatch(SetNewsAction(paperFromFile));
}

Future _readNewsFromREST(Store<NewsStore> store, ReadNewsFromRESTAction action,
    NextDispatcher next) async {
  Log.doLog("Reading from REST in middleware", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());

  NewsHandler nh = new NewsHandler();
  try {
    NewsPaper paperFromREST = await nh.getNewsFromREST();
    store.dispatch(SetNewsAction(paperFromREST));
    store.dispatch(SaveNewsAction(paperFromREST));
  } catch (e) {
    store.dispatch(CouldNotReadRESTAction(e.toString()));
  } finally {
    store.dispatch(StopLoadingAction());
  }
}

// Saving the news items to local file for faster startup
Future _saveNews(
    Store<NewsStore> store, SaveNewsAction action, NextDispatcher next) async {
//  await new Future.delayed(new Duration(seconds: 1));
  Log.doLog("Saving in middleware", logLevel.DEBUG);
  NewsHandler nh = new NewsHandler();
  nh.saveNews(action.paper);
}

Future _showFloatingMessage(Store<NewsStore> store,
    ShowFloatingMessageAction action, NextDispatcher next) async {
  Log.doLog("_showFloatingMessage", logLevel.DEBUG);
  next(action);
  await new Future.delayed(Constants.floatingMessageDuration);
  store.dispatch(FloatMessageShownAction());
}

Future _readSubscriptionsPrefs(Store<NewsStore> store,
    ReadSubscriptionsFromPrefsAction action, NextDispatcher next) async {
  Log.doLog("_readSubscriptionsPrefs in Middleware", logLevel.DEBUG);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  store.dispatch(SubscribeToNewsNotificationsAction(prefs.getBool('News') ?? false));
  store.dispatch(SubscribeToMensNotificationsAction(prefs.getBool('MensScore') ?? false));
  store.dispatch(SubscribeToWomensNotificationsAction(prefs.getBool('WomensScore') ?? false));
}

Future _saveSubscriptionsPrefs(Store<NewsStore> store,
    SaveSubscriptionsToPrefsAction action, NextDispatcher next) async {
  Log.doLog("_saveSubscriptionsPrefs in Middleware", logLevel.DEBUG);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('News', store.state.subManager.news);
  await prefs.setBool('MensScore', store.state.subManager.mensScores);
  await prefs.setBool('WomensScore', store.state.subManager.womensScores);
}
