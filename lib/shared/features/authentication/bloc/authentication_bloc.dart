import 'dart:async';
import 'dart:convert';
import 'package:bible_game/shared/utils/google_auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:equatable/equatable.dart';
import 'package:bible_game_api/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/awesome_notification.dart';
import '../../user/repository/user_repository.dart';
import '../repository/authentication_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final prefs = SharedPreferences.getInstance();

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState(isUnauthenticated: true)) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLoginRequested>(_onAuthenticationLoginRequested);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationRegisterRequested>(_onAuthenticationRegisterRequested);
    on<FetchUserDataRequested>(_onFetchUserDataRequested);
    on<AuthenticationRefreshTokenRequested>(_onRefreshTokenRequested);
    on<UpdateFCMToken>(_onUpdateFCMToken);
    on<SendForgotPasswordMail>(_onSendForgotPasswordEmail);
    on<VerifyOTP>(_onVerifyOTP);
    on<ResetPassword>(_onResetPassword);
    on<DeleteAccount>(_onDeleteAccount);
    on<RestoreSession>(_onRestoreSession);
    on<AuthenticationGoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(event.state);
  }

  Future<void> _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoggingOut: true, hasLoggedOut: false));

    // Best effort, and deliberately not conditional on the result. The server
    // call used to gate everything below it: any non-200 made logOut() return
    // false, nothing was emitted, and isLoggingOut stayed true -- the spinner
    // ran forever with no way out. The whole handler also sat behind
    // `state.user.id != 0`, so a logout before the profile landed did nothing
    // at all, spinner already showing. The user asked to log out; the local
    // session goes regardless of what the server says.
    try {
      await _authenticationRepository.logOut();
    } catch (e) {
      debugPrint('\u26A0\uFE0F Server logout failed, clearing locally: $e');
    }

    // The Google plugin keeps its own session, and nothing was clearing it.
    // signIn() kept returning the cached account with no picker, so you could
    // not switch Google accounts and the logout looked like it had not taken.
    try {
      await GoogleAuthService.signOut();
    } catch (e) {
      debugPrint('\u26A0\uFE0F Google sign-out failed: $e');
    }

    GetStorage().remove(_cachedUserKey);
    GetStorage().remove('user_token');
    GetStorage().remove('refresh_token');

    // A fresh state rather than copyWith: copyWith resolves token as
    // `token ?? this.token`, so passing null there leaves the old token in
    // place and the session is never really cleared.
    emit(const AuthenticationState(
        isUnauthenticated: true, hasLoggedOut: true));
    emit(const AuthenticationState(isUnauthenticated: true));
  }

  Future<void> _onAuthenticationLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoadingLogin: true, failedToLogin: false));
    final response =
        await _authenticationRepository.logIn(event.email, event.password, event.deviceName, event.deviceOs);
    if (response.containsKey('token')) {
      emit(state.copyWith(
        isLoggedIn: true,
        isLoadingLogin: false,
        token: response['token'],
        refreshToken: response['refreshToken'],
        failedToLogin: false,
      ));
      GetStorage().write('user_token', state.token!);
      GetStorage().write('refresh_token', state.refreshToken!);
      add(FetchUserDataRequested());
      add(UpdateFCMToken());
      emit(state.copyWith(isLoadingLogin: false, failedToLogin: false));
    } else {
      emit(state.copyWith(isLoadingLogin: false, failedToLogin: true));
      emit(state.copyWith(isLoadingLogin: false, failedToLogin: false));
    }
  }

  Future<void> _onAuthenticationRegisterRequested(
    AuthenticationRegisterRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoadingLogin: true, failedToRegister: false));

    try {
      final success = await _authenticationRepository.register(
          event.name, event.email, event.password, event.fcmToken, event.country, event.deviceName, event.deviceOs);
      if (success) {
        final response =
        await _authenticationRepository.logIn(event.email, event.password, event.deviceName, event.deviceOs);
        if (response.containsKey('token')) {
          emit(state.copyWith(
            isLoggedIn: true,
            isLoadingLogin: false,
            token: response['token'],
            refreshToken: response['refreshToken'],
            failedToRegister: false,
          ));
          Future.delayed(Duration(seconds: 1), () {
            add(FetchUserDataRequested());
            add(UpdateFCMToken());
          });
          emit(state.copyWith(isLoadingLogin: false, failedToRegister: false));
        }
      } else {
        emit(state.copyWith(isLoadingLogin: false, failedToRegister: true));
        emit(state.copyWith(isLoadingLogin: false, failedToRegister: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingLogin: false, failedToRegister: true));
      emit(state.copyWith(isLoadingLogin: false, failedToRegister: false));
    }
  }

  /// Key used to persist the last successfully-fetched User JSON in GetStorage.
  static const _cachedUserKey = 'cached_user_data';

  Future<void> _onFetchUserDataRequested(
    FetchUserDataRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await _userRepository.getUser();
      emit(state.copyWith(user: user, isUnauthenticated: false, isLoggedIn: true));

      // Persist the user locally so we can restore it when offline
      GetStorage().write(_cachedUserKey, jsonEncode(user.toJson()));
    } catch (_) {
      // Network failed — try to restore from local cache
      final cachedUser = _loadCachedUser();
      if (cachedUser != null) {
        emit(state.copyWith(user: cachedUser, isUnauthenticated: false, isLoggedIn: true));
      } else {
        emit(state.copyWith(isUnauthenticated: true, user: null));
      }
    }
  }

  /// Attempts to load a previously-cached User from GetStorage.
  User? _loadCachedUser() {
    try {
      final raw = GetStorage().read(_cachedUserKey);
      if (raw != null && raw is String && raw.isNotEmpty) {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return User.fromJson(json);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _onUpdateFCMToken(
      UpdateFCMToken event, Emitter<AuthenticationState> emit) async {
    try {
      final fcmToken = await AwesomeNotification.getFirebaseMessagingToken();
      // An empty token means FCM was not ready, not that push was revoked.
      // Sending it would clear a perfectly good token on the server.
      if (fcmToken.isEmpty) return;
      await _userRepository.updateUserFCMToken(fcmToken);
    } catch (_) {}
  }

  Future<void> _onRefreshTokenRequested(
    AuthenticationRefreshTokenRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final newTokens =
          await _authenticationRepository.refreshToken(event.refreshToken);
      print('new Tokens $newTokens');
      emit(state.copyWith(
        token: newTokens['token'],
        refreshToken: newTokens['refreshToken'],
      ));
      GetStorage().write('user_token', newTokens['token']);
      GetStorage().write('refresh_token', newTokens['refreshToken']);

      Future.delayed(Duration(seconds: 2), () {
        add(FetchUserDataRequested());
      });
    } catch (_) {
      emit(state.copyWith(
        isUnauthenticated: true,
        token: null,
        refreshToken: null,
      ));
    }
  }

  Future<void> _onSendForgotPasswordEmail(
      SendForgotPasswordMail event, Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(isSendingForgotPasswordCode: true));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('reset_email', event.email);
      await _authenticationRepository.sendForgotPasswordMail(event.email);
      emit(state.copyWith(
          isSendingForgotPasswordCode: false, forgotPasswordMailSent: true));
    } catch (_) {
      emit(state.copyWith(isSendingForgotPasswordCode: false));
    }
  }

  Future<void> _onVerifyOTP(
      VerifyOTP event, Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(isVerifyingCode: true));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('reset_email');
      await _authenticationRepository.verifyOTP(event.OTP, email);
      emit(state.copyWith(isVerifyingCode: false, hasVerifiedCode: true));
    } catch (_) {
      emit(state.copyWith(isVerifyingCode: false));
    }
  }

  Future<void> _onResetPassword(
      ResetPassword event, Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(isResettingPassword: true));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('reset_email');
      await _authenticationRepository.resetPassword(event.newPassword, email);
      emit(state.copyWith(isResettingPassword: false, hasResetPassword: true));
    } catch (_) {
      emit(state.copyWith(isResettingPassword: false));
    }
  }

  Future<void> _onRestoreSession(
    RestoreSession event,
    Emitter<AuthenticationState> emit,
  ) async {
    final storedToken = GetStorage().read('user_token');
    final storedRefreshToken = GetStorage().read('refresh_token');
    if (storedToken != null) {
      emit(state.copyWith(
        token: storedToken,
        refreshToken: storedRefreshToken,
        isUnauthenticated: false,
      ));
      // Restore cached user data immediately so UI shows logged-in state
      final cachedUser = _loadCachedUser();
      if (cachedUser != null) {
        emit(state.copyWith(
          user: cachedUser,
          isLoggedIn: true,
        ));
      }
    }
  }

  Future<void> _onGoogleSignInRequested(
      AuthenticationGoogleSignInRequested event,
      Emitter<AuthenticationState> emit) async {
    emit(state.copyWith(
        isLoadingGoogleSignIn: true, failedGoogleSignIn: false));
    try {
      // One call. The backend verifies the token with Google and creates or
      // links the account itself, so there is no password to invent and no
      // login-then-register guessing to do.
      final response = await _authenticationRepository.googleSignIn(
        event.idToken,
        event.deviceName,
        event.deviceOs,
        event.fcmToken,
        event.country,
      );

      if (response.containsKey('token')) {
        emit(state.copyWith(
          isLoggedIn: true,
          isLoadingGoogleSignIn: false,
          token: response['token'],
          refreshToken: response['refreshToken'],
          failedGoogleSignIn: false,
        ));
        GetStorage().write('user_token', state.token!);
        GetStorage().write('refresh_token', state.refreshToken!);
        add(FetchUserDataRequested());
        add(UpdateFCMToken());
        emit(state.copyWith(
            isLoadingGoogleSignIn: false, failedGoogleSignIn: false));
      } else {
        debugPrint('\u26A0\uFE0F Google sign-in: no token back from the backend '
            '(status ${response['status']}: '
            '${response['error'] ?? response['message']})');
        emit(state.copyWith(
            isLoadingGoogleSignIn: false, failedGoogleSignIn: true));
        emit(state.copyWith(
            isLoadingGoogleSignIn: false, failedGoogleSignIn: false));
      }
    } catch (error) {
      debugPrint('\u26A0\uFE0F Google sign-in threw: $error');
      emit(state.copyWith(
          isLoadingGoogleSignIn: false, failedGoogleSignIn: true));
      emit(state.copyWith(
          isLoadingGoogleSignIn: false, failedGoogleSignIn: false));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccount event, Emitter<AuthenticationState> emit) async {
    try {
      emit(state.copyWith(isDeletingAccount: true));
       add(AuthenticationLogoutRequested());
      await _authenticationRepository.deleteAccount(state.user.id);
      emit(state.copyWith(isDeletingAccount: false, hasDeletedAccount: true));
      emit(state.copyWith(isDeletingAccount: false, hasDeletedAccount: false));
    } catch (_) {
      emit(state.copyWith(isDeletingAccount: false, hasDeletedAccount: false));
    }
  }

}


