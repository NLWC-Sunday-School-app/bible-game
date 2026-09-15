import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game/shared/utils/verse_frequency.dart';

/// Shows a Bible verse on the lock screen by pre-scheduling one silent
/// repeating notification per delivery hour. Rescheduled on every app launch
/// so the verse rotation advances day by day.
///
/// How often is the user's choice -- see [kVerseFrequencyOptions]. Every hour
/// is 24 a day, which suits some people and is far too many for others.
class HourlyVerseNotification {
  static const String _channelKey = 'hourly_verse';

  /// Ids 200-223 — one per hour, kept clear of other notification ids.
  static const int _baseId = 200;

  static NotificationChannel get channel => NotificationChannel(
        channelKey: _channelKey,
        channelName: 'Hourly Bible Verse',
        channelDescription:
            'A Bible verse on your lock screen every hour',
        importance: NotificationImportance.Low,
        playSound: false,
        enableVibration: false,
        channelShowBadge: false,
        defaultColor: const Color(0xFF6B4C9A),
      );

  /// [everyHours] is the gap between verses: 1 delivers on every hour, 3 on
  /// 0:00, 3:00, 6:00 and so on. Anything outside the supported set falls back
  /// to the default rather than scheduling something unexpected.
  static Future<void> scheduleHourlyVerses({int? everyHours}) async {
    final step = kVerseFrequencyOptions.containsKey(everyHours)
        ? everyHours!
        : kDefaultVerseFrequencyHours;

    final verses = await MemoryVerseData.loadAllVerses();
    if (verses.isEmpty) return;

    // Always clear the whole channel first: dropping from hourly to twice a
    // day has to remove the schedules the old setting left behind, or the
    // user keeps getting the ones in between.
    await AwesomeNotifications().cancelSchedulesByChannelKey(_channelKey);

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    for (var hour = 0; hour < 24; hour += step) {
      final verse = verses[(dayOfYear * 24 + hour) % verses.length];
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: _baseId + hour,
          channelKey: _channelKey,
          title: '\u{1F4D6} ${verse.reference}',
          body: verse.text,
          notificationLayout: NotificationLayout.BigText,
          category: NotificationCategory.Reminder,
          wakeUpScreen: false,
          autoDismissible: true,
        ),
        schedule: NotificationCalendar(
          hour: hour,
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: true,
          allowWhileIdle: true,
        ),
      );
    }
  }

  static Future<void> cancelHourlyVerses() async {
    await AwesomeNotifications().cancelSchedulesByChannelKey(_channelKey);
  }

  /// Fires the current hour's verse after [afterSeconds] so the lock screen
  /// presentation can be checked without waiting for the top of the hour.
  static Future<void> showTestVerseNow({int afterSeconds = 10}) async {
    final allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    final verses = await MemoryVerseData.loadAllVerses();
    if (verses.isEmpty) return;

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final verse = verses[(dayOfYear * 24 + now.hour) % verses.length];

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 199,
        channelKey: _channelKey,
        title: '\u{1F4D6} ${verse.reference}',
        body: verse.text,
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Reminder,
        // Unlike the hourly verses, the test notification announces itself —
        // on iOS this raises the interruption level above passive so a banner
        // actually appears instead of landing silently in Notification Center.
        wakeUpScreen: true,
        autoDismissible: true,
      ),
      schedule: NotificationInterval(
        interval: Duration(seconds: afterSeconds),
        repeats: false,
        allowWhileIdle: true,
        preciseAlarm: false,
      ),
    );
  }
}
