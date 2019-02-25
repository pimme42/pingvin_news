import 'package:flutter/material.dart';

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

  static const String dataURL = "pingvinapi.rorstam.se";

  static const String dataEntry = "/news/168643/";

  static const Duration standardSnackBarDuration = Duration(seconds: 2);

  static const String emptyString = "";

  static const bool useHttps = true;
}
