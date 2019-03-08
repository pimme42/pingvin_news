import 'package:flutter/material.dart';

enum teams { MENS, WOMENS, NONE }

class Constants {
  static const String logoPath = "images/pingvinlogo_transp.png";
  static const String logoPathEllipse =
      "images/pingvinlogo_transp_with_ellipse.png";

  static Widget logo = new Padding(
    padding: EdgeInsets.all(5.0),
    child: new Image(
      image: new AssetImage(Constants.logoPath),
    ),
  );

  static const String title = 'Pingvin Rugby Club';

  static const String apiURL = "pingvinapi.rorstam.se";

  static const String newsEndPoint = "/news/168643/";

  static const String newsFile = '/news.json';

  static const Map<teams, String> teamEndPoints = {
    teams.MENS: '/tables/current/team/mens',
    teams.WOMENS: '/tables/current/team/womens',
  };

  static const Map<teams, String> teamFiles = {
    teams.MENS: '/mens.json',
    teams.WOMENS: '/womens.json',
  };

  static const Duration standardSnackBarDuration = Duration(seconds: 2);

  static const String emptyString = "";

  static const bool useHttps = true;

  static const TextStyle drawerTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  static const TextStyle drawerPageTextStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
}
