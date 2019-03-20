import 'package:pingvin_news/Store/Teams/LeagueState.dart';
import 'package:pingvin_news/Misc/Constants.dart';

class TeamState {
  teams team;
  LeagueState table;

  TeamState({this.team, this.table});

  factory TeamState.initial() => TeamState(
        team: teams.NONE,
        table: LeagueState.initial(),
      );
}
