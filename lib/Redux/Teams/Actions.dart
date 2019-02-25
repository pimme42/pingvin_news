import 'package:pingvin_news/Store/Teams/TeamState.dart';

class ViewTeamAction {
  final team;

  ViewTeamAction(this.team);
  factory ViewTeamAction.mens() => ViewTeamAction(teams.MENS);
  factory ViewTeamAction.womens() => ViewTeamAction(teams.WOMENS);
}

class ReadTeamFromFileAction {}

class ReadTeamFromRESTAction {}

class SaveTeamToFileAction {}

class SetTeamData {
  final String text;
  SetTeamData(this.text);
}
