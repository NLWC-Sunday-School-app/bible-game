part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isSoundOn;
  final bool isMusicOn;
  /// Push from the backend through Firebase. Lock screen verses have no
  /// switch, only a frequency.
  final bool isPushOn;

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
    required this.isPushOn,
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
      isPushOn: true,
      gamePlaySettings: {},
      isLoadingAds: false,

    );
  }

  SettingsState copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isPushOn,
    int? verseFrequencyHours,
    List<String>? verseTopics,
    dynamic gamePlaySettings,
    bool? isLoadingAds,
    List<GameAds>? adContent,

  }) {
    return SettingsState(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isPushOn: isPushOn ?? this.isPushOn,
      verseFrequencyHours: verseFrequencyHours ?? this.verseFrequencyHours,
      verseTopics: verseTopics ?? this.verseTopics,
      gamePlaySettings: gamePlaySettings ?? this.gamePlaySettings,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      adContent: adContent ?? this.adContent,

    );
  }

  @override
  List<Object> get props => [isSoundOn, isMusicOn, isPushOn,
      verseFrequencyHours, verseTopics, gamePlaySettings, isLoadingAds];
}