import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/FirebaseHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/NotificationDecoder.dart';

import 'package:pingvin_news/Redux/Actions.dart';

import 'package:pingvin_news/Store/NewsStore.dart';

import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:pingvin_news/Pages/WebViewPage.dart';
import 'package:pingvin_news/Pages/LoadIndicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<NewsStore, _ViewModel>(
      onInit: (store) {
        store.dispatch(ReadSubscriptionsFromPrefsAction());
        store.dispatch(ReadNewsFromFileAction());
        store.dispatch(ReadNewsFromRESTAction());
        FirebaseHandler(
          (Map<String, dynamic> message) {
            Log.doLog("onMessage: $message", logLevel.DEBUG);
            Map<String, dynamic> json =
                NotificationDecoder.decodeOnMessage(message);
            store.dispatch(SelectNewsItemAction(json['nid']));
            store.dispatch(ReadNewsFromRESTAction());
            store.dispatch(NewNewsItemNotificationAction(
                "Pingvin har publicerat en nyhet!"));
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
      converter: (Store<NewsStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) {
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
            appBar: new AppBar(
              title: new Text(Constants.title),
              automaticallyImplyLeading: true,
              leading: _displayLeading(context, viewModel),
              actions: _displayAppBarActions(context, viewModel),
            ),
            drawer: _displayDrawer(context, viewModel),
            body: new IconTheme(
              data: new IconThemeData(color: Theme.of(context).accentColor),
              child: RefreshIndicator(
                onRefresh: viewModel.onRefresh,
                displacement: 50.0,
                color: Colors.black,
                child: Stack(
                  children: <Widget>[
                    viewModel.showWebView
                        ? _displayWebPage(context, viewModel)
                        : _displayListView(context, viewModel),
                    _displayFloatingMessage(context, viewModel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _displayListView(BuildContext context, _ViewModel viewModel) {
    if (viewModel.items.length > 0) {
      return ListView(
          padding: EdgeInsets.all(5.0),
          children: viewModel.items.reversed
              .map((_NewsItemViewModel item) =>
                  _createListItemWidget(item, context))
              .toList());
    } else {
      return Positioned(
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text("Inga nyheter laddade"),
                subtitle: Text("Tryck här för att ladda nyheter"),
                leading: IconButton(
                    icon: Icon(Icons.autorenew),
                    onPressed: viewModel.onRefresh),
                onTap: viewModel.onRefresh,
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _displayWebPage(BuildContext context, _ViewModel viewModel) {
    return WebViewPage(viewModel.urlToShow);
  }

  Widget _displayLeading(BuildContext context, _ViewModel viewModel) {
    if (viewModel.showWebView)
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => viewModel.closeWebView(),
      );
    return null;
  }

  List<Widget> _displayAppBarActions(
      BuildContext context, _ViewModel viewModel) {
    return <Widget>[
      Padding(
        child: viewModel.loading
            ? LoadIndicator()
            : Transform(
                origin: Offset(IconTheme.of(context).size / 2,
                    IconTheme.of(context).size / 2),
                transform: Matrix4.skewX(-0.0),
                child: ImageIcon(
                  ExactAssetImage(Constants.logoPathEllipse),
                ),
              ),
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      ),
    ];
  }

  Widget _displayFloatingMessage(BuildContext context, _ViewModel viewModel) {
    if (viewModel.floatingMsg != Constants.emptyString) {
      return Positioned(
        child: Center(
            child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.black54,
          ),
          child: Text(
            viewModel.floatingMsg,
            style: TextStyle(color: Colors.white),
          ),
        )),
        width: MediaQuery.of(context).size.width,
        bottom: 50,
      );
    }
    return Container();
  }

  Widget _displayDrawer(BuildContext context, _ViewModel viewModel) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: ExactAssetImage("images/drawer_background2.jpg")),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    Constants.title,
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
          SwitchListTile(
            value: viewModel.subscribingToNews,
            onChanged: (bool value) => viewModel.subscribeToNews(value),
            title: Text(
              "Prenumerera på nyheter",
              style: TextStyle(fontSize: 12.0),
            ),
            secondary: Icon(Icons.notifications),
            inactiveThumbImage: ExactAssetImage(Constants.logoPath),
            inactiveTrackColor: Colors.black26,
            inactiveThumbColor: Colors.black12,
            activeThumbImage: ExactAssetImage(Constants.logoPath),
            activeTrackColor: Colors.green[800],
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _createListItemWidget(_NewsItemViewModel item, BuildContext context) =>
      Card(
        child: ExpansionTile(
          key: ObjectKey(item.summary),
          onExpansionChanged: (bool opening) =>
              item.selectNews(context, opening),
          initiallyExpanded: item.selected,
          leading: IconButton(
            icon: item.leadingIcon,
            onPressed: () => item.onPressed(context),
          ),
          title: Text(item.title),
          children: <Widget>[
            InkWell(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(item.summary),
                ),
              ),
              onTap: () => item.onPressed(context),
            ),
          ],
        ),
      );
}

@immutable
class _ViewModel {
  final List<_NewsItemViewModel> items;
  final Function() onRefresh;
  final bool loading;
  final String floatingMsg;
  final bool showWebView;
  final String urlToShow;
  final Function() closeWebView;
  final bool subscribingToNews;
  final Function(bool) subscribeToNews;

  _ViewModel(
      this.items,
      this.onRefresh,
      this.loading,
      this.floatingMsg,
      this.showWebView,
      this.urlToShow,
      this.closeWebView,
      this.subscribingToNews,
      this.subscribeToNews);

  factory _ViewModel.create(Store<NewsStore> store) {
    List<_NewsItemViewModel> items = store.state.paper.entries
        .map(
          (NewsEntry item) => _NewsItemViewModel(
                Icon(Icons.web),
                (BuildContext context) {
                  store.dispatch(SelectUrlToShowAction(item.link));
                },
                item.title,
                item.summary,
                (BuildContext context, bool opening) {
                  if (opening)
                    store.dispatch(SelectNewsItemAction(item.nid));
                  else
                    store.dispatch(DeSelectNewsItemAction(item.nid));
                },
                store.state.status.isNewsItemSelected(item.nid),
              ),
        )
        .toList();
    return _ViewModel(
      items,
      () async {
        store.dispatch(ReadNewsFromRESTAction());
      },
      store.state.status.loading,
      store.state.status.floatMsg,
      store.state.status.urlToShow != Constants.emptyString,
      store.state.status.urlToShow,
      () => store.dispatch(CloseWebViewAction()),
      store.state.subManager.news,
      (bool value) {
        store.dispatch(SubscribeToNewsNotificationsAction(value));
        store.dispatch(SaveSubscriptionsToPrefsAction());
      },
    );
  }
}

@immutable
class _NewsItemViewModel {
  final Widget leadingIcon;
  final Function(BuildContext) onPressed;
  final String title;
  final String summary;
  final Function(BuildContext, bool) selectNews;
  final bool selected;

  _NewsItemViewModel(this.leadingIcon, this.onPressed, this.title, this.summary,
      this.selectNews, this.selected);
}
