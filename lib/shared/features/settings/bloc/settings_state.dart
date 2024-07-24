part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isSoundOn;
  final bool isMusicOn;
  final bool isNotificationOn;
  final dynamic gamePlaySettings;

  const SettingsState({
    required this.isSoundOn,
    required this.isMusicOn,
    required this.isNotificationOn,
    this.gamePlaySettings
  });

  factory SettingsState.initial() {
    return SettingsState(
      isSoundOn: true,
      isMusicOn: true,
      isNotificationOn: true,
      gamePlaySettings: {},
    );
  }

  SettingsState copyWith({
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isNotificationOn,
    dynamic gamePlaySettings
  }) {
    return SettingsState(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      gamePlaySettings: gamePlaySettings ?? this.gamePlaySettings,
    );
  }

  @override
  List<Object> get props => [isSoundOn, isMusicOn, isNotificationOn, gamePlaySettings];
}