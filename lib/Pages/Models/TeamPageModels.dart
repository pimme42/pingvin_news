import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Data/Teams/TableInfo.dart';
import 'package:pingvin_news/Data/Teams/TableRow.dart';

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

@immutable
class TeamPageViewModel {
  final String team;
  final List<TableInfoItem> tableInfoItems;
  final Map<int, List<TableRowItem>> tableRows;
  final TableRowItem header;
  final Function() onRefresh;
  final Function() pop;
  final Function() dispose;

  TeamPageViewModel({
    this.team,
    this.tableInfoItems,
    this.tableRows,
    this.header,
    this.onRefresh,
    this.pop,
    this.dispose,
  });

  factory TeamPageViewModel.create(Store<AppStore> store) {
    teams team = store.state.teamState.team;

    /// LeagueIds som är associerade med det valda laget
    List<int> leagueIds =
        store.state.teamState.table.teamsLeagueId[store.state.teamState.team];
    List<TableInfoItem> tableInfoItems = List();
    Map<int, List<TableRowItem>> tableRows = {};

    leagueIds?.forEach((int leagueId) {
      TableInfo tableInfo = store.state.teamState.table[leagueId];
      tableInfoItems.add(TableInfoItem(
        leagueId,
        tableInfo.name,
        tableInfo.year.toString(),
        tableInfo.parentInfo?.name ?? "",
      ));
      tableRows[leagueId] = List();
      tableInfo.data?.rows?.forEach((TableRowData row) {
        tableRows[leagueId].add(TableRowItem.fromTableRow(row));
      });
    });
    List<TableRowItem> rows = new List();
    rows.add(TableRowItem.header());
//    store.state.teamState.table.tables[team]?.rows?.forEach((TeamTableRow ttr) {
//      rows.add(TableRowItem.fromTableRow(rowNum++, ttr));
//    });
    return TeamPageViewModel(
      team: team.toString(),
      tableInfoItems: tableInfoItems,
      tableRows: tableRows,
      header: TableRowItem.header(),
      onRefresh: () async => store.dispatch(ReadTeamFromRESTAction(team)),
      pop: () {},
      dispose: () => store.dispatch(ViewTeamAction.none()),
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
