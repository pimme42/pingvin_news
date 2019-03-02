import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, DrawerViewModel>(
      onInit: (store) => store.dispatch(ReadSubscriptionsFromPrefsAction()),
      converter: (Store<AppStore> store) => DrawerViewModel.create(store),
      builder: (BuildContext context, DrawerViewModel viewModel) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: ExactAssetImage(viewModel.headerImage)),
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        viewModel.headerTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListView(
                  shrinkWrap: true,
                  children: viewModel.pages
                      .map((DrawerPageViewModel page) =>
                          _createPageItemWidget(context, page))
                      .toList()),
              ListView(
                  shrinkWrap: true,
                  children: viewModel.subItems
                      .map((DrawerSubscribeItemView item) =>
                          _createSubscriptionWidget(context, item))
                      .toList()),
/*
              Card(
                child: AboutListTile(
                  applicationIcon: ImageIcon(
                    ExactAssetImage(viewModel.aboutImage),
                  ),
                  child: Text(viewModel.aboutText),
                  icon: Icon(viewModel.aboutIcon),
                  applicationName: viewModel.appName,
                  aboutBoxChildren: _createAboutBox(viewModel),
                ),
              ),
*/
            ],
          ),
        );
      },
    );
  }

  Widget _createPageItemWidget(BuildContext context, DrawerPageViewModel page) {
    return Card(
      child: ListTile(
        onTap: () => page.tap(),
        title: Center(
          child: Text(
            page.text,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createSubscriptionWidget(
      BuildContext context, DrawerSubscribeItemView item) {
    return Card(
      child: SwitchListTile(
        value: item.subscribingTo,
        onChanged: (bool value) => item.subscribeTo(value),
        title: Text(
          item.subscribeText,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
        secondary: Icon(item.subscribeIcons),
        inactiveThumbImage: ExactAssetImage(item.thumbImage),
        inactiveTrackColor: Colors.black26,
        inactiveThumbColor: Colors.black12,
        activeThumbImage: ExactAssetImage(item.thumbImage),
        activeTrackColor: Colors.green[800],
        activeColor: Colors.white,
      ),
    );
  }

  List<Widget> _createAboutBox(DrawerViewModel model) {
    List<Widget> widgets = _createAboutBoxStrings(model.aboutBoxText);
    widgets.add(
      InkWell(
        child: Text(
          model.aboutEmail,
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () => _launchUrl(
            "mailto:${model.aboutEmail}?subject=${model.aboutSubject}"),
      ),
    );
    return widgets;
  }

  List<Widget> _createAboutBoxStrings(List<String> texts) {
    List<Widget> widgets = List();
    texts.forEach((String str) => widgets.add(Text(str)));
    return widgets;
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
