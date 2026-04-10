
import 'dart:convert';

import 'package:equatable/equatable.dart';

List<GameQuestion> questionFromJson(String str) => List<GameQuestion>.from(json.decode(str)['plays'].map((x) => GameQuestion.fromJson(x)));

class GameQuestion extends Equatable {
  final String instruction;
  final String answer;
  final String question;
  final List<dynamic> options;

  const GameQuestion({
    required this.instruction,
    required this.answer,
    required this.question,
    required this.options,
  });

  factory GameQuestion.fromJson(Map<String, dynamic> json) => GameQuestion(
      instruction: json["instruction"],
      question: json["question"],
      answer: json["correct_option"],
      options: json["options"]
  );

  @override

  List<Object?> get props => [instruction, question, answer, options];

}