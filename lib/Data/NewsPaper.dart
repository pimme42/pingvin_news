import 'package:pingvin_news/Data/NewsEntry.dart';

const String _prefix = "NewsEntry_";

class NewsPaper {
  final List<NewsEntry> entries;

  NewsPaper(this.entries);

  factory NewsPaper.empty() => NewsPaper(List<NewsEntry>());

  factory NewsPaper.fromJson(Map<String, dynamic> json) {
    List<NewsEntry> data = new List();
    int len = json['length'];
    for (int i = 0; i < len-1; ++i) {
      String key = "$_prefix${i.toString()}";
      NewsEntry ne = NewsEntry.fromJson((json[key]));
      data.add(ne);
    }
    return NewsPaper(data);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map['length'] = this.entries.length;
    for (var i = 0; i < entries.length; ++i) {
      map[_prefix + i.toString()] = entries.elementAt(i).toJson();
    }
    return map;
  }
}
