part of 'true_or_false_bloc.dart';

class TrueOrFalseState extends Equatable {
  final List<Map<String, dynamic>> allQuestions;
  final List<int> currentSessionIndices;
  final bool isLoaded;
  final int highScore;
  final int totalGamesPlayed;
  final int bestStreak;
  final int currentQuestionIndex;
  final int questionsPerGame;
  final int correctAnswers;
  final bool hasAnswered;
  final bool? isCorrect;
  final bool? selectedAnswer;
  final bool gameCompleted;
  final bool gameInProgress;
  final int coinsGained;
  final int currentStreak;
  final int highestStreakThisGame;

  /// Tracks each answered question for review at the end.
  /// Each entry: {'questionIndex': int, 'userAnswer': bool?, 'isCorrect': bool}
  final List<Map<String, dynamic>> answerHistory;

  /// Whether the score was submitted to the server (false = enqueued for later sync).
  final bool scoreSubmitted;

  const TrueOrFalseState({
    this.allQuestions = const [],
    this.currentSessionIndices = const [],
    this.isLoaded = false,
    this.highScore = 0,
    this.totalGamesPlayed = 0,
    this.bestStreak = 0,
    this.currentQuestionIndex = 0,
    this.questionsPerGame = 20,
    this.correctAnswers = 0,
    this.hasAnswered = false,
    this.isCorrect,
    this.selectedAnswer,
    this.gameCompleted = false,
    this.gameInProgress = false,
    this.coinsGained = 0,
    this.currentStreak = 0,
    this.highestStreakThisGame = 0,
    this.answerHistory = const [],
    this.scoreSubmitted = false,
  });

  TrueOrFalseState copyWith({
    List<Map<String, dynamic>>? allQuestions,
    List<int>? currentSessionIndices,
    bool? isLoaded,
    int? highScore,
    int? totalGamesPlayed,
    int? bestStreak,
    int? currentQuestionIndex,
    int? questionsPerGame,
    int? correctAnswers,
    bool? hasAnswered,
    bool? isCorrect,
    bool? selectedAnswer,
    bool? gameCompleted,
    bool? gameInProgress,
    int? coinsGained,
    int? currentStreak,
    int? highestStreakThisGame,
    List<Map<String, dynamic>>? answerHistory,
    bool? scoreSubmitted,
  }) {
    return TrueOrFalseState(
      allQuestions: allQuestions ?? this.allQuestions,
      currentSessionIndices:
          currentSessionIndices ?? this.currentSessionIndices,
      isLoaded: isLoaded ?? this.isLoaded,
      highScore: highScore ?? this.highScore,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      bestStreak: bestStreak ?? this.bestStreak,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      questionsPerGame: questionsPerGame ?? this.questionsPerGame,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      gameCompleted: gameCompleted ?? this.gameCompleted,
      gameInProgress: gameInProgress ?? this.gameInProgress,
      coinsGained: coinsGained ?? this.coinsGained,
      currentStreak: currentStreak ?? this.currentStreak,
      highestStreakThisGame:
          highestStreakThisGame ?? this.highestStreakThisGame,
      answerHistory: answerHistory ?? this.answerHistory,
      scoreSubmitted: scoreSubmitted ?? this.scoreSubmitted,
    );
  }

  @override
  List<Object?> get props => [
        allQuestions,
        currentSessionIndices,
        isLoaded,
        highScore,
        totalGamesPlayed,
        bestStreak,
        currentQuestionIndex,
        questionsPerGame,
        correctAnswers,
        hasAnswered,
        isCorrect,
        selectedAnswer,
        gameCompleted,
        gameInProgress,
        coinsGained,
        currentStreak,
        highestStreakThisGame,
        answerHistory,
        scoreSubmitted,
      ];
}
