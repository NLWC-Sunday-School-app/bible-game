import 'package:equatable/equatable.dart';

class PositionUpdate extends Equatable {
  PositionUpdate({
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
  final String? toastNotificationMessage;
  final Data? data;
  final DateTime? timestamp;

  factory PositionUpdate.fromJson(Map<String, dynamic> json){
    return PositionUpdate(
      type: json["type"],
      roomId: json["roomId"],
      userId: json["userId"],
      playerId: json["playerId"],
      toastNotificationMessage: json["toastNotificationMessage"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
    type, roomId, userId, playerId, toastNotificationMessage, data, timestamp, ];
}

class Data extends Equatable {
  Data({
    required this.leaderboard,
    required this.message,
  });

  final List<PlayerLeaderboard> leaderboard;
  final String? message;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      leaderboard: json["leaderboard"] == null ? [] : List<PlayerLeaderboard>.from(json["leaderboard"]!.map((x) => PlayerLeaderboard.fromJson(x))),
      message: json["message"],
    );
  }

  @override
  List<Object?> get props => [
    leaderboard, message, ];
}

class PlayerLeaderboard extends Equatable {
  PlayerLeaderboard({
    required this.playerId,
    required this.username,
    required this.score,
    required this.rank,
  });

  final String? playerId;
  final String? username;
  final int? score;
  final int? rank;

  factory PlayerLeaderboard.fromJson(Map<String, dynamic> json){
    return PlayerLeaderboard(
      playerId: json["playerId"],
      username: json["username"],
      score: json["score"],
      rank: json["rank"],
    );
  }

  @override
  List<Object?> get props => [
    playerId, username, score, rank, ];
}
