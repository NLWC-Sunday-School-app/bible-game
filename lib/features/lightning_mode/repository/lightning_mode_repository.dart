import 'package:bible_game_api/bible_game_api.dart';

class LightningModeRepository {
  final MultiplayerAPI multiplayerAPI;

  LightningModeRepository(this.multiplayerAPI);

  Future<StartGameRoomModel> startGame(roomId, hostId) async {
    return multiplayerAPI.startGame(roomId, hostId);
  }



}
