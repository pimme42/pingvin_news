import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Misc/Log.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

class RESTHandler {
  static final RESTHandler _singleton = new RESTHandler._internal();

  factory RESTHandler() {
    return _singleton;
  }

  RESTHandler._internal();

  Future<String> getJsonAsStringFromApi(String url, String endPoint) async {
    try {
//      throw Exception("FEL FEL FEL");
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
//      await Future.delayed(Duration(seconds: 5));
      Log.doLog("Times up in _getJsonFromApi", logLevel.DEBUG);
      return responseBody;
    } catch (e) {
      Log.doLog(
          "Error RESTHandler._getJsonFromApi: ${e.toString()}", logLevel.ERROR);
      throw HttpException("Could not fetch data from server");
    }
  }
}
