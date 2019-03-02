import 'package:pingvin_news/Data/DataHandler.dart';

class NewsEntry {
  int _rowId, _id, _nid, _publishedTimestamp;
  String _link, _title, _summary;

  NewsEntry(this._rowId, this._id, this._nid, this._publishedTimestamp,
      this._link, this._title, this._summary);

  factory NewsEntry.fromJson(Map<String, dynamic> json) {
    return NewsEntry(
      DataHandler.parseInt(json['id']),
      DataHandler.parseInt(json['club_id']),
      DataHandler.parseInt(json['news_id']),
      DataHandler.parseInt(json['published']),
      json['link'],
      json['title'],
      json['summary'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.rowId,
        'club_id': this.id,
        'news_id': this.nid,
        'published': this.publishedTimestamp,
        'title': this.title,
        'link': this.link,
        'summary': this.summary,
      };

  get summary => _summary;

  get title => _title;

  String get link => _link;

  get publishedTimestamp => _publishedTimestamp;

  get nid => _nid;

  get id => _id;

  int get rowId => _rowId;
}
