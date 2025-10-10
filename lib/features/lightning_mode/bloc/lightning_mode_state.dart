part of 'lightning_mode_bloc.dart';

class LightningModeState extends Equatable{
  final bool isLoadingStartGame;
  final bool hasStartedGame;
  final bool isLoadingGameRestart;
  final bool hasRestartedGame;
  final StartGameRoomModel startGameRoomModel;
  final String? correctAnswer;
  final int? selectedOptionIndex;
  final bool hasAnswered;
  final bool? isCorrectAnswer;
  final int coinsGained;
  final int noOfCorrectAnswers;

  const LightningModeState(
      {
        required this.isLoadingStartGame,
        required this.hasStartedGame,
        required this.startGameRoomModel,
        required this.correctAnswer,
        required this.selectedOptionIndex,
        required this.hasAnswered,
        required this.isCorrectAnswer,
        required this.coinsGained,
        required this.noOfCorrectAnswers,
        required this.isLoadingGameRestart,
        required this.hasRestartedGame,
      });

  factory LightningModeState.initial(){
    return LightningModeState(
        isLoadingStartGame: false,
        hasStartedGame: false,
        startGameRoomModel: StartGameRoomModel.fromJson({}),
        correctAnswer: null,
        selectedOptionIndex: null,
        hasAnswered: false,
        isCorrectAnswer: null,
        coinsGained: 0,
        noOfCorrectAnswers: 0,
        isLoadingGameRestart:false,
        hasRestartedGame:false,
    );
  }

  LightningModeState copyWith(
      {
        bool? isLoadingStartGame,
        bool? hasStartedGame,
        StartGameRoomModel? startGameRoomModel,
        String? correctAnswer,
        int? selectedOptionIndex,
        bool? hasAnswered,
        bool? isCorrectAnswer,
        int? coinsGained,
        int? noOfCorrectAnswers,
        bool? isLoadingGameRestart,
        bool? hasRestartedGame,
      }) {
    return LightningModeState(
      isLoadingStartGame: isLoadingStartGame ?? this.isLoadingStartGame,
      hasStartedGame: hasStartedGame ?? this.hasStartedGame,
      startGameRoomModel: startGameRoomModel ?? this.startGameRoomModel,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      hasAnswered: hasAnswered ??this.hasAnswered,
      isCorrectAnswer: isCorrectAnswer ?? this.isCorrectAnswer,
      coinsGained: coinsGained ?? this.coinsGained,
      noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
      isLoadingGameRestart: isLoadingGameRestart ?? this.isLoadingGameRestart,
      hasRestartedGame: hasRestartedGame ?? this.hasRestartedGame,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingStartGame,
    hasStartedGame,
    startGameRoomModel,
    correctAnswer,
    selectedOptionIndex,
    hasAnswered,
    isCorrectAnswer,
    coinsGained,
    noOfCorrectAnswers,
    isLoadingGameRestart,
    hasRestartedGame
  ];
}
