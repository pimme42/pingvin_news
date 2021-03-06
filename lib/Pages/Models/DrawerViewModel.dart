import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Pages/AboutPage.dart';
import 'package:pingvin_news/Pages/NewsPage.dart';
import 'package:pingvin_news/Pages/TeamPage.dart';
import 'package:pingvin_news/Pages/ContactPage.dart';

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

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
  final DrawerPageViewModel aboutBoxViewModel;

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
          (BuildContext context) {
            ///This pops the Drawer and navigates to the page
            store.dispatch(ViewTeamAction.none());
            Navigator.of(context).pushReplacementNamed(NewsPage.route);
          },
          Constants.drawerPageTextStyle,
          "\u{1F5DE}",
        ),
        DrawerPageViewModel(
          'Herrar',
          (BuildContext context) {
            store.dispatch(ViewTeamAction.mens());
            Navigator.of(context).pushReplacementNamed(TeamPage.route);
          },
          Constants.drawerPageTextStyle,
          "\u{2642}",
        ),
        DrawerPageViewModel(
          'Damer',
          (BuildContext context) {
            store.dispatch(ViewTeamAction.womens());
            Navigator.of(context).pushReplacementNamed(TeamPage.route);
          },
          Constants.drawerPageTextStyle,
          "\u{2640}",
        ),
        DrawerPageViewModel(
          'Kontakt/Hitta oss',
          (BuildContext context) {
            store.dispatch(ViewTeamAction.none());
            Navigator.of(context).pushReplacementNamed(ContactPage.route);
          },
          Constants.drawerPageTextStyle,
          Icon(Icons.map),
        ),
      ],
      DrawerPageViewModel(
        "Om Appen",
        (BuildContext context) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AboutPage(store),
          );
        },
        Constants.drawerTextStyle,
        Icons.info_outline,
      ),
    );
  }
}

class DrawerPageViewModel {
  final String text;
  final Function(BuildContext context) tap;
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
