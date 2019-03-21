import 'package:pingvin_news/Misc/Log.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHandler {
  FirebaseMessaging _firebaseMessaging;
  Function(Map<String, dynamic>) _onMessage;
  Function(Map<String, dynamic>) _onResume;
  Function(Map<String, dynamic>) _onLaunch;

  FirebaseHandler(onM, onR, onL)
      : _onMessage = onM,
        _onResume = onR,
        _onLaunch = onL {
    _firebaseMessaging = new FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) => this._onMessage(message),
      onResume: (Map<String, dynamic> message) => this._onResume(message),
      onLaunch: (Map<String, dynamic> message) => this._onLaunch(message),
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      Log.doLog("Settings registered: $settings", logLevel.DEBUG);
    });
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((token) {
      Log.doLog("FirebaseMessaging Token: $token", logLevel.DEBUG);
    });
  }
}
