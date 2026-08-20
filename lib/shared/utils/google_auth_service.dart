import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleProfile {
  final String id;
  final String email;
  final String username;

  GoogleProfile({required this.id, required this.email, required this.username});
}

class GoogleAuthService {
  // Auto-provisioned "Web application" OAuth client for the bible-game-e2616
  // Firebase project (see android/app/google-services.json oauth_client[0]
  // and ios/GoogleService-Info.plist CLIENT_ID). Used as clientId on web and
  // serverClientId on Android/iOS so all platforms resolve to the same
  // Google Cloud project.
  static const _googleClientId =
      '242806293668-qh1o5db6qievge5nrqeelrpcukp8vud4.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email'],
    clientId: _googleClientId,
    serverClientId: _googleClientId,
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
