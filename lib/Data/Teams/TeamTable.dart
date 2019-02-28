import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/DataHandler.dart';

import 'dart:convert';

class TeamTable {
  TeamTableInfo _info;
  List<TeamTableRow> _rows;

  TeamTable.initial() {
    this._rows = List();
  }

  factory TeamTable.fromRestApi(String apiResponse) {
    if (apiResponse != null) {
      TeamTable teamTable = TeamTable.initial();

      var responseList = jsonDecode(apiResponse);

      teamTable._info = TeamTableInfo.fromJson(responseList['League']);

      List tableList = responseList['Table'];
      tableList.forEach((dynamic json) {
        teamTable._rows.add(TeamTableRow.fromJson(json));
      });
      return teamTable;
    }
    return null;
  }

  factory TeamTable.fromFile(String fileContents) {
    if (fileContents != null) {
      Map decode = jsonDecode(fileContents);
      return TeamTable.fromJson(decode);
    }
    return null;
  }

  factory TeamTable.fromJson(Map<String, dynamic> json) {
    TeamTable tt = TeamTable.initial();
    tt._info = TeamTableInfo.fromJson(jsonDecode(json['tableInfo']));
    List jsonRows = jsonDecode(json['tableRows']);
    jsonRows.forEach((dynamic rowJson) {
      tt._rows.add(TeamTableRow.fromJson((rowJson)));
    });
    return tt;
  }

  Map<String, dynamic> toJson() => {
        'class': this.runtimeType.toString(),
        'tableInfo': jsonEncode(this._info),
        'tableRows': jsonEncode(this._rows),
      };

  TeamTableInfo get info => _info;

  List<TeamTableRow> get rows => _rows;
}

class TeamTableRow {
  int id;
  int pos;
  String team;
  int played;
  int W;
  int D;
  int L;
  int pFor;
  int pAgainst;
  int points;

  TeamTableRow._internal(
      {this.id,
      this.pos,
      this.team,
      this.played,
      this.W,
      this.D,
      this.L,
      this.pFor,
      this.pAgainst,
      this.points});

  factory TeamTableRow.fromJson(Map<String, dynamic> json) {
    TeamTableRow ttr = TeamTableRow._internal(
      id: DataHandler.parseInt(json['id']),
      pos: DataHandler.parseInt(json['pos']),
      team: json['team'],
      played: DataHandler.parseInt(json['played']),
      W: DataHandler.parseInt(json['W']),
      D: DataHandler.parseInt(json['D']),
      L: DataHandler.parseInt(json['L']),
      pFor: DataHandler.parseInt(json['for']),
      pAgainst: DataHandler.parseInt(json['against']),
      points: DataHandler.parseInt(json['points']),
    );

    return ttr;
  }

  Map<String, dynamic> toJson() => {
        'class': this.runtimeType.toString(),
        'id': this.id,
        'pos': this.pos,
        'team': this.team,
        'played': this.played,
        'W': this.W,
        'D': this.D,
        'L': this.L,
        'for': this.pFor,
        'against': this.pAgainst,
        'points': this.points,
      };

  @override
  String toString() => "(${this.pos}) ${this.team}";
}

class TeamTableInfo {
  int id;
  String name;
  int year;
  String link;

  TeamTableInfo._internal({this.id, this.name, this.year, this.link});

  factory TeamTableInfo.fromJson(Map<String, dynamic> json) {
//    print(json.toString());
    TeamTableInfo tti = TeamTableInfo._internal(
      id: DataHandler.parseInt(json['id']),
      name: json['name'],
      year: DataHandler.parseInt(json['year']),
      link: json['link'],
    );
    return tti;
  }

  Map<String, dynamic> toJson() => {
        'class': this.runtimeType.toString(),
        'id': this.id,
        'name': this.name,
        'year': this.year,
        'link': this.link,
      };

  @override
  String toString() =>
      "(Id: ${this.id}) ${this.name} \{${this.year}\} :: ${this.link}";
}
