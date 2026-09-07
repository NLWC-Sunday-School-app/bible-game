class MarkTime {
  dynamic questionStartTime;

  void onQuestionReceived() {
    // Mark when the question starts
    questionStartTime = DateTime.now();
  }

  Future<void> submitAnswer(String roomId, String playerId, int questionIndex,
      String selectedOption) async {
    if (questionStartTime == null) {
      throw Exception("Question start time not set");
    }

    // Calculate response time from question start to now
    final answerTime = DateTime.now();
    final responseTimeMs = answerTime
        .difference(questionStartTime!)
        .inMilliseconds;
  }
}