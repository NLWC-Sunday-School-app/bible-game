import 'package:bible_game_api/api/game_api.dart';
import 'package:bible_game_api/model/league_data.dart';
import 'package:bible_game_api/model/league_preview.dart';
import 'package:bible_game_api/model/user_league_preview.dart';

class FantasyLeagueRepository {
  final GameAPI gameAPI;

  FantasyLeagueRepository(this.gameAPI);

  Future<Map<String, dynamic>> createFantasyBibleLeague(
      name, goal, isOpen, seasonEnd) async {
    return await gameAPI.createFantasyBibleLeague(
        name, goal, isOpen, seasonEnd);
  }

  Future<List<LeaguePreview>> getOpenLeagues() async {
    return await gameAPI.getOpenLeagues();
  }

  Future<List<LeaguePreview>> findLeagues(code) async {
    return await gameAPI.findLeague(code);
  }

  Future<List<UserLeaguePreview>> getUserLeagues(userId) async {
    return await gameAPI.getUserLeagues(userId);
  }

  Future<LeagueData> viewLeagueData(leagueId) async {

    var test = await gameAPI.viewLeagueData(leagueId);
    print('power of lif $test');
    return test;
  }

  Future<void> joinLeague(leagueId) async {
    return await gameAPI.joinLeague(leagueId);
  }

  Future<void> leaveLeague(leagueId) async {
    return await gameAPI.leaveLeague(leagueId);
  }
}
