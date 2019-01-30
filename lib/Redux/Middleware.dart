import 'Actions.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';
import 'package:pingvin_news/Data/NewsHandler.dart';
import 'dart:async';
import 'package:redux/redux.dart';

List<Middleware<NewsStore>> createStoreMiddleware() => [
      TypedMiddleware<NewsStore, ReadNewsAction>(_readNews),
      TypedMiddleware<NewsStore, SaveNewsAction>(_saveNews),
    ];

Future _readNews(
    Store<NewsStore> store, ReadNewsAction action, NextDispatcher next) async {
//  await new Future.delayed(new Duration(seconds: 1));
  Log.doLog("Reading in middleware", logLevel.DEBUG);
  NewsHandler nh = new NewsHandler();
  List<NewsEntry> entriesFromFile = await nh.getNewsFromFile();
  store.dispatch(SetNewsAction(entriesFromFile));
  List<NewsEntry> entriesFromREST = await nh.getNewsFromREST();
  store.dispatch(SetNewsAction(entriesFromREST));
  store.dispatch(SaveNewsAction(entriesFromREST));
}

Future _saveNews(
    Store<NewsStore> store, SaveNewsAction action, NextDispatcher next) async {
//  await new Future.delayed(new Duration(seconds: 1));
  Log.doLog("Saving in middleware", logLevel.DEBUG);
  NewsHandler nh = new NewsHandler();
  nh.saveNews(action.entries);
}
