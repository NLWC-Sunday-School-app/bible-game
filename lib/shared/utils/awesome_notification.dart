import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AwesomeNotification {
  static Future<void>? _remoteInit;

  /// Idempotent. Startup kicks this off without awaiting it, so anything that
  /// genuinely needs Firebase -- the FCM token at login -- awaits this same
  /// future rather than racing it or initialising a second time.
  static Future<void> initializeRemoteNotifications({required bool debug}) =>
      _remoteInit ??= _initializeRemote(debug);

  static Future<void> _initializeRemote(bool debug) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: AwesomeNotification.mySilentDataHandle,
        onFcmTokenHandle: AwesomeNotification.myFcmTokenHandle,
        onNativeTokenHandle: AwesomeNotification.myNativeTokenHandle,
        licenseKeys: [
          '2023-09-21==hsKXB8OM7Op4VuSlnvBk0itJezn7LOiBJtEpOB5lX3At7zj9h+X1xHnSoTBLizJtZfwfreCch8lU7H+C8G8zvePodCA7wKNB6Poj0OL0TXDVYlIZNt/d2rEDjxMhWkSgNlBoULKpeCVD5zzKECtaQQVU5s3qIRJmt41gXPynTQ6sb8iE/DHg7/K8J/T9esEjZA0mst8jbAaD7OfyMGHXYsbDV4V3xAWY8sjEZxwpwEJHt5/CSVSBjRbToIeIvJwf9Vn1jqFcQDUmuGypOFU5yKmsCiak4l0cgD7iAufhDtEdSSrZYfKcMJ8Oj7xxq0M1K60WmP8j/N/S/p8FOee0UA==',
        ],
        debug: debug);
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {

  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {}

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }

  // Request FCM token to Firebase
  static Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';

    // Startup no longer blocks on Firebase, so it may still be coming up.
    // Bounded, because a wedged FCM registration must not hang login -- the
    // caller treats an empty token as "no push for this session".
    try {
      await _remoteInit?.timeout(const Duration(seconds: 20));
    } catch (exception) {
      debugPrint('FCM not ready, continuing without a token: $exception');
      return firebaseAppToken;
    }

    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
        print('fb token: $firebaseAppToken');
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }

    return firebaseAppToken;
  }
}
