import 'package:pingvin_news/Data/FileHandler.dart';
import 'package:pingvin_news/Data/RESTHandler.dart';
import 'package:pingvin_news/Data/News/NewsPaper.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'dart:convert';

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

  Future<NewsPaper> getNewsFromREST() async => NewsPaper.fromRestApi(
        await this
            ._rh
            ?.getJsonAsStringFromApi(Constants.apiURL, Constants.newsEndPoint),
      );

  Future<NewsPaper> getNewsFromFile() async => NewsPaper.fromFile(
        await this._fh?.getJsonFromFile(Constants.newsFile),
      );

  void saveNews(NewsPaper paper) async {
//    this._fh?.writeNews(paper);
    this._fh?.writeToFile(Constants.newsFile, jsonEncode(paper));
  }
}
