import 'package:equatable/equatable.dart';

class CreateGameRoomModel extends Equatable {
  CreateGameRoomModel({
    required this.id,
    required this.inviteCode,
    required this.hostId,
    required this.gameMode,
    required this.status,
    required this.createdAt,
    required this.maxPlayers,
    required this.victoryCondition,
    required this.winCondition,
    required this.playerIds,
    required this.scores,
    required this.currentQuestionId,
    required this.questionStartTime,
    required this.currentTurnPlayerId,
    required this.questionsAsked,
    required this.gameStartTime,
    required this.eliminatedPlayers,
    required this.full,
    required this.activePlayers,
  });

  final String? id;
  final String? inviteCode;
  final String? hostId;
  final String? gameMode;
  final String? status;
  final DateTime? createdAt;
  final int? maxPlayers;
  final VictoryCondition? victoryCondition;
  final WinCondition? winCondition;
  final List<dynamic> playerIds;
  final Scores? scores;
  final String? currentQuestionId;
  final DateTime? questionStartTime;
  final String? currentTurnPlayerId;
  final int? questionsAsked;
  final DateTime? gameStartTime;
  final List<dynamic> eliminatedPlayers;
  final bool? full;
  final List<dynamic> activePlayers;

  factory CreateGameRoomModel.fromJson(Map<String, dynamic> json){
    return CreateGameRoomModel(
      id: json["id"],
      inviteCode: json["inviteCode"],
      hostId: json["hostId"],
      gameMode: json["gameMode"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      maxPlayers: json["maxPlayers"],
      victoryCondition: json["victoryCondition"] == null ? null : VictoryCondition.fromJson(json["victoryCondition"]),
      winCondition: json["winCondition"] == null ? null : WinCondition.fromJson(json["winCondition"]),
      playerIds: json["playerIds"] == null ? [] : List<dynamic>.from(json["playerIds"]!.map((x) => x)),
      scores: json["scores"] == null ? null : Scores.fromJson(json["scores"]),
      currentQuestionId: json["currentQuestionId"],
      questionStartTime: DateTime.tryParse(json["questionStartTime"] ?? ""),
      currentTurnPlayerId: json["currentTurnPlayerId"],
      questionsAsked: json["questionsAsked"],
      gameStartTime: DateTime.tryParse(json["gameStartTime"] ?? ""),
      eliminatedPlayers: json["eliminatedPlayers"] == null ? [] : List<dynamic>.from(json["eliminatedPlayers"]!.map((x) => x)),
      full: json["full"],
      activePlayers: json["activePlayers"] == null ? [] : List<dynamic>.from(json["activePlayers"]!.map((x) => x)),
    );
  }

  @override
  List<Object?> get props => [
    id, inviteCode, hostId, gameMode, status, createdAt, maxPlayers, victoryCondition, winCondition, playerIds, scores, currentQuestionId, questionStartTime, currentTurnPlayerId, questionsAsked, gameStartTime, eliminatedPlayers, full, activePlayers, ];
}

class Scores extends Equatable {
  Scores({required this.json});
  final Map<String,dynamic> json;

  factory Scores.fromJson(Map<String, dynamic> json){
    return Scores(
        json: json
    );
  }

  @override
  List<Object?> get props => [
  ];
}

class VictoryCondition extends Equatable {
  VictoryCondition({
    required this.type,
    required this.value,
    required this.questionType,
  });

  final String? type;
  final int? value;
  final String? questionType;

  factory VictoryCondition.fromJson(Map<String, dynamic> json){
    return VictoryCondition(
      type: json["type"],
      value: json["value"],
      questionType: json["questionType"],
    );
  }

  @override
  List<Object?> get props => [
    type, value, questionType, ];
}

class WinCondition extends Equatable {
  WinCondition({
    required this.type,
    required this.value,
  });

  final String? type;
  final int? value;

  factory WinCondition.fromJson(Map<String, dynamic> json){
    return WinCondition(
      type: json["type"],
      value: json["value"],
    );
  }

  @override
  List<Object?> get props => [
    type, value, ];
}
