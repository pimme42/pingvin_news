import 'package:flutter/material.dart';

class Constants {
  static String logoPath = "images/pingvinlogo.png";

  static Widget logo = new Padding(
    padding: EdgeInsets.all(5.0),
    child: new Image(
      image: new AssetImage('images/pingvinlogo.png'),
    ),
  );

  static Widget logoAction = new Padding(
    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
    child: Constants.logo,
  );

  static String title = 'Pingvin News';
}
