import 'package:flutter/foundation.dart' show debugPrint;
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/game_invites_model.dart';
import 'package:bible_game_api/model/online_player.dart';

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

  Future<bool> configureGameRoom(roomId, hostId, gameType, questionType,
      conditionType, condition, int secondsPerQuestion) async {
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
          },
          // Top level rather than inside victoryCondition: that object says how
          // a round is won, this says how fast it moves, and it is the same
          // setting in every mode. The server echoes it on GAME_STARTED so all
          // players run the same clock.
          "secondsPerQuestion": secondsPerQuestion
        }
      );
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  /// Players currently online and invitable.
  ///
  /// Returns an empty list rather than throwing when the endpoint is missing
  /// or the payload is not a list -- an empty "Online" tab is a better failure
  /// than a modal that cannot open.
  Future<List<OnlinePlayer>> fetchOnlinePlayers({
    int page = 0,
    int size = 20,
    String? search,
  }) async {
    try {
      final query = StringBuffer('?page=$page&size=$size');
      if (search != null && search.trim().isNotEmpty) {
        query.write('&search=${Uri.encodeQueryComponent(search.trim())}');
      }
      final response =
          await apiClient.get('/multiplayer/players/online$query');

      // The endpoint returns an OnlinePlayersResponse wrapper rather than a
      // bare list, and the field it wraps has not been pinned down -- accept
      // the usual names instead of guessing one and rendering nothing.
      final data = response.data;
      dynamic list = data;
      if (data is Map) {
        for (final key in ['players', 'content', 'data', 'items', 'results']) {
          if (data[key] is List) {
            list = data[key];
            break;
          }
        }
      }
      if (list is! List) {
        // An empty list and an unrecognised payload used to look identical to
        // the caller, which makes "nobody is online" impossible to tell from
        // "we could not read the response".
        debugPrint('\u26A0\uFE0F online players: no list in the response '
            '(keys: ${data is Map ? data.keys.toList() : data.runtimeType})');
        return const [];
      }
      debugPrint('\u{1F7E2} online players: ${list.length} returned');
      return list
          .whereType<Map<String, dynamic>>()
          .map(OnlinePlayer.fromJson)
          .where((p) => p.username.isNotEmpty)
          .toList();
    } on ApiException catch (e) {
      // Surfaced, not swallowed: a 404 while the endpoint is still being
      // deployed should not look the same as an empty room.
      debugPrint('\u26A0\uFE0F online players failed: ${e.code} ${e.message}');
      rethrow;
    }
  }

  Future<bool> gameInvite(inviteeUsername, roomId, gameType ) async {
    try {
      final response = await apiClient.post(
          '/multiplayer/invites',
        data: {
          "inviteeUsername": inviteeUsername,
          "roomId": roomId,
          "gameMode": gameType
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

  Future<dynamic> roomDetails(roomId) async {
    try {
      final response = await apiClient.get(
          '/multiplayer/rooms/${roomId}',
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
