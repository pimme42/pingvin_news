import 'package:pingvin_news/Data/Teams/TeamTable.dart';
import 'package:pingvin_news/Misc/Constants.dart';

class ViewTeamAction {
  final teams team;

  ViewTeamAction(this.team);
  factory ViewTeamAction.mens() => ViewTeamAction(teams.MENS);
  factory ViewTeamAction.womens() => ViewTeamAction(teams.WOMENS);
  factory ViewTeamAction.none() => ViewTeamAction(teams.NONE);
}

class ReadTeamFromFileAction {
  final teams team;
  ReadTeamFromFileAction(this.team);
}

class ReadTeamFromRESTAction {
  final teams team;
  ReadTeamFromRESTAction(this.team);
}

class SaveTeamToFileAction {
  final teams team;
  SaveTeamToFileAction(this.team);
}

class SetTeamData {
  final teams team;
  final TeamTable teamTable;
  SetTeamData(this.team, this.teamTable);
}

class ClearTeamDataAction {}
