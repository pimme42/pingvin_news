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
  final AboutBoxViewModel aboutBoxViewModel;

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
    this.aboutBoxViewModel,
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
          Icons.notifications_none,
          Constants.logoPath,
          "Prenumerera på nyheter",
          Constants.drawerTextStyle,
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
          Constants.drawerPageTextStyle,
          ImageIcon(ExactAssetImage('images/Icons/news-48.png')),
        ),
        DrawerPageViewModel(
          'Herrar',
          () {
            store.dispatch(ViewTeamAction.mens());
            store.dispatch(NavigateToAction.replace('/teamPage'));
          },
          Constants.drawerPageTextStyle,
          "\u{2642}",
        ),
        DrawerPageViewModel(
          'Damer',
          () {
            store.dispatch(ViewTeamAction.womens());
            store.dispatch(NavigateToAction.replace('/teamPage'));
          },
          Constants.drawerPageTextStyle,
          "\u{2640}",
        ),
      ],
      AboutBoxViewModel(
        "Om Appen",
        Icons.info_outline,
        () {
          store.dispatch(NavigateToAction.pop());
          store.dispatch(NavigateToAction.push(Constants.AboutPageRoute));
        },
        Constants.drawerTextStyle,
      ),
    );
  }
}

class DrawerPageViewModel {
  final String text;
  final Function() tap;
  final TextStyle style;
  final dynamic icon;

  DrawerPageViewModel(this.text, this.tap, this.style, this.icon);
}

class DrawerSubscribeItemView {
  final bool subscribingTo;
  final Function(bool) subscribeTo;
  final IconData subscribeIcons; //Icons.notification
  final String thumbImage; //Constants.logoPath
  final String subscribeText;
  final TextStyle style;

  DrawerSubscribeItemView(
    this.subscribingTo,
    this.subscribeTo,
    this.subscribeIcons,
    this.thumbImage,
    this.subscribeText,
    this.style,
  );
}

class AboutBoxViewModel {
  final String cardTitle;
  final IconData cardIcon;
  final Function() onTap;
  final TextStyle style;

  AboutBoxViewModel(
    this.cardTitle,
    this.cardIcon,
    this.onTap,
    this.style,
  );
}
