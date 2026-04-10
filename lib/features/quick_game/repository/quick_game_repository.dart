import 'package:bible_game_api/bible_game_api.dart';

class QuickGameRepository {
  final GameAPI gameAPI;

  QuickGameRepository(this.gameAPI);

  Future<List<GameQuestion>> getQuickGameQuestions(
      String gameMode, String userRank, List<String> tags) async {
    return await gameAPI.getQuestions(gameMode, userRank, tags);
  }

  Future<List<QuickGameTopic>> getQuickGameTopics() async {
    return await gameAPI.getQuickGameTopics();
  }

  Future<List<QuickGameTopic>> findQuickGameTopics(code) async {
    return await gameAPI.findQuickGameTopic(code);
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
      deviceName,
      deviceOs
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
      deviceName,
      deviceOs
    );
  }
}
