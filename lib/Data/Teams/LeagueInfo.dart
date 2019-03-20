import 'package:pingvin_news/Data/Teams/TableData.dart';
import 'package:pingvin_news/Data/Teams/FixtureData.dart';
import 'package:pingvin_news/Data/DataHandler.dart';
import 'package:pingvin_news/Misc/Log.dart';

class TableInfo {
  final int id;
  final String name;
  final int parentId;
  final TableInfo parentInfo;
  final int year;
  final String link;
  final TableData tableData;
  final FixtureData fixtureData;

  TableInfo({
    this.id,
    this.name,
    this.parentId,
    this.parentInfo,
    this.year,
    this.link,
    this.tableData,
    this.fixtureData,
  });

  factory TableInfo.fromJson(Map<String, dynamic> json) {
    try {
      TableInfo tableInfo = TableInfo(
        id: DataHandler.parseInt(json['id']),
        parentId: DataHandler.parseInt(json['parent']),
        name: json['name'],
        year: DataHandler.parseInt(json['year']),
        link: json['link'],
      );
      return tableInfo;
    } catch (e, s) {
      Log.doLog(
          "Error in TableInfo.fromJson: ${e.toString()}\nStackTrace: ${s.toString()}",
          logLevel.ERROR);
      return null;
    }
  }

  factory TableInfo.fromJsonFile(Map<String, dynamic> json) {
    try {
      TableInfo tableInfo = TableInfo(
        id: DataHandler.parseInt(json['id']),
        parentId: DataHandler.parseInt(json['parent']),
        name: json['name'],
        year: DataHandler.parseInt(json['year']),
        link: json['link'],
        parentInfo: TableInfo.fromJson(json['parentInfo']),
        tableData: TableData.fromJson(json['tableData']),
        fixtureData: FixtureData.fromJson(json['fixtures']),
      );
      return tableInfo;
    } catch (e, s) {
      print(json.toString());
      Log.doLog(
          "Error in TableInfo.fromJsonFile: ${e.toString()}\nStackTrace: ${s.toString()}",
          logLevel.ERROR);
      return null;
    }
  }

  /// This allows us to create a new TableInfo from an old one,
  /// and alter some data. The new data will probably by
  /// parent and data.
  factory TableInfo.copy(TableInfo original,
      {id, name, parentId, parent, year, link, tableData, fixtureData}) {
    return TableInfo(
      id: id ?? original?.id,
      name: name ?? original?.name,
      parentId: parentId ?? original?.parentId,
      parentInfo: parent ?? original?.parentInfo,
      year: year ?? original?.year,
      link: link ?? original?.link,
      tableData: tableData ?? original?.tableData,
      fixtureData: fixtureData ?? original?.fixtureData,
    );
  }

  Map<String, dynamic> toJson() => {
        'class': this.runtimeType.toString(),
        'id': this.id,
        'name': this.name,
        'parent': this.parentId,
        'year': this.year,
        'link': this.link,
        'parentInfo': this.parentInfo?.toJson() ?? {},
        'tableData': this.tableData?.toJson() ?? {},
        'fixtures': this.fixtureData?.toJson() ?? {},
      };

  @override
  String toString() {
    return "($id) $name ($year)";
  }
}
