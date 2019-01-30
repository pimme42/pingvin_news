import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Redux/Middleware.dart';
import 'package:pingvin_news/Redux/Reducers.dart';

import 'package:pingvin_news/Pages/NewsPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Store<NewsStore> store = Store<NewsStore>(
    newsReducer,
    initialState: NewsStore.initial(),
    middleware: createStoreMiddleware(),

  );

  @override
  Widget build(BuildContext context) => StoreProvider(
        store: this.store,
        child: MaterialApp(
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
          routes: <String, WidgetBuilder>{
//        '/ProjectPage': (BuildContext context) => ProjectPage(),
//        '/PartPage': (BuildContext context) => PartPage(),
          },
          navigatorKey: navigatorKey,
          home: NewsPage(),
        ),
      );
}
