import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

@immutable
class DrawerViewModel {
  final String headerImage;
  final String headerTitle;
  final List<DrawerSubscribeItemView> subItems;
  final String appName;
  final String aboutText;
  final List<String> aboutBoxText;
  final String aboutEmail;
  final String aboutSubject;
  final IconData aboutIcon;
  final String aboutImage;
  final List<DrawerPageViewModel> pages;

  DrawerViewModel(
    this.headerImage,
    this.headerTitle,
    this.subItems,
    this.appName,
    this.aboutText,
    this.aboutBoxText,
    this.aboutEmail,
    this.aboutSubject,
    this.aboutIcon,
    this.aboutImage,
    this.pages,
  );

  factory DrawerViewModel.create(Store<AppStore> store) {
    return DrawerViewModel(
      "images/drawer_background2.jpg",
      Constants.title,
      [
        DrawerSubscribeItemView(
          store.state.subManager.news,
          (bool value) {
            store.dispatch(SubscribeToNewsNotificationsAction(value));
            store.dispatch(SaveSubscriptionsToPrefsAction());
          },
          Icons.notifications,
          Constants.logoPath,
          "Prenumerera på nyheter",
        ),
      ],
      Constants.title,
      'Om appen',
      ['Den här appen är skapad av Tobias Rörstam'],
      'pingvin_app@pimme.org',
      'Pingvin-appen',
      Icons.info,
      Constants.logoPath,
      [
        DrawerPageViewModel(
          'Nyheter',
          () {
            store.dispatch(NavigateToAction.replace('/'));
          },
        ),
        DrawerPageViewModel(
          'Herrar',
          () {
            store.dispatch(ViewTeamAction.mens());
            store.dispatch(NavigateToAction.replace('/teamPage'));
          },
        ),
        DrawerPageViewModel(
          'Damer',
          () {
            store.dispatch(ViewTeamAction.womens());
            store.dispatch(NavigateToAction.replace('/teamPage'));
          },
        ),
      ],
    );
  }
}

class DrawerPageViewModel {
  final String text;
  final Function() tap;

  DrawerPageViewModel(this.text, this.tap);
}

class DrawerSubscribeItemView {
  final bool subscribingTo;
  final Function(bool) subscribeTo;
  final IconData subscribeIcons; //Icons.notification
  final String thumbImage; //Constants.logoPath
  final String subscribeText;

  DrawerSubscribeItemView(this.subscribingTo, this.subscribeTo,
      this.subscribeIcons, this.thumbImage, this.subscribeText);
}
