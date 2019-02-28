import 'package:pingvin_news/Data/Teams/TeamTable.dart';

class TableState {
  TeamTable teamTable;

  TableState({this.teamTable});

  factory TableState.initial() => TableState(
        teamTable: TeamTable.initial(),
      );
}
