import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/Models/TeamPageModels.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:redux/redux.dart';

class TeamPage extends StatefulWidget {
  @override
  State createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Function() _dispose;
  @override
  void dispose() {
    this._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(),
      drawer: AppDrawer(),
      body: StoreConnector<AppStore, TeamPageViewModel>(
//        onInit: (store) {
//          store.dispatch(ReadTeamFromFileAction(store.state.teamState.team));
//          store.dispatch(ReadTeamFromRESTAction(store.state.teamState.team));
//        },
        converter: (Store<AppStore> store) => TeamPageViewModel.create(store),
        builder: (BuildContext context, TeamPageViewModel viewModel) {
          this._dispose = viewModel.dispose;
//          return _buildTable(context, viewModel.tableRows);
          return RefreshIndicator(
            onRefresh: viewModel.onRefresh,
            displacement: 50.0,
            color: Colors.black,
            child: ListView(
              children: _buildTable(
                  context, viewModel.tableInfo, viewModel.tableRows),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTable(
      BuildContext context, TableInfo tableInfo, List<TableRowItem> rows) {
    List<Widget> retVals = List();
    if (tableInfo.name != null) {
      retVals = [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "${tableInfo.name} (${tableInfo.year})",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Table(
              defaultColumnWidth: FlexColumnWidth(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: rows
                  .map((TableRowItem item) => _createTableRow(item))
                  .toList(),
              border: TableBorder(
                horizontalInside: BorderSide(),
                bottom: BorderSide(),
              ),
              textBaseline: TextBaseline.alphabetic,
              columnWidths: {
                0: FixedColumnWidth(30.0),
                /*
                 Tar fram bredden för kolumnen med lagnamn. Det gör att tabellen
                 inte tar upp hela bredden när man lägger telefonen/plattan ner. -20 i första
                 argumentet är kopplat till att vi har padding: 10 på både höger och vänster sida.
                */
                1: MinColumnWidth(
                  FixedColumnWidth(MediaQuery.of(context).size.width -
                      (30 + 20 * 4 + 75 + 50) -
                      20),
                  FixedColumnWidth(225),
                ),
                2: FixedColumnWidth(20.0),
                3: FixedColumnWidth(20.0),
                4: FixedColumnWidth(20.0),
                5: FixedColumnWidth(20.0),
                6: FixedColumnWidth(75.0),
                7: FixedColumnWidth(50.0),
              },
            ),
          ),
        ),
      ];
    } else {
      retVals = [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              "Laddar tabell",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
        )
      ];
    }
    return retVals;
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
        margin:
            topRow ? null : EdgeInsets.symmetric(vertical: 5, horizontal: 0),
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
