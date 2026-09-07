import 'package:equatable/equatable.dart';

class PlayerAnswers extends Equatable {
  PlayerAnswers({
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
  final String? playerId;
  final dynamic toastNotificationMessage;
  final Details? data;
  final DateTime? timestamp;

  factory PlayerAnswers.fromJson(Map<String, dynamic> json){
    return PlayerAnswers(
      type: json["type"],
      roomId: json["roomId"],
      userId: json["userId"],
      playerId: json["playerId"],
      toastNotificationMessage: json["toastNotificationMessage"],
      data: json["data"] == null ? null : Details.fromJson(json["data"]),
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
    type, roomId, userId, playerId, toastNotificationMessage, data, timestamp, ];
}

class Details extends Equatable {
  Details({
    required this.username,
    required this.isCorrect,
    required this.pointsAwarded,
    required this.playerScore,
    required this.rank,
    required this.gameEnded,
    required this.victoryResult,
    required this.message,
  });

  final String? username;
  final bool? isCorrect;
  final int? pointsAwarded;
  final int? playerScore;
  final int? rank;
  final bool? gameEnded;
  final dynamic victoryResult;
  final String? message;

  factory Details.fromJson(Map<String, dynamic> json){
    return Details(
      username: json["username"],
      isCorrect: json["isCorrect"],
      pointsAwarded: json["pointsAwarded"],
      playerScore: json["playerScore"],
      rank: json["rank"],
      gameEnded: json["gameEnded"],
      victoryResult: json["victoryResult"],
      message: json["message"],
    );
  }

  @override
  List<Object?> get props => [
    username, isCorrect, pointsAwarded, playerScore, rank, gameEnded, victoryResult, message, ];
}
