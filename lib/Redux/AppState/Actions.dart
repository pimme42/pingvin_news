import 'package:pingvin_news/Misc/Constants.dart';
import 'package:flutter/material.dart';

class StartLoadingAction {}

class StopLoadingAction {}

abstract class ShowSnackBarAction {
  final String msg;
  final SnackBarAction action;
  final Duration duration;
  ShowSnackBarAction(this.msg,
      {this.action = null, this.duration = Constants.standardSnackBarDuration});
}

class CouldNotReadRESTAction extends ShowSnackBarAction {
  CouldNotReadRESTAction(String msg) : super(msg);
}

class NewNewsItemNotificationAction extends ShowSnackBarAction {
  NewNewsItemNotificationAction(String msg) : super(msg);
}

// Actions on SubscriptionsManager

abstract class SubscribeToNotificationAction {
  bool value;
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
