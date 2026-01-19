class InsightRecap {
  const InsightRecap({
    required this.userTopGameMode,
    required this.userPercentile,
    required this.totalNumberOfUserGamePlays,
    required this.totalMinutesSpent,
    required this.totalQuestionsGotten,
    required this.totalCoinsGotten,
    required this.highestStreak,
    required this.peakPlayingMonth,
    required this.longestSession,
    required this.firstGameOfYear,
    required this.globalWinner,
  });

  final String? userTopGameMode;
  final int? userPercentile;
  final int? totalNumberOfUserGamePlays;
  final int? totalMinutesSpent;
  final int? totalQuestionsGotten;
  final int? totalCoinsGotten;
  final int? highestStreak;
  final PeakPlayingMonth? peakPlayingMonth;
  final LongestSession? longestSession;
  final DateTime? firstGameOfYear;
  final int? globalWinner;

  factory InsightRecap.fromJson(Map<String, dynamic> json){
    return InsightRecap(
      userTopGameMode: json["user_top_game_mode"],
      userPercentile: json["user_percentile"],
      totalNumberOfUserGamePlays: json["total_number_of_user_game_plays"],
      totalMinutesSpent: json["total_minutes_spent"],
      totalQuestionsGotten: json["total_questions_gotten"],
      totalCoinsGotten: json["total_coins_gotten"],
      highestStreak: json["highest_streak"],
      peakPlayingMonth: json["peak_playing_month"] == null ? null : PeakPlayingMonth.fromJson(json["peak_playing_month"]),
      longestSession: json["longest_session"] == null ? null : LongestSession.fromJson(json["longest_session"]),
      firstGameOfYear: DateTime.tryParse(json["first_game_of_year"] ?? ""),
      globalWinner: json["global_winner"],
    );
  }

}

class LongestSession {
  const LongestSession({
    required this.sessionTime,
    required this.sessionDate,
  });

  final int? sessionTime;
  final DateTime? sessionDate;

  factory LongestSession.fromJson(Map<String, dynamic> json){
    return LongestSession(
      sessionTime: json["sessionTime"],
      sessionDate: DateTime.tryParse(json["sessionDate"] ?? ""),
    );
  }

}

class PeakPlayingMonth {
  const PeakPlayingMonth({
    required this.month,
    required this.totalGames,
  });

  final String? month;
  final int? totalGames;

  factory PeakPlayingMonth.fromJson(Map<String, dynamic> json){
    return PeakPlayingMonth(
      month: json["month"],
      totalGames: json["totalGames"],
    );
  }

}
