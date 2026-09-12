import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'platform_info.dart';

class GoogleProfile {
  final String id;
  final String email;
  final String username;

  GoogleProfile({required this.id, required this.email, required this.username});
}

class GoogleAuthService {
  // "Web application" OAuth client for the bible-game-e2616 Firebase project
  // (android/app/google-services.json oauth_client[0], client_type 3). This is
  // the audience the backend would verify against, so it is the serverClientId
  // on every platform, and the clientId on web.
  static const _webClientId =
      '242806293668-m9po3eictcocq4514cbti85dadilef0b.apps.googleusercontent.com';

  // iOS OAuth client, from ios/GoogleService-Info.plist CLIENT_ID. It must
  // match the REVERSED_CLIENT_ID URL scheme registered in ios/Runner/Info.plist,
  // otherwise the callback has nowhere to land.
  static const _iosClientId =
      '242806293668-kthsbqf9g782mlgso7kb3dq2g17ua5ek.apps.googleusercontent.com';

  // clientId is per-platform: iOS needs its own client, Android takes it from
  // google-services.json (passing one there is rejected), and web uses the web
  // client. Previously the web client was passed on all three, so on iOS the
  // client being authenticated did not match the URL scheme it redirects to.
  static String? get _clientId {
    if (PlatformInfo.isWeb) return _webClientId;
    if (PlatformInfo.isIOS) return _iosClientId;
    return null; // Android: resolved from google-services.json
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email'],
    clientId: _clientId,
    serverClientId: PlatformInfo.isWeb ? null : _webClientId,
  );

  /// Signs the user in with Google and returns a sanitized profile.
  /// Returns null if the user cancels the flow.
  static Future<GoogleProfile?> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    return GoogleProfile(
      id: account.id,
      email: account.email,
      username: _usernameFrom(account.displayName, account.email),
    );
  }

  static Future<void> signOut() => _googleSignIn.signOut();

  /// The app's register form caps usernames to 5-10 chars of [A-Za-z0-9#-]
  /// (see Validator.validateName / the CreateProfileModal input formatter).
  /// Google display names rarely fit that, so derive a compliant handle
  /// from it instead of prompting the user to pick one.
  static String _usernameFrom(String? displayName, String email) {
    String base = (displayName ?? '').replaceAll(RegExp(r'[^A-Za-z0-9#-]'), '');
    if (base.isEmpty) {
      base = email.split('@').first.replaceAll(RegExp(r'[^A-Za-z0-9#-]'), '');
    }
    if (base.isEmpty) base = 'Player';
    if (base.length > 10) base = base.substring(0, 10);

    final rnd = Random();
    while (base.length < 5) {
      base += rnd.nextInt(10).toString();
    }
    return base;
  }

  /// The backend has no Google-auth endpoint, so we sign in with Google
  /// purely for identity (name + email) and reuse the existing
  /// email/password register+login flow. This derives a stable "password"
  /// from the Google account's own id, so the same Google account maps to
  /// the same backend password across devices/reinstalls without ever
  /// asking the user to set or remember one.
  static String derivePassword(String googleId) {
    final bytes = utf8.encode('bible_game_google_auth_v1:$googleId');
    return sha256.convert(bytes).toString();
  }
}
