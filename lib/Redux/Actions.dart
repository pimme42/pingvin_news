import 'package:pingvin_news/Data/NewsPaper.dart';


// Actions on NewsStore

class SetNewsAction {
  final NewsPaper paper;
  SetNewsAction(this.paper);
}

class SaveNewsAction {
  final NewsPaper paper;
  SaveNewsAction(this.paper);
}

class ReadNewsFromFileAction {}

class ReadNewsFromRESTAction {}

class CouldNotReadRESTAction {}


// Actions on Status

class SelectNewsItemAction {
  final int newsId;
  SelectNewsItemAction(this.newsId);
}

class DeSelectNewsItemAction {
  final int newsId;
  DeSelectNewsItemAction(this.newsId);
}

class StartLoadingAction {}

class StopLoadingAction {}

