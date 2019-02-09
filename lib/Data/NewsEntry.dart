class NewsEntry {
  int _rowId, _id, _nid, _publishedTimestamp;
  String _link, _title, _summary;

  NewsEntry(this._rowId, this._id, this._nid, this._publishedTimestamp,
      this._link, this._title, this._summary);

  factory NewsEntry.fromJson(Map<String, dynamic> json) {
    return NewsEntry(
      _toInt(json['rowid']),
      _toInt(json['id']),
      _toInt(json['nid']),
      _toInt(json['published']),
      json['link'],
      json['title'],
      json['summary'],
    );
  }

  static int _toInt(dynamic value) {
//    print("_toInt: ${value.toString()} : ${value.runtimeType}");
    if (value is String) {
      if (value.contains('.') || value.contains(','))
        value = double.parse(value);
      else
        value = int.parse(value);
    }
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.round();
    }
    return -1;
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
