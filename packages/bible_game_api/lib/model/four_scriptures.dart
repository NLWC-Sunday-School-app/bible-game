import 'dart:convert';

import 'package:equatable/equatable.dart';

List<FourScripturesOneWordQuestion> fourScripturesFromJson(String str) =>
    List<FourScripturesOneWordQuestion>.from(
        json.decode(str).map((x) => FourScripturesOneWordQuestion.fromJson(x)));

class FourScripturesOneWordQuestion extends Equatable {
  const FourScripturesOneWordQuestion({
    required this.id,
    required this.scriptureOne,
    required this.scriptureTwo,
    required this.scriptureThree,
    required this.scriptureFour,
    required this.answer,
  });

 final int id;
 final String scriptureOne;
 final String scriptureTwo;
 final String scriptureThree;
 final String scriptureFour;
 final String answer;

  factory FourScripturesOneWordQuestion.fromJson(Map<String, dynamic> json) =>
      FourScripturesOneWordQuestion(
        id: json["id"],
        scriptureOne: json["scriptureOne"],
        scriptureTwo: json["scriptureTwo"],
        scriptureThree: json["scriptureThree"],
        scriptureFour: json["scriptureFour"],
        answer: json["answer"],
      );

  @override
  List<Object?> get props => [
        id,
        scriptureOne,
        scriptureTwo,
        scriptureThree,
        scriptureFour,
        answer,
      ];
}
