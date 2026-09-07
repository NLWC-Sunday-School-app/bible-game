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

  // AppBlocObserver prints every event; keep the password out of the console.
  @override
  String toString() =>
      'AuthenticationLoginRequested(email: $email, password: <redacted>)';
}

class AuthenticationRefreshTokenRequested extends AuthenticationEvent {
  final refreshToken;

  AuthenticationRefreshTokenRequested(this.refreshToken);

  @override
  List<Object> get props => [refreshToken];

  @override
  String toString() =>
      'AuthenticationRefreshTokenRequested(refreshToken: <redacted>)';
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

  @override
  String toString() => 'AuthenticationRegisterRequested(name: $name, '
      'email: $email, password: <redacted>)';
}

class FetchUserDataRequested extends AuthenticationEvent {}

class RestoreSession extends AuthenticationEvent {}

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

  @override
  String toString() => 'VerifyOTP(OTP: <redacted>)';
}

class ResetPassword extends AuthenticationEvent {
  final String newPassword;

  ResetPassword(this.newPassword);

  @override
  List<Object> get props => [this.newPassword];

  @override
  String toString() => 'ResetPassword(newPassword: <redacted>)';
}

class DeleteAccount extends AuthenticationEvent {}

class AuthenticationGoogleSignInRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final String country;
  final String fcmToken;
  final deviceName;
  final deviceOs;

  AuthenticationGoogleSignInRequested(this.name, this.email, this.password,
      this.country, this.fcmToken, this.deviceName, this.deviceOs);

  @override
  List<Object> get props =>
      [name, email, password, country, fcmToken, deviceName, deviceOs];

  @override
  String toString() => 'AuthenticationGoogleSignInRequested(name: $name, '
      'email: $email, password: <redacted>)';
}
