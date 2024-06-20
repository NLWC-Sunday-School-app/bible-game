
import 'dart:convert';

List<FourScripturesOneWordQuestion> fourScripturesFromJson(String str) => List<FourScripturesOneWordQuestion>.from(json.decode(str).map((x) => FourScripturesOneWordQuestion.fromJson(x)));


class FourScripturesOneWordQuestion {
  FourScripturesOneWordQuestion({
    required this.id,
    required this.scriptureOne,
    required this.scriptureTwo,
    required this.scriptureThree,
    required this.scriptureFour,
    required this.answer,
  });

  int id;
  String scriptureOne;
  String scriptureTwo;
  String scriptureThree;
  String scriptureFour;
  String answer;

  factory FourScripturesOneWordQuestion.fromJson(Map<String, dynamic> json) => FourScripturesOneWordQuestion(
    id: json["id"],
    scriptureOne: json["scriptureOne"],
    scriptureTwo: json["scriptureTwo"],
    scriptureThree: json["scriptureThree"],
    scriptureFour: json["scriptureFour"],
    answer: json["answer"],
  );
}
