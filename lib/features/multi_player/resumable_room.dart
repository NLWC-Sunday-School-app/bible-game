import 'package:bible_game_api/bible_game_api.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A room this user can go back to, as the server describes it right now.
class ResumableRoom extends Equatable {
  const ResumableRoom({
    required this.details,
    required this.isHost,
    required this.myPlayerId,
    this.knownPlayers = const [],
  });

  final RoomDetailsModel details;
  final bool isHost;

  /// Null when this user is no longer one of the room's players -- they left
  /// from another device, or were removed -- so returning means joining again.
  final String? myPlayerId;

  /// Players looked up by name for a server that does not send player
  /// details with the room, so their rows are not left blank.
  final List<OnlinePlayer> knownPlayers;

  ResumableRoom withKnownPlayers(List<OnlinePlayer> players) => ResumableRoom(
        details: details,
        isHost: isHost,
        myPlayerId: myPlayerId,
        knownPlayers: players,
      );

  /// Other players the room details say nothing about beyond a name.
  Iterable<String> get unidentifiedPlayerNames => details.players
      .where((p) =>
          p.playerId != myPlayerId &&
          p.userId == null &&
          (p.playerName?.isNotEmpty ?? false))
      .map((p) => p.playerName!);

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
  /// The details carry ids and names only, so the rest comes from what the
  /// app already knows: our own row from our profile -- its user id is how the
  /// waiting room and answer sending find their own player -- and everyone
  /// else's from the online players list, matched by name. Anything still
  /// unknown stays null and the row leaves it off until the server's next
  /// waiting-room update supplies it.
  WaitingRoomModel toWaitingRoom(User me,
      {List<OnlinePlayer> known = const []}) {
    final lookup = [...knownPlayers, ...known];
    final players = details.players
        .where((p) => p.playerId != null)
        .map((p) {
          final isMe = p.playerId == myPlayerId;
          final name = p.playerName?.toLowerCase();
          final online = isMe || name == null
              ? null
              : lookup.firstWhereOrNull((o) => o.username.toLowerCase() == name);
          final userId =
              isMe ? me.id.toString() : p.userId ?? online?.userId.toString();
          return Player(
            id: p.playerId,
            userId: userId,
            username: p.playerName,
            isReady: true,
            // The room names its host by user id, so anyone whose user id is
            // known can be matched to it even when the server does not mark
            // the row itself.
            isHost: p.isHost ??
                ((isMe && isHost) ||
                    (userId != null && userId == details.hostId)),
            country: _nonEmpty(isMe ? me.country : p.country ?? online?.country),
            level: _nonEmpty(isMe ? me.rank : p.level ?? online?.level),
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

  static String? _nonEmpty(String? value) =>
      value == null || value.trim().isEmpty ? null : value;

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
  List<Object?> get props => [details, isHost, myPlayerId, knownPlayers];
}
