import 'package:pingvin_news/Data/FileHandler.dart';
import 'package:pingvin_news/Data/RESTHandler.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Data/Teams/LeagueInfo.dart';
import 'package:pingvin_news/Data/Teams/TableData.dart';
import 'package:pingvin_news/Data/Teams/TableRow.dart';
import 'package:pingvin_news/Data/Teams/FixtureData.dart';

import 'dart:convert';

class LeagueHandler {
  FileHandler _fh;
  RESTHandler _rh;

  static final LeagueHandler _singleton = new LeagueHandler._internal();

  factory LeagueHandler() {
    return _singleton;
  }

  LeagueHandler._internal() {
    this._fh = new FileHandler();
    this._rh = new RESTHandler();
  }

  Future<List<TableInfo>> getTableInfoForTeamFromREST(teams team) async {
    String jsonString = await this._rh?.getJsonAsStringFromApi(
        Constants.apiURL, Constants.teamEndPoints[team]);
    if ((jsonString?.length ?? 0) > 0) {
      List<dynamic> json = jsonDecode(jsonString);
      List<TableInfo> tableInfos = json.map((dynamic entry) {
        return TableInfo.fromJson(entry);
      }).toList();

//    print(tableInfos.toString());
      return tableInfos;
    }
    return null;
  }

  Future<TableInfo> getTableInfoFromREST(int leagueId) async {
    String jsonString = await this._rh?.getJsonAsStringFromApi(
        Constants.apiURL, Constants.tableEndPoint + leagueId.toString());
    Map<String, dynamic> json = jsonDecode(jsonString)['League'];
    TableInfo tableInfo = TableInfo.fromJson(json);
    return tableInfo;
  }

  Future<TableData> getTableDataFromREST(int leagueId) async {
    String jsonString = await this._rh?.getJsonAsStringFromApi(
        Constants.apiURL, Constants.tableEndPoint + leagueId.toString());
    List<dynamic> json = jsonDecode(jsonString)['Table'];
    TableData tableData = TableData(json.map((dynamic entry) {
      return TableRowData.fromJson(entry);
    }).toList());
    return tableData;
  }

  Future<List<TableInfo>> getTableDataFromFile(teams team) async {
    String jsonString =
        await this._fh?.getJsonFromFile(Constants.leaguePaths[team]);
//    print(jsonDecode(jsonString));
    if (jsonString != null && jsonString.length > 0) {
      List jsonList = jsonDecode(jsonString);
      List<TableInfo> tableInfos = List();
      jsonList.forEach((dynamic entry) {
        tableInfos.add(TableInfo.fromJsonFile(entry));
//      print(entry);
      });
      return tableInfos;
    }
    return null;
  }

  Future<FixtureData> getFixtureDataFromREST(int leagueId) async {
    String jsonString = await this._rh?.getJsonAsStringFromApi(
        Constants.apiURL, Constants.fixtureEndPoint + leagueId.toString());
    List<dynamic> json = jsonDecode(jsonString)['Fixtures'];
    FixtureData fixtureData = FixtureData(json.map((dynamic entry) {
      return Fixture.fromJson(entry);
    }).toList());
    return fixtureData;
  }

  void saveTableInfoToFile(teams team, List<TableInfo> tableInfos) async {
    Log.doLog("TableHandler/saveTableInfoToFile", logLevel.DEBUG);
    this._fh?.writeToFile(
          Constants.leaguePaths[team],
          jsonEncode(tableInfos),
        );
  }

  void saveLeagueIdsToFile(teams team, List<int> leagueIds) {
    this._fh?.writeToFile(
        "${Constants.leaguePaths[team]}.json", jsonEncode(leagueIds));
  }

  void saveToFile(teams team, TeamTable tt) async {
    Log.doLog("TableHandler/saveToFile: team: $team", logLevel.DEBUG);
    this._fh?.writeToFile(Constants.leaguePaths[team], jsonEncode(tt.toJson()));
  }
}
