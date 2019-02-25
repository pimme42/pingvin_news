import 'package:pingvin_news/Store/Teams/TableState.dart';
import 'package:pingvin_news/Store/Teams/TeamState.dart';
import 'package:pingvin_news/Redux/Teams/Actions.dart';
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
]);

TableState _setTeamData(TableState table, SetTeamData action) =>
    TableState(table.table + " - " + action.text);
