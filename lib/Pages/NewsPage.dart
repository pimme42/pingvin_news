import 'package:pingvin_news/Misc/Constants.dart';

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
        store.dispatch(ReadNewsFromFileAction());
        store.dispatch(ReadNewsFromRESTAction());
      },
      converter: (Store<NewsStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text(Constants.title),
            automaticallyImplyLeading: true,
            leading: _displayLeading(context, viewModel),
            actions: _displayAppBarActions(context, viewModel),
          ),
          body: new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: RefreshIndicator(
              onRefresh: viewModel.onRefresh,
              child: Stack(
                children: <Widget>[
                  viewModel.showWebView
                      ? _displayWebPage(context, viewModel)
                      : _displayListView(context, viewModel),
                  _displayErrorMessage(context, viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _displayListView(BuildContext context, _ViewModel viewModel) {
    return ListView(
        padding: EdgeInsets.all(5.0),
        children: viewModel.items.reversed
            .map((_NewsItemViewModel item) =>
                _createListItemWidget(item, context))
            .toList());
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
    return Container();
  }

  List<Widget> _displayAppBarActions(BuildContext context, _ViewModel viewModel) {
    return <Widget>[
      Padding(
        child: viewModel.loading ? LoadIndicator() : Container(),
        padding: EdgeInsets.all(5.0),
      ),
      Constants.logoAction,
    ];
  }

  Widget _displayErrorMessage(BuildContext context, _ViewModel viewModel) {
    if (viewModel.errorMsg != Constants.emptyString) {
      return Positioned(
        child: Center(
            child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.black54,
          ),
          child: Text(
            viewModel.errorMsg,
            style: TextStyle(color: Colors.white),
          ),
        )),
        width: MediaQuery.of(context).size.width,
        bottom: 5,
      );
    }
    return Container();
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
  final String errorMsg;
  final bool showWebView;
  final String urlToShow;
  final Function() closeWebView;

  _ViewModel(this.items, this.onRefresh, this.loading, this.errorMsg,
      this.showWebView, this.urlToShow, this.closeWebView);

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
      store.state.status.errorMsg,
      store.state.status.urlToShow != Constants.emptyString,
      store.state.status.urlToShow,
      () => store.dispatch(CloseWebViewAction()),
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
