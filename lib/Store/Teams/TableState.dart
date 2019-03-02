import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/Teams/TeamTable.dart';

class TableState {
  Map<teams, TeamTable> teamTable;

  TableState({this.teamTable});

  factory TableState.initial() => TableState(
        teamTable: {},
      );
}
