import 'package:pingvin_news/Redux/Actions.dart';
import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Store/Status.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

import 'package:redux/redux.dart';
import 'package:quiver/time.dart';

NewsStore newsReducer(NewsStore state, action) => NewsStore(
      entryReducer(state.paper, action),
      statusReducer(state.status, action),
    );

final Reducer<NewsPaper> entryReducer = combineReducers([
  TypedReducer<NewsPaper, SetNewsAction>(_setNews),
]);

NewsPaper _setNews(NewsPaper paper, SetNewsAction action) {
  if (action.paper != null &&
      action.paper.entries != null &&
      action.paper.entries.length > 0)
    return NewsPaper(List.unmodifiable(List.from(action.paper.entries)));
  return paper;
}

final Reducer<Status> statusReducer = combineReducers([
  TypedReducer<Status, SelectNewsItemAction>(_addNewsItem),
  TypedReducer<Status, DeSelectNewsItemAction>(_removeNewsItem),
  TypedReducer<Status, StartLoadingAction>(_startLoading),
  TypedReducer<Status, StopLoadingAction>(_stopLoading),
]);

Status _addNewsItem(Status status, SelectNewsItemAction action) =>
    Status(status.openedNewsItems..add(action.newsId), status.loading);

Status _removeNewsItem(Status status, DeSelectNewsItemAction action) =>
    Status(status.openedNewsItems..remove(action.newsId), status.loading);

Status _startLoading(Status status, StartLoadingActionaction) =>
    Status(status.openedNewsItems, true);

Status _stopLoading(Status status, StopLoadingAction) =>
    Status(status.openedNewsItems, false);
