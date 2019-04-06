import 'package:pingvin_news/Misc/Log.dart';

import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<bool> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    return _launch(googleUrl);
  }

  static Future<bool> call(String phoneNumber) async {
    String phoneUri = "tel://$phoneNumber";
    return _launch(phoneUri);
  }

  static Future<bool> launchUrl(String url) async {
    return _launch(url);
  }

  static Future<bool> _launch(String uri) async {
    if (await canLaunch(uri)) {
      await launch(uri);
      return true;
    } else {
      Log.doLog("MapUtils._launch couldn't launch $uri", logLevel.ERROR);
      return false;
    }
  }
}
