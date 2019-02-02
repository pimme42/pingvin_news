import 'Actions.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Data/NewsHandler.dart';
import 'package:pingvin_news/Data/FileHandler.dart';
import 'dart:async';
import 'package:redux/redux.dart';

List<Middleware<NewsStore>> createStoreMiddleware() => [
      TypedMiddleware<NewsStore, ReadNewsFromFileAction>(_readNewsFromFile),
      TypedMiddleware<NewsStore, ReadNewsFromRESTAction>(_readNewsFromREST),
      TypedMiddleware<NewsStore, SaveNewsAction>(_saveNews),
      TypedMiddleware<NewsStore, ShowErrorMessageAction>(_showErrorMessage),
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

Future _showErrorMessage(Store<NewsStore> store, ShowErrorMessageAction action,
    NextDispatcher next) async {
  Log.doLog("_showErrorMessage", logLevel.DEBUG);
  next(action);
  await new Future.delayed(Constants.timeOfErrorMessage);
  store.dispatch(ErrorMessageShownAction());
}
