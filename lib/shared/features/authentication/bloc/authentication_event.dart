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
  final deviceName;
  final deviceOs;

  AuthenticationLoginRequested(
      this.email, this.password, this.deviceName, this.deviceOs);

  @override
  List<Object> get props => [email, password, deviceName, deviceOs];
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
  final deviceName;
  final deviceOs;

  AuthenticationRegisterRequested(this.name, this.email, this.password,
      this.fcmToken, this.country, this.deviceName, this.deviceOs);

  @override
  List<Object> get props =>
      [name, email, password, fcmToken, country, deviceName, deviceOs];
}

class FetchUserDataRequested extends AuthenticationEvent {}

class UpdateFCMToken extends AuthenticationEvent {}

class SendForgotPasswordMail extends AuthenticationEvent {
  final String email;

  SendForgotPasswordMail(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOTP extends AuthenticationEvent {
  final String OTP;

  VerifyOTP(this.OTP);

  @override
  List<Object> get props => [this.OTP];
}

class ResetPassword extends AuthenticationEvent {
  final String newPassword;

  ResetPassword(this.newPassword);

  @override
  List<Object> get props => [this.newPassword];
}

class DeleteAccount extends AuthenticationEvent {}
