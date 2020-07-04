import 'package:pingvin_news/Data/FirebaseHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/NotificationDecoder.dart';
import 'package:pingvin_news/Pages/Models/NewsPageModels.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';
import 'package:pingvin_news/Pages/AppBarPage.dart';
import 'package:pingvin_news/Pages/AppDrawer.dart';
import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Pages/WebViewPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NewsPage extends StatelessWidget {
  static const String route = '/NewsPage';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStore, NewsPageViewModel>(
      onInit: (store) {
        store.dispatch(ViewTeamAction.none());
        store.dispatch(ReadNewsFromFileAction());
        store.dispatch(ReadNewsFromRESTAction());
        FirebaseHandler(
          (Map<String, dynamic> message) {
            Log.doLog("onMessage: $message", logLevel.DEBUG);
            Map<String, dynamic> json =
                NotificationDecoder.decodeOnMessage(message);
            store.dispatch(SelectNewsItemAction(json['nid']));
            store.dispatch(ReadNewsFromRESTAction());
            store.dispatch(
                ShowSnackBarAction.message("Pingvin har publicerat en nyhet!"));
          },
          (Map<String, dynamic> message) {
            Log.doLog("onResume: $message", logLevel.DEBUG);
            Map<String, dynamic> json =
                NotificationDecoder.decodeOnResume(message);
            store.dispatch(SelectNewsItemAction(json['nid']));
            store.dispatch(ReadNewsFromRESTAction());
          },
          (Map<String, dynamic> message) {
            Log.doLog("_onLaunch: $message", logLevel.DEBUG);
            Map<String, dynamic> json =
                NotificationDecoder.decodeOnResume(message);
            store.dispatch(SelectNewsItemAction(json['nid']));
            store.dispatch(ReadNewsFromRESTAction());
          },
        );
      },
      converter: (Store<AppStore> store) => NewsPageViewModel.create(store),
      builder: (BuildContext context, NewsPageViewModel viewModel) {
        return WillPopScope(
          //Gör att vi kan ändra tillbaka-knappens beteende
          onWillPop: () async {
            if (viewModel.showWebView) {
              viewModel.closeWebView();
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBarPage(),
            drawer: AppDrawer(),
            body: new IconTheme(
              data: new IconThemeData(color: Theme.of(context).accentColor),
              child: RefreshIndicator(
                onRefresh: viewModel.onRefresh,
                displacement: 50.0,
                color: Colors.black,
                child: viewModel.showWebView
                    ? _displayWebPage(context, viewModel)
                    : _displayNewsList(context, viewModel),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _displayNewsList(BuildContext context, NewsPageViewModel viewModel) {
    if (viewModel.items.length > 0) {
      return ListView(
          padding: EdgeInsets.all(5.0),
          children: viewModel.items.reversed
              .map((NewsPageItemViewModel item) =>
                  _createListItemWidget(item, context))
              .toList());
    } else {
      return ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text("Inga nyheter laddade"),
              subtitle: Text("Tryck här för att ladda nyheter"),
              leading: IconButton(
                  icon: Icon(Icons.autorenew), onPressed: viewModel.onRefresh),
              onTap: viewModel.onRefresh,
            ),
          )
        ],
      );
    }
  }

  Widget _displayWebPage(BuildContext context, NewsPageViewModel viewModel) {
    return WebViewPage(viewModel.urlToShow);
  }

  Widget _createListItemWidget(
          NewsPageItemViewModel item, BuildContext context) =>
      Card(
        color: item.bgColor,
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: item.fgColor,
            accentColor: item.fgColor,
          ),
          child: ExpansionTile(
            key: ObjectKey(item.summary),
            backgroundColor: item.bgColor,
            onExpansionChanged: (bool opening) =>
                item.selectNews(context, opening),
            initiallyExpanded: item.selected,
            leading: IconButton(
              icon: item.leadingIcon,
              onPressed: () => item.onPressed(context),
            ),
            title: Text(
              item.title,
              style: TextStyle(color: item.fgColor),
            ),
            children: <Widget>[
              Container(
//                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () => item.onURLPressed(context),
                    child: Text(
                      "Nyheten hämtad från ${item.URL}",
                      style: TextStyle(
                        color: item.fgColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      item.summary,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                onTap: () => item.onPressed(context),
              ),
            ],
          ),
        ),
      );
}
