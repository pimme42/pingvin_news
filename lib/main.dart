import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/AppState/Middleware.dart';
import 'package:pingvin_news/Redux/News/Middleware.dart';
import 'package:pingvin_news/Redux/AppState/Reducers.dart';
import 'package:pingvin_news/Redux/Teams/Middleware.dart';

import 'package:pingvin_news/Pages/NewsPage.dart';
import 'package:pingvin_news/Pages/TeamPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

//void navigationMiddleware(
//  Store<int> store,
//  dynamic action,
//  NextDispatcher next,
//) {
//  next(action);
//
//  if (action is NavigateAction) {
//    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
//      return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("New Route"),
//        ),
//      );
//    }));
//  }
//}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Store<AppStore> store = Store<AppStore>(
    appReducer,
    initialState: AppStore.initial(),
    middleware: [NavigationMiddleware<AppStore>()]
      ..addAll(appStoreMiddleware())
      ..addAll(newsStoreMiddleware())
      ..addAll(teamStateMiddleware()),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          // Define the default Brightness and Colors
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.black,

          // Define the default Font Family
          fontFamily: 'Montserrat',

          iconTheme: IconThemeData(size: 30.0),

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            display1: TextStyle(fontSize: 30.0, fontFamily: 'Hind'),
            body2: TextStyle(fontSize: 10.0, fontFamily: 'Hind'),
            body1: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
          ),
        ),
//        initialRoute: '/',
//        routes: <String, WidgetBuilder>{
//          '/': (BuildContext context) => _makePage(NewsPage()),
//          '/TeamPage': (BuildContext context) => _makePage(TeamPage()),
//        },
        onGenerateRoute: _getRoute,
        navigatorKey: NavigatorHolder.navigatorKey,
//        home: _makePage(NewsPage()),
      );

  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(settings, NewsPage());
      case '/MensTeam':
      case '/WomensTeam':
        return _buildRoute(settings, TeamPage());
      default:
        return _buildRoute(settings, NewsPage());
    }
  }

  Widget _makePage(Widget Page) {
    return StoreProvider(
      store: this.store,
      child: Scaffold(
        body: Page,
      ),
    );
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => _makePage(builder),
    );
  }
}
