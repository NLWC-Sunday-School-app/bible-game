import 'package:shared_preferences/shared_preferences.dart';

import 'platform_info.dart';

/// The push token to send when registering an account.
///
/// The backend rejects registration with "fcmToken must not be blank" and
/// "fcmToken size must be between 10 and 2147483647", so an empty string fails
/// the whole sign-up. That happened on every web registration: app.dart only
/// fetches an FCM token on mobile, so the SharedPreferences key was never
/// written there. It can also happen on mobile whenever registration beats
/// Firebase to the finish, since FCM init no longer blocks the first frame.
///
/// Sends an explicit placeholder rather than a blank, so the server can tell a
/// client that cannot receive push from one whose token simply is not ready.
/// UpdateFCMToken replaces it with the real token once FCM comes up.
Future<String> registrationPushToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('fcmToken') ?? '';
  if (token.isNotEmpty) return token;
  return PlatformInfo.isWeb ? 'web-no-push-token' : 'pending-fcm-token';
}
