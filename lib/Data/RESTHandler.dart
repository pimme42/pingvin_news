import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';
import 'package:pingvin_news/Data/NewsPaper.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

class RESTHandler {
  Duration _timeout;
  static final RESTHandler _singleton = new RESTHandler._internal();

  factory RESTHandler() {
    return _singleton;
  }

  RESTHandler._internal() {
    this._timeout = const Duration(seconds: 2);
  }

  Future<NewsPaper> readNews() async {
    String response = await _getNewsApi();

    List responseList = jsonDecode(response)['News'];
    List<NewsEntry> entries = List<NewsEntry>();
    // responseList?.length blir null om responseList är null och isåfall
    //    använder vi 0 istället vid jämförelsen
    if ((responseList?.length ?? 0) > 0) {
      responseList.forEach((dynamic map) {
        entries.add(NewsEntry.fromJson(map));
      });
    }
    return NewsPaper(entries);
  }

  Future<String> _getNewsApi() async {
    try {
      var httpClient = new HttpClient();
      var uri = new Uri.https(Constants.dataURL, Constants.dataEntry);
      Log.doLog("Uri: ${uri.toString()}", logLevel.DEBUG);
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      await Future.delayed(_timeout);
      Log.doLog("Times up in _getNewsApi", logLevel.DEBUG);
      return responseBody;
    } catch (e) {
      // If we encounter an error, return 0
      Log.doLog(
          "Error RESTHandler._getNewsApi: ${e.toString()}", logLevel.ERROR);
      throw HttpException("Could not fetch data from server");
    }
  }
}
