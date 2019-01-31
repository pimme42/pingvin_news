import 'package:pingvin_news/Misc/Constants.dart';

import 'package:pingvin_news/Redux/Actions.dart';

import 'package:pingvin_news/Store/NewsStore.dart';

import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:pingvin_news/Pages/WebViewPage.dart';
import 'package:pingvin_news/Pages/LoadIndicator.dart';

import 'package:progress_indicators/progress_indicators.dart';

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
//            store.dispatch(ReadNewsFromRESTAction());
      },
      converter: (Store<NewsStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text(Constants.title),
            automaticallyImplyLeading: true,
            actions: <Widget>[
              viewModel.loading ? LoadIndicator() : Container(),
              Constants.logoAction,
            ],
          ),
          body: new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: RefreshIndicator(
              onRefresh: viewModel.onRefresh,
              child: ListView(
                  padding: EdgeInsets.all(5.0),
                  children: viewModel.items.reversed
                      .map((_NewsItemViewModel item) =>
                          _createListItemWidget(item, context))
                      .toList()),
            ),
          ),
        );
      },
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
            Container(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(item.summary),
              ),
            ),
          ],
        ),
      );
}

class _ViewModel {
  final List<_NewsItemViewModel> items;
  final Function() onRefresh;
  final bool loading;

  _ViewModel(this.items, this.onRefresh, this.loading);

  factory _ViewModel.create(Store<NewsStore> store) {
    List<_NewsItemViewModel> items = store.state.paper.entries
        .map(
          (NewsEntry item) => _NewsItemViewModel(
                Icon(Icons.web),
                (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(item.link),
                    ),
                  );
                },
                item.title,
                item.summary,
                (BuildContext context, bool opening) {
                  if (opening)
                    store.dispatch(SelectNewsItemAction(item.nid));
                  else
                    store.dispatch(DeSelectNewsItemAction(item.nid));
                },
                store.state.status.newsItemSelected(item.nid),
              ),
        )
        .toList();
    return _ViewModel(
      items,
      () async => store.dispatch(ReadNewsFromRESTAction()),
      store.state.status.loading,
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
