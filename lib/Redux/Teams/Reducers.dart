import 'package:pingvin_news/Store/Teams/TableState.dart';
import 'package:pingvin_news/Store/Teams/TeamState.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
import 'package:pingvin_news/Misc/Constants.dart';

import 'package:redux/redux.dart';

TeamState teamReducer(TeamState state, action) => TeamState(
      team: teamSelectionReducer(state.team, action),
      table: tableReducers(state.table, action),
    );

final Reducer<teams> teamSelectionReducer = combineReducers([
  TypedReducer<teams, ViewTeamAction>(_setTeam),
]);

teams _setTeam(teams team, ViewTeamAction action) => action.team;

final Reducer<TableState> tableReducers = combineReducers([
  TypedReducer<TableState, SetTeamData>(_setTeamData),
  TypedReducer<TableState, ClearTeamDataAction>(_clearTeamData),
]);

TableState _setTeamData(TableState table, SetTeamData action) => TableState(
      teamTable: action.teamTable,
    );

TableState _clearTeamData(TableState table, ClearTeamDataAction action) =>
    TableState.initial();
