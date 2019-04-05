import 'package:pingvin_news/Store/AppState/SharedPrefs.dart';

import 'package:pingvin_news/Misc/Constants.dart';
import 'package:flutter/material.dart';

class StartLoadingAction {}

class StopLoadingAction {}

class ShowSnackBarAction {
  final String msg;
  final SnackBarAction action;
  final Duration duration;

  ShowSnackBarAction(
    this.msg,
    this.action,
    this.duration,
  );

  factory ShowSnackBarAction.message(String msg) => ShowSnackBarAction(
        msg,
        null,
        Constants.standardSnackBarDuration,
      );
}
//
//class CouldNotReadRESTAction extends ShowSnackBarAction {
//  CouldNotReadRESTAction(String msg) : super(msg);
//}
//
//class NewNewsItemNotificationAction extends ShowSnackBarAction {
//  NewNewsItemNotificationAction(String msg) : super(msg);
//}

// Actions on SubscriptionsManager

abstract class SubscribeToNotificationAction {
  final bool value;
  SubscribeToNotificationAction(this.value);
}

class SubscribeToNewsNotificationsAction extends SubscribeToNotificationAction {
  SubscribeToNewsNotificationsAction(bool value) : super(value);
}

class SubscribeToMensNotificationsAction extends SubscribeToNotificationAction {
  SubscribeToMensNotificationsAction(bool value) : super(value);
}

class SubscribeToWomensNotificationsAction
    extends SubscribeToNotificationAction {
  SubscribeToWomensNotificationsAction(bool value) : super(value);
}

class ReadSubscriptionsFromPrefsAction {}

class SaveSubscriptionsToPrefsAction {}

class UpdateVersionInfoAction {}

class SetVersionInfoAction {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  SetVersionInfoAction(
      this.appName, this.packageName, this.version, this.buildNumber);
}

/// Actions on SharedPrefs

class ReadSharedPrefs {}

class PopulateSharedPrefs {
  SharedPrefs sharedPrefs;
  PopulateSharedPrefs(this.sharedPrefs);
}

class ToggleFavouriteLeague {
  final String leagueName;

  ToggleFavouriteLeague(this.leagueName);
}

//class AddLeagueToFavourite {
//  final String leagueName;
//
//  AddLeagueToFavourite(this.leagueName);
//}
//
//class RemoveLeagueToFavourite {
//  final String leagueName;
//
//  RemoveLeagueToFavourite(this.leagueName);
//}
