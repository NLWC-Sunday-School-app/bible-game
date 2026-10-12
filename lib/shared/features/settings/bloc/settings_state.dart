part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isSoundOn;
  final bool isMusicOn;
  /// Lock screen verses. Named before the daily reading reminder had a
  /// switch of its own, when this one covered both.
  final bool isNotificationOn;

  /// The 8 AM daily reading reminder.
  final bool isDailyReadingOn;

  /// Hours between lock screen verses -- see kVerseFrequencyOptions.
  final int verseFrequencyHours;

  /// Topic ids the verses come from, in file order. Empty until loaded.
  final List<String> verseTopics;
  final dynamic gamePlaySettings;
  final List<GameAds>? adContent;
  final bool isLoadingAds;


  const SettingsState({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isNotificationOn,
    this.isDailyReadingOn = true,
    this.verseFrequencyHours = kDefaultVerseFrequencyHours,
    this.verseTopics = const [],
    this.gamePlaySettings,
    this.adContent,
    this.isLoadingAds = false,

  });

  factory SettingsState.initial() {
    return SettingsState(
      isSoundOn: true,
      isMusicOn: true,
      isNotificationOn: true,
      gamePlaySettings: {},
      isLoadingAds: false,

    );
  }

  SettingsState copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isNotificationOn,
    bool? isDailyReadingOn,
    int? verseFrequencyHours,
    List<String>? verseTopics,
    dynamic gamePlaySettings,
    bool? isLoadingAds,
    List<GameAds>? adContent,

  }) {
    return SettingsState(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      isDailyReadingOn: isDailyReadingOn ?? this.isDailyReadingOn,
      verseFrequencyHours: verseFrequencyHours ?? this.verseFrequencyHours,
      verseTopics: verseTopics ?? this.verseTopics,
      gamePlaySettings: gamePlaySettings ?? this.gamePlaySettings,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      adContent: adContent ?? this.adContent,

    );
  }

  @override
  List<Object> get props => [isSoundOn, isMusicOn, isNotificationOn,
      isDailyReadingOn,
      verseFrequencyHours, verseTopics, gamePlaySettings, isLoadingAds];
}