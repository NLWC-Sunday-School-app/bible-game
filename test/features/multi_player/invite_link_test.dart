import 'package:bible_game/features/multi_player/invite_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InviteLink.codeFrom', () {
    test('reads the code from the shared web link', () {
      expect(
          InviteLink.codeFrom(
              Uri.parse('https://api.biblegame.nlwc.church/join/P0YB07RE')),
          'P0YB07RE');
    });

    test('accepts a trailing slash and any case', () {
      expect(
          InviteLink.codeFrom(
              Uri.parse('https://API.BibleGame.nlwc.church/Join/p0yb07re/')),
          'P0YB07RE');
    });

    test('reads the app scheme in each spelling', () {
      expect(InviteLink.codeFrom(Uri.parse('biblegame://join/P0YB07RE')),
          'P0YB07RE');
      expect(InviteLink.codeFrom(Uri.parse('biblegame:/join/P0YB07RE')),
          'P0YB07RE');
      expect(
          InviteLink.codeFrom(Uri.parse('biblegame://join?code=P0YB07RE')),
          'P0YB07RE');
    });

    test('ignores links that are not invites', () {
      for (final link in [
        'https://example.com/join/P0YB07RE',
        'https://biblegame.nlwc.church/join/P0YB07RE',
        'https://api.biblegame.nlwc.church/catalog',
        'https://api.biblegame.nlwc.church/join/P0YB07RE/extra',
        'https://api.biblegame.nlwc.church/join/AB',
        'https://api.biblegame.nlwc.church/join/P0Y%20B07RE',
        'biblegame://settings',
        'com.googleusercontent.apps.123:/oauth2redirect',
      ]) {
        expect(InviteLink.codeFrom(Uri.parse(link)), isNull, reason: link);
      }
    });
  });

  test('the link the app shares is one it opens', () {
    final link = InviteLink.forCode('P0YB07RE');
    expect(link.toString(), 'https://api.biblegame.nlwc.church/join/P0YB07RE');
    expect(InviteLink.codeFrom(link), 'P0YB07RE');
  });

  test('the share message carries both the link and the code', () {
    final message =
        InviteLink.shareMessage(code: 'P0YB07RE', modeLabel: 'Lightning Mode');
    expect(message, contains('https://api.biblegame.nlwc.church/join/P0YB07RE'));
    expect(message, contains('enter code P0YB07RE'));
    expect(message, contains('Lightning Mode'));
  });
}
