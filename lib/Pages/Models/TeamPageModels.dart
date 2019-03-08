import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

@immutable
class TeamPageViewModel {
  final String team;
  final TableInfo tableInfo;
  final List<TableRowItem> tableRows;
  final Function() onRefresh;
  final Function() pop;
  final Function() dispose;

  TeamPageViewModel({
    this.team,
    this.tableInfo,
    this.tableRows,
    this.onRefresh,
    this.pop,
    this.dispose,
  });

  factory TeamPageViewModel.create(Store<AppStore> store) {
    int rowNum = 1;
    teams team = store.state.teamState.team;
    List<TableRowItem> rows = new List();
    rows.add(TableRowItem.header());
    store.state.teamState.table.teamTable[team]?.rows
        ?.forEach((TeamTableRow ttr) {
      rows.add(TableRowItem.fromTableRow(rowNum++, ttr));
    });
    return TeamPageViewModel(
      team: team.toString(),
      tableInfo: TableInfo(
        store.state.teamState.table.teamTable[team]?.info?.name,
        store.state.teamState.table.teamTable[team]?.info?.year.toString(),
      ),
      tableRows: rows,
      onRefresh: () async => store.dispatch(ReadTeamFromRESTAction(team)),
      pop: () {},
      dispose: () => store.dispatch(ViewTeamAction.none()),
    );
  }
}

@immutable
class TableInfo {
  final String name;
  final String year;

  TableInfo(this.name, this.year);
}

@immutable
class TableRowItem {
  final int rowNum;
  final String pos;
  final String team;
  final String played;
  final String W;
  final String D;
  final String L;
  final String pDiff;
  final String points;

  TableRowItem(this.rowNum, this.pos, this.team, this.played, this.W, this.D,
      this.L, this.pDiff, this.points);

  factory TableRowItem.header() =>
      TableRowItem(0, "Pos", "Lag", "S", "V", "O", "F", "Mål", "P");

  factory TableRowItem.fromTableRow(int rowNum, TeamTableRow ttr) =>
      TableRowItem(
        rowNum,
        ttr.pos.toString(),
        ttr.team,
        ttr.played.toString(),
        ttr.W.toString(),
        ttr.D.toString(),
        ttr.L.toString(),
        "${ttr.pFor.toString()} - ${ttr.pAgainst.toString()}",
        ttr.points.toString(),
      );

  @override
  String toString() {
    return "($pos) $team $played $W $D $L $pDiff $points";
  }
}
