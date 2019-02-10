
import 'package:pingvin_news/Data/FileHandler.dart';
import 'package:pingvin_news/Data/RESTHandler.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

class NewsHandler {
  FileHandler _fh;
  RESTHandler _rh;

  static final NewsHandler _singleton = new NewsHandler._internal();

  factory NewsHandler() {
    return _singleton;
  }

  NewsHandler._internal() {
//    this._fh = new FileHandler();
//    this._fh.deleteFile();
    this._rh = new RESTHandler();
  }

  Future<NewsPaper> getNewsFromFile() async => this._fh?.readNews();

  Future<NewsPaper> getNewsFromREST() async => this._rh?.readNews();

  void saveNews(NewsPaper paper) async {
    this._fh?.writeNews(paper);
  }
}