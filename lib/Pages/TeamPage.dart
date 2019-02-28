import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/FirebaseHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/NotificationDecoder.dart';
import 'package:pingvin_news/Pages/Models/NewsPageModels.dart';
import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';

import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:pingvin_news/Pages/Models/TeamPageModels.dart';

import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/LoadIndicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:meta/meta.dart';
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
            return RefreshIndicator(
              onRefresh: viewModel.onRefresh,
              displacement: 50.0,
              color: Colors.black,
              child: Center(
                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: <Widget>[
                    _buildTable(context, viewModel.tableRows),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildTable(BuildContext context, List<TableRowItem> rows) {
    TableRowItem topRow = rows.removeAt(0);
    Widget ret = Column(
      children: <Widget>[
        _createTopRow(context, topRow),
      ]..addAll(rows
          .map<Widget>((TableRowItem row) => _createTableRow(context, row))),
    );
    return ret;
  }

  Widget _createTopRow(BuildContext context, TableRowItem row) {
    return Row(
      children: <Widget>[
        _createRowItem(context, row.pos),
        _createRowItem(context, row.team),
        _createRowItem(context, row.played),
        _createRowItem(context, row.W),
        _createRowItem(context, row.D),
        _createRowItem(context, row.L),
        _createRowItem(context, row.pDiff),
        _createRowItem(context, row.points),
      ],
    );
  }

  Widget _createTableRow(BuildContext context, TableRowItem row) {
    return Row(
      children: <Widget>[
        _createRowItem(context, row.pos),
        _createRowItem(context, row.team),
        _createRowItem(context, row.played),
        _createRowItem(context, row.W),
        _createRowItem(context, row.D),
        _createRowItem(context, row.L),
        _createRowItem(context, row.pDiff),
        _createRowItem(context, row.points),
      ],
    );
  }

  Widget _createRowItem(BuildContext context, String item) {
    return Container(
      child: Text(item),
    );
  }
}
