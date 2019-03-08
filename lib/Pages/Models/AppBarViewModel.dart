import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

@immutable
class AppBarViewModel {
  final String title;
  final bool loading;
  final bool showWebView;
  final Function() closeWebView;
  final bool showPopButton;
  final Function() pop;

  AppBarViewModel({
    this.title,
    this.loading,
    this.showWebView,
    this.closeWebView,
    this.showPopButton,
    this.pop,
  });

  factory AppBarViewModel.create(Store<AppStore> store) {
    return AppBarViewModel(
      title: Constants.title,
      loading: store.state.status.loading > 0,
      showWebView:
          store.state.newsStore.newsStatus.urlToShow != Constants.emptyString,
      closeWebView: () => store.dispatch(CloseWebViewAction()),
      showPopButton: false,
      pop: () {
        store.dispatch(NavigateToAction.pop());
      },
    );
  }
}
