import 'package:pingvin_news/Data/Teams/TableRow.dart';
import 'package:pingvin_news/Misc/Log.dart';

class TableData {
  final List<TableRowData> rows;

  TableData(this.rows);

  TableData copyAdd(TableRowData data) {
    List newRows = List.from(this.rows);
    newRows.add(data);
    return TableData(newRows);
  }

  factory TableData.fromJson(Map<String, dynamic> json) {
    try {
      List<TableRowData> tableRowData = List();
      List<dynamic> jsonList = json['Tabell'];
      jsonList?.forEach((dynamic element) {
        tableRowData.add(TableRowData.fromJson(element));
      });
      return TableData(List.unmodifiable(tableRowData));
    } catch (e, s) {
      Log.doLog(
          "Error in Tabledata.fromJson: ${e.toString()}\nStackTrace: ${s.toString()}",
          logLevel.ERROR);
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'Tabell': this.rows,
      };

  @override
  String toString() {
    return this.rows.map((TableRowData row) => row.toString()).toString();
  }
}
