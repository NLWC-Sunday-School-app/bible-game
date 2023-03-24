
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game/screens/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/awesome_notification_controller.dart';

void main() async{
  AwesomeNotifications().initialize('resource://drawable/notification_icon', [
    NotificationChannel(
      channelKey: 'game notifications',
      channelName: 'Game Notifications',
      channelDescription: 'Notification channel for notification',
      channelShowBadge: true,
      importance: NotificationImportance.Max,
    ),
  ]);
  await GetStorage.init();
  await AwesomeNotificationController.initializeRemoteNotifications(debug: false);
  AwesomeNotifications().requestPermissionToSendNotifications(channelKey: 'game notifications');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

