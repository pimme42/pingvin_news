import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/Models/TeamPageModels.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:redux/redux.dart';

class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(),
      drawer: AppDrawer(),
      body: StoreConnector<AppStore, TeamPageViewModel>(
        onInit: (store) {
          store.dispatch(ReadTeamFromFileAction(store.state.teamState.team));
          store.dispatch(ReadTeamFromRESTAction(store.state.teamState.team));
        },
        converter: (Store<AppStore> store) => TeamPageViewModel.create(store),
        builder: (BuildContext context, TeamPageViewModel viewModel) {
//          return _buildTable(context, viewModel.tableRows);
          return RefreshIndicator(
            onRefresh: viewModel.onRefresh,
            displacement: 50.0,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    "Tabell för : ${viewModel.tableInfo.name} (${viewModel.tableInfo.year})"),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: _buildTable(context, viewModel.tableRows),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<TableRowItem> rows) {
    return Table(
      defaultColumnWidth: FlexColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows.map((TableRowItem item) => _createTableRow(item)).toList(),
      border: TableBorder(horizontalInside: BorderSide(), bottom: BorderSide()),
      textBaseline: TextBaseline.alphabetic,
      columnWidths: {
        0: FixedColumnWidth(30.0),
        2: FixedColumnWidth(20.0),
        3: FixedColumnWidth(20.0),
        4: FixedColumnWidth(20.0),
        5: FixedColumnWidth(20.0),
        6: FixedColumnWidth(75.0),
        7: FixedColumnWidth(50.0),
      },
    );
  }

  TableRow _createTableRow(TableRowItem row) {
    return TableRow(
      decoration: BoxDecoration(
          color: (row.rowNum % 2 == 0) ? Colors.black12 : Colors.black26),
      children: [
        _createTableCell(row.pos, row.rowNum == 0),
        _createTableCell(row.team, row.rowNum == 0),
        _createTableCell(row.played, row.rowNum == 0),
        _createTableCell(row.W, row.rowNum == 0),
        _createTableCell(row.D, row.rowNum == 0),
        _createTableCell(row.L, row.rowNum == 0),
        _createTableCell(row.pDiff, row.rowNum == 0),
        _createTableCell(row.points, row.rowNum == 0),
      ],
    );
  }

  Widget _createTableCell(String item, bool topRow) {
    return TableCell(
      child: Container(
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: topRow ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
