part of 'authentication_bloc.dart';


abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}


class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();
}

class AuthenticationLoadingLogin extends AuthenticationState {
  const AuthenticationLoadingLogin();
}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;

  const AuthenticationAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationLoginSuccess extends AuthenticationState {
  final String token;
  final String refreshToken;

  const AuthenticationLoginSuccess(this.token, this.refreshToken);

  @override
  List<Object> get props => [token, refreshToken];
}
