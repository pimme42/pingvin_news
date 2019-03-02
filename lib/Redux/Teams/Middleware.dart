import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Store/Teams/TeamState.dart';
import 'package:pingvin_news/Data/Teams/TableHandler.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

List<Middleware<AppStore>> teamStateMiddleware() => [
      TypedMiddleware<AppStore, ViewTeamAction>(_viewTeam),
      TypedMiddleware<AppStore, ReadTeamFromFileAction>(_readTeamFromFile),
      TypedMiddleware<AppStore, ReadTeamFromRESTAction>(_readTeamFromREST),
      TypedMiddleware<AppStore, SaveTeamToFileAction>(_saveTeamToFile),
    ];
//
Future _viewTeam(
    Store<AppStore> store, ViewTeamAction action, NextDispatcher next) async {
  Log.doLog(
      "Teams/Middleware/_viewTeam ${action.team.toString()}", logLevel.DEBUG);
  if (action.team != store.state.teamState.team) {
    store.dispatch(ClearTeamDataAction());
  }
  next(action);
}

Future _readTeamFromFile(Store<AppStore> store, ReadTeamFromFileAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_readFromFile", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());
  next(action);
  try {
    TeamTable tt = await TableHandler().getTableFromFile(action.team);
    if (tt != null) store.dispatch(SetTeamData(tt));
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_readFromFile: ${e.toString()}\n${s.toString()}",
        logLevel.ERROR);
  } finally {
    store.dispatch(StopLoadingAction());
  }
}

Future _readTeamFromREST(Store<AppStore> store, ReadTeamFromRESTAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_readFromREST", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());
  next(action);
  try {
    TeamTable tt =
        await TableHandler().getTableFromREST(store.state.teamState.team);
    if (tt != null) {
      store.dispatch(SetTeamData(tt));
      store.dispatch(SaveTeamToFileAction(store.state.teamState.team));
    }
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_readFromREST: ${e.toString()} \n${s.toString()}",
        logLevel.ERROR);
  } finally {
    store.dispatch(StopLoadingAction());
  }
}

Future _saveTeamToFile(Store<AppStore> store, SaveTeamToFileAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_saveToFile", logLevel.DEBUG);
  next(action);
  try {
    await TableHandler().saveToFile(
        store.state.teamState.team, store.state.teamState.table.teamTable);
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_saveToFile: ${e.toString()} \n${s.toString()}",
        logLevel.ERROR);
  }
}
