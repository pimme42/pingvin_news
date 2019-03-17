import 'package:pingvin_news/Store/Teams/LeagueState.dart';
import 'package:pingvin_news/Store/Teams/TeamState.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';
import 'package:pingvin_news/Data/Teams/TableInfo.dart';

import 'package:redux/redux.dart';

TeamState teamReducer(TeamState state, action) => TeamState(
      team: teamSelectionReducer(state.team, action),
      table: tableReducers(state.table, action),
    );

final Reducer<teams> teamSelectionReducer = combineReducers([
  TypedReducer<teams, ViewTeamAction>(_viewTeam),
]);

teams _viewTeam(teams team, ViewTeamAction action) => action.team;

final Reducer<LeagueState> tableReducers = combineReducers([
  TypedReducer<LeagueState, SetTableInfoAction>(_setTableInfo),
]);

LeagueState _setTableInfo(LeagueState table, SetTableInfoAction action) {
  /// Här associerar vi leagueId med vilket lag de tillhör
  Map<teams, List<int>> leagueIds = {
    action.team: action.list.map((TableInfo info) => info.id).toList()
  };

  /// Se om det redan finns data för det aktuella laget och
  /// i så fall ta bort den.
  Map oldIds = Map.from(table.teamsLeagueId);
  if (oldIds.containsKey(action.team)) oldIds.remove(action.team);

  Map.unmodifiable(oldIds..addAll(leagueIds));

  return LeagueState(
    teamsLeagueId: leagueIds,
    tables: Map.unmodifiable(
      Map.fromEntries(
        action.list.map(
          (TableInfo info) {
            return MapEntry(info.id, info);
          },
        ),
      ),
    ),
  );
}
