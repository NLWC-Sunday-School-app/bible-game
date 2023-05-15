
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AwesomeNotificationController extends GetxController{


  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: AwesomeNotificationController.mySilentDataHandle,
        onFcmTokenHandle: AwesomeNotificationController.myFcmTokenHandle,
        onNativeTokenHandle: AwesomeNotificationController.myNativeTokenHandle,
        // This license key is necessary only to remove the watermark for
        // push notifications in release mode. To know more about it, please
        // visit http://awesome-notifications.carda.me#prices
        licenseKeys: ['EAGdLUy2QRsxxldCQSY8IEcIQUOWa/6xBdSJuXB3wTx7oq00VYVwFi0mtZt19AxUSV4XLijbz77ul3Q/9B67ZX9p3KDLrBCQxpxJRMVfUuWX6pmvJiBmzTNgAsCuqlARlVYOqp2YbgVEv9vSk5WsflUbihFfDgB34WCdlg5eCRQ='],
        debug: false);
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    print('silent notification');
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {

  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }

  // Request FCM token to Firebase
  static Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
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