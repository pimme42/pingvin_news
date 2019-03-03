import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/News/NewsEntry.dart';

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

  NewsPageViewModel(this.items, this.onRefresh, this.loading, this.floatingMsg,
      this.showWebView, this.urlToShow, this.closeWebView);

  factory NewsPageViewModel.create(Store<AppStore> store) {
    List<NewsPageItemViewModel> items = store.state.newsStore.paper.entries
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
                store.state.newsStore.newsStatus.isNewsItemSelected(item.nid),
              ),
        )
        .toList();
    return NewsPageViewModel(
      items,
      () async {
        store.dispatch(ReadNewsFromRESTAction());
      },
      store.state.status.loading > 0,
      store.state.status.floatMsg,
      store.state.newsStore.newsStatus.urlToShow != Constants.emptyString,
      store.state.newsStore.newsStatus.urlToShow,
      () => store.dispatch(CloseWebViewAction()),
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

  NewsPageItemViewModel(this.leadingIcon, this.onPressed, this.title,
      this.summary, this.selectNews, this.selected);
}
