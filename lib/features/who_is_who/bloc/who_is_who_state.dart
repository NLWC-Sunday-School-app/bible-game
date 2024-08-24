part of 'who_is_who_bloc.dart';

class WhoIsWhoState extends Equatable {
  final List<WhoIsWhoGameLevel> wiwGameLevels;
  final List<GameQuestion>? wiwGameQuestions;
  final int? gameDuration;
  final int? coinsPerQuestion;
  final bool? isLoadingGameLevels;
  final bool? isLoadingGameQuestions;
  final bool wiwGameQuestionsLoaded;
  final int? coinsGained;
  final int? totalCorrectAnswers;
  final int? noOfQuestionsAnswered;
  final int? totalTimeSpent;
  final String? correctAnswer;
  final bool? isCorrectAnswer;
  final int? selectedOptionIndex;
  final bool? hasAnswered;
  final int? noOfCorrectAnswers;
  final bool completedSelectedLevel;
  final int? selectedGameLevel;

  const WhoIsWhoState({
    this.wiwGameLevels = const [],
    this.wiwGameQuestions = const [],
    this.gameDuration = 0,
    this.coinsPerQuestion = 0,
    this.isLoadingGameLevels = false,
    this.isLoadingGameQuestions = false,
    this.wiwGameQuestionsLoaded = false,
    this.coinsGained = 0,
    this.totalCorrectAnswers = 0,
    this.noOfQuestionsAnswered = 0,
    this.totalTimeSpent = 0,
    this.correctAnswer,
    this.isCorrectAnswer,
    this.selectedOptionIndex,
    this.hasAnswered = false,
    this.noOfCorrectAnswers = 0,
    this.completedSelectedLevel = false,
    this.selectedGameLevel,
  });

  WhoIsWhoState copyWith({
    List<WhoIsWhoGameLevel>? wiwGameLevels,
      List<GameQuestion>? wiwGameQuestions,
      int? gameDuration,
      int? coinsPerQuestion,
      bool? isLoadingGameLevels,
      bool? isLoadingGameQuestions,
      bool? wiwGameQuestionsLoaded,
      int? coinsGained,
      int? totalCorrectAnswers,
      int? noOfQuestionsAnswered,
      int? totalTimeSpent,
      String? correctAnswer,
      bool? isCorrectAnswer,
      int? selectedOptionIndex,
      bool? hasAnswered,
      int? noOfCorrectAnswers,
      bool? completedSelectedLevel,
      int? selectedGameLevel}) {
    return WhoIsWhoState(
        wiwGameLevels: wiwGameLevels ?? this.wiwGameLevels,
        wiwGameQuestions: wiwGameQuestions ?? this.wiwGameQuestions,
        gameDuration: gameDuration ?? this.gameDuration,
        coinsPerQuestion: coinsPerQuestion ?? this.coinsPerQuestion,
        isLoadingGameLevels: isLoadingGameLevels ?? this.isLoadingGameLevels,
        isLoadingGameQuestions:
            isLoadingGameQuestions ?? this.isLoadingGameQuestions,
        wiwGameQuestionsLoaded:
            wiwGameQuestionsLoaded ?? this.wiwGameQuestionsLoaded,
        coinsGained: coinsGained ?? this.coinsGained,
        totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
        noOfQuestionsAnswered:
            noOfQuestionsAnswered ?? this.noOfQuestionsAnswered,
        totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
        correctAnswer: correctAnswer ?? null,
        isCorrectAnswer: isCorrectAnswer ?? null,
        selectedOptionIndex: selectedOptionIndex ?? null,
        hasAnswered: hasAnswered ?? this.hasAnswered,
        noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
        completedSelectedLevel:
            completedSelectedLevel ?? this.completedSelectedLevel,
        selectedGameLevel: selectedGameLevel ?? this.selectedGameLevel);
  }

  @override
  List<Object?> get props => [
        wiwGameLevels,
        wiwGameQuestions,
        gameDuration,
        coinsPerQuestion,
        isLoadingGameLevels,
        isLoadingGameQuestions,
        wiwGameQuestionsLoaded,
        coinsGained,
        totalCorrectAnswers,
        noOfQuestionsAnswered,
        totalTimeSpent,
        correctAnswer,
        isCorrectAnswer,
        selectedOptionIndex,
        hasAnswered,
        noOfCorrectAnswers,
        completedSelectedLevel,
        selectedGameLevel
      ];
}
