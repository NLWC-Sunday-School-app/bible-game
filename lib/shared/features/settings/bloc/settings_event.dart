part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class ToggleSound extends SettingsEvent {}

class ToggleMusic extends SettingsEvent {}

class ToggleNotification extends SettingsEvent {}

class FetchGamePlaySettings extends SettingsEvent {}

