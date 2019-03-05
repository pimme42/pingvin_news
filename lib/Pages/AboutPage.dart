import 'package:pingvin_news/Store/AppState/AppStore.dart';
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
          return WillPopScope(
            onWillPop: () async {
              viewModel.pop();
              return false;
            },
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                Image.asset(
                  Constants.logoPath,
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
                _createText(
                  viewModel.packageInfo['appName'],
                  TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _createText(
                  "Version ${viewModel.packageInfo['version']} (${viewModel.packageInfo['buildNumber']})",
                  TextStyle(color: Colors.black45),
                ),
                _createText(
                  "\u{00A9} Tobias Rörstam",
                  TextStyle(color: Colors.black45),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _createText(
                      viewModel.contactText,
                      TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                    InkWell(
                      child: _createText(
                        viewModel.contactEmail,
                        TextStyle(color: Colors.blue),
                      ),
                      onTap: () => viewModel.contactOnTap(),
                    ),
                  ],
                ),
                InkWell(
                  child: Center(
                    child: Text(
                      "Licenser",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  onTap: () => showLicensePage(
                        context: context,
                        applicationName: viewModel.packageInfo['appName'],
                        applicationVersion:
                            "${viewModel.packageInfo['version']} (${viewModel.packageInfo['buildNumber']})",
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

  Widget _createText(String text, TextStyle style) => Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
          child: Text(
            text,
            style: style,
          ),
        ),
      );
}
