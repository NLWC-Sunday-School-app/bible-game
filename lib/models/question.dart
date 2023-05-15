
import 'dart:convert';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str)['plays'].map((x) => Question.fromJson(x)));


class Question {
  final String instruction;
  final String answer;
  final String question;
  final List<dynamic> options;

  Question({
    required this.instruction,
    required this.answer,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    instruction: json["instruction"],
    question: json["question"],
    answer: json["correct_option"],
    options: json["options"]
  );

}

 const List adsImage = [
  {
    'id': 1,
    'imageUrl': 'assets/images/ads/ads1.jpeg'
  },
  {
    'id': 2,
    'imageUrl': 'assets/images/ads/ads2.jpeg'
  },
  {
    'id': 3,
    'imageUrl':'assets/images/ads/ads3.jpeg'
  },
  {
    'id': 4,
    'imageUrl': 'assets/images/ads/ads4.jpeg'
  },
];

