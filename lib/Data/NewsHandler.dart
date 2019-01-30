import 'package:pingvin_news/Misc/Log.dart';

import 'package:pingvin_news/Data/FileHandler.dart';
import 'package:pingvin_news/Data/RESTHandler.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';

class NewsHandler {
  FileHandler _fh;
  RESTHandler _rh;

  static final NewsHandler _singleton = new NewsHandler._internal();

  factory NewsHandler() {
    return _singleton;
  }

  NewsHandler._internal() {
    this._fh = new FileHandler();
//    this._fh.deleteFile();
    this._rh = new RESTHandler();
  }

  Future<List<NewsEntry>> getNewsFromFile() async => this._fh.readNews();

  Future<List<NewsEntry>> getNewsFromREST() async => this._rh.readNews();

  void saveNews(List<NewsEntry> entries) async {
    this._fh.writeNews(entries);
  }
}