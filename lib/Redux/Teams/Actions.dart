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
  teams team;
  ReadTeamFromFileAction(this.team);
}

class ReadTeamFromRESTAction {
  teams team;
  ReadTeamFromRESTAction(this.team);
}

class SaveTeamToFileAction {
  teams team;
  SaveTeamToFileAction(this.team);
}

class SetTeamData {
  final TeamTable teamTable;
  SetTeamData(this.teamTable);
}

class ClearTeamDataAction {}
