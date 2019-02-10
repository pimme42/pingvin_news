import 'package:flutter/material.dart';

class Constants {
  static String logoPath = "images/pingvinlogo_transp.png";
  static String logoPathEllipse = "images/pingvinlogo_transp_with_ellipse.png";

  static Widget logo = new Padding(
    padding: EdgeInsets.all(5.0),
    child: new Image(
      image: new AssetImage(Constants.logoPath),
    ),
  );

  static String title = 'Pingvin Rugby Club';

  static String dataURL = "pingvin.rorstam.se";

  static String dataEntry = "/news/168643/";

  static Duration floatingMessageDuration = Duration(seconds: 2);

  static String emptyString = "";
}
