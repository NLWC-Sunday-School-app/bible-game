import 'package:equatable/equatable.dart';

class GameFinishedEvent extends Equatable {
  GameFinishedEvent({
    required this.type,
    required this.roomId,
    required this.userId,
    required this.playerId,
    required this.toastNotificationMessage,
    required this.data,
    required this.timestamp,
  });

  final String? type;
  final String? roomId;
  final dynamic userId;
  final dynamic playerId;
  final dynamic toastNotificationMessage;
  final GameFinishedData? data;
  final DateTime? timestamp;

  factory GameFinishedEvent.fromJson(Map<String, dynamic> json){
    return GameFinishedEvent(
      type: json["type"],
      roomId: json["roomId"],
      userId: json["userId"],
      playerId: json["playerId"],
      toastNotificationMessage: json["toastNotificationMessage"],
      data: json["data"] == null ? null : GameFinishedData.fromJson(json["data"]),
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
    type, roomId, userId, playerId, toastNotificationMessage, data, timestamp, ];
}

class GameFinishedData extends Equatable {
  GameFinishedData({
    required this.winner,
    required this.finalScores,
    required this.leaderboard,
    required this.message,
    required this.victoryType,
  });

  final String? winner;
  final Map<String, int> finalScores;
  final List<GameFinishedLeaderboard> leaderboard;
  final String? message;
  final String? victoryType;

  factory GameFinishedData.fromJson(Map<String, dynamic> json){
    return GameFinishedData(
      winner: json["winner"],
      finalScores: Map.from(json["finalScores"]).map((k, v) => MapEntry<String, int>(k, v)),
      leaderboard: json["leaderboard"] == null ? [] : List<GameFinishedLeaderboard>.from(json["leaderboard"]!.map((x) => GameFinishedLeaderboard.fromJson(x))),
      message: json["message"],
      victoryType: json["victoryType"],
    );
  }

  @override
  List<Object?> get props => [
    winner, finalScores, leaderboard, message, victoryType, ];
}

class GameFinishedLeaderboard extends Equatable {
  GameFinishedLeaderboard({
    required this.playerId,
    required this.userId,
    required this.username,
    required this.country,
    required this.level,
    required this.score,
    required this.rank,
  });

  final String? playerId;
  final String? userId;
  final String? username;
  final String? country;
  final String? level;
  final int? score;
  final int? rank;

  factory GameFinishedLeaderboard.fromJson(Map<String, dynamic> json){
    return GameFinishedLeaderboard(
      playerId: json["playerId"],
      userId: json["userId"],
      username: json["username"],
      country: json["country"],
      level: json["level"],
      score: json["score"],
      rank: json["rank"],
    );
  }

  @override
  List<Object?> get props => [
    playerId, userId, username, country, level, score, rank, ];
}
