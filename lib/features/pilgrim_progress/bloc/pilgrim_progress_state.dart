part of 'pilgrim_progress_bloc.dart';

class PilgrimProgressState extends Equatable {
  final List<PilgrimProgressLevelData> pilgrimProgressLevelData;
  final List<GameQuestion>? pilgrimProgressQuestions;
  final int? durationPerQuestion;
  final int? coinsPerQuestion;
  final int coinsGained;
  final int? totalCorrectAnswers;
  final int? totalCoinsGained;
  final int? totalTimeSpent;
  final int? totalBonusCoinsGained;
  final String? correctAnswer;
  final bool? isCorrectAnswer;
  final int? selectedOptionIndex;
  final bool hasAnswered;
  final bool quickGameCompleted;
  final int noOfCorrectAnswers;
  final bool childLevelIsLocked;
  final bool youngBelieversLevelIsLocked;
  final bool charityLevelIsLocked;
  final bool fatherLevelIsLocked;
  final bool elderLevelIsLocked;
  final int totalPointsGainedInBabe;
  final int totalPointsGainedInChild;
  final int totalPointsGainedInYb;
  final int totalPointsGainedInCharity;
  final int totalPointsGainedInFather;
  final int totalPointsGainedInElder;
  final int passOnFirstTrialScore;
  final bool? pilgrimProgressQuestionLoaded;
  final int? roundsLeftForSelectedLevel;
  final int? noOfTrialForSelectedLevel;
  final int? totalCoinsAvailableForSelectedLevel;
  final String? selectedGameLevel;
  final bool hasUnlockedNewRank;
  final String? newRankUnlocked;
  final String? newRankBadgeSrc;
  final bool userHasToRetry;

  const PilgrimProgressState(
      {this.pilgrimProgressQuestions = const [],
      this.durationPerQuestion = 0,
      this.coinsPerQuestion = 0,
      this.totalCorrectAnswers = 0,
      this.totalCoinsGained = 0,
      this.coinsGained = 0,
      this.totalBonusCoinsGained = 0,
      this.totalTimeSpent = 0,
      this.correctAnswer,
      this.selectedOptionIndex,
      this.isCorrectAnswer,
      this.hasAnswered = false,
      this.quickGameCompleted = false,
      this.noOfCorrectAnswers = 0,
      this.childLevelIsLocked = false,
      this.youngBelieversLevelIsLocked = false,
      this.charityLevelIsLocked = false,
      this.fatherLevelIsLocked = false,
      this.elderLevelIsLocked = false,
      this.totalPointsGainedInBabe = 0,
      this.totalPointsGainedInChild = 0,
      this.totalPointsGainedInYb = 0,
      this.totalPointsGainedInCharity = 0,
      this.totalPointsGainedInFather = 0,
      this.totalPointsGainedInElder = 0,
      this.passOnFirstTrialScore = 0,
      this.pilgrimProgressLevelData = const [],
      this.pilgrimProgressQuestionLoaded = false,
      this.roundsLeftForSelectedLevel = 0,
      this.noOfTrialForSelectedLevel = 0,
      this.totalCoinsAvailableForSelectedLevel = 0,
      this.selectedGameLevel,
      this.hasUnlockedNewRank = false,
      this.newRankUnlocked,
      this.newRankBadgeSrc,
      this.userHasToRetry = false});

