import 'package:pingvin_news/Data/FileHandler.dart';
import 'package:pingvin_news/Data/RESTHandler.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Misc/Constants.dart';

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

//  Future<TeamTable> getTableFromFile() async => this._fh?.readNews();

  Future<TeamTable> getTableFromREST(teams team) async => TeamTable.fromRestApi(
        await this
            ._rh
            ?.getJsonFromApi(Constants.apiURL, Constants.teamEndPoints[team]),
      );

  Future<TeamTable> getTableFromFile(teams team) async => TeamTable.fromFile(
        await this._fh?.getJsonFromFile(Constants.teamFiles[team]),
      );

  void saveToFile(teams team, TeamTable tt) async {
    this._fh?.writeToFile(Constants.teamFiles[team], jsonEncode(tt.toJson()));
  }
}
