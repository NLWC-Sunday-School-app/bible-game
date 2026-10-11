import 'package:get_storage/get_storage.dart';

/// The room this device last created or joined, kept across app restarts.
///
/// The room itself outlives the app -- the server keeps it until its last
/// player leaves -- but its id and code only ever lived in bloc memory, so a
/// player who left the app had no way back in and their friends were left
/// holding a code for a room nobody could start.
class ActiveRoom {
  const ActiveRoom({
    required this.roomId,
    required this.inviteCode,
    required this.userId,
    required this.savedAt,
    this.playerId,
  });

  final String roomId;
  final String inviteCode;

  /// Whose room this is. A different account signing in on the same device
  /// must not be offered someone else's game.
  final String userId;

  /// This user's player in the room. Rejoining by code makes a new player
  /// rather than finding the old one, so resuming has to know which it was.
  final String? playerId;
  final DateTime savedAt;

  Map<String, dynamic> toJson() => {
        'roomId': roomId,
        'inviteCode': inviteCode,
        'userId': userId,
        'playerId': playerId,
        'savedAt': savedAt.toIso8601String(),
      };

  static ActiveRoom? fromJson(Object? json) {
    if (json is! Map) return null;
    final roomId = json['roomId'];
    final inviteCode = json['inviteCode'];
    final userId = json['userId'];
    final savedAt = DateTime.tryParse(json['savedAt']?.toString() ?? '');
    if (roomId is! String || inviteCode is! String || userId is! String ||
        savedAt == null) {
      return null;
    }
    return ActiveRoom(
      roomId: roomId,
      inviteCode: inviteCode,
      userId: userId,
      playerId: json['playerId'] as String?,
      savedAt: savedAt,
    );
  }
}

class ActiveRoomStore {
  ActiveRoomStore([GetStorage? box]) : _box = box ?? GetStorage();

  final GetStorage _box;

  static const _key = 'active_multiplayer_room';

  /// Rooms never expire on the server, so without a cut-off a room abandoned
  /// last month would be offered back as though the friends were still in it.
  static const maxAge = Duration(hours: 12);

  ActiveRoom? read(String userId) {
    final room = ActiveRoom.fromJson(_box.read(_key));
    if (room == null) return null;
    if (room.userId != userId ||
        DateTime.now().difference(room.savedAt) > maxAge) {
      clear();
      return null;
    }
    return room;
  }

  Future<void> save({
    required String roomId,
    required String inviteCode,
    required String userId,
    String? playerId,
  }) {
    return _box.write(
        _key,
        ActiveRoom(
          roomId: roomId,
          inviteCode: inviteCode,
          userId: userId,
          playerId: playerId,
          savedAt: DateTime.now(),
        ).toJson());
  }

  /// Records this user's player once a socket frame names it. Ignored if the
  /// stored room has since changed.
  Future<void> rememberPlayerId(String roomId, String playerId) async {
    final json = _box.read(_key);
    final room = ActiveRoom.fromJson(json);
    if (room == null || room.roomId != roomId || room.playerId == playerId) {
      return;
    }
    await _box.write(_key, {...room.toJson(), 'playerId': playerId});
  }

  /// Clears the stored room, or only [roomId] when given -- so a late clear
  /// for an old room cannot wipe out the one that replaced it.
  Future<void> clear([String? roomId]) async {
    if (roomId != null) {
      final room = ActiveRoom.fromJson(_box.read(_key));
      if (room != null && room.roomId != roomId) return;
    }
    await _box.remove(_key);
  }
}
