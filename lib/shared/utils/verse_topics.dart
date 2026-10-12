import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key for the topics lock screen verses and the home screen
/// widgets draw from. Nothing stored means every topic.
const String kVerseTopicsPrefKey = 'verseTopics';

/// The topic ids to use, in the order of the bundled file: the stored ones
/// that still exist, or every topic when none of them do. Never empty -- a
/// verse rotation with no verses in it has nothing to show.
List<String> resolveVerseTopics(List<String>? stored, List<String> allIds) {
  final chosen = allIds.where((id) => stored?.contains(id) ?? false).toList();
  return chosen.isEmpty ? List.of(allIds) : chosen;
}

/// The chosen topics as stored, already resolved against the bundled topics.
Future<List<String>> loadVerseTopicIds() async {
  final prefs = await SharedPreferences.getInstance();
  final topics = await MemoryVerseData.loadTopics();
  return resolveVerseTopics(
    prefs.getStringList(kVerseTopicsPrefKey),
    [for (final t in topics) t.id],
  );
}

/// Every verse of the chosen topics, topic by topic in file order. The iOS and
/// Android widgets build the same list, so all three pick the same verse.
List<MemoryVerse> versesForTopics(
    List<VerseTopic> topics, Iterable<String> topicIds) {
  final chosen = topicIds.toSet();
  return [
    for (final t in topics)
      if (chosen.contains(t.id)) ...t.verses,
  ];
}

/// The verse for the slot starting at [slotHour] on [date]'s day.
MemoryVerse verseForSlot(
    List<MemoryVerse> verses, DateTime date, int slotHour) {
  return verses[(verseDayOfYear(date) * 24 + slotHour) % verses.length];
}

/// Day of the year counted from 0. Worked out on calendar dates in UTC: the
/// gap between two local times is an hour short across a clock change, which
/// put the first hour after midnight on the previous day.
int verseDayOfYear(DateTime date) => DateTime.utc(date.year, date.month, date.day)
    .difference(DateTime.utc(date.year, 1, 1))
    .inDays;
