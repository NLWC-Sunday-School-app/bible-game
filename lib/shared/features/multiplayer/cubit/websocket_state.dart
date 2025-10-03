part of 'websocket_cubit.dart';

class WebsocketState extends Equatable{
  final String eventType;
  final WaitingRoomModel playersJoined;
  final List<Datum> questionData;

  const WebsocketState({
    required this.eventType,
    required this.playersJoined,
    required this.questionData,
  });

  factory WebsocketState.initial(){
    return WebsocketState(
        eventType: "",
        playersJoined: WaitingRoomModel.fromJson({}),
      questionData: []
    );
  }

  WebsocketState copyWith({
    String? eventType,
    WaitingRoomModel? playersJoined,
    List<Datum>? questionData
  }) {
    return WebsocketState(
        playersJoined: playersJoined ?? this.playersJoined,
        eventType:  eventType ?? this.eventType,
        questionData: questionData ?? this.questionData
    );
  }

  @override
  List<Object?> get props =>
      [
       playersJoined,
        eventType,
        questionData
      ];
}