import 'package:shared_preferences/shared_preferences.dart';

/// How often lock screen verses arrive, as hours between them.
///
/// Keys are the gap in hours; values are what the user sees. Only these values
/// are accepted -- a verse schedule is built by stepping through the 24 hours
/// of a day, so the gap has to divide the day evenly or the last slot of one
/// day sits oddly close to the first of the next.
const Map<int, String> kVerseFrequencyOptions = {
  1: 'Every hour',
  2: 'Every 2 hours',
  3: 'Every 3 hours',
  4: 'Every 4 hours',
  6: 'Every 6 hours',
  8: 'Every 8 hours',
  12: 'Twice a day',
  24: 'Once a day',
};

/// Hourly, which is what shipped before this was configurable.
const int kDefaultVerseFrequencyHours = 1;

/// SharedPreferences / GetStorage key.
const String kVerseFrequencyPrefKey = 'verseFrequencyHours';

/// Accepts anything stored or passed in and returns a supported value.
int resolveVerseFrequency(dynamic value) {
  final hours = value is int ? value : int.tryParse('${value ?? ''}');
  if (hours == null || !kVerseFrequencyOptions.containsKey(hours)) {
    return kDefaultVerseFrequencyHours;
  }
  return hours;
}

/// Lock screen verses used to have an off switch. They are always on now, and
/// how often is the only control, so anyone who had switched them off gets the
/// quietest setting, once a day, rather than the hourly default. Runs once.
Future<void> retireVerseOffSwitch(SharedPreferences prefs) async {
  const doneKey = 'verseOffSwitchRetired';
  if (prefs.getBool(doneKey) ?? false) return;
  if (prefs.getBool('isNotificationOn') == false) {
    await prefs.setInt(kVerseFrequencyPrefKey, 24);
  }
  await prefs.setBool(doneKey, true);
}
