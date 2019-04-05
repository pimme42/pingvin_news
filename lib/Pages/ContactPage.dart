import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/MapUtils.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';

class ContactPage extends StatefulWidget {
  final API_KEY =
      'sk.eyJ1IjoicGltbWUiLCJhIjoiY2p1NGZjM3N4MHVwNTN5cHBnenoyMjhicCJ9.vRHQ1VPRgSsfk2RqtD2A5g';

  @override
  State createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: Constants.coordinates,
                zoom: 15.0,
                onTap: (LatLng coord) => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Vill du öppna kartan i google maps?"),
                        duration: Duration(seconds: 5),
                        action: SnackBarAction(
                          label: "Ja",
                          textColor: Colors.white,
                          disabledTextColor: Colors.black,
                          onPressed: () => MapUtils.openMap(
                              Constants.coordinates.latitude,
                              Constants.coordinates.longitude),
                        ),
                      ),
                    ),
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://api.mapbox.com/v4/"
                      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                  additionalOptions: {
                    'accessToken': widget.API_KEY,
                    'id': 'mapbox.streets',
                  },
                ),
//              TileLayerOptions(
//                  urlTemplate:
//                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                  subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: Constants.coordinates,
                    builder: (ctx) => Container(
                          child: Constants.logo,
                        ),
                  ),
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//        Location(55.375460, 13.185478),
  }
}
