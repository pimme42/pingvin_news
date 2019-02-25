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
            store.dispatch(ReadTeamFromFileAction());
            store.dispatch(ReadTeamFromRESTAction());
          },
          converter: (Store<AppStore> store) => TeamPageViewModel.create(store),
          builder: (BuildContext context, TeamPageViewModel viewModel) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(viewModel.team),
                  Text(viewModel.table),
                ],
              ),
            );
          }),
    );
  }
}
