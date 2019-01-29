import 'package:pingvin_news/misc/Constants.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:url_launcher/url_launcher.dart';

const TIMEOUT = const Duration(seconds: 2);

_getUserApi() async {
  await Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
  var httpClient = new HttpClient();
  var uri = new Uri.http("desktop.rorstam.se:5002", '/news');
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(utf8.decoder).join();
  return responseBody;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.title,
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.black,

        // Define the default Font Family
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          display1: TextStyle(fontSize: 100.0, fontFamily: 'Hind'),
          body2: TextStyle(fontSize: 10.0, fontFamily: 'Hind'),
          body1: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
        ),
      ),
      home: new Splash(),
    );
  }
}

final GlobalKey<AsyncLoaderState> _asyncLoaderState =
    new GlobalKey<AsyncLoaderState>();
var _asyncLoader = new AsyncLoader(
  key: _asyncLoaderState,
  initState: () async => await _getUserApi(),
  renderLoad: () => new LoaderIndicator(),
  renderError: ([error]) => new Text('Sorry, there was an error loading'),
  renderSuccess: ({data}) => new NewsPage(data),
);

class LoaderIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Constants.title),
        leading: Constants.logo,
      ),
      body: new Stack(
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
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _asyncLoader;
  }
}

class NewsPage extends StatefulWidget {
  final String _response;

  NewsPage(this._response);

  @override
  _NewsPageState createState() => new _NewsPageState(_response);
}

class _NewsPageState extends State<NewsPage> {
  List<NewsEntry> _entries;

  _NewsPageState(String response) {
    List responseList = jsonDecode(response)['News'];
    this._entries = List();
    responseList.forEach((dynamic map) {
      this._entries.add(NewsEntry.fromJson(map));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Constants.title),
        leading: Constants.logo,
      ),
      body: ListView.builder(
        itemCount: this._entries.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              leading: IconButton(
                icon: Icon(Icons.link),
                onPressed: () => _LaunchBrowser(this._entries[index].link),
              ),
              title: Text(this._entries[index].title),
              children: <Widget>[
                Text(this._entries[index].summary),
              ],
            ),
          );
        },
      ),
    );
  }

  void _LaunchBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
