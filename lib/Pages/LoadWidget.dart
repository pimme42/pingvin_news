import 'package:pingvin_news/Misc/Constants.dart';

import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(Constants.logoPath),
              fit: BoxFit.contain,
            ),
          ),
          margin: EdgeInsets.all(10.0),
        ),
        new Center(
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
        ),
      ],
    );
  }
}
