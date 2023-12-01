

import 'dart:convert';

List<WhoIsWho> whoIsWhoFromJson(String str) => List<WhoIsWho>.from(json.decode(str).map((x) => WhoIsWho.fromJson(x)));

String whoIsWhoToJson(List<WhoIsWho> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WhoIsWho {
  final String question;
  final String category;
  final List<String> options;
  final String correctOption;

  WhoIsWho({
    required this.question,
    required this.category,
    required this.options,
    required this.correctOption,
  });

  factory WhoIsWho.fromJson(Map<String, dynamic> json) => WhoIsWho(
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

