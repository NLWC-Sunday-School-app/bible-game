import 'package:bible_game_api/api/game_api.dart';
import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/global_game.dart';
import 'package:bible_game_api/model/global_leaderboard.dart';
import 'package:bible_game_api/model/leaderboard.dart';

class GlobalChallengeRepository {
  final GameAPI gameAPI;

  GlobalChallengeRepository(this.gameAPI);

  Future<List<GlobalGame>> FetchGlobalChallengeGames() async {
     return gameAPI.getGlobalGames();
  }

  Future<void> updateGlobalChallengeGame (id, title, description, image, campaignTag, isActive, isComingSoon, startDate, endDate) async{
    return gameAPI.updateGlobalChallengeGame(id, title, description, image, campaignTag, isActive, isComingSoon, startDate, endDate);
  }

  Future<List<GameQuestion>> getQuickGameQuestions(
      String gameMode, String userRank, dynamic tags) async {
    return await gameAPI.getQuestions(gameMode, userRank, tags);
  }

  Future<List<GlobalChallengeLeaderboard>> getGameLeaderBoard(campaignType)async{
    return await gameAPI.getGlobalGameLeaderBoard(campaignType);
  }

  Future<void> sendGameData(
      gameMode,
      totalScore,
      baseScore,
      bonusScore,
      averageTimeSpent,
      playerRank,
      noOfCorrectAnswers,
      playerId,
      userProgress,
      numberOfRoundsLeft,
      ) async {
    return await gameAPI.sendGameData(
      gameMode,
      totalScore,
      baseScore,
      bonusScore,
      averageTimeSpent,
      playerRank,
      noOfCorrectAnswers,
      playerId,
      userProgress,
      numberOfRoundsLeft,
    );
  }
}