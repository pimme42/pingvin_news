import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/Teams/TableInfo.dart';

class TableState {
//  final Map<teams, List<TableInfo>> tables;
  /// Containts a list of leagueId assosiated with a team
  final Map<teams, List<int>> teamsLeagueId;

  /// Maps a leagueId to a TableInfo
  final Map<int, TableInfo> tables;

  TableState({this.tables, this.teamsLeagueId});

  factory TableState.initial() => TableState(
        tables: {},
        teamsLeagueId: {},
      );

  TableInfo operator [](int leagueId) {
    try {
      return this.tables[leagueId];
    } catch (e) {
      throw IndexError(leagueId, tables);
    }
  }
//  operator []=(int i, int value) => _list[i] = value; // set
}
