import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

enum teams { MENS, WOMENS, NONE }

class Constants {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

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

  static const String apiVersion = "/api/v2";

  static const String apiURL =
      isProduction ? "pingvinapi.rorstam.se" : "pingvinapid.rorstam.se";
//  static const String apiURL = "pingvinapi.rorstam.se";

  static const String newsEndPoint = apiVersion + "/news/168643/";

  static const String newsFile = '/news.json';

  static const String tableEndPoint = apiVersion + '/tables/league/';

  static const String fixtureEndPoint = apiVersion + '/fixtures/league/';

  static const Map<teams, String> teamEndPoints = {
    teams.MENS: apiVersion + '/tables/search/herr/pingvin/',
    teams.WOMENS: apiVersion + '/tables/search/dam/pingvin/',
  };

  static const Map<teams, String> leaguePaths = {
    teams.MENS: '/mens.json',
    teams.WOMENS: '/womens.json',
  };

  static const Duration standardSnackBarDuration = Duration(seconds: 2);

  static const String emptyString = "";

//  static const bool useHttps = isProduction;
  static const bool useHttps = true;

  static const TextStyle drawerTextStyle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

  static const TextStyle drawerPageTextStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);

  static const String teamPageRoute = '/TeamPage';

  static const double maxWidth = 500.0; // Max width for tables/fixture list

  static const String contactRoute = '/contact';

  static LatLng coordinates = LatLng(55.375460, 13.185478);
}
