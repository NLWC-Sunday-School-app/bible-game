import 'dart:convert';

List<GlobalLeaderboard> globalLeaderBoardFromJson(String str) => List<GlobalLeaderboard>.from(json.decode(str)['data'].map((x) => GlobalLeaderboard.fromJson(x)));


class GlobalLeaderboard{
  int playerId;
  int playerScore;
  String playerName;
  int playerPosition;

  GlobalLeaderboard({required this.playerId, required this.playerScore, required this.playerPosition, required this. playerName});

  factory GlobalLeaderboard.fromJson(Map<String, dynamic> json) => GlobalLeaderboard(
    playerId: json["playerId"],
    playerScore: json["totalScore"],
    playerName: json["playerName"],
    playerPosition: json["position"]
  );


}

