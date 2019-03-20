import 'package:meta/meta.dart';
import 'package:pingvin_news/Misc/Log.dart';
import 'package:pingvin_news/Data/DataHandler.dart';

class FixtureData {
  final List<Fixture> fixtures;

  FixtureData(this.fixtures);

  FixtureData copyAdd(Fixture data) {
    List newRows = List.from(this.fixtures);
    newRows.add(data);
    return FixtureData(newRows);
  }

  factory FixtureData.fromJson(Map<String, dynamic> json) {
    try {
      List<Fixture> fixtures = List();
      List<dynamic> jsonList = json['Fixtures'];
      jsonList?.forEach((dynamic element) {
        fixtures.add(Fixture.fromJson(element));
      });
      return FixtureData(List.unmodifiable(fixtures));
    } catch (e, s) {
      Log.doLog(
          "Error in FixtureData.fromJson: ${e.toString()}\nStackTrace: ${s.toString()}",
          logLevel.ERROR);
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'Fixtures': this.fixtures,
      };

  @override
  String toString() {
    return this
        .fixtures
        .map((Fixture fixture) => fixture.toString())
        .toString();
  }
}

class Fixture {
  final int id;
  final int leagueId;
  final int timestamp;
  final int round;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String link;

  Fixture({
    @required this.id,
    @required this.leagueId,
    @required this.timestamp,
    this.round,
    @required this.homeTeam,
    @required this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.link,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      id: DataHandler.parseInt(json['id']),
      leagueId: DataHandler.parseInt(json['league_id']),
      timestamp: DataHandler.parseInt(json['timestamp']),
      round: DataHandler.parseInt(json['round']),
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      homeScore: DataHandler.parseInt(json['homeScore']),
      awayScore: DataHandler.parseInt(json['awayScore']),
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'leagueId': this.leagueId,
        'timestamp': this.timestamp,
        'round': this.round,
        'homeTeam': this.homeTeam,
        'awayTeam': this.awayTeam,
        'homeScore': this.homeScore,
        'awayScore': this.awayScore,
        'link': this.link,
      };
}
