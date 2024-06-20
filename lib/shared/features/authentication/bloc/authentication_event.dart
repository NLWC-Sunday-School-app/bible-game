part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.state);

  final AuthenticationState state;

  @override
  List<Object> get props => [state];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  final email;
  final password;

  AuthenticationLoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthenticationRefreshTokenRequested extends AuthenticationEvent {
  final refreshToken;

  AuthenticationRefreshTokenRequested(this.refreshToken);

  @override
  List<Object> get props => [refreshToken];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationRegisterRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final String fcmToken;
  final String country;

  AuthenticationRegisterRequested(
    this.name,
    this.email,
    this.password,
    this.fcmToken,
    this.country,
  );

  @override
  List<Object> get props => [name, email, password, fcmToken, country];
}

class FetchUserDataRequested extends AuthenticationEvent {}


