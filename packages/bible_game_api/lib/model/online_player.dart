import 'package:equatable/equatable.dart';

/// A player currently online and available to invite.
///
/// Parsing is deliberately tolerant: the endpoint is still being built, and
/// accepting the obvious spellings means a small naming difference on the
/// server does not leave the list blank with no explanation.
class OnlinePlayer extends Equatable {
  const OnlinePlayer({
    required this.userId,
    required this.username,
    required this.profileUrl,
    required this.country,
    this.level,
  });

  final int userId;
  final String username;

  /// Avatar seed, the same shape AvatarWidget already takes elsewhere.
  final String profileUrl;
  final String country;

  /// Rank -- "babe", "elder" and the rest, as the waiting room calls it.
  /// Null or empty when the endpoint does not send one, in which case the row
  /// leaves the badge off rather than drawing the default for everybody.
  ///
  /// Nullable on purpose. A non-nullable field added to a class whose
  /// instances already exist reads back as null after a hot reload -- those
  /// objects have no storage for it -- and every bloc emission then threw
  /// while Equatable stringified the state. Nullable degrades to "no badge".
  final String? level;

  static String _pick(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return '';
  }

  static int _pickInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      final parsed = int.tryParse('${value ?? ''}');
      if (parsed != null) return parsed;
    }
    return 0;
  }

  factory OnlinePlayer.fromJson(Map<String, dynamic> json) => OnlinePlayer(
        userId: _pickInt(json, ['userId', 'id']),
        // The DTO calls it `name`; invites are still sent by username, so this
        // is the value handed to POST /multiplayer/invites.
        username: _pick(json, ['username', 'userName', 'name']),
        profileUrl: _pick(json, ['profileUrl', 'avatar', 'avatarUrl']),
        country: _pick(json, ['country', 'countryName']),
        level: _pick(json, ['level', 'rank', 'userRank']).toLowerCase(),
      );

  @override
  List<Object?> get props => [userId, username, profileUrl, country, level];
}

/// One page of online players, plus how many there are in total.
///
/// The endpoint is paginated and defaults to 20 per page, so the length of
/// [players] is a page size, not a population. Anything that reports "N online"
/// has to read [total] instead, or it stops counting at 20 and stays there.
class OnlinePlayersPage extends Equatable {
  const OnlinePlayersPage({required this.players, required this.total});

  const OnlinePlayersPage.empty() : players = const [], total = 0;

  final List<OnlinePlayer> players;

  /// Everyone online, the signed-in user included -- the endpoint does not
  /// exclude the caller. Falls back to the page length when the response
  /// carries no total, which at least never overstates it.
  final int total;

  @override
  List<Object?> get props => [players, total];
}
