import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/Teams/LeagueInfo.dart';

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

class SetTableInfoAction {
  final teams team;
  final List<TableInfo> list;
  SetTableInfoAction(this.team, this.list) : assert(list != null);
}

class SaveTableDataAction {
  final teams team;
  final List<TableInfo> tableInfos;

  SaveTableDataAction(this.team, this.tableInfos);
}
