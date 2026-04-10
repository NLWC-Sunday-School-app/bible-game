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
  final String country;

  const GlobalChallengeLeaderboard(
      {required this.country,  required this.playerId,
      required this.playerScore,
      required this.playerPosition,
      required this.playerName});

  factory GlobalChallengeLeaderboard.fromJson(Map<String, dynamic> json) =>
      GlobalChallengeLeaderboard(
        playerId: json["playerId"] ?? 0,
        playerScore: json["totalScore"] ?? 0,
        playerName: json["playerName"] ?? "Unknown",
        playerPosition: json["position"] ?? 0,
        country: json["country"] ?? "N/A",
      );

  @override
  List<Object?> get props => [
        playerId,
        playerScore,
        playerName,
        playerPosition,
        country
      ];
}
