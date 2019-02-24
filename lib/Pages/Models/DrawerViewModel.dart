import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter/material.dart';

@immutable
class DrawerViewModel {
  final String headerImage;
  final String headerTitle;
  final String notifHeader;
  final Map<String, bool> subscribingTo;
  final Map<String, Function(bool)> subscribeTo;
  final Map<String, IconData> subscribeIcons; //Icons.notification
  final Map<String, String> thumbImage; //Constants.logoPath
  final Map<String, String> subscribeText;
  final String appName;
  final String aboutText;
  final List<String> aboutBoxText;
  final String aboutEmail;
  final String aboutSubject;
  final IconData aboutIcon;
  final String aboutImage;
  final String newsPage;
  final Function() showNewsPage;
  final String mensPage;
  final Function() showMensPage;
  final String womensPage;
  final Function() showWomensPage;

  DrawerViewModel(
    this.headerImage,
    this.headerTitle,
    this.notifHeader,
    this.subscribingTo,
    this.subscribeTo,
    this.subscribeIcons,
    this.thumbImage,
    this.subscribeText,
    this.appName,
    this.aboutText,
    this.aboutBoxText,
    this.aboutEmail,
    this.aboutSubject,
    this.aboutIcon,
    this.aboutImage,
    this.newsPage,
    this.showNewsPage,
    this.mensPage,
    this.showMensPage,
    this.womensPage,
    this.showWomensPage,
  );

  factory DrawerViewModel.create(Store<AppStore> store) {
    return DrawerViewModel(
      "images/drawer_background2.jpg",
      Constants.title,
      'Notifikationer',
      {'news': store.state.subManager.news},
      {
        'news': (bool value) {
          store.dispatch(SubscribeToNewsNotificationsAction(value));
          store.dispatch(SaveSubscriptionsToPrefsAction());
        }
      },
      {'news': Icons.notifications},
      {'news': Constants.logoPath},
      {'news': "Prenumerera på nyheter"},
      Constants.title,
      'Om appen',
      ['Den här appen är skapad av Tobias Rörstam'],
      'pingvin_app@pimme.org',
      'Pingvin-appen',
      Icons.info,
      Constants.logoPath,
      'Nyheter',
      () {
        store.dispatch(NavigateToAction.push('/'));
      },
      'Herrar',
      () {
        store.dispatch(NavigateToAction.push('/MensTeam'));
      },
      'Damer',
      () {
        store.dispatch(NavigateToAction.push('/WomensTeam'));
      },
    );
  }
}
