import 'package:equatable/equatable.dart';

class WaitingRoomModel extends Equatable {
  WaitingRoomModel({
    required this.type,
    required this.roomId,
    required this.players,
    required this.readyCount,
    required this.totalPlayers,
    required this.maxPlayers,
    required this.gameMode,
  });

  final String? type;
  final String? roomId;
  final List<Player> players;
  final int? readyCount;
  final int? totalPlayers;
  final int? maxPlayers;
  final String? gameMode;

  factory WaitingRoomModel.fromJson(Map<String, dynamic> json){
    return WaitingRoomModel(
      type: json["type"],
      roomId: json["roomId"],
      players: json["players"] == null ? [] : List<Player>.from(json["players"]!.map((x) => Player.fromJson(x))),
      readyCount: json["readyCount"],
      totalPlayers: json["totalPlayers"],
      maxPlayers: json["maxPlayers"],
      gameMode: json["gameMode"],
    );
  }

  @override
  List<Object?> get props => [
    type, roomId, players, readyCount, totalPlayers, maxPlayers, gameMode, ];
}

class Player extends Equatable {
  Player({
    required this.userId,
    required this.username,
    required this.isReady,
    required this.isHost,
  });

  final String? userId;
  final String? username;
  final bool? isReady;
  final bool? isHost;

  factory Player.fromJson(Map<String, dynamic> json){
    return Player(
      userId: json["userId"],
      username: json["username"],
      isReady: json["isReady"],
      isHost: json["isHost"],
    );
  }

  @override
  List<Object?> get props => [
    userId, username, isReady, isHost, ];
}
