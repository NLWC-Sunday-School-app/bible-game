import 'dart:convert';

import 'package:equatable/equatable.dart';

List<GlobalChallengeLeaderboard> globalLeaderBoardFromJson(String str) =>
    List<GlobalChallengeLeaderboard>.from(json
        .decode(str)['data']
        .map((x) => GlobalChallengeLeaderboard.fromJson(x)));

class GlobalChallengeLeaderboard extends Equatable {
  final int playerId;
  final int playerScore;
  final String playerName;
  final int playerPosition;

  const GlobalChallengeLeaderboard(
      {required this.playerId,
      required this.playerScore,
      required this.playerPosition,
      required this.playerName});

  factory GlobalChallengeLeaderboard.fromJson(Map<String, dynamic> json) =>
      GlobalChallengeLeaderboard(
          playerId: json["playerId"],
          playerScore: json["totalScore"],
          playerName: json["playerName"],
          playerPosition: json["position"]);

  @override
  List<Object?> get props => [
        playerId,
        playerScore,
        playerName,
        playerPosition,
      ];
}
