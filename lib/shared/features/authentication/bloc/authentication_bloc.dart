import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bible_game_api/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user/repository/user_repository.dart';
import '../repository/authentication_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final prefs = SharedPreferences.getInstance();

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository,
      required UserRepository userRepository})
      : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(AuthenticationUnauthenticated()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLoginRequested>(_onAuthenticationLoginRequested);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationRegisterRequested>(_onAuthenticationRegisterRequested);
    on<FetchUserDataRequested>(_onFetchUserDataRequested);
    on<AuthenticationRefreshTokenRequested>(_onRefreshTokenRequested);
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(event.state);
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  Future<void> _onAuthenticationLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoadingLogin());
    final response =
        await _authenticationRepository.logIn(event.email, event.password);
    if (response.containsKey('token')) {
      emit(
        AuthenticationLoginSuccess(response['token'], response['refreshToken']),
      );
      add(FetchUserDataRequested());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onAuthenticationRegisterRequested(
    AuthenticationRegisterRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoadingLogin());
    final success = await _authenticationRepository.register(
        event.name, event.email, event.password, event.fcmToken, event.country);
    if (success) {
      final response =
          await _authenticationRepository.logIn(event.email, event.password);
      if (response.containsKey('token')) {
        emit(
          AuthenticationLoginSuccess(
              response['token'], response['refreshToken']),
        );
        add(FetchUserDataRequested());
      }
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onFetchUserDataRequested(
    FetchUserDataRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await _userRepository.getUser();
      emit(AuthenticationAuthenticated(user));
    } catch (_) {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onRefreshTokenRequested(
      AuthenticationRefreshTokenRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    try {
      // final user = await _authenticationRepository.refreshToken();
      // emit(AuthenticationAuthenticated(user));
    } catch (_) {
      emit(AuthenticationUnauthenticated());
    }
  }
}
