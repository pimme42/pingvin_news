import 'package:pingvin_news/Data/FileHandler.dart';
import 'package:pingvin_news/Data/RESTHandler.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Data/Teams/TableInfo.dart';
import 'package:pingvin_news/Data/Teams/TableData.dart';
import 'package:pingvin_news/Data/Teams/TableRow.dart';

import 'dart:convert';

class TableHandler {
  FileHandler _fh;
  RESTHandler _rh;

  static final TableHandler _singleton = new TableHandler._internal();

  factory TableHandler() {
    return _singleton;
  }

  TableHandler._internal() {
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
        Constants.apiURL, Constants.leagueEndPoint + leagueId.toString());
    Map<String, dynamic> json = jsonDecode(jsonString)['League'];
    TableInfo tableInfo = TableInfo.fromJson(json);

//    print(tableInfo.toString());
    return tableInfo;
  }

  Future<TableData> getTableDataFromREST(int leagueId) async {
    String jsonString = await this._rh?.getJsonAsStringFromApi(
        Constants.apiURL, Constants.leagueEndPoint + leagueId.toString());
    List<dynamic> json = jsonDecode(jsonString)['Table'];
    TableData tableData = TableData(json.map((dynamic entry) {
      return TableRowData.fromJson(entry);
    }).toList());

//    print(tableData.toString());
    return tableData;
  }

  //  Future<TeamTable> getTableFromREST(teams team) async => TeamTable.fromRestApi(
//        await this
//            ._rh
//            ?.getJsonFromApi(Constants.apiURL, Constants.teamEndPoints[team]),
//      );

  Future<List<TableInfo>> getTableDataFromFile(teams team) async {
    String jsonString =
        await this._fh?.getJsonFromFile(Constants.teamPaths[team]);
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

  void saveTableInfoToFile(teams team, List<TableInfo> tableInfos) async {
    Log.doLog("TableHandler/saveTableInfoToFile", logLevel.DEBUG);
//    print(tableInfo.toJson());
//    Log.doLog("Json: ${jsonEncode(tableInfo.toJson())}", logLevel.DEBUG);
    this._fh?.writeToFile(
          Constants.teamPaths[team],
          jsonEncode(tableInfos),
        );
  }

  void saveLeagueIdsToFile(teams team, List<int> leagueIds) {
    this._fh?.writeToFile(
        "${Constants.teamPaths[team]}.json", jsonEncode(leagueIds));
  }

  void saveToFile(teams team, TeamTable tt) async {
    Log.doLog("TableHandler/saveToFile: team: $team", logLevel.DEBUG);
    this._fh?.writeToFile(Constants.teamPaths[team], jsonEncode(tt.toJson()));
  }
}
