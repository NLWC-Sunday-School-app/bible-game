part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class ToggleSound extends UserEvent {}

class ToggleMusic extends UserEvent {}

class ToggleNotification extends UserEvent {}

class FetchAds extends UserEvent {}

class FetchPilgrimProgressData extends UserEvent {
  final int userId;

  FetchPilgrimProgressData(this.userId);

  @override
  List<Object> get props => [userId];
}

class FetchGamePlaySettings extends UserEvent {}
