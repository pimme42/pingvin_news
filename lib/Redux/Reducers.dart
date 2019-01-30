import 'package:pingvin_news/Redux/Actions.dart';
import 'package:pingvin_news/Store/NewsStore.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';

import 'package:redux/redux.dart';
import 'package:quiver/time.dart';

NewsStore newsReducer(NewsStore state, action) => NewsStore(
      entryReducer(state.paper, action),

    );

final Reducer<NewsPaper> entryReducer = combineReducers([
  TypedReducer<NewsPaper, SetNewsAction>(_setNews),
]);

NewsPaper _setNews(NewsPaper paper, SetNewsAction action) {
  if(action.entries != null && action.entries.length > 0)
    return NewsPaper(List.unmodifiable(List.from(action.entries)), true);
  return paper;
}
