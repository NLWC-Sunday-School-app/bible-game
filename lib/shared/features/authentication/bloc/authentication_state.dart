part of 'authentication_bloc.dart';

class _NotSpecified {
  const _NotSpecified();
}

const _notSpecified = _NotSpecified();

class AuthenticationState extends Equatable {
  final bool isLoggedIn;
  final bool isUnauthenticated;
  final bool isLoadingLogin;
  final bool isLoggingOut;
  final User? user;
  final String? token;
  final String? refreshToken;

  const AuthenticationState({
    this.isLoggedIn = false,
    this.isUnauthenticated = false,
    this.isLoadingLogin = false,
    this.isLoggingOut = false,
    this.user,
    this.token,
    this.refreshToken,
  });

  AuthenticationState copyWith({
    bool? isLoggedIn,
    bool? isUnauthenticated,
    bool? isLoadingLogin,
    bool? isLoggingOut,
    User? user,
    String? token,
    String? refreshToken,
  }) {
    return AuthenticationState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isUnauthenticated: isUnauthenticated ?? this.isUnauthenticated,
      isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      user: user ?? null,
      token: token ?? null ,
      refreshToken: refreshToken  ?? null,
    );
  }

  @override
  List<Object?> get props => [
    isLoggedIn,
    isUnauthenticated,
    isLoadingLogin,
    isLoggingOut,
    user,
    token,
    refreshToken,
  ];
}

