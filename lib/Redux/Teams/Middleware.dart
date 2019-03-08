import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Data/Teams/TableHandler.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'dart:async';
import 'package:redux/redux.dart';

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
//  if (action.team != store.state.teamState.team) {
//    store.dispatch(ClearTeamDataAction());
//  }
  next(action);
}

Future _readTeamFromFile(Store<AppStore> store, ReadTeamFromFileAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_readFromFile", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());
  next(action);
  try {
    TeamTable tt = await TableHandler().getTableFromFile(action.team);
    if (tt != null) store.dispatch(SetTeamData(action.team, tt));
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
    TeamTable tt = await TableHandler().getTableFromREST(action.team);
    if (tt != null) {
      store.dispatch(SetTeamData(action.team, tt));
      store.dispatch(SaveTeamToFileAction(action.team));
    } else {
      throw Exception("Could not read table from REST-API");
    }
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_readFromREST: ${e.toString()} \n${s.toString()}",
        logLevel.ERROR);
    store.dispatch(
        ShowSnackBarAction.message("Kunde inte hämta tabell från servern"));
  } finally {
    store.dispatch(StopLoadingAction());
  }
}

Future _saveTeamToFile(Store<AppStore> store, SaveTeamToFileAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_saveToFile", logLevel.DEBUG);
  next(action);
  try {
    TableHandler().saveToFile(
        action.team, store.state.teamState.table.teamTable[action.team]);
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_saveToFile: ${e.toString()} \n${s.toString()}",
        logLevel.ERROR);
  }
}
