import 'package:bible_game_api/api/game_api.dart';
import 'package:bible_game_api/model/four_scriptures.dart';

class FourScripturesOneWordRepository {
  final GameAPI gameAPI;

  FourScripturesOneWordRepository(this.gameAPI);

  Future<List<FourScripturesOneWordQuestion>> getQuickGameQuestions(level) async {
    return await gameAPI.getFourScripturesOneWordQuestions(level);
  }

  Future<int> getTotalNoOfQuestionsInFourScriptures () async{
    return await gameAPI.getTotalNoOfQuestionsInFourScriptures();
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

  Future<dynamic> updateUserFourScriptureOneWordLevel(userId, newLevel)async{
    return await gameAPI.updateUserFourScriptureOneWordLevel(userId, newLevel);
  }

  Future<bool> purchaseHint(userID, hintPurchasePrice) async {
    return await gameAPI.buyFromStore(userID, hintPurchasePrice);
  }
}