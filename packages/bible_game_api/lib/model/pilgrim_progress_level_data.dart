import 'dart:convert';

List<PilgrimProgressLevelData> adsFromJson(String str) => List<PilgrimProgressLevelData>.from(json.decode(str).map((x) => PilgrimProgressLevelData.fromJson(x)));


class PilgrimProgressLevelData{
  int id;
  int userId;
  int rankId;
  int progress;
  int numberOfRounds;
  PilgrimProgressLevelData({required this.id, required this.userId, required this.rankId, required this.numberOfRounds, required this.progress});

  factory PilgrimProgressLevelData.fromJson(Map<String, dynamic> json) => PilgrimProgressLevelData(
    id: json["id"],
    userId: json["userId"],
    rankId: json["rankId"],
    progress: json["progress"],
    numberOfRounds: json["numberOfRounds"]
  );


}