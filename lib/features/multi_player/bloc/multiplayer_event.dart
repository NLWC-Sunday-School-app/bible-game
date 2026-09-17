import 'package:bible_game/features/multi_player/question_timing.dart';
import 'package:equatable/equatable.dart';

class MultiplayerEvent extends Equatable{
  const MultiplayerEvent();

  @override
  List<Object?> get props => [];
}

class CreateGameRoom extends MultiplayerEvent{}

class KickOut extends MultiplayerEvent{
  final String playerId;

  KickOut(this.playerId);
  @override
  List<Object> get props => [playerId];
}

class LeaveRoom extends MultiplayerEvent{
  final String playerId;

  LeaveRoom(this.playerId);
  @override
  List<Object> get props => [playerId];
}

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

  /// Seconds each question stays on screen, chosen by the host. Sent to the
  /// server rather than applied locally: every player has to run the same
  /// clock, so it reaches the others through the GAME_STARTED frame.
  final int secondsPerQuestion;

  ConfigureGameRoom(this.gameType, this.questionType, this.conditionValue,
      this.conditionType,
      {this.secondsPerQuestion = kDefaultSecondsPerQuestion});
  @override
  List<Object> get props =>
      [gameType, questionType, conditionType, conditionValue, secondsPerQuestion];
}

class GameInvites extends MultiplayerEvent{
  final String inviteeUsername;
  final String gameType;

  GameInvites(this.inviteeUsername, this.gameType);
  @override
  List<Object> get props => [inviteeUsername,gameType];
}

class FetchGameInvites extends MultiplayerEvent{}

/// Loads the players available to invite right now.
class FetchOnlinePlayers extends MultiplayerEvent{}

/// Looks up players by username as the host types.
///
/// Kept apart from [FetchOnlinePlayers] because they write to different parts
/// of the state: a search would otherwise overwrite the browse list, and with
/// it the "N online" count on the invite button.
class SearchOnlinePlayers extends MultiplayerEvent {
  final String query;

  SearchOnlinePlayers(this.query);
  @override
  List<Object> get props => [query];
}

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

class StartPolling extends MultiplayerEvent {
  const StartPolling();
}

class StopPolling extends MultiplayerEvent {
  const StopPolling();
}