import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/Models/TeamPageModels.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'package:redux/redux.dart';
import 'dart:math';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  TeamPageViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, TeamPageViewModel>(
      onInit: (Store<AppStore> store) => store.dispatch(ReadSharedPrefs()),
      converter: (Store<AppStore> store) => TeamPageViewModel.create(store),
      builder: (BuildContext context, TeamPageViewModel viewModel) {
        this._viewModel = viewModel;
        List<Widget> leagues =
            viewModel.tableInfoItems?.map((TableInfoItem tableInfoItem) {
          return _buildLeague(
            context,
            tableInfoItem,
            viewModel,
          );
        })?.toList();
        if (leagues.length == 0) {
          leagues = [
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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Säsong: ${viewModel.year}",
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.7, fontWeightDelta: 2),
                    ),
                  ),
                ),
              ]..addAll(leagues),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeague(BuildContext context, TableInfoItem tableInfo,
      TeamPageViewModel viewModel) {
    return Card(
      elevation: 4,
      child: ExpansionTile(
        initiallyExpanded: tableInfo.isFavourite,
        key: Key("${tableInfo.parentName}/${tableInfo.name}_${tableInfo.year}"),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: tableInfo.isFavourite
                    ? Icon(Icons.star, color: Colors.yellow[800])
                    : Icon(Icons.star_border, color: Colors.black54),
//                icon: Icon(
//                  tableInfo.isFavourite ? Icons.star : Icons.star_border,
//                  color: tableInfo.isFavourite
//                      ? Colors.yellow[800]
//                      : Colors.black54,
//                ),
                onPressed: () => tableInfo.toggleFavourite()),
            Text(
              "Favorit",
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
        title: ListTile(
          title: Text(
            "${tableInfo?.parentName ?? 'Seriesystem'}/${tableInfo?.name ?? 'Division'}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        children: <Widget>[
          _buildTable(context, tableInfo, viewModel.header,
              viewModel?.tableRows[tableInfo.leagueId]),
          _buildFixtureList(
              context,
              viewModel?.fixtureRounds[tableInfo.leagueId],
              viewModel?.fixtures[tableInfo.leagueId]),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, TableInfoItem tableInfo,
      TableRowItem header, List<TableRowItem> rows) {
    if (rows.length == 0) return Container();
    int rowNum = 1;
    return Center(
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
                  .map((TableRowItem item) => _createTableRow(rowNum++, item))
                  .toList(),
            ),
          border: TableBorder(
            horizontalInside: BorderSide(),
            bottom: BorderSide(),
          ),
          textBaseline: TextBaseline.alphabetic,
          columnWidths: {
            0: FixedColumnWidth(30.0),
            /**
                 * Tar fram bredden för kolumnen med lagnamn. Det gör att tabellen
                 * inte tar upp hela bredden när man lägger telefonen/plattan ner. -20 i första
                 * argumentet är kopplat till att vi har padding: 10 på både höger och vänster sida.
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
    );
  }

  TableRow _createTableRow(int rowNum, TableRowItem row) {
    return TableRow(
      /// Fick ta bort detta p.g.a. en bugg i Flutter som gör att
      /// tabellen försvinner när man klickade på den.
//      decoration: BoxDecoration(
//        color: (rowNum % 2 == 0) ? Colors.black12 : Colors.black26,
//      ),
      children: [
        _createTableCell(row.pos, rowNum == 0),
        _createTableCell(row.team,
            rowNum == 0 || row.team.contains(this._viewModel?.teamOfInterest)),
        _createTableCell(row.played, rowNum == 0),
        _createTableCell(row.W, rowNum == 0),
        _createTableCell(row.D, rowNum == 0),
        _createTableCell(row.L, rowNum == 0),
        _createTableCell(row.pDiff, rowNum == 0),
        _createTableCell(row.points, rowNum == 0),
      ],
    );
  }

  Widget _createTableCell(String item, [bool topRow = false]) {
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

  Widget _buildFixtureList(
      BuildContext context, bool fixtureRounds, List<FixtureItem> fixtures) {
    if (fixtures != null && fixtures.length == 0) return Container();
    List<Widget> rows = List();
    String prevRound = "";
    String prevDate = "";
    FixtureItem fixture;
    for (int i = 0; i < fixtures.length; i++) {
      fixture = fixtures[i];
      if (fixtureRounds && prevRound != fixture.round) {
        /// New round
        prevRound = fixture.round;
        rows.add(
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Omgång ${fixture.round}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }
      if (fixture.date != prevDate) {
        /// New date
        prevDate = fixture.date;
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                fixture.date,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black45),
              ),
            ],
          ),
        );
      }

      double width = min(
          MediaQuery.of(context).size.width - (50 + 10 * 2 + 30 * 2) - 20,
          300.0);

//      BoxDecoration rowDecor = BoxDecoration(
//          color: ((n % 2 == 0) ? Colors.black12 : Colors.black26));

      rows.add(
        Container(
//          decoration: rowDecor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                child: Center(
                  child: Text(fixture.time ?? ""),
                ),
              ),
              Container(
                width: width / 2,
                child: Text(
                  fixture.homeTeam ?? "",
                  style: TextStyle(
                      fontWeight: (fixture.homeTeam
                              .contains(this._viewModel?.teamOfInterest)
                          ? FontWeight.bold
                          : FontWeight.normal)),
                ),
              ),
              Container(
                width: 10.0,
                child: Center(
                  child: Text('-'),
                ),
              ),
              Container(
                width: width / 2,
                child: Text(
                  fixture.awayTeam ?? "",
                  style: TextStyle(
                      fontWeight: (fixture.awayTeam
                              .contains(this._viewModel?.teamOfInterest)
                          ? FontWeight.bold
                          : FontWeight.normal)),
                ),
              ),
              Container(
                width: 30.0,
                child: Align(
                  alignment: Alignment(0, 0),
                  child: Text(fixture.homeScore ?? ""),
                ),
              ),
              Container(
                width: 10.0,
                child: Center(
                  child: Text('-'),
                ),
              ),
              Container(
                width: 30.0,
                child: Align(
                  alignment: Alignment(0, 0),
                  child: Text(fixture.awayScore ?? ""),
                ),
              ),
            ],
          ),
        ),
      );
      rows.add(Divider(
        color: Colors.black,
      ));
    }

    return Container(
      width: min(MediaQuery.of(context).size.width,
          Constants.maxWidth - 20), // -20 pga padding
      child: ListView(
        padding: EdgeInsets.all(6.0),

        /// Should be 10.0, but Card adds 4.0px
        shrinkWrap: true,
        primary: false,
        children: rows,
      ),
    );
  }
}
