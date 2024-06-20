import 'dart:convert';

List<Leaderboard> leaderBoardFromJson(String str) => List<Leaderboard>.from(json.decode(str).map((x) => Leaderboard.fromJson(x)));
List<Leaderboard> leaderBoardFromDataJson(String str) => List<Leaderboard>.from(json.decode(str)['data'].map((x) => Leaderboard.fromJson(x)));


class Leaderboard{
  int playerId;
  int playerScore;
  String playerName;
  int playerPosition;

  Leaderboard({required this.playerId, required this.playerScore, required this.playerPosition, required this. playerName});

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
      playerId: json["playerId"],
      playerScore: json["totalScore"],
      playerName: json["playerName"],
      playerPosition: json["position"]
  );


}
