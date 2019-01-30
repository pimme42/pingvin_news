import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/NewsEntry.dart';

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
    this._timeout = const Duration(seconds: 5);
  }

  Future<List<NewsEntry>> readNews() async {
    var response = await _getUserApi();
    List responseList = jsonDecode(response)['News'];
    List<NewsEntry> entries = List<NewsEntry>();
    responseList.forEach((dynamic map) {
      entries.add(NewsEntry.fromJson(map));
    });
    return entries;
  }

  _getUserApi() async {
    await Future.delayed(_timeout);
    var httpClient = new HttpClient();
    var uri = new Uri.http(Constants.dataURL, Constants.dataEntry);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }
}
