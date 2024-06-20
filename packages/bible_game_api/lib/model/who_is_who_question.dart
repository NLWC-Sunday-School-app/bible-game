

import 'dart:convert';

List<WhoIsWhoQuestion> whoIsWhoQuestionFromJson(String str) => List<WhoIsWhoQuestion>.from(json.decode(str).map((x) => WhoIsWhoQuestion.fromJson(x)));

String whoIsWhoToJson(List<WhoIsWhoQuestion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WhoIsWhoQuestion {
  final String question;
  final String category;
  final List<String> options;
  final String correctOption;

  WhoIsWhoQuestion({
    required this.question,
    required this.category,
    required this.options,
    required this.correctOption,
  });

  factory WhoIsWhoQuestion.fromJson(Map<String, dynamic> json) => WhoIsWhoQuestion(
    question: json["question"],
    category: json["category"],
    options: List<String>.from(json["options"].map((x) => x)),
    correctOption: json["correct_option"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "category": category,
    "options": List<dynamic>.from(options.map((x) => x)),
    "correct_option": correctOption,
  };
}

