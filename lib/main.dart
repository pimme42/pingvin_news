import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Middleware.dart';
import 'package:pingvin_news/Redux/News/Middleware.dart';
import 'package:pingvin_news/Redux/AppState/Reducers.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Redux/Teams/Middleware.dart';
import 'package:pingvin_news/Pages/NewsPage.dart';
import 'package:pingvin_news/Pages/TeamPage.dart';
import 'package:pingvin_news/Pages/SyncErrorProvider.dart';
import 'package:pingvin_news/Pages/ContactPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Store<AppStore> store = Store<AppStore>(
    appReducer,
    initialState: AppStore.initial(),
    middleware: appStoreMiddleware()
      ..addAll(newsStoreMiddleware())
      ..addAll(teamStateMiddleware()),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
//        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define the default Brightness and Colors
          brightness: Brightness.light,
          primaryColor: Colors.white,
//          accentColor: FlavorConfig.instance.color,
          accentColor: Colors.black,

          // Define the default Font Family
          fontFamily: 'Montserrat',

          iconTheme: IconThemeData(size: 30.0),

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline5: TextStyle(fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            headline4: TextStyle(fontSize: 30.0, fontFamily: 'Hind'),
            bodyText2: TextStyle(fontSize: 10.0, fontFamily: 'Hind'),
            bodyText1: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
          ),
        ),
//        initialRoute: '/',
//        routes: <String, WidgetBuilder>{
//          '/': (BuildContext context) => _makePage(NewsPage()),
//          '/TeamPage': (BuildContext context) => _makePage(TeamPage()),
//        },
        onGenerateRoute: _getRoute,
//        navigatorKey: NavigatorHolder.navigatorKey,
//        home: _makePage(NewsPage()),
      );

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case NewsPage.route:
//        return _buildRoute(settings, ContactPage());
        return _buildRoute(settings, NewsPage());
      case TeamPage.route:
        return _buildRoute(settings, TeamPage());
      case ContactPage.route:
        return _buildRoute(settings, ContactPage());
      default:
        return _buildRoute(settings, NewsPage());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget child) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => _makePage(child),
    );
  }

  Widget _makePage(Widget child) {
    return StoreProvider(
      store: this.store,
      child: SyncErrorProvider(
        errors: this.store.state.status.snackBarItems?.stream,
        child: Scaffold(
          body: _Page(child: child),
        ),
      ),
    );
  }
}

/// _Page is a helper Class that allows us to display SnackBars.
/// It listens to a Stream of ShowSnackBarAction's and displays them as they
/// are added to the stream

class _Page extends StatefulWidget {
  final Widget child;

  _Page({@required this.child}) : assert(child != null);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<_Page> {
  StreamSubscription _errorsSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_errorsSubscription == null) {
      _errorsSubscription = SyncErrorProvider.of(context)
          .errors
          ?.listen((ShowSnackBarAction action) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              action.msg.toString(),
            ),
            action: action.action,
            duration: action.duration,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _errorsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }
}
