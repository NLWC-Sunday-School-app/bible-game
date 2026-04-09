import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game/shared/data/daily_devotionals.dart';

class DevotionalNotification {
  static const String _channelKey = 'daily_devotional';
  static const int _notificationId = 100;

  /// Register the notification channel (call once in main.dart).
  static NotificationChannel get channel => NotificationChannel(
        channelKey: _channelKey,
        channelName: 'Daily Devotional',
        channelDescription: 'Daily morning devotional reminder at 8 AM',
        channelShowBadge: true,
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF6B4C9A),
      );

  /// Schedule a repeating daily notification at 8:00 AM local time.
  static Future<void> scheduleDailyReminder() async {
    // Cancel any existing devotional notification first
    await AwesomeNotifications().cancel(_notificationId);

    // Pick today's devotional for the preview text
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final devotional = DailyDevotionals
        .devotionals[dayOfYear % DailyDevotionals.devotionals.length];
    final passage = devotional['passage'] as String;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _notificationId,
        channelKey: _channelKey,
        title: '\u{1F4D6} Daily Devotional',
        body: 'Today\'s passage: $passage — Tap to read and reflect!',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        hour: 8,
        minute: 0,
        second: 0,
        millisecond: 0,
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }

  /// Cancel the daily devotional notification.
  static Future<void> cancelDailyReminder() async {
    await AwesomeNotifications().cancel(_notificationId);
  }
}
