import 'package:pingvin_news/Store/Teams/TableState.dart';

enum teams { MENS, WOMENS, NONE }

class TeamState {
  teams team;
  TableState table;

  TeamState({this.team, this.table});

  factory TeamState.initial() => TeamState(
        team: teams.NONE,
        table: TableState.initial(),
      );
}
