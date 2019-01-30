import 'package:pingvin_news/Data/NewsEntry.dart';

const String _prefix = "NewsEntry_";

class NewsPaper {
  final List<NewsEntry> entries;
  final bool loaded;

  NewsPaper(this.entries, this.loaded);

  factory NewsPaper.empty() => NewsPaper(List<NewsEntry>(), false);

  factory NewsPaper.fromJson(Map<String, dynamic> json) {
    List data = new List();
    for (var i = 0; i < json['length']; ++i) {
      NewsEntry ne = new NewsEntry.fromJson((json[_prefix + i.toString()]));
      data.add(ne);
    }
    if (json['length'] > 0) return NewsPaper(data, true);
    return NewsPaper(data, false);
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
