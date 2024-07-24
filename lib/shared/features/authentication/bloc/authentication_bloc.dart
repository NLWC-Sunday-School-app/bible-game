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
    if (state.user != null) {
      emit(state.copyWith(isLoggingOut: true));
      try {
        final loggedOut = await _authenticationRepository.logOut();
        if (loggedOut) {
          emit(state.copyWith(
            isLoggedIn: false,
            isUnauthenticated: true,
            isLoadingLogin: false,
            isLoggingOut: false,
            user: null,
            token: null,
            refreshToken: null,
          ));
        }
      } catch (_) {
        emit(state.copyWith(isLoggingOut: false));
      }
    }
  }

  Future<void> _onAuthenticationLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoadingLogin: true));
    final response =
        await _authenticationRepository.logIn(event.email, event.password);
    if (response.containsKey('token')) {
      emit(state.copyWith(
        isLoggedIn: true,
        isLoadingLogin: false,
        token: response['token'],
        refreshToken: response['refreshToken'],
        isUnauthenticated: false,
      ));
      add(FetchUserDataRequested());
    } else {
      emit(state.copyWith(isLoadingLogin: false, isUnauthenticated: true));
    }
  }

  Future<void> _onAuthenticationRegisterRequested(
    AuthenticationRegisterRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoadingLogin: true));
    final success = await _authenticationRepository.register(
        event.name, event.email, event.password, event.fcmToken, event.country);
    if (success) {
      final response =
          await _authenticationRepository.logIn(event.email, event.password);
      if (response.containsKey('token')) {
        emit(state.copyWith(
          isLoadingLogin: false,
          token: response['token'],
          refreshToken: response['refreshToken'],
          isUnauthenticated: false,
        ));
        add(FetchUserDataRequested());
      }
    } else {
      emit(state.copyWith(isLoadingLogin: false, isUnauthenticated: true));
    }
  }

  Future<void> _onFetchUserDataRequested(
    FetchUserDataRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await _userRepository.getUser();
       emit(state.copyWith(user: user));
    } catch (_) {
      emit(state.copyWith(isUnauthenticated: true, user: null));
    }
  }

  Future<void> _onRefreshTokenRequested(
    AuthenticationRefreshTokenRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final newTokens = await _authenticationRepository.refreshToken('');
      // emit(state.copyWith(
      //   token: newTokens['token'],
      //   refreshToken: newTokens['refreshToken'],
      // ));
    } catch (_) {
      emit(state.copyWith(
          isUnauthenticated: true, token: null, refreshToken: null));
    }
  }
}
