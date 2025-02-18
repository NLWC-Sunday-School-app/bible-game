part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchPilgrimProgressData extends UserEvent {
  final int userId;

  FetchPilgrimProgressData(this.userId);

  @override
  List<Object> get props => [userId];
}

class FetchGlobalLeaderBoard extends UserEvent {
  final bool isLoggedIn;

  FetchGlobalLeaderBoard(this.isLoggedIn);

  @override
  List<Object> get props => [isLoggedIn];
}

class FetchCountryLeaderBoard extends UserEvent {}

class FetchUserStreakDetails extends UserEvent {}

class FetchUserYearlyRecap extends UserEvent {}

class UpdateUserProfile extends UserEvent {
  final newUserName;

  UpdateUserProfile(this.newUserName);

  @override
  List<Object> get props => [newUserName];
}

class PurchaseGem extends UserEvent {}

class RestoreStreak extends UserEvent {}

class OnboardCollaborator extends UserEvent {}

class InitializeWallet extends UserEvent {}

class UpdateCountry extends UserEvent {
  final String country;

  UpdateCountry(this.country);

  @override
  List<Object> get props => [country];
}
