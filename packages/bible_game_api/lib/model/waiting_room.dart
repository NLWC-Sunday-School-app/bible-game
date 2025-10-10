import 'package:equatable/equatable.dart';

class WaitingRoomModel extends Equatable {
  WaitingRoomModel({
    required this.type,
    required this.roomId,
    required this.players,
    required this.readyCount,
    required this.totalPlayers,
    required this.maxPlayers,
    required this.totalQuestions,
    required this.gameMode,
  });

  final String? type;
  final String? roomId;
  final List<Player> players;
  final int? readyCount;
  final int? totalPlayers;
  final int? maxPlayers;
  final String? totalQuestions;
  final String? gameMode;

  factory WaitingRoomModel.fromJson(Map<String, dynamic> json){
    return WaitingRoomModel(
      type: json["type"],
      roomId: json["roomId"],
      players: json["players"] == null ? [] : List<Player>.from(json["players"]!.map((x) => Player.fromJson(x))),
      readyCount: json["readyCount"],
      totalPlayers: json["totalPlayers"],
      maxPlayers: json["maxPlayers"],
      totalQuestions: json["totalQuestions"],
      gameMode: json["gameMode"],
    );
  }

  @override
  List<Object?> get props => [
    type, roomId, players, readyCount, totalPlayers, maxPlayers, gameMode,totalQuestions ];
}

class Player extends Equatable {
  Player({
    required this.id,
    required this.userId,
    required this.username,
    required this.isReady,
    required this.isHost,
    required this.country,
    required this.level,
  });

  final String? id;
  final String? userId;
  final String? username;
  final bool? isReady;
  final bool? isHost;
  final String? country;
  final String? level;

  factory Player.fromJson(Map<String, dynamic> json){
    return Player(
      id: json["id"],
      userId: json["userId"],
      username: json["username"],
      isReady: json["isReady"],
      isHost: json["isHost"],
      country: json["country"],
      level: json["level"],
    );
  }

  @override
  List<Object?> get props => [
    id, userId, username, isReady, isHost, country, level, ];
}
