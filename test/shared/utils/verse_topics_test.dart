import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game/shared/utils/verse_topics.dart';
import 'package:flutter_test/flutter_test.dart';

VerseTopic _topic(String id, int count) => VerseTopic(
      id: id,
      name: id,
      tagline: '',
      verses: [
        for (var i = 0; i < count; i++)
          MemoryVerse(reference: '$id $i', text: '$id verse $i'),
      ],
    );

void main() {
  const all = ['healing', 'faith', 'peace'];

  group('resolveVerseTopics', () {
    test('nothing stored means every topic', () {
      expect(resolveVerseTopics(null, all), all);
      expect(resolveVerseTopics([], all), all);
    });

    test('keeps file order, whatever order they were stored in', () {
      expect(resolveVerseTopics(['peace', 'healing'], all),
          ['healing', 'peace']);
    });

    test('drops topics that no longer exist', () {
      expect(resolveVerseTopics(['faith', 'gone'], all), ['faith']);
      expect(resolveVerseTopics(['gone'], all), all);
    });
  });

  group('versesForTopics', () {
    final topics = [_topic('healing', 2), _topic('faith', 3), _topic('peace', 1)];

    test('only the chosen topics, topic by topic in file order', () {
      final verses = versesForTopics(topics, ['peace', 'healing']);
      expect(verses.map((v) => v.reference),
          ['healing 0', 'healing 1', 'peace 0']);
    });
  });

  group('verseForSlot', () {
    final verses = versesForTopics([_topic('faith', 50)], ['faith']);

    test('counts the day of the year from 0', () {
      // 1 Jan, 8:00 slot: (0 * 24 + 8) % 50
      expect(verseForSlot(verses, DateTime(2026, 1, 1, 9), 8).reference,
          'faith 8');
      // 2 Jan, 0:00 slot: (1 * 24 + 0) % 50
      expect(verseForSlot(verses, DateTime(2026, 1, 2), 0).reference,
          'faith 24');
    });

    test('the day does not slip in the first hour after a clock change', () {
      // 30 March 2026 is day 88 whatever the local time zone does.
      expect(verseDayOfYear(DateTime(2026, 3, 30, 0, 30)), 88);
      expect(verseDayOfYear(DateTime(2026, 10, 26, 0, 30)), 298);
    });
  });
}
