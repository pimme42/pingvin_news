import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/FirebaseHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Misc/NotificationDecoder.dart';
import 'package:pingvin_news/Pages/Models/NewsPageModels.dart';
import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Redux/AppState/Actions.dart';

import 'package:pingvin_news/Store/AppState/AppStore.dart';

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
    return StoreConnector<AppStore, NewsPageViewModel>(
      onInitialBuild: (NewsPageViewModel model) => model.floatingMsg.length > 0
          ? Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(model.floatingMsg),
              ),
            )
          : null,
      onInit: (store) {
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
            appBar: new AppBar(
              title: new Text(Constants.title),
              automaticallyImplyLeading: true,
              leading: _displayLeading(context, viewModel),
              actions: _displayAppBarActions(context, viewModel),
            ),
            drawer: viewModel.drawer,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _displayListView(BuildContext context, NewsPageViewModel viewModel) {
    if (viewModel.items.length > 0) {
      return ListView(
          padding: EdgeInsets.all(5.0),
          children: viewModel.items.reversed
              .map((NewsPageItemViewModel item) =>
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

  Widget _displayWebPage(BuildContext context, NewsPageViewModel viewModel) {
    return WebViewPage(viewModel.urlToShow);
  }

  Widget _displayLeading(BuildContext context, NewsPageViewModel viewModel) {
    if (viewModel.showWebView)
      return IconButton(
        icon: Icon(Icons.close),
        onPressed: () => viewModel.closeWebView(),
      );
    return null;
  }

  List<Widget> _displayAppBarActions(
      BuildContext context, NewsPageViewModel viewModel) {
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

  Widget _createListItemWidget(
          NewsPageItemViewModel item, BuildContext context) =>
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
