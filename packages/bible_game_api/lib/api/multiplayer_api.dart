import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/game_invites_model.dart';

class MultiplayerAPI {
  final ApiClient apiClient;

  MultiplayerAPI(this.apiClient);

  Future<CreateGameRoomModel> createGameRoom(hostId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms',
        data: {
          "hostId": hostId,
          "gameMode": "MULTIPLAYER_GROUP"
        }
      );
      return CreateGameRoomModel.fromJson(response.data);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<CreateGameRoomModel> joinRoom(inviteCode, userId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms/join',
          data:{
            "inviteCode": inviteCode,
            "userId": userId
          }
      );
      return CreateGameRoomModel.fromJson(response.data);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> configureGameRoom(roomId, hostId, gameType, questionType, conditionType, condition) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms/$roomId/configure',
        data: {
          "hostId": hostId,
          "victoryCondition": {
            "type": gameType,
            "value": condition,
            "questionType": questionType
          },
          "winCondition": {
            "type": conditionType,
            "value": condition
          }
        }
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> gameInvite(inviteeUsername, roomId, gameType ) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/invites',
        data: {
          "inviteeUsername": inviteeUsername,
          "roomId": roomId,
          "gameMode": gameType,
          "message": "interesting"
        }
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GameInviteModel>> fetchGameInvite() async {
    try {
      final response = await apiClient.get(
          '/multiplayer/invites/pending',
      );
      final listOfResponse = (response.data as List)
          .map((e) => GameInviteModel.fromJson(e))
          .toList();
      return listOfResponse;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> countInvite() async {
    try {
      final response = await apiClient.get(
          '/multiplayer/invites/count',
      );
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<CreateGameRoomModel> acceptAndJoinInvite(inviteId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/invites/${inviteId}/accept-and-join',
        data: {}
      );
      return CreateGameRoomModel.fromJson(response.data);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> reject(inviteId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/invites/$inviteId/reject',
          data: {}
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> leaveRoom(roomId, playerId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms/${roomId}/leave',
          data: {
            "playerId": playerId
          }
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> kickOut(roomId, playerId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms/${roomId}/kick-out',
          data: {
            "playerId": playerId
          }
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }


  Future<StartGameRoomModel> startGame(roomId, hostId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms/${roomId}/start',
          data: {
            "hostId": hostId
          }
      );
      return StartGameRoomModel.fromJson(response.data);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> gameRestart(roomId, hostId) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/rooms/$roomId/restart',
          data: {
            "hostId": hostId
          }
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }



}
