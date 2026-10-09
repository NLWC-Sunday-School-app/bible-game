import 'package:equatable/equatable.dart';

/// GET /multiplayer/rooms/{roomId}. Unlike the create and join responses this
/// one lists the players by id and name, which is what a client returning to
/// a room needs to rebuild its waiting room before any socket frame arrives.
class RoomDetailsModel extends Equatable {
  const RoomDetailsModel({
    required this.id,
    required this.inviteCode,
    required this.hostId,
    required this.gameMode,
    required this.status,
    required this.victoryType,
    required this.victoryValue,
    required this.questionType,
    required this.secondsPerQuestion,
    required this.totalQuestions,
    required this.players,
  });

  final String? id;
  final String? inviteCode;

  /// The host's user id, as a string.
  final String? hostId;
  final String? gameMode;

  /// WAITING, ACTIVE or FINISHED.
  final String? status;

  /// LIGHTNING or FIRST_TO_X; null until the host configures the room.
  final String? victoryType;
  final int? victoryValue;
  final String? questionType;
  final int? secondsPerQuestion;
  final int? totalQuestions;
  final List<RoomPlayer> players;

  bool get isWaiting => status == 'WAITING';
  bool get isActive => status == 'ACTIVE';
  bool get isFinished => status == 'FINISHED';

  factory RoomDetailsModel.fromJson(Map<String, dynamic> json) {
    final victory = json['victoryCondition'] as Map<String, dynamic>?;
    return RoomDetailsModel(
      id: json['id'],
      inviteCode: json['inviteCode'],
      hostId: json['hostId']?.toString(),
      gameMode: json['gameMode'],
      status: json['status'],
      victoryType: victory?['type'],
      victoryValue: victory?['value'],
      questionType: victory?['questionType'],
      secondsPerQuestion: json['secondsPerQuestion'],
      totalQuestions: json['totalQuestions'],
      players: json['players'] == null
          ? const []
          : List<RoomPlayer>.from(
              (json['players'] as List).map((x) => RoomPlayer.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        id,
        inviteCode,
        hostId,
        gameMode,
        status,
        victoryType,
        victoryValue,
        questionType,
        secondsPerQuestion,
        totalQuestions,
        players,
      ];
}

class RoomPlayer extends Equatable {
  const RoomPlayer({required this.playerId, required this.playerName});

  final String? playerId;
  final String? playerName;

  factory RoomPlayer.fromJson(Map<String, dynamic> json) {
    return RoomPlayer(
      playerId: json['playerId'],
      playerName: json['playerName'],
    );
  }

  @override
  List<Object?> get props => [playerId, playerName];
}
