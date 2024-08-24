part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isSoundOn;
  final bool isMusicOn;
  final bool isNotificationOn;
  final dynamic gamePlaySettings;
  final List<GameAds>? adContent;
  final bool isLoadingAds;


  const SettingsState({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isNotificationOn,
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
    dynamic gamePlaySettings,
    bool? isLoadingAds,
    List<GameAds>? adContent,

  }) {
    return SettingsState(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      gamePlaySettings: gamePlaySettings ?? this.gamePlaySettings,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      adContent: adContent ?? this.adContent,

    );
  }

  @override
  List<Object> get props => [isSoundOn, isMusicOn, isNotificationOn, gamePlaySettings, isLoadingAds];
}