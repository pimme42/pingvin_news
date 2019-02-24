import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Data/NewsHandler.dart';

import 'dart:io';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppStore>> newsStoreMiddleware() => [
      TypedMiddleware<AppStore, ReadNewsFromFileAction>(_readNewsFromFile),
      TypedMiddleware<AppStore, ReadNewsFromRESTAction>(_readNewsFromREST),
      TypedMiddleware<AppStore, SaveNewsAction>(_saveNews),
    ];

Future _readNewsFromFile(Store<AppStore> store, ReadNewsFromFileAction action,
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

Future _readNewsFromREST(Store<AppStore> store, ReadNewsFromRESTAction action,
    NextDispatcher next) async {
  Log.doLog("Reading from REST in middleware", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());

  NewsHandler nh = new NewsHandler();
  try {
    NewsPaper paperFromREST = await nh.getNewsFromREST();
    store.dispatch(SetNewsAction(paperFromREST));
    store.dispatch(SaveNewsAction(paperFromREST));
  } on HttpException {
    store.dispatch(
        CouldNotReadRESTAction("Kunde inte hämta nyheter från servern"));
  } catch (e) {
    Log.doLog("Error in _readNewsFromRest: ${e.toString()}", logLevel.ERROR);
  } finally {
    store.dispatch(StopLoadingAction());
  }
}

// Saving the news items to local file for faster startup
Future _saveNews(
    Store<AppStore> store, SaveNewsAction action, NextDispatcher next) async {
//  await new Future.delayed(new Duration(seconds: 1));
  Log.doLog("Saving in middleware", logLevel.DEBUG);
  if ((action.paper?.length ?? 0) > 0) {
    NewsHandler nh = new NewsHandler();
    nh.saveNews(action.paper);
  }
}
