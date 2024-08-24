part of 'global_challenge_bloc.dart';

class GlobalChallengeState extends Equatable {
  final List<GlobalGame> globalChallengeGames;
  final bool isFetchingGames;
  final List<GameQuestion>? globalChallengeQuestions;
  final int? durationPerQuestion;
  final int? coinsPerQuestion;
  final bool? isLoadingGameQuestions;
  final int? coinsGained;
  final int? totalBonusCoinsGained;
  final int? totalTimeSpent;
  final bool? globalGameQuestionLoaded;
  final String? correctAnswer;
  final int? selectedOptionIndex;
  final bool hasAnswered;
  final bool? isCorrectAnswer;
  final bool? quickGameCompleted;
  final int noOfCorrectAnswers;
  final List<GlobalChallengeLeaderboard> globalChallengeLeaderboard;
  final bool isFetchingGlobalChallengeLeaderboard;

  const GlobalChallengeState(
      {this.globalChallengeGames = const [],
      this.globalChallengeQuestions = const [],
      this.globalChallengeLeaderboard = const [],
      this.isFetchingGames = false,
      this.durationPerQuestion = 0,
      this.coinsPerQuestion = 0,
      this.coinsGained = 0,
      this.correctAnswer,
      this.isLoadingGameQuestions = false,
      this.totalTimeSpent = 0,
      this.totalBonusCoinsGained = 0,
      this.globalGameQuestionLoaded = false,
      this.selectedOptionIndex,
      this.hasAnswered = false,
      this.quickGameCompleted = false,
      this.isCorrectAnswer,
      this.noOfCorrectAnswers = 0,
      this.isFetchingGlobalChallengeLeaderboard = false});

  GlobalChallengeState copyWith(
      {List<GlobalGame>? globalChallengeGames,
      bool? isFetchingGames,
      List<GameQuestion>? globalChallengeQuestion,
      int? durationPerQuestion,
      int? coinsPerQuestion,
      bool? isLoadingGameQuestions,
      int? coinsGained,
      int? totalTimeSpent,
      bool? globalGameQuestionLoaded,
      String? correctAnswer,
      int? selectedOptionIndex,
      int? totalBonusCoinsGained,
      bool? hasAnswered,
      bool? isCorrectAnswer,
      bool? quickGameCompleted,
      int? noOfCorrectAnswers,
      List<GlobalChallengeLeaderboard>? globalChallengeLeaderboard,
      bool? isFetchingGlobalChallengeLeaderboard}) {
    return GlobalChallengeState(
        globalChallengeGames: globalChallengeGames ?? this.globalChallengeGames,
        isFetchingGames: isFetchingGames ?? this.isFetchingGames,
        globalChallengeQuestions:
            globalChallengeQuestion ?? this.globalChallengeQuestions,
        durationPerQuestion: durationPerQuestion ?? this.durationPerQuestion,
        coinsPerQuestion: coinsPerQuestion ?? this.coinsPerQuestion,
        totalBonusCoinsGained:
            totalBonusCoinsGained ?? this.totalBonusCoinsGained,
        isLoadingGameQuestions:
            isLoadingGameQuestions ?? this.isLoadingGameQuestions,
        coinsGained: coinsGained ?? this.coinsGained,
        totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
        globalGameQuestionLoaded:
            globalGameQuestionLoaded ?? this.globalGameQuestionLoaded,
        correctAnswer: correctAnswer ?? null,
        selectedOptionIndex: selectedOptionIndex ?? null,
        hasAnswered: hasAnswered ?? this.hasAnswered,
        isCorrectAnswer: isCorrectAnswer ?? null,
        quickGameCompleted: quickGameCompleted ?? this.quickGameCompleted,
        noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
        globalChallengeLeaderboard:
            globalChallengeLeaderboard ?? this.globalChallengeLeaderboard,
        isFetchingGlobalChallengeLeaderboard:
            isFetchingGlobalChallengeLeaderboard ??
                this.isFetchingGlobalChallengeLeaderboard);
  }

  @override
  List<Object?> get props => [
        globalChallengeGames,
        isFetchingGames,
        globalChallengeQuestions,
        durationPerQuestion,
        coinsPerQuestion,
        isLoadingGameQuestions,
        coinsGained,
        totalBonusCoinsGained,
        totalTimeSpent,
        globalGameQuestionLoaded,
        correctAnswer,
        selectedOptionIndex,
        isCorrectAnswer,
        hasAnswered,
        quickGameCompleted,
        noOfCorrectAnswers,
        globalChallengeLeaderboard,
        isFetchingGlobalChallengeLeaderboard
      ];
}
