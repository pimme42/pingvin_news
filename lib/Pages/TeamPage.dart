import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/FirebaseHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/NotificationDecoder.dart';
import 'package:pingvin_news/Pages/Models/NewsPageModels.dart';
import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'package:pingvin_news/Store/AppState/AppStore.dart';

import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:pingvin_news/Pages/WebViewPage.dart';
import 'package:pingvin_news/Pages/LoadIndicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Här bygger vi laget!");
  }
}
