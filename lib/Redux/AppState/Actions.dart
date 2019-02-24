class StartLoadingAction {}

class StopLoadingAction {}

abstract class ShowFloatingMessageAction {
  final String msg;
  ShowFloatingMessageAction(this.msg);
}

class CouldNotReadRESTAction extends ShowFloatingMessageAction {
  CouldNotReadRESTAction(String msg) : super(msg);
}

class NewNewsItemNotificationAction extends ShowFloatingMessageAction {
  NewNewsItemNotificationAction(String msg) : super(msg);
}

class FloatMessageShownAction {}

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
