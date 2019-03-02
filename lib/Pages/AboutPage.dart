import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Store/AppState/VersionInfo.dart';
import 'package:pingvin_news/Pages/Models/AboutViewModel.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(),
      drawer: AppDrawer(),
      body: StoreConnector<AppStore, AboutViewModel>(
//    onInit: (store) => store.dispatch(ReadSubscriptionsFromPrefsAction()),
        converter: (Store<AppStore> store) => AboutViewModel.create(store),
        builder: (BuildContext context, AboutViewModel viewModel) {
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Text(
                  viewModel.aboutText,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(viewModel.contactText),
                    InkWell(
                      child: Text(
                        viewModel.contactEmail,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => viewModel.contactOnTap(),
                    ),
                  ],
                ),
                Container(
                  height: 10.0,
                ),
                Table(
                  border: TableBorder.all(),
                  children: viewModel.packageInfo.entries
                      .map((MapEntry<String, String> data) =>
                          _createTableRow(data))
                      .toList(),
                ),
                Container(
                  height: 10.0,
                ),
                InkWell(
                  child: Text(
                    "Licenser",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () => showLicensePage(
                        context: context,
                        applicationName: viewModel.packageInfo['appName'],
                        applicationVersion: viewModel.packageInfo['version'],
                        applicationLegalese: viewModel.legalese,
                        applicationIcon: Constants.logo,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TableRow _createTableRow(MapEntry data) {
    return TableRow(
      children: [
        Padding(
          child: Text(data.key),
          padding: EdgeInsets.all(5.0),
        ),
        Padding(
          child: Text(data.value),
          padding: EdgeInsets.all(5.0),
        ),
      ],
    );
  }
}
