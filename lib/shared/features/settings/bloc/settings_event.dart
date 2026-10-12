part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleSound extends SettingsEvent {}

class ToggleMusic extends SettingsEvent {}

/// Switches push from the backend on or off.
class TogglePushNotifications extends SettingsEvent {}

/// Restores the persisted notification preference on launch.
class LoadNotificationSetting extends SettingsEvent {}

/// Sets how many hours apart lock screen verses arrive.
class SetVerseFrequency extends SettingsEvent {
  final int hours;
  SetVerseFrequency(this.hours);
  @override
  List<Object> get props => [hours];
}

/// Sets the topics lock screen verses and the widgets draw from.
class SetVerseTopics extends SettingsEvent {
  final List<String> topicIds;
  SetVerseTopics(this.topicIds);
  @override
  List<Object> get props => [topicIds];
}

class UpdateSoundState extends SettingsEvent {
  final bool isMusicOn;
  final bool isSoundOn;

  UpdateSoundState(this.isMusicOn, this.isSoundOn);

  @override
  List<Object> get props => [isMusicOn, isSoundOn];
}

class FetchGamePlaySettings extends SettingsEvent {}

class FetchAds extends SettingsEvent {}
