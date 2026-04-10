import 'package:bible_game_api/bible_game_api.dart';

class WhoIsWhoRepository {
  final GameAPI gameAPI;
  WhoIsWhoRepository(this.gameAPI);

  Future<List<WhoIsWhoGameLevel>> getGameLevels() async {
    return await gameAPI.getWhoIsWhoLevels();
  }

  Future<List<GameQuestion>> getGameQuestions() async {
    return await gameAPI.getWhoIsWhoQuestions();
  }

  Future<bool> purchaseExtraTime(userID, gameTimePurchasePrice) async {
    return await gameAPI.buyFromStore(userID, gameTimePurchasePrice);
  }

  Future<bool> submitWhoIsWhoScore( totalScore, playerId, levelId, completedLevel) async{
    return await gameAPI.sendWhoIsWhoGameData( totalScore, playerId, levelId, completedLevel);
  }


}