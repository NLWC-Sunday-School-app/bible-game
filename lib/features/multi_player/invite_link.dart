/// Links that open the app straight into joining a game.
///
/// `https://<host>/join/<CODE>` is the one people share: messaging apps only
/// make web links tappable, and a phone without the app installed lands on
/// the web page at that address instead. `biblegame://join/<CODE>` opens the
/// app directly; it needs no website, which makes it the one to test with.
class InviteLink {
  InviteLink._();

  /// The host in links the app hands out.
  static const shareHost = 'api.biblegame.nlwc.church';

  /// Every host whose /join links the app accepts. A link verified for one of
  /// these on the platform side opens the app; one that is not just opens the
  /// browser, so listing a host here costs nothing until it is set up.
  static const hosts = {'api.biblegame.nlwc.church', 'biblegame.nlwc.church'};

  static const scheme = 'biblegame';

  static final _code = RegExp(r'^[A-Za-z0-9]{6,12}$');

  static Uri forCode(String code) => Uri.https(shareHost, '/join/$code');

  /// The invite code a link carries, upper-cased, or null when it is not an
  /// invite link.
  static String? codeFrom(Uri uri) {
    String? code;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        hosts.contains(uri.host.toLowerCase()) &&
        segments.length == 2 &&
        segments.first.toLowerCase() == 'join') {
      code = segments[1];
    } else if (uri.scheme == scheme) {
      // biblegame://join/CODE puts "join" in the host; biblegame:/join/CODE
      // and biblegame://join?code=CODE are accepted too.
      if (uri.host == 'join' && segments.length == 1) {
        code = segments.first;
      } else if (segments.length == 2 && segments.first == 'join') {
        code = segments[1];
      } else if (uri.host == 'join' || segments.firstOrNull == 'join') {
        code = uri.queryParameters['code'];
      }
    }

    if (code == null || !_code.hasMatch(code)) return null;
    return code.toUpperCase();
  }

  /// What goes in the share sheet. The code is spelled out as well, for anyone
  /// whose app never got the link -- an old version, or a messenger that drops it.
  static String shareMessage({required String code, String? modeLabel}) {
    final game = modeLabel == null || modeLabel.isEmpty
        ? 'my Bible Game match'
        : 'my $modeLabel match on Bible Game';
    return 'Join $game! Tap to join: ${forCode(code)}\n\n'
        'Or open Bible Game, go to Arcade → Multiplayer → Join gameplay, '
        'and enter code $code.';
  }
}
