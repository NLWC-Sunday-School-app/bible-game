import 'package:bible_game_api/bible_game_api.dart';
import 'package:equatable/equatable.dart';

/// A room this user can go back to, as the server describes it right now.
class ResumableRoom extends Equatable {
  const ResumableRoom({
    required this.details,
    required this.isHost,
    required this.myPlayerId,
  });

  final RoomDetailsModel details;
  final bool isHost;

  /// Null when this user is no longer one of the room's players -- they left
  /// from another device, or were removed -- so returning means joining again.
  final String? myPlayerId;

  String get inviteCode => details.inviteCode ?? '';

  bool get isMember => myPlayerId != null;

  /// The display name the waiting room and question screens route on.
  String get modeLabel {
    switch (details.victoryType) {
      case 'LIGHTNING':
        return 'Lightning Mode';
      case 'FIRST_TO_X':
        return 'First to X';
      default:
        return '';
    }
  }

  String? get questionTypeLabel {
    switch (details.questionType) {
      case 'WHO_IS_WHO':
        return 'Who is Who';
      case 'SCRIPTURE_QUIZ':
        return 'Scripture Quiz';
      default:
        return null;
    }
  }

  /// Rebuilds the waiting room's roster from the room details, so a returning
  /// player sees who is already in -- and a returning host can press Start --
  /// without waiting for someone else to join and trigger a socket frame.
  ///
  /// The details carry ids and names only. Our own row gets our user id, which
  /// is how the waiting room and answer sending find their own player.
  WaitingRoomModel toWaitingRoom(String myUserId) {
    final players = details.players
        .where((p) => p.playerId != null)
        .map((p) {
          final isMe = p.playerId == myPlayerId;
          return Player(
            id: p.playerId,
            userId: isMe ? myUserId : null,
            username: p.playerName,
            isReady: true,
            isHost: isMe && isHost,
            country: null,
            level: null,
          );
        })
        .toList();
    return WaitingRoomModel(
      type: null,
      roomId: details.id,
      players: players,
      readyCount: players.length,
      totalPlayers: players.length,
      maxPlayers: null,
      // Written the way the server's own waiting-room frames write them
      // (MultiplayerHelper on the backend), so the summary line reads the same
      // whether it came from a frame or from here.
      totalQuestions: details.victoryType == 'LIGHTNING'
          ? details.victoryValue?.toString()
          : '∞',
      gameMode: switch (details.questionType) {
        'WHO_IS_WHO' => 'Who Is Who',
        'SCRIPTURE_QUIZ' => 'Scripture Quiz',
        _ => null,
      },
      toastNotificationMessage: null,
    );
  }

  /// The shape the rest of the multiplayer flow reads the current room from.
  /// activePlayers leads with the host's own player, which is what the waiting
  /// room's close button removes.
  CreateGameRoomModel toCreateGameRoomModel() {
    return CreateGameRoomModel.fromJson({
      'id': details.id,
      'inviteCode': details.inviteCode,
      'hostId': details.hostId,
      'gameMode': details.gameMode,
      'status': details.status,
      'victoryCondition': details.victoryType == null
          ? null
          : {
              'type': details.victoryType,
              'value': details.victoryValue,
              'questionType': details.questionType,
            },
      'activePlayers': [
        if (myPlayerId != null) myPlayerId,
        ...details.players
            .map((p) => p.playerId)
            .where((id) => id != null && id != myPlayerId),
      ],
    });
  }

  @override
  List<Object?> get props => [details, isHost, myPlayerId];
}
