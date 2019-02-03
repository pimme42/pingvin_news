import 'package:flutter/material.dart';

class Constants {
  static String logoPath = "images/pingvinlogo_transp.png";

  static Widget logo = new Padding(
    padding: EdgeInsets.all(5.0),
    child: new Image(
      image: new AssetImage(Constants.logoPath),
    ),
  );

  static Widget logoAction = new Padding(
    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
    child: Constants.logo,
  );

  static String title = 'Pingvin News';

  static String dataURL = "desktop.rorstam.se:5002";

  static String dataEntry = "/news";

  static Duration floatingMessageDuration = Duration(seconds: 2);

  static String emptyString = "";
}
