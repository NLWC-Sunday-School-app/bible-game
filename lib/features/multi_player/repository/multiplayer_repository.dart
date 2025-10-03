import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/game_invites_model.dart';

class MultiplayerRepository {
  final MultiplayerAPI multiplayerAPI;

  MultiplayerRepository(this.multiplayerAPI);

  Future<CreateGameRoomModel> createGameRoom(hostId) async {
    return multiplayerAPI.createGameRoom(hostId);
  }

  Future<CreateGameRoomModel> joinRoom(inviteCode, userId) async {
    return multiplayerAPI.joinRoom(inviteCode, userId);
  }

  Future<bool> configureGameRoom(roomId, hostId, gameType, questionType, conditionType, condition) async {
    return multiplayerAPI.configureGameRoom(roomId, hostId, gameType, questionType, conditionType, condition);
  }

  Future<bool> gameInvite(inviteeUsername, roomId, gameType) async {
    return multiplayerAPI.gameInvite(inviteeUsername, roomId, gameType);
  }

  Future<CreateGameRoomModel> acceptAndJoin(inviteId) async {
    return multiplayerAPI.acceptAndJoinInvite(inviteId);
  }

  Future<bool> reject(inviteId) async {
    return multiplayerAPI.reject(inviteId);
  }

  Future<List<GameInviteModel>> fetchGameInvite() async {
    return multiplayerAPI.fetchGameInvite();
  }

  Future<Map<String,dynamic>> countInvite() async {
    return multiplayerAPI.countInvite();
  }
}
