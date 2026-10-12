import 'package:bible_game/shared/utils/devotional_notification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DevotionalNotification.isEnabled', () {
    test('on for someone who never touched either switch', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(await DevotionalNotification.isEnabled(prefs), isTrue);
    });

    test('stays off for someone who switched the old combined switch off',
        () async {
      SharedPreferences.setMockInitialValues({'isNotificationOn': false});
      final prefs = await SharedPreferences.getInstance();
      expect(await DevotionalNotification.isEnabled(prefs), isFalse);
    });

    test('once read, switching verses later leaves the reminder alone',
        () async {
      SharedPreferences.setMockInitialValues({'isNotificationOn': true});
      final prefs = await SharedPreferences.getInstance();
      expect(await DevotionalNotification.isEnabled(prefs), isTrue);

      await prefs.setBool('isNotificationOn', false);
      expect(await DevotionalNotification.isEnabled(prefs), isTrue);
    });

    test('its own setting wins over the verses switch', () async {
      SharedPreferences.setMockInitialValues(
          {'isNotificationOn': true, DevotionalNotification.prefKey: false});
      final prefs = await SharedPreferences.getInstance();
      expect(await DevotionalNotification.isEnabled(prefs), isFalse);
    });
  });
}
