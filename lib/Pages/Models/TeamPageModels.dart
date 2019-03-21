import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Data/Teams/LeagueInfo.dart';
import 'package:pingvin_news/Data/Teams/TableRow.dart';
import 'package:pingvin_news/Data/Teams/FixtureData.dart';

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class TeamPageViewModel {
  final String team;
  final List<TableInfoItem> tableInfoItems;
  final Map<int, List<TableRowItem>> tableRows;
  final Map<int, List<FixtureItem>> fixtures;
  final TableRowItem header;
  final Function() onRefresh;
  final Function() pop;
  final Function() dispose;
  final Map<int, bool> fixtureRounds;

  TeamPageViewModel({
    this.team,
    this.tableInfoItems,
    this.tableRows,
    this.fixtures,
    this.header,
    this.onRefresh,
    this.pop,
    this.dispose,
    this.fixtureRounds, // Is true if there is a round for that league, if false, it is probably play off games
  });

  factory TeamPageViewModel.create(Store<AppStore> store) {
    teams team = store.state.teamState.team;

    /// LeagueIds som är associerade med det valda laget
    List<int> leagueIds =
        store.state.teamState.table.teamsLeagueId[store.state.teamState.team];
    List<TableInfoItem> tableInfoItems = List();
    Map<int, List<TableRowItem>> tableRows = {};
    Map<int, List<FixtureItem>> fixtures = {};
    Map<int, bool> fixtureRounds = {};

    leagueIds?.forEach((int leagueId) {
      TableInfo tableInfo = store.state.teamState.table[leagueId];
      tableInfoItems.add(TableInfoItem(
        leagueId,
        tableInfo.name,
        tableInfo.year.toString(),
        tableInfo.parentInfo?.name ?? "",
      ));
      tableRows[leagueId] = List();
      tableInfo.tableData?.rows?.forEach((TableRowData row) {
        tableRows[leagueId].add(TableRowItem.fromTableRow(row));
      });

      fixtures[leagueId] = List();
      tableInfo.fixtureData?.fixtures?.forEach((Fixture fixture) {
        if (fixture.round != null && fixture.round > 0)
          fixtureRounds[leagueId] = true;
        else
          fixtureRounds[leagueId] = false;
        fixtures[leagueId].add(FixtureItem(
          DateFormat('yyyy-MM-dd').format(
              DateTime.fromMillisecondsSinceEpoch(fixture.timestamp * 1000)),
          DateFormat('HH:mm').format(
              DateTime.fromMillisecondsSinceEpoch(fixture.timestamp * 1000)),
          fixture.round?.toString(),
          fixture.homeTeam,
          fixture.awayTeam,
          fixture.homeScore?.toString(),
          fixture.awayScore?.toString(),
        ));
      });
    });
    List<TableRowItem> rows = new List();
    rows.add(TableRowItem.header());

    return TeamPageViewModel(
      team: team.toString(),
      tableInfoItems: tableInfoItems,
      tableRows: tableRows,
      fixtures: fixtures,
      header: TableRowItem.header(),
      onRefresh: () async => store.dispatch(ReadTeamFromRESTAction(team)),
      pop: () {},
      dispose: () => store.dispatch(ViewTeamAction.none()),
      fixtureRounds: fixtureRounds,
    );
  }
}

@immutable
class TableInfoItem {
  final int leagueId;
  final String name;
  final String year;
  final String parentName;

  TableInfoItem(this.leagueId, this.name, this.year, this.parentName);
}

@immutable
class TableRowItem {
//  final int rowNum;
  final String pos;
  final String team;
  final String played;
  final String W;
  final String D;
  final String L;
  final String pDiff;
  final String points;

  TableRowItem(this.pos, this.team, this.played, this.W, this.D, this.L,
      this.pDiff, this.points);

  factory TableRowItem.header() =>
      TableRowItem("Pos", "Lag", "S", "V", "O", "F", "Mål", "P");

  factory TableRowItem.fromTableRow(TableRowData tableRow) => TableRowItem(
        tableRow.pos.toString(),
        tableRow.team,
        tableRow.played.toString(),
        tableRow.W.toString(),
        tableRow.D.toString(),
        tableRow.L.toString(),
        "${tableRow.pFor.toString()} - ${tableRow.pAgainst.toString()}",
        tableRow.points.toString(),
      );

  @override
  String toString() {
    return "($pos) $team $played $W $D $L $pDiff $points";
  }
}

@immutable
class FixtureItem {
  final String date;
  final String time;
  final String round;
  final String homeTeam;
  final String awayTeam;
  final String homeScore;
  final String awayScore;

  FixtureItem(this.date, this.time, this.round, this.homeTeam, this.awayTeam,
      this.homeScore, this.awayScore);
}
