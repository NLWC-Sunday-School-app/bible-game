import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game/shared/data/daily_devotionals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevotionalNotification {
  static const String _channelKey = 'daily_devotional';
  static const int _notificationId = 100;

  static const String prefKey = 'isDailyReadingOn';

  /// Whether the reminder is switched on. Until it had its own switch, the
  /// verses switch covered it too, so anyone who turned that off keeps the
  /// reminder off rather than having it come back after an update. That is
  /// saved the first time it is read: falling back every time would let
  /// switching verses off later take the reminder with it.
  static Future<bool> isEnabled(SharedPreferences prefs) async {
    final stored = prefs.getBool(prefKey);
    if (stored != null) return stored;
    final enabled = prefs.getBool('isNotificationOn') ?? true;
    await prefs.setBool(prefKey, enabled);
    return enabled;
  }

  /// Register the notification channel (call once in main.dart).
  static NotificationChannel get channel => NotificationChannel(
        channelKey: _channelKey,
        channelName: 'Daily Devotional',
        channelDescription: 'Daily morning devotional reminder at 8 AM',
        channelShowBadge: true,
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF6B4C9A),
      );

  /// How many days ahead are scheduled. Each day is its own notification
  /// carrying that day's passage; a single repeating one carried whatever
  /// passage was current when it was scheduled, every day, until the app was
  /// next opened. Rescheduled on every launch, so this only runs out for
  /// someone who leaves the app closed for longer than this. Kept well inside
  /// iOS's 64 pending notifications, which the hourly verses share (up to 24).
  static const int _daysAhead = 14;

  /// Schedules the 8:00 AM Daily Reading reminder for each of the next
  /// [_daysAhead] days, each naming the passage the app will show that day.
  static Future<void> scheduleDailyReminder() async {
    await cancelDailyReminder();

    final now = DateTime.now();
    for (var day = 0; day < _daysAhead; day++) {
      final date = DateTime(now.year, now.month, now.day + day, 8);
      if (!date.isAfter(now)) continue; // today's 8 AM has already passed
      final passage = DailyDevotionals.forDate(date)['passage'] as String;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: _notificationId + day,
          channelKey: _channelKey,
          title: '\u{1F4D6} Daily Reading',
          body: 'Today\'s passage: $passage — Tap to read and reflect!',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          badge: 0,
        ),
        schedule: NotificationCalendar(
          year: date.year,
          month: date.month,
          day: date.day,
          hour: 8,
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: false,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
    }
  }

  /// Cancels every scheduled Daily Reading reminder, including the single
  /// repeating one earlier versions scheduled under [_notificationId].
  static Future<void> cancelDailyReminder() async {
    for (var day = 0; day < _daysAhead; day++) {
      await AwesomeNotifications().cancel(_notificationId + day);
    }
  }

}
