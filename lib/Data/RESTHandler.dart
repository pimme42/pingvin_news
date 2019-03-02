import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Data/News/NewsEntry.dart';
import 'package:pingvin_news/Data/News/NewsPaper.dart';

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

  Future<String> getJsonFromApi(String url, String endPoint) async {
    try {
      var httpClient = new HttpClient();
      var uri;
      if (Constants.useHttps)
        uri = new Uri.https(url, endPoint);
      else
        uri = new Uri.http(url, endPoint);
      Log.doLog("Uri: ${uri.toString()}", logLevel.DEBUG);
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      await Future.delayed(_timeout);
      Log.doLog("Times up in _getJsonFromApi", logLevel.DEBUG);
      return responseBody;
    } catch (e) {
      Log.doLog(
          "Error RESTHandler._getJsonFromApi: ${e.toString()}", logLevel.ERROR);
      throw HttpException("Could not fetch data from server");
    }
  }
}
