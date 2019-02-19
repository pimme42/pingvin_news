import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class PingvinDrawer extends StatefulWidget {
  final DrawerViewModel model;
  PingvinDrawer(this.model);

  @override
  _PingvinDrawerState createState() => _PingvinDrawerState();
}

class _PingvinDrawerState extends State<PingvinDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: ExactAssetImage(widget.model.headerImage)),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    widget.model.headerTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Text(
                    widget.model.notifHeader,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.all(5.0),
                ),
                SwitchListTile(
                  value: widget.model.subscribingTo['news'],
                  onChanged: (bool value) =>
                      widget.model.subscribeTo['news'](value),
                  title: Text(
                    widget.model.subscribeText['news'],
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  secondary: Icon(widget.model.subscribeIcons['news']),
                  inactiveThumbImage:
                      ExactAssetImage(widget.model.thumbImage['news']),
                  inactiveTrackColor: Colors.black26,
                  inactiveThumbColor: Colors.black12,
                  activeThumbImage:
                      ExactAssetImage(widget.model.thumbImage['news']),
                  activeTrackColor: Colors.green[800],
                  activeColor: Colors.white,
                ),
              ],
            ),
          ),
          Card(
            child: AboutListTile(
              applicationIcon: ImageIcon(
                ExactAssetImage(widget.model.aboutImage),
              ),
              child: Text(widget.model.aboutText),
              icon: Icon(widget.model.aboutIcon),
              applicationName: "PRC",
              aboutBoxChildren: _makeAboutBox(widget.model),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _makeAboutBox(DrawerViewModel model) {
    List<Widget> widgets = _makeAboutBoxStrings(model.aboutBoxText);
    widgets.add(
      InkWell(
        child: Text(
          model.aboutEmail,
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () => _launchUrl(
            "mailto:${model.aboutEmail}?subject=${model.aboutSubject}"),
      ),
    );
    return widgets;
  }

  List<Widget> _makeAboutBoxStrings(List<String> texts) {
    List<Widget> widgets = List();
    texts.forEach((String str) => widgets.add(Text(str)));
    return widgets;
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
