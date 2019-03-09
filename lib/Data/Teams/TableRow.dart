import 'package:pingvin_news/Data/DataHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';

class TableRowData {
  final int id;
  final int pos;
  final String team;
  final int played;
  final int W;
  final int D;
  final int L;
  final int pFor;
  final int pAgainst;
  final int points;

  TableRowData(
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

  factory TableRowData.fromJson(Map<String, dynamic> json) {
    try {
      TableRowData tableRow = TableRowData(
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
      return tableRow;
    } catch (e, s) {
      Log.doLog(
          "Error in _TableRow.fromJson: ${e.toString()}\nStackTrace: ${s.toString()}",
          logLevel.ERROR);
      return null;
    }
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
  String toString() {
    return "($pos) $team";
  }
}
