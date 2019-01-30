import 'package:pingvin_news/Data/NewsEntry.dart';

class SetNewsAction {
  final List<NewsEntry> entries;
  SetNewsAction(this.entries);
}

class SaveNewsAction {
  final List<NewsEntry> entries;
  SaveNewsAction(this.entries);
}

class ReadNewsAction {}
