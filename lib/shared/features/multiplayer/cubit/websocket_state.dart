part of 'websocket_cubit.dart';

class WebsocketState extends Equatable{
  final String eventType;
  final WaitingRoomModel playersJoined;
  final PlayerAnswers playerAnswersDetails;
  final PositionUpdate positionUpdate;
  final GameFinishedEvent gameFinishedEvent;
  final List<Datum> questionData;
  final String? correctAnswer;
  final String? userToastMessage;
  final String? userPlayerId;
  final int? selectedOptionIndex;
  final bool hasAnswered;
  final bool? isCorrectAnswer;
  final int coinsGained;
  final int noOfCorrectAnswers;
  final bool newPlayerJoined;
  final int userRank;

  const WebsocketState({
    required this.eventType,
    required this.playersJoined,
    required this.playerAnswersDetails,
    required this.positionUpdate,
    required this.gameFinishedEvent,
    required this.questionData,
    required this.correctAnswer,
    required this.userToastMessage,
    required this.userPlayerId,
    required this.selectedOptionIndex,
    required this.hasAnswered,
    required this.isCorrectAnswer,
    required this.coinsGained,
    required this.noOfCorrectAnswers,
    required this.newPlayerJoined,
    required this.userRank,
  });

  factory WebsocketState.initial(){
    return WebsocketState(
        eventType: "",
        userToastMessage: "",
        userPlayerId: "",
        playersJoined: WaitingRoomModel.fromJson({}),
        playerAnswersDetails: PlayerAnswers.fromJson({}),
        positionUpdate: PositionUpdate.fromJson({}),
        gameFinishedEvent: GameFinishedEvent.fromJson({}),
        questionData: [],
        correctAnswer: null,
        selectedOptionIndex: null,
        hasAnswered: false,
        newPlayerJoined: false,
        isCorrectAnswer: null,
        coinsGained: 0,
        userRank:0,
        noOfCorrectAnswers: 0,
    );
  }

  WebsocketState copyWith({
    String? eventType,
    WaitingRoomModel? playersJoined,
    PlayerAnswers? playerAnswersDetails,
    PositionUpdate? positionUpdate,
    GameFinishedEvent? gameFinishedEvent,
    List<Datum>? questionData,
    String? correctAnswer,
    String? userToastMessage,
    String? userPlayerId,
    int? selectedOptionIndex,
    bool? hasAnswered,
    bool? isCorrectAnswer,
    bool? newPlayerJoined,
    int? coinsGained,
    int? userRank,
    int? noOfCorrectAnswers,
  }) {
    return WebsocketState(
        playersJoined: playersJoined ?? this.playersJoined,
        eventType:  eventType ?? this.eventType,
        questionData: questionData ?? this.questionData,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        userToastMessage: userToastMessage ?? this.userToastMessage,
        userPlayerId: userPlayerId ?? this.userPlayerId,
        selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
        hasAnswered: hasAnswered ??this.hasAnswered,
        isCorrectAnswer: isCorrectAnswer ?? this.isCorrectAnswer,
        newPlayerJoined: newPlayerJoined ?? this.newPlayerJoined,
        coinsGained: coinsGained ?? this.coinsGained,
        userRank: userRank ?? this.userRank,
        noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
        playerAnswersDetails: playerAnswersDetails ?? this.playerAnswersDetails,
        positionUpdate: positionUpdate ?? this.positionUpdate,
      gameFinishedEvent: gameFinishedEvent ?? this.gameFinishedEvent
    );
  }

  @override
  List<Object?> get props =>
      [
        userPlayerId,
       playersJoined,
        playerAnswersDetails,
        positionUpdate,
        eventType,
        questionData,
        correctAnswer,
        selectedOptionIndex,
        hasAnswered,
        isCorrectAnswer,
        coinsGained,
        noOfCorrectAnswers,
        newPlayerJoined,
        userRank,
        userToastMessage,
        gameFinishedEvent
      ];
}