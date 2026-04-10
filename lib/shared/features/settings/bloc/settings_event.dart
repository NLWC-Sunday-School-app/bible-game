part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleSound extends SettingsEvent {}

class ToggleMusic extends SettingsEvent {}

class ToggleNotification extends SettingsEvent {}

class UpdateSoundState extends SettingsEvent {
  final bool isMusicOn;
  final bool isSoundOn;

  UpdateSoundState(this.isMusicOn, this.isSoundOn);

  @override
  List<Object> get props => [isMusicOn, isSoundOn];
}

class FetchGamePlaySettings extends SettingsEvent {}

class FetchAds extends SettingsEvent {}
