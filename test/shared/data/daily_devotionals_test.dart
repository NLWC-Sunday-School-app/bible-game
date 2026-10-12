import 'package:bible_game/shared/data/daily_devotionals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('day of year counts calendar dates from 0 on 1 January', () {
    expect(DailyDevotionals.dayOfYear(DateTime(2026, 1, 1)), 0);
    expect(DailyDevotionals.dayOfYear(DateTime(2026, 1, 1, 23, 59)), 0);
    expect(DailyDevotionals.dayOfYear(DateTime(2026, 12, 31)), 364);
    expect(DailyDevotionals.dayOfYear(DateTime(2028, 12, 31)), 365); // leap
  });

  test('the whole day maps to one passage, whatever the time', () {
    final morning = DailyDevotionals.forDate(DateTime(2026, 10, 12, 8));
    final night = DailyDevotionals.forDate(DateTime(2026, 10, 12, 23, 30));
    expect(night['passage'], morning['passage']);
  });

  test('consecutive days get different passages', () {
    final passages = {
      for (var d = 1; d <= 7; d++)
        DailyDevotionals.forDate(DateTime(2026, 10, d))['passage']
    };
    expect(passages.length, 7);
  });
}
