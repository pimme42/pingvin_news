import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Data/Teams/LeagueHandler.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Data/Teams/LeagueInfo.dart';
import 'package:pingvin_news/Data/Teams/TableData.dart';
import 'package:pingvin_news/Data/Teams/FixtureData.dart';

import 'dart:async';
import 'package:redux/redux.dart';

List<Middleware<AppStore>> teamStateMiddleware() => [
      TypedMiddleware<AppStore, ViewTeamAction>(_viewTeam),
      TypedMiddleware<AppStore, ReadTeamFromFileAction>(_readTeamFromFile),
      TypedMiddleware<AppStore, ReadTeamFromRESTAction>(_readTeamFromREST),
      TypedMiddleware<AppStore, SaveTableDataAction>(_saveTableInfoToFile),
      TypedMiddleware<AppStore, SaveTeamToFileAction>(_saveTeamToFile),
    ];
//
Future _viewTeam(
    Store<AppStore> store, ViewTeamAction action, NextDispatcher next) async {
  Log.doLog(
      "Teams/Middleware/_viewTeam ${action.team.toString()}", logLevel.DEBUG);
  next(action);
  if (store.state.teamState.team != teams.NONE) {
    store.dispatch(ReadTeamFromFileAction(store.state.teamState.team));
    store.dispatch(ReadTeamFromRESTAction(store.state.teamState.team));
  }
}

Future _readTeamFromFile(Store<AppStore> store, ReadTeamFromFileAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_readFromFile", logLevel.DEBUG);
  store.dispatch(StartLoadingAction());
  next(action);
  try {
    List<TableInfo> tableInfos =
        await LeagueHandler().getTableDataFromFile(action.team);
    List<int> leagueIds = List();
    if (tableInfos != null) {
      tableInfos.forEach((TableInfo tableInfo) {
        leagueIds.add(tableInfo.id);
      });

      store.dispatch(SetTableInfoAction(action.team, tableInfos));
    }
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
    List<TableInfo> tableInfos =
        await LeagueHandler().getTableInfoForTeamFromREST(action.team);
    if (tableInfos != null) {
      for (int i = 0; i < tableInfos.length; i++) {
        TableInfo tableInfo = tableInfos[i];
        TableData tableData =
            await LeagueHandler().getTableDataFromREST(tableInfo.id);

        TableInfo parent =
            await LeagueHandler().getTableInfoFromREST(tableInfo.parentId);

        FixtureData fixtureData =
            await LeagueHandler().getFixtureDataFromREST(tableInfo.id);

        tableInfos[i] = TableInfo.copy(
          tableInfo,
          parent: parent,
          tableData: tableData,
          fixtureData: fixtureData,
        );
      }
      store.dispatch(SetTableInfoAction(action.team, tableInfos));
      store.dispatch(SaveTableDataAction(action.team, tableInfos));
    } else {
      throw Exception("Could not read table from REST-API");
    }
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_readFromREST: ${e.toString()}, \n${s.toString()}",
        logLevel.ERROR);
    store.dispatch(
        ShowSnackBarAction.message("Kunde inte hämta tabell från servern"));
  } finally {
    store.dispatch(StopLoadingAction());
  }
}

Future _saveTableInfoToFile(Store<AppStore> store, SaveTableDataAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_saveTableInfoToFile", logLevel.DEBUG);
  next(action);
  LeagueHandler().saveTableInfoToFile(action.team, action.tableInfos);
}

Future _saveTeamToFile(Store<AppStore> store, SaveTeamToFileAction action,
    NextDispatcher next) async {
  Log.doLog("Teams/Middleware/_saveToFile", logLevel.DEBUG);
  next(action);
  try {
//    TableHandler().saveToFile(
//        action.team, store.state.teamState.table.tables[action.team]);
  } catch (e, s) {
    Log.doLog(
        "Error in Teams/Middleware/_saveToFile: ${e.toString()} \n${s.toString()}",
        logLevel.ERROR);
  }
}