  PilgrimProgressState copyWith({
    List<PilgrimProgressLevelData>? pilgrimProgressLevelData,
    List<GameQuestion>? pilgrimProgressQuestions,
    int? durationPerQuestion,
    int? coinsPerQuestion,
    int? totalCorrectAnswers,
    int? coinsGained,
    int? totalCoinsGained,
    int? totalTimeSpent,
    int? totalBonusCoinsGained,
    String? correctAnswer,
    int? selectedOptionIndex,
    bool? isCorrectAnswer,
    bool? hasAnswered,
    bool? quickGameCompleted,
    int? noOfCorrectAnswers,
    bool? childLevelIsLocked,
    bool? youngBelieversLevelIsLocked,
    bool? charityLevelIsLocked,
    bool? fatherLevelIsLocked,
    bool? elderLevelIsLocked,
    int? totalPointsGainedInBabe,
    int? totalPointsGainedInChild,
    int? totalPointsGainedInYb,
    int? totalPointsGainedInCharity,
    int? totalPointsGainedInFather,
    int? totalPointsGainedInElder,
    int? passOnFirstTrialScore,
    bool? pilgrimProgressQuestionLoaded,
    int? roundsLeftForSelectedLevel,
    int? noOfTrialForSelectedLevel,
    int? totalCoinsAvailableForSelectedLevel,
    String? selectedGameLevel,
    bool? hasUnlockedNewRank,
    String? newRankUnlocked,
    String? newRankBadgeSrc,
    bool? userHasToRetry,
  }) {
    return PilgrimProgressState(
        pilgrimProgressLevelData:
            pilgrimProgressLevelData ?? this.pilgrimProgressLevelData,
        pilgrimProgressQuestions:
            pilgrimProgressQuestions ?? this.pilgrimProgressQuestions,
        durationPerQuestion: durationPerQuestion ?? this.durationPerQuestion,
        coinsPerQuestion: coinsPerQuestion ?? this.coinsPerQuestion,
        totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
        coinsGained: coinsGained ?? this.coinsGained,
        totalCoinsGained: totalCoinsGained ?? this.totalCoinsGained,
        totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
        totalBonusCoinsGained:
            totalBonusCoinsGained ?? this.totalBonusCoinsGained,
        correctAnswer: correctAnswer ?? null,
        selectedOptionIndex: selectedOptionIndex ?? null,
        isCorrectAnswer: isCorrectAnswer ?? null,
        hasAnswered: hasAnswered ?? this.hasAnswered,
        quickGameCompleted: quickGameCompleted ?? this.quickGameCompleted,
        noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
        childLevelIsLocked: childLevelIsLocked ?? this.childLevelIsLocked,
        youngBelieversLevelIsLocked:
            youngBelieversLevelIsLocked ?? this.youngBelieversLevelIsLocked,
        charityLevelIsLocked: charityLevelIsLocked ?? this.charityLevelIsLocked,
        fatherLevelIsLocked: fatherLevelIsLocked ?? this.fatherLevelIsLocked,
        elderLevelIsLocked: elderLevelIsLocked ?? this.elderLevelIsLocked,
        totalPointsGainedInBabe:
            totalPointsGainedInBabe ?? this.totalPointsGainedInBabe,
        totalPointsGainedInChild:
            totalPointsGainedInChild ?? this.totalPointsGainedInChild,
        totalPointsGainedInYb:
            totalPointsGainedInYb ?? this.totalPointsGainedInYb,
        totalPointsGainedInCharity:
            totalPointsGainedInCharity ?? this.totalPointsGainedInCharity,
        totalPointsGainedInFather:
            totalPointsGainedInFather ?? this.totalPointsGainedInFather,
        totalPointsGainedInElder:
            totalPointsGainedInElder ?? this.totalPointsGainedInElder,
        pilgrimProgressQuestionLoaded:
            pilgrimProgressQuestionLoaded ?? this.pilgrimProgressQuestionLoaded,
        roundsLeftForSelectedLevel:
            roundsLeftForSelectedLevel ?? this.roundsLeftForSelectedLevel,
        noOfTrialForSelectedLevel:
            noOfTrialForSelectedLevel ?? this.noOfTrialForSelectedLevel,
        passOnFirstTrialScore:
            passOnFirstTrialScore ?? this.passOnFirstTrialScore,
        totalCoinsAvailableForSelectedLevel:
            totalCoinsAvailableForSelectedLevel ??
                this.totalCoinsAvailableForSelectedLevel,
        selectedGameLevel: selectedGameLevel ?? this.selectedGameLevel,
        hasUnlockedNewRank: hasUnlockedNewRank ?? this.hasUnlockedNewRank,
        newRankUnlocked: newRankUnlocked ?? this.newRankUnlocked,
        newRankBadgeSrc: newRankBadgeSrc ?? this.newRankBadgeSrc,
        userHasToRetry: userHasToRetry ?? this.userHasToRetry);
  }

  @override
  List<Object?> get props => [
        pilgrimProgressLevelData,
        pilgrimProgressQuestions,
        durationPerQuestion,
        coinsPerQuestion,
        totalCoinsGained,
        totalTimeSpent,
        totalBonusCoinsGained,
        correctAnswer,
        selectedOptionIndex,
        isCorrectAnswer,
        hasAnswered,
        childLevelIsLocked,
        youngBelieversLevelIsLocked,
        charityLevelIsLocked,
        fatherLevelIsLocked,
        elderLevelIsLocked,
        totalPointsGainedInBabe,
        totalPointsGainedInChild,
        totalPointsGainedInYb,
        totalPointsGainedInCharity,
        totalPointsGainedInFather,
        totalPointsGainedInElder,
        pilgrimProgressQuestionLoaded,
        roundsLeftForSelectedLevel,
        noOfTrialForSelectedLevel,
        totalCoinsAvailableForSelectedLevel,
        selectedGameLevel,
        passOnFirstTrialScore,
        hasUnlockedNewRank,
        newRankUnlocked,
        newRankBadgeSrc,
        userHasToRetry,
        coinsGained,
      ];
}
