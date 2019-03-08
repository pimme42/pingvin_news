import 'package:pingvin_news/Data/News/NewsEntry.dart';
import 'dart:convert';

class NewsPaper {
  final List<NewsEntry> entries;

  NewsPaper(this.entries);

  factory NewsPaper.empty() => NewsPaper(List<NewsEntry>());

  factory NewsPaper.fromJson(Map<String, dynamic> json) {
    List responseList = json['News'];
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

  factory NewsPaper.fromRestApi(String apiResponse) {
    if (apiResponse != null) {
      Map decode = jsonDecode(apiResponse);
      return NewsPaper.fromJson(decode);
    }
    return null;
  }

  factory NewsPaper.fromFile(String fileContents) {
    if (fileContents != null) {
      Map decode = jsonDecode(fileContents);
      return NewsPaper.fromJson(decode);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'class': this.runtimeType.toString(),
      'News': entries,
    };
//    for (var i = 0; i < entries.length; ++i) {
//
//      map[_prefix + i.toString()] = entries.elementAt(i).toJson();
//    }
    return map;
  }

  int get length => this.entries.length;
}
