import 'dart:convert';

List<UserYearlyRecap> adsFromJson(String str) => List<UserYearlyRecap>.from(
    json.decode(str).map((x) => UserYearlyRecap.fromJson(x)));

class UserYearlyRecap {
  String userTopGameMode;
  int userPercentile;
  int totalNumberOfGamesPlayed;
  int totalNumberOfUserGamePlays;
  int totalMinutesSpent;
  int totalSecondsSpent;

  UserYearlyRecap({
    required this.userTopGameMode,
    required this.userPercentile,
    required this.totalNumberOfGamesPlayed,
    required this.totalMinutesSpent,
    required this.totalNumberOfUserGamePlays,
    required this.totalSecondsSpent,
  });

  factory UserYearlyRecap.fromJson(Map<String, dynamic> json) =>
      UserYearlyRecap(
        userTopGameMode: json["user_top_game_mode"],
        userPercentile: json["user_percentile"],
        totalNumberOfUserGamePlays: json["total_number_of_games_played"],
        totalMinutesSpent: json["total_minutes_spent"],
        totalSecondsSpent: json["total_seconds_spent"],
        totalNumberOfGamesPlayed: json["total_number_of_games_played"],
      );
}
