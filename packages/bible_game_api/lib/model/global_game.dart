import 'dart:convert';

List<GlobalGame> gamesFromJson(String str) => List<GlobalGame>.from(
    json.decode(str).map((x) => GlobalGame.fromJson(x)));

class GlobalGame {
  int id;
  String title;
  String description;
  String imageUrl;
  String campaignTag;
  bool gameIsActive;
  String? startDate;
  String?endDate;

  GlobalGame(
      {required this.id,
        required this.title,
        required this.description,
        required this.imageUrl,
        required this.campaignTag,
        required this.gameIsActive,
        this.startDate,
        this.endDate
      });

  factory GlobalGame.fromJson(Map<String, dynamic> json) => GlobalGame(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    imageUrl: json["image"],
    campaignTag: json["campaign_tag"],
    gameIsActive: json["is_active"],
    startDate: json["start_date"],
    endDate: json["end_date"],
  );
}
