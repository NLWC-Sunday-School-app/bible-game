
import 'dart:convert';

import 'package:equatable/equatable.dart';

List<WhoIsWhoGameLevel> whoIsWhoGameLevelFromJson(String str) => List<WhoIsWhoGameLevel>.from(json.decode(str).map((x) => WhoIsWhoGameLevel.fromJson(x)));

String whoIsWhoGameLevelToJson(List<WhoIsWhoGameLevel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WhoIsWhoGameLevel extends Equatable {
  final String alias;
  final String backgroundImage;
  final int reward;
  final bool isSpecialLevel;
  final int playTime;
  final bool isUnlocked;
  final String groupName;

  WhoIsWhoGameLevel({
    required this.alias,
    required this.backgroundImage,
    required this.reward,
    required this.isSpecialLevel,
    required this.playTime,
    required this.isUnlocked,
    required this.groupName,
  });

  factory WhoIsWhoGameLevel.fromJson(Map<String, dynamic> json) => WhoIsWhoGameLevel(
    alias: json["alias"],
    backgroundImage: json["backgroundImage"],
    reward: json["reward"],
    isSpecialLevel: json["isSpecialLevel"],
    playTime: json["playTime"],
    isUnlocked: json["isUnlocked"],
    groupName: json["groupName"],
  );

  Map<String, dynamic> toJson() => {
    "alias": alias,
    "backgroundImage": backgroundImage,
    "reward": reward,
    "isSpecialLevel": isSpecialLevel,
    "playTime": playTime,
    "isUnlocked": isUnlocked,
    "groupName": groupName,
  };

  @override
  List<Object?> get props => [alias, backgroundImage, reward, isSpecialLevel, playTime, isUnlocked, groupName];
}
