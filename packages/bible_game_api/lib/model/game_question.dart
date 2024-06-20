
import 'dart:convert';

List<GameQuestion> questionFromJson(String str) => List<GameQuestion>.from(json.decode(str)['plays'].map((x) => GameQuestion.fromJson(x)));

class GameQuestion {
  final String instruction;
  final String answer;
  final String question;
  final List<dynamic> options;

  GameQuestion({
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

}