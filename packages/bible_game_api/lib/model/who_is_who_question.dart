

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<WhoIsWhoQuestion> whoIsWhoQuestionFromJson(String str) => List<WhoIsWhoQuestion>.from(json.decode(str).map((x) => WhoIsWhoQuestion.fromJson(x)));


class WhoIsWhoQuestion extends Equatable {
  final String instruction;
  final String question;
  final String category;
  final List<String> options;
  final String answer;

  const WhoIsWhoQuestion({
    required this.instruction,
    required this.question,
    required this.category,
    required this.options,
    required this.answer,
  });

  factory WhoIsWhoQuestion.fromJson(Map<String, dynamic> json) => WhoIsWhoQuestion(
    instruction: json["instruction"],
    question: json["question"],
    category: json["category"],
    options: List<String>.from(json["options"].map((x) => x)),
    answer: json["correct_option"],
  );

  @override
  List<Object?> get props => [];


}

