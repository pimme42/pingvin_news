import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Redux/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'package:redux/redux.dart';
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
      );

  factory DrawerViewModel.create(Store<NewsStore> store) {
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
      'PRC',
      'Om appen',
      ['Den här appen är skapad av Tobias Rörstam'],
      'pingvin_app@pimme.org',
      'Pingvin-appen',
      Icons.info,
      Constants.logoPath,
    );
  }
}
