import 'package:pingvin_news/Store/AppState/AppStore.dart';
import 'package:pingvin_news/Store/News/NewsStore.dart';
import 'package:pingvin_news/Store/News/NewsStatus.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Redux/News/Actions.dart';

import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

@immutable
class AppBarViewModel {
  final String title;
  final bool loading;
  final bool showWebView;
  final Function() closeWebView;

  AppBarViewModel({
    this.title,
    this.loading,
    this.showWebView,
    this.closeWebView,
  });

  factory AppBarViewModel.create(Store<AppStore> store) {
    return AppBarViewModel(
      title: Constants.title,
      loading: store.state.status.loading > 0,
      showWebView:
          store.state.newsStore.newsStatus.urlToShow != Constants.emptyString,
      closeWebView: () => store.dispatch(CloseWebViewAction()),
    );
  }
}
