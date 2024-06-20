part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class SoundOff extends UserState {}

class SoundOn extends UserState {}

class MusicOn extends UserState {}

class MusicOff extends UserState {}

class NotificationOn extends UserState {}

class NotificationOff extends UserState {}

class LoadingAds extends UserState {}

class LoadedAds extends UserState {}

class AdsDisplayed extends UserState {
  final List<GameAds> adContent;

  const AdsDisplayed(this.adContent);

  @override
  List<Object> get props => [adContent];
}

class PilgrimProgressData extends UserState {
  final List<PilgrimProgressLevelData> pilgrimProgressDetails;

  const PilgrimProgressData(this.pilgrimProgressDetails);

  @override
  List<Object> get props => [pilgrimProgressDetails];
}

class GamePlaySettings extends UserState {
  final Map<String, dynamic> gamePlaySettings;

  const GamePlaySettings(this.gamePlaySettings);

  @override
  List<Object> get props => [gamePlaySettings];
}
