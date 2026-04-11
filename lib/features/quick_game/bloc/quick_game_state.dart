part of 'quick_game_bloc.dart';

class QuickGameState extends Equatable {
  final List<QuickGameTopic>? quickGameTopics;
  final List<QuickGameTopic>? selectedGameTopics;
  final List<GameQuestion>? quickGameQuestions;
  final int? durationPerQuestion;
  final int? coinsPerQuestion;
  final bool? isLoadingGameTopics;
  final bool? isLoadingGameQuestions;
  final bool? hasReachedMaximumTopicSelection;
  final int?  coinsGained;
  final int? totalCorrectAnswers;
  final int? totalCoinsGained;
  final int? totalTimeSpent;
  final int? totalBonusCoinsGained;
  final bool? quickGameQuestionLoaded;
  final String? correctAnswer;
  final bool? isCorrectAnswer;
  final int? selectedOptionIndex;
  final bool hasAnswered;
  final bool quickGameCompleted;
  final int noOfCorrectAnswers;
  final int currentStreak;
  final int bestStreak;
  // Power-ups
  final bool fiftyFiftyUsed;
  final List<int> eliminatedOptionIndices;
  final bool timeFreezeUsed;
  final bool timeFreezeTriggered; // true for one frame when freeze fires
  final bool doubleCoinsActive;
  final bool secondChanceAvailable; // user owns & activated for this game
  final bool secondChanceUsed; // consumed on first wrong answer
  final bool secondChanceTriggered; // true for one frame when second chance fires

  const QuickGameState({
    this.quickGameTopics = const [],
    this.selectedGameTopics = const [],
    this.quickGameQuestions = const [],
    this.durationPerQuestion = 0,
    this.coinsPerQuestion = 0,
    this.isLoadingGameQuestions = false,
    this.isLoadingGameTopics = false,
    this.hasReachedMaximumTopicSelection = false,
    this.totalCorrectAnswers = 0,
    this.totalCoinsGained = 0,
    this.coinsGained = 0,
    this.totalBonusCoinsGained = 0,
    this.totalTimeSpent = 0,
    this.quickGameQuestionLoaded = false,
    this.correctAnswer,
    this.selectedOptionIndex,
    this.isCorrectAnswer,
    this.hasAnswered = false,
    this.quickGameCompleted = false,
    this.noOfCorrectAnswers = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.fiftyFiftyUsed = false,
    this.eliminatedOptionIndices = const [],
    this.timeFreezeUsed = false,
    this.timeFreezeTriggered = false,
    this.doubleCoinsActive = false,
    this.secondChanceAvailable = false,
    this.secondChanceUsed = false,
    this.secondChanceTriggered = false,
  });

  QuickGameState copyWith({
    List<QuickGameTopic>? quickGameTopics,
    List<QuickGameTopic>? selectedGameTopics,
    List<GameQuestion>? quickGameQuestions,
    int? durationPerQuestion,
    int? coinsPerQuestion,
    bool? isLoadingGameTopics,
    bool? isLoadingGameQuestions,
    bool? hasReachedMaximumTopicSelection,
    int? totalCorrectAnswers,
    int? coinsGained,
    int? totalCoinsGained,
    int? totalTimeSpent,
    int? totalBonusCoinsGained,
    bool? quickGameQuestionLoaded,
    String? correctAnswer,
    int? selectedOptionIndex,
    bool? isCorrectAnswer,
    bool? hasAnswered,
    bool? quickGameCompleted,
    int? noOfCorrectAnswers,
    int? currentStreak,
    int? bestStreak,
    bool? fiftyFiftyUsed,
    List<int>? eliminatedOptionIndices,
    bool? timeFreezeUsed,
    bool? timeFreezeTriggered,
    bool? doubleCoinsActive,
    bool? secondChanceAvailable,
    bool? secondChanceUsed,
    bool? secondChanceTriggered,
  }) {
    return QuickGameState(
      quickGameTopics: quickGameTopics ?? this.quickGameTopics,
      selectedGameTopics: selectedGameTopics ?? this.selectedGameTopics,
      quickGameQuestions: quickGameQuestions ?? this.quickGameQuestions,
      durationPerQuestion: durationPerQuestion ?? this.durationPerQuestion,
      coinsPerQuestion: coinsPerQuestion ?? this.coinsPerQuestion,
      isLoadingGameTopics: isLoadingGameTopics ?? this.isLoadingGameTopics,
      isLoadingGameQuestions:
          isLoadingGameQuestions ?? this.isLoadingGameQuestions,
      hasReachedMaximumTopicSelection: hasReachedMaximumTopicSelection ??
          this.hasReachedMaximumTopicSelection,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      coinsGained: coinsGained ?? this.coinsGained,
      totalCoinsGained: totalCoinsGained ?? this.totalCoinsGained,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      totalBonusCoinsGained:
          totalBonusCoinsGained ?? this.totalBonusCoinsGained,
      quickGameQuestionLoaded:
          quickGameQuestionLoaded ?? this.quickGameQuestionLoaded,
      correctAnswer: correctAnswer ?? null,
      selectedOptionIndex: selectedOptionIndex ?? null,
      isCorrectAnswer: isCorrectAnswer ?? null,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      quickGameCompleted: quickGameCompleted ?? this.quickGameCompleted,
      noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      fiftyFiftyUsed: fiftyFiftyUsed ?? this.fiftyFiftyUsed,
      eliminatedOptionIndices: eliminatedOptionIndices ?? this.eliminatedOptionIndices,
      timeFreezeUsed: timeFreezeUsed ?? this.timeFreezeUsed,
      timeFreezeTriggered: timeFreezeTriggered ?? false,
      doubleCoinsActive: doubleCoinsActive ?? this.doubleCoinsActive,
      secondChanceAvailable: secondChanceAvailable ?? this.secondChanceAvailable,
      secondChanceUsed: secondChanceUsed ?? this.secondChanceUsed,
      secondChanceTriggered: secondChanceTriggered ?? false,
    );
  }

  @override
  List<Object?> get props => [
        quickGameTopics,
        selectedGameTopics,
        quickGameQuestions,
        durationPerQuestion,
        coinsPerQuestion,
        isLoadingGameTopics,
        isLoadingGameQuestions,
        hasReachedMaximumTopicSelection,
        totalCorrectAnswers,
        coinsGained,
        totalCoinsGained,
        totalTimeSpent,
        totalBonusCoinsGained,
        quickGameQuestionLoaded,
        correctAnswer,
        selectedOptionIndex,
        isCorrectAnswer,
        hasAnswered,
        quickGameCompleted,
        currentStreak,
        bestStreak,
        fiftyFiftyUsed,
        eliminatedOptionIndices,
        timeFreezeUsed,
        timeFreezeTriggered,
        doubleCoinsActive,
        secondChanceAvailable,
        secondChanceUsed,
        secondChanceTriggered,
      ];
}
