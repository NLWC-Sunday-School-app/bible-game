part of 'websocket_cubit.dart';

enum WebsocketConnectionStatus { disconnected, connecting, connected, error }

/// Sentinel used by [WebsocketState.copyWith] so a nullable field can be
/// explicitly reset to null, distinct from being omitted entirely.
const _unset = Object();

class WebsocketState extends Equatable{
  final String eventType;
  final WaitingRoomModel waitingRoomInfo;
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
  final WebsocketConnectionStatus connectionStatus;

  const WebsocketState({
    required this.eventType,
    required this.waitingRoomInfo,
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
    required this.connectionStatus,
  });

  factory WebsocketState.initial(){
    return WebsocketState(
        eventType: "",
        userToastMessage: "",
        userPlayerId: "",
        waitingRoomInfo: WaitingRoomModel.fromJson({}),
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
        connectionStatus: WebsocketConnectionStatus.disconnected,
    );
  }

  WebsocketState copyWith({
    String? eventType,
    WaitingRoomModel? waitingRoomInfo,
    PlayerAnswers? playerAnswersDetails,
    PositionUpdate? positionUpdate,
    GameFinishedEvent? gameFinishedEvent,
    List<Datum>? questionData,
    Object? correctAnswer = _unset,
    String? userToastMessage,
    String? userPlayerId,
    Object? selectedOptionIndex = _unset,
    bool? hasAnswered,
    Object? isCorrectAnswer = _unset,
    bool? newPlayerJoined,
    int? coinsGained,
    int? userRank,
    int? noOfCorrectAnswers,
    WebsocketConnectionStatus? connectionStatus,
  }) {
    return WebsocketState(
        waitingRoomInfo: waitingRoomInfo ?? this.waitingRoomInfo,
        eventType:  eventType ?? this.eventType,
        questionData: questionData ?? this.questionData,
        correctAnswer: correctAnswer == _unset ? this.correctAnswer : correctAnswer as String?,
        userToastMessage: userToastMessage ?? this.userToastMessage,
        userPlayerId: userPlayerId ?? this.userPlayerId,
        selectedOptionIndex: selectedOptionIndex == _unset ? this.selectedOptionIndex : selectedOptionIndex as int?,
        hasAnswered: hasAnswered ??this.hasAnswered,
        isCorrectAnswer: isCorrectAnswer == _unset ? this.isCorrectAnswer : isCorrectAnswer as bool?,
        newPlayerJoined: newPlayerJoined ?? this.newPlayerJoined,
        coinsGained: coinsGained ?? this.coinsGained,
        userRank: userRank ?? this.userRank,
        noOfCorrectAnswers: noOfCorrectAnswers ?? this.noOfCorrectAnswers,
        playerAnswersDetails: playerAnswersDetails ?? this.playerAnswersDetails,
        positionUpdate: positionUpdate ?? this.positionUpdate,
      gameFinishedEvent: gameFinishedEvent ?? this.gameFinishedEvent,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props =>
      [
        userPlayerId,
       waitingRoomInfo,
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
        gameFinishedEvent,
        connectionStatus,
      ];
}