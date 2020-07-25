import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/LauncherUtils.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class ContactPage extends StatefulWidget {
  static const String route = '/Contact';
  static const _API_KEY =
      'sk.eyJ1IjoicGltbWUiLCJhIjoiY2p1NGZjM3N4MHVwNTN5cHBnenoyMjhicCJ9.vRHQ1VPRgSsfk2RqtD2A5g';

  @override
  State createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Column(
              children: <Widget>[
                _createContactListTile(
                  Icons.my_location,
                  "Klövervallsvägen, Trelleborg",
                  () => LauncherUtils.openMap(Constants.coordinates.latitude,
                      Constants.coordinates.longitude),
                ),
                Divider(),
//                _createContactListTile(
//                  Icons.phone_android,
//                  "+46 (0)410 103 50",
//                  () => LauncherUtils.call("+4641010350"),
//                ),
//                Divider(),
                _createContactListTile(
                  Icons.web,
                  "pingvin.nu",
                  () => LauncherUtils.launchUrl("http://www.pingvin.nu"),
                ),
              ],
            ),
          ),
          Flexible(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              elevation: 7.0,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  interactive: true,
                  center: Constants.coordinates,
                  zoom: Constants.mapZoom,
                  plugins: [
                    _ActionPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
//                    urlTemplate: "https://api.mapbox.com/v4/"
//                        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    additionalOptions: {
                      'accessToken': ContactPage._API_KEY,
                      'id': 'mapbox.streets',
                    },
                    tileProvider: CachedNetworkTileProvider(),
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 50.0,
                        height: 50.0,
                        point: Constants.coordinates,
                        builder: (ctx) => new Container(
                            child: new GestureDetector(
                          onTap: () => LauncherUtils.openMap(
                              Constants.coordinates.latitude,
                              Constants.coordinates.longitude),
                          child: Constants.logo,
                        )),
//                      Container(
//                            child: Constants.logo,
//                          ),
                      ),
                    ],
                  ),
                  _ActionPluginOptions(
                    text: "Återgå",
                    iconData: Icons.undo,
                    onTap: () => mapController.move(
                        Constants.coordinates, Constants.mapZoom),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  Widget _createContactListTile(
      IconData iconData, String text, Function() onTap) {
    var color = Colors.black;
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        color: color,
      ),
      trailing: Icon(
        Icons.launch,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ActionPluginOptions extends LayerOptions {
  final String text;
  final IconData iconData;
  final Function() onTap;
  _ActionPluginOptions({this.text = "", this.iconData, this.onTap});
}

class _ActionPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is _ActionPluginOptions) {
      var color = Colors.black;
      var style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12.0,
        color: color,
      );
      return Align(
        alignment: Alignment(1, 0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  options.iconData,
                  color: color,
                ),
                onPressed: options.onTap,
              ),
              Text(
                options.text,
                style: style,
              ),
            ],
          ),
        ),
      );
    }
    throw ("Unknown options type for _ActionPlugin, plugin: $options");
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is _ActionPluginOptions;
  }
}
