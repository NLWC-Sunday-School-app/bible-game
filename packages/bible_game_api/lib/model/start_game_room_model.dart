import 'package:equatable/equatable.dart';

class StartGameRoomModel extends Equatable {
  StartGameRoomModel({
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
    // required this.scores,
    required this.currentQuestionId,
    required this.questionStartTime,
    required this.currentTurnPlayerId,
    required this.questionsAsked,
    required this.gameStartTime,
    required this.eliminatedPlayers,
    required this.questions,
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
  final VicCondition? victoryCondition;
  final WinnCondition? winCondition;
  final List<String>? playerIds;
  // final Map<String, int>? scores;
  final dynamic currentQuestionId;
  final dynamic questionStartTime;
  final dynamic currentTurnPlayerId;
  final int? questionsAsked;
  final dynamic gameStartTime;
  final List<dynamic>? eliminatedPlayers;
  final Questions? questions;
  final bool? full;
  final List<String>? activePlayers;

  factory StartGameRoomModel.fromJson(Map<String, dynamic> json){
    return StartGameRoomModel(
      id: json["id"],
      inviteCode: json["inviteCode"],
      hostId: json["hostId"],
      gameMode: json["gameMode"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      maxPlayers: json["maxPlayers"],
      victoryCondition: json["victoryCondition"] == null ? null : VicCondition.fromJson(json["victoryCondition"]),
      winCondition: json["winCondition"] == null ? null : WinnCondition.fromJson(json["winCondition"]),
      playerIds: json["playerIds"] == null ? [] : List<String>.from(json["playerIds"]!.map((x) => x)),
      // scores: Map.from(json["scores"]).map((k, v) => MapEntry<String, int>(k, v)),
      currentQuestionId: json["currentQuestionId"],
      questionStartTime: json["questionStartTime"],
      currentTurnPlayerId: json["currentTurnPlayerId"],
      questionsAsked: json["questionsAsked"],
      gameStartTime: json["gameStartTime"],
      eliminatedPlayers: json["eliminatedPlayers"] == null ? [] : List<dynamic>.from(json["eliminatedPlayers"]!.map((x) => x)),
      questions: json["questions"] == null ? null : Questions.fromJson(json["questions"]),
      full: json["full"],
      activePlayers: json["activePlayers"] == null ? [] : List<String>.from(json["activePlayers"]!.map((x) => x)),
    );
  }

  @override
  List<Object?> get props => [
    id, inviteCode, hostId, gameMode, status, createdAt, maxPlayers, victoryCondition, winCondition, playerIds,
    // scores,
    currentQuestionId, questionStartTime, currentTurnPlayerId, questionsAsked, gameStartTime, eliminatedPlayers, questions, full, activePlayers, ];
}

class Questions extends Equatable {
  Questions({
    required this.data,
  });

  final List<Datum> data;

  factory Questions.fromJson(Map<String, dynamic> json){
    return Questions(
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
  @override
  List<Object?> get props => [
    data, ];
}

class Datum extends Equatable {
  Datum({
    required this.instruction,
    required this.question,
    required this.category,
    required this.options,
    required this.correctOption,
  });

  final String? instruction;
  final String? question;
  final String? category;
  final List<String> options;
  final String? correctOption;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      instruction: json["instruction"],
      question: json["question"],
      category: json["category"],
      options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
      correctOption: json["correct_option"],
    );
  }

  @override
  List<Object?> get props => [
    instruction, question, category, options, correctOption, ];
}

class VicCondition extends Equatable {
  VicCondition({
    required this.type,
    required this.value,
    required this.questionType,
  });

  final String? type;
  final int? value;
  final String? questionType;

  factory VicCondition.fromJson(Map<String, dynamic> json){
    return VicCondition(
      type: json["type"],
      value: json["value"],
      questionType: json["questionType"],
    );
  }

  @override
  List<Object?> get props => [
    type, value, questionType, ];
}

class WinnCondition extends Equatable {
  WinnCondition({
    required this.type,
    required this.value,
  });

  final String? type;
  final int? value;

  factory WinnCondition.fromJson(Map<String, dynamic> json){
    return WinnCondition(
      type: json["type"],
      value: json["value"],
    );
  }

  @override
  List<Object?> get props => [
    type, value, ];
}
