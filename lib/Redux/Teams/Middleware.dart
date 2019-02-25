import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Store/Teams/TeamState.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

List<Middleware<AppStore>> teamStateMiddleware() => [
      TypedMiddleware<AppStore, NavigateToAction>(_navigateTo),
      TypedMiddleware<AppStore, ReadTeamFromFileAction>(_readFromFile),
      TypedMiddleware<AppStore, ReadTeamFromRESTAction>(_readFromREST),
      TypedMiddleware<AppStore, SaveTeamToFileAction>(_saveToFile),
    ];

Future _navigateTo(
    Store<AppStore> store, NavigateToAction action, NextDispatcher next) async {
  Log.doLog("_navigateTo ${action.name}", logLevel.DEBUG);
  if (action.name == '/MensTeam') store.dispatch(ViewTeamAction.mens());
  if (action.name == '/WomensTeam') store.dispatch(ViewTeamAction.womens());
  next(action);
}

Future _readFromFile(Store<AppStore> store, ReadTeamFromFileAction action,
    NextDispatcher next) async {
  Log.doLog("_readFromFile", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());
  next(action);
  store.dispatch(SetTeamData("File"));

  store.dispatch(StopLoadingAction());
}

Future _readFromREST(Store<AppStore> store, ReadTeamFromRESTAction action,
    NextDispatcher next) async {
  Log.doLog("_readFromREST", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());
  next(action);
  store.dispatch(SetTeamData("REST"));
  store.dispatch(StopLoadingAction());
}

Future _saveToFile(Store<AppStore> store, SaveTeamToFileAction action,
    NextDispatcher next) async {
  Log.doLog("_saveToFile", logLevel.DEBUG);
  next(action);
}
