import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/Models/TeamPageModels.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:redux/redux.dart';

//class TeamPage extends StatefulWidget {
//  @override
//  State createState() => _TeamPageState();
//}
//
//class _TeamPageState extends State<TeamPage> {
//  Function() _dispose;
//  @override
//  void dispose() {
////    this._dispose();
//    super.dispose();
//  }
class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, TeamPageViewModel>(
//        onInit: (store) {
//          store.dispatch(ReadTeamFromFileAction(store.state.teamState.team));
//          store.dispatch(ReadTeamFromRESTAction(store.state.teamState.team));
//        },
      converter: (Store<AppStore> store) => TeamPageViewModel.create(store),
      builder: (BuildContext context, TeamPageViewModel viewModel) {
        List<Widget> tables =
            viewModel.tableInfoItems?.map((TableInfoItem tableInfoItem) {
          return _buildTable(
            context,
            tableInfoItem,
            viewModel.header,
            viewModel.tableRows[tableInfoItem.leagueId],
          );
        })?.toList();
        if (tables.length == 0) {
          tables = [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  "Kan tyvärr inte visa några tabeller",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
            ),
          ];
        }

        return Scaffold(
          appBar: AppBarPage(),
          drawer: AppDrawer(),
          body: RefreshIndicator(
            onRefresh: viewModel.onRefresh,
            displacement: 50.0,
            color: Colors.black,
            child: ListView(
              children: tables,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context, TableInfoItem tableInfo,
      TableRowItem header, List<TableRowItem> rows) {
    int rowNum = 1;
    return Column(
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "${tableInfo.parentName}/${tableInfo.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Table(
              defaultColumnWidth: FlexColumnWidth(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                _createTableRow(
                  0,
                  header,
                ),
              ]..addAll(
                  rows
                      .map((TableRowItem item) =>
                          _createTableRow(rowNum++, item))
                      .toList(),
                ),
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
      ],
    );
  }

  TableRow _createTableRow(int rowNum, TableRowItem row) {
    return TableRow(
      decoration: BoxDecoration(
          color: (rowNum % 2 == 0) ? Colors.black12 : Colors.black26),
      children: [
        _createTableCell(row.pos, rowNum == 0),
        _createTableCell(row.team, rowNum == 0),
        _createTableCell(row.played, rowNum == 0),
        _createTableCell(row.W, rowNum == 0),
        _createTableCell(row.D, rowNum == 0),
        _createTableCell(row.L, rowNum == 0),
        _createTableCell(row.pDiff, rowNum == 0),
        _createTableCell(row.points, rowNum == 0),
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
