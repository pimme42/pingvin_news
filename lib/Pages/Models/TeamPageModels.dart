import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

@immutable
class TeamPageViewModel {
  final String team;
  final String table;

  TeamPageViewModel({
    this.team,
    this.table,
  });

  factory TeamPageViewModel.create(Store<AppStore> store) {
    return TeamPageViewModel(
      team: store.state.teamState.team.toString(),
      table: store.state.teamState.table.table,
    );
  }
}
