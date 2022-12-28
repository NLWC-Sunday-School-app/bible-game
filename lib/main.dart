
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game/screens/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/awesome_notification_controller.dart';

void main() async{
  AwesomeNotifications().initialize('resource://drawable/background', [
    NotificationChannel(
      channelKey: 'notifications',
      channelName: 'Notifications',
      channelDescription: 'Notification channel for notification',
      channelShowBadge: true,
      importance: NotificationImportance.Max,
    ),
  ]);
  await GetStorage.init();
  //await AwesomeNotificationController.initializeRemoteNotifications(debug: false);
  runApp(const MyApp());
}

