import 'package:bible_game/shared/utils/verse_frequency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('retireVerseOffSwitch', () {
    test('someone who had verses off gets them once a day', () async {
      SharedPreferences.setMockInitialValues({'isNotificationOn': false});
      final prefs = await SharedPreferences.getInstance();
      await retireVerseOffSwitch(prefs);
      expect(prefs.getInt(kVerseFrequencyPrefKey), 24);
    });

    test('someone who had verses on keeps their frequency', () async {
      SharedPreferences.setMockInitialValues(
          {'isNotificationOn': true, kVerseFrequencyPrefKey: 4});
      final prefs = await SharedPreferences.getInstance();
      await retireVerseOffSwitch(prefs);
      expect(prefs.getInt(kVerseFrequencyPrefKey), 4);
    });

    test('runs once, so a frequency chosen afterwards sticks', () async {
      SharedPreferences.setMockInitialValues({'isNotificationOn': false});
      final prefs = await SharedPreferences.getInstance();
      await retireVerseOffSwitch(prefs);
      await prefs.setInt(kVerseFrequencyPrefKey, 6);
      await retireVerseOffSwitch(prefs);
      expect(prefs.getInt(kVerseFrequencyPrefKey), 6);
    });
  });
}
