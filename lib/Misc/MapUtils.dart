import 'package:pingvin_news/Misc/Log.dart';

import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Log.doLog("MapUtils.openMap couldn't open map", logLevel.ERROR);
    }
  }
}
