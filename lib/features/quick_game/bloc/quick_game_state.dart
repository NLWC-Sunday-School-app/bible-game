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
    this.noOfCorrectAnswers = 0
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
    int? noOfCorrectAnswers
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
      noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers
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
        quickGameCompleted
      ];
}
