class NewsEntry {
  int _rowId, _id, _nid, _publishedTimestamp;
  String _link, _title, _summary;

  NewsEntry(this._rowId, this._id, this._nid, this._publishedTimestamp,
      this._link, this._title, this._summary);

  factory NewsEntry.fromJson(Map<String, dynamic> json) {
    return NewsEntry(
      (json['rowid']),
      int.parse(json['id']),
      int.parse(json['nid']),
      json['published'].round(),
      json['link'],
      json['title'],
      json['summary'],
    );
  }

  Map<String, dynamic> toJson() => {
        'rowid': this.rowId,
        'id': this.id.toString(),
        'nid': this.nid.toString(),
        'published': this.publishedTimestamp,
        'link': this.link,
        'title': this.title,
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
