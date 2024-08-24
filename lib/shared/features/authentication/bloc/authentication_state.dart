part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool isLoggedIn;
  final bool isUnauthenticated;
  final bool isLoadingLogin;
  final bool isLoggingOut;
  final User user;
  final String? token;
  final String? refreshToken;
  final bool isSendingForgotPasswordCode;
  final bool forgotPasswordMailSent;
  final bool isVerifyingCode;
  final bool hasVerifiedCode;
  final bool isResettingPassword;
  final bool hasResetPassword;
  final bool failedToLogin;
  final bool failedToRegister;

  const AuthenticationState(
      {this.isLoggedIn = false,
      this.isUnauthenticated = false,
      this.isLoadingLogin = false,
      this.isLoggingOut = false,
      this.isSendingForgotPasswordCode = false,
      this.hasVerifiedCode = false,
      this.forgotPasswordMailSent = false,
      this.isResettingPassword = false,
      this.hasResetPassword = false,
      this.isVerifyingCode = false,
      this.user = emptyUser,
      this.token,
      this.refreshToken,
      this.failedToLogin = false,
      this.failedToRegister = false});

  AuthenticationState copyWith({
    bool? isLoggedIn,
    bool? isUnauthenticated,
    bool? isLoadingLogin,
    bool? isLoggingOut,
    bool? isSendingForgotPasswordCode,
    bool? hasVerifiedCode,
    bool? forgotPasswordMailSent,
    bool? isResettingPassword,
    bool? hasResetPassword,
    bool? isVerifyingCode,
    User? user,
    String? token,
    String? refreshToken,
    bool? failedToLogin,
    bool? failedToRegister,
  }) {
    return AuthenticationState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isUnauthenticated: isUnauthenticated ?? this.isUnauthenticated,
        isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
        isSendingForgotPasswordCode:
            isSendingForgotPasswordCode ?? this.isSendingForgotPasswordCode,
        hasVerifiedCode: hasVerifiedCode ?? this.hasVerifiedCode,
        forgotPasswordMailSent:
            forgotPasswordMailSent ?? this.forgotPasswordMailSent,
        isResettingPassword: isResettingPassword ?? this.isResettingPassword,
        hasResetPassword: hasResetPassword ?? this.hasResetPassword,
        isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
        isLoggingOut: isLoggingOut ?? this.isLoggingOut,
        user: user ?? this.user,
        token: token ?? null,
        refreshToken: refreshToken ?? null,
        failedToLogin: failedToLogin ?? this.failedToLogin,
        failedToRegister: failedToRegister ?? this.failedToRegister);
  }

  @override
  List<Object?> get props => [
        isLoggedIn,
        isUnauthenticated,
        isLoadingLogin,
        isLoggingOut,
        isSendingForgotPasswordCode,
        hasVerifiedCode,
        forgotPasswordMailSent,
        isResettingPassword,
        hasResetPassword,
        isVerifyingCode,
        user,
        token,
        refreshToken,
        failedToLogin,
        failedToRegister
      ];
}
