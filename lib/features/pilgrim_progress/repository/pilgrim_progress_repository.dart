import 'package:bible_game_api/api/game_api.dart';
import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/pilgrim_progress_level_data.dart';

class PilgrimProgressRepository {
  final GameAPI gameAPI;

  PilgrimProgressRepository(this.gameAPI);

  Future<List<GameQuestion>> getPilgrimProgressQuestions(
      String gameMode, String userRank, dynamic tags) async {
    return await gameAPI.getQuestions(gameMode, userRank, tags);
  }

  Future<List<PilgrimProgressLevelData>> getUserPilgrimProgress(userId) async {
    return await gameAPI.getUserPilgrimProgress(userId);
  }

  Future<bool> updateUserRank(id, newRank) async{
     return await gameAPI.updatePlayerRank(id, newRank);
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