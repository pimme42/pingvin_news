import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Pages/PingvinDrawer.dart';
import 'package:pingvin_news/Pages/Models/DrawerViewModel.dart';
import 'package:pingvin_news/Redux/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

@immutable
class NewsPageViewModel {
  final List<NewsPageItemViewModel> items;
  final Function() onRefresh;
  final bool loading;
  final String floatingMsg;
  final bool showWebView;
  final String urlToShow;
  final Function() closeWebView;
  final PingvinDrawer drawer;

  NewsPageViewModel(
      this.items,
      this.onRefresh,
      this.loading,
      this.floatingMsg,
      this.showWebView,
      this.urlToShow,
      this.closeWebView,
      this.drawer);

  factory NewsPageViewModel.create(Store<NewsStore> store) {
    List<NewsPageItemViewModel> items = store.state.paper.entries
        .map(
          (NewsEntry item) => NewsPageItemViewModel(
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
    return NewsPageViewModel(
      items,
          () async {
        store.dispatch(ReadNewsFromRESTAction());
      },
      store.state.status.loading,
      store.state.status.floatMsg,
      store.state.status.urlToShow != Constants.emptyString,
      store.state.status.urlToShow,
          () => store.dispatch(CloseWebViewAction()),
      PingvinDrawer(DrawerViewModel.create(store)),
    );
  }
}

@immutable
class NewsPageItemViewModel {
  final Widget leadingIcon;
  final Function(BuildContext) onPressed;
  final String title;
  final String summary;
  final Function(BuildContext, bool) selectNews;
  final bool selected;

  NewsPageItemViewModel(this.leadingIcon, this.onPressed, this.title, this.summary,
      this.selectNews, this.selected);
}
