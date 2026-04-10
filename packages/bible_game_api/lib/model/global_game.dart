import 'dart:convert';

import 'package:equatable/equatable.dart';

List<GlobalGame> gamesFromJson(String str) =>
    List<GlobalGame>.from(json.decode(str).map((x) => GlobalGame.fromJson(x)));

class GlobalGame extends Equatable {
  int id;
  String title;
  String description;
  String imageUrl;
  String campaignTag;
  bool gameIsActive;
  bool? isComingSoon;
  String? startDate;
  String? endDate;

  GlobalGame(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.campaignTag,
      this.gameIsActive = false,
      this.isComingSoon = false,
      this.startDate,
      this.endDate});

  factory GlobalGame.fromJson(Map<String, dynamic> json) => GlobalGame(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image"],
        campaignTag: json["campaign_tag"],
        gameIsActive: json["is_active"],
        isComingSoon: json["is_coming_soon"],
        startDate: json["start_date"],
        endDate: json["end_date"],
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        campaignTag,
        gameIsActive,
        isComingSoon,
        startDate,
        endDate,
      ];
}
