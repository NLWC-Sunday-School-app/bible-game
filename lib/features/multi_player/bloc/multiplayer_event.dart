import 'package:equatable/equatable.dart';

class MultiplayerEvent extends Equatable{
  const MultiplayerEvent();

  @override
  List<Object?> get props => [];
}

class CreateGameRoom extends MultiplayerEvent{}

class JoinRoom extends MultiplayerEvent{
  final String inviteCode;

  JoinRoom(this.inviteCode);
  @override
  List<Object> get props => [inviteCode];
}

class ConfigureGameRoom extends MultiplayerEvent{
  final String gameType;
  final String questionType;
  final int conditionValue;
  final String conditionType;


  ConfigureGameRoom(this.gameType, this.questionType, this.conditionValue, this.conditionType);
  @override
  List<Object> get props => [gameType, questionType, conditionType, conditionValue];
}

class GameInvites extends MultiplayerEvent{
  final String inviteeUsername;
  final String gameType;

  GameInvites(this.inviteeUsername, this.gameType);
  @override
  List<Object> get props => [inviteeUsername,gameType];
}

class FetchGameInvites extends MultiplayerEvent{}

class CountInvite extends MultiplayerEvent{}

class AcceptAndJoin extends MultiplayerEvent{
  final String inviteId;

  AcceptAndJoin(this.inviteId);
  @override
  List<Object> get props => [inviteId];
}

class Reject extends MultiplayerEvent{
  final String inviteId;

  Reject(this.inviteId);
  @override
  List<Object> get props => [inviteId];
}