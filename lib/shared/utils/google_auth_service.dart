import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:google_sign_in/google_sign_in.dart';

import 'platform_info.dart';

/// Thrown when Google signs the user in but hands back no ID token. Without
/// one there is nothing to send to /auth/google, and the caller should surface
/// a failure rather than treat it as a cancelled sign-in.
class MissingGoogleIdTokenException implements Exception {
  @override
  String toString() => 'Google returned no ID token';
}

class GoogleAuthService {
  // "Web application" OAuth client for the bible-game-e2616 Firebase project.
  // The backend verifies that every ID token carries this as its `aud`, so it
  // is the serverClientId on mobile and the clientId on web -- one audience
  // across all three platforms.
  static const _webClientId =
      '242806293668-m9po3eictcocq4514cbti85dadilef0b.apps.googleusercontent.com';

  // iOS OAuth client, from ios/GoogleService-Info.plist CLIENT_ID. It must
  // match the REVERSED_CLIENT_ID URL scheme registered in ios/Runner/Info.plist,
  // otherwise the callback has nowhere to land.
  static const _iosClientId =
      '242806293668-kthsbqf9g782mlgso7kb3dq2g17ua5ek.apps.googleusercontent.com';

  // clientId is per-platform: iOS needs its own client, Android takes it from
  // google-services.json (passing one there is rejected), and web uses the web
  // client.
  static String? get _clientId {
    if (PlatformInfo.isWeb) return _webClientId;
    if (PlatformInfo.isIOS) return _iosClientId;
    return null; // Android: resolved from google-services.json
  }

  // 'profile' is required on web: google_sign_in_web resolves the display name
  // through the People API, and without this scope that call comes back 403.
  // Both scopes are non-sensitive, so neither needs OAuth verification.
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
    clientId: _clientId,
    serverClientId: PlatformInfo.isWeb ? null : _webClientId,
  );

  /// Signs the user in with Google and returns the ID token to send to
  /// /auth/google. Returns null if the user cancels the account picker.
  ///
  /// The token is the whole of what the app contributes: the backend verifies
  /// it with Google and reads the email, name and account id from the verified
  /// claims, so none of that is sent from here.
  static Future<String?> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null; // cancelled

    final idToken = (await account.authentication).idToken;
    if (idToken == null || idToken.isEmpty) {
      throw MissingGoogleIdTokenException();
    }

    if (kDebugMode) await _copyIdTokenForBackendTesting(idToken);
    return idToken;
  }

  /// Puts the ID token on the clipboard so the backend can develop against a
  /// real one. Debug builds only -- kDebugMode is a compile-time constant, so
  /// this and the call to it are tree-shaken out of release.
  ///
  /// The token is a live credential for roughly an hour: it is the whole of
  /// what proves identity to /auth/google. Treat it like a password -- hand it
  /// over directly, never paste it into a ticket, chat or screenshot. Once the
  /// backend has a browser page issuing its own tokens, this can go.
  static Future<void> _copyIdTokenForBackendTesting(String idToken) async {
    try {
      await Clipboard.setData(ClipboardData(text: idToken));
      debugPrint('\u{1F511} Google ID token copied to the clipboard '
          '(expires in ~1h, treat it like a password).');
    } catch (e) {
      debugPrint('\u{1F511} Could not copy the Google ID token: $e');
    }
  }

  static Future<void> signOut() => _googleSignIn.signOut();
}
