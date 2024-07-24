import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user/repository/user_repository.dart';
import '../sound_manager.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SoundManager soundManager;
  final UserRepository _userRepository;

  SettingsBloc(this.soundManager, {required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SettingsState.initial()) {
    on<ToggleSound>(_onToggleSound);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleNotification>(_onToggleNotification);
    on<FetchGamePlaySettings>(_onFetchGamePlaySettings);
  }

  void _onToggleSound(ToggleSound event, Emitter<SettingsState> emit) {
    final newState = state.copyWith(isSoundOn: !state.isSoundOn);
    emit(newState);
    soundManager.updateSettings(newState);
  }

  void _onToggleMusic(ToggleMusic event, Emitter<SettingsState> emit) {
    final newState = state.copyWith(isMusicOn: !state.isMusicOn);
    emit(newState);
    soundManager.updateSettings(newState);
  }

  void _onToggleNotification(
      ToggleNotification event, Emitter<SettingsState> emit) {
    final newState = state.copyWith(isNotificationOn: !state.isNotificationOn);
    emit(newState);
  }


  Future<void> _onFetchGamePlaySettings(
      FetchGamePlaySettings event, Emitter<SettingsState> emit) async {
    try {
      final gamePlaySettings = await _userRepository.getUserGamePlaySettings();
      emit(state.copyWith(gamePlaySettings: gamePlaySettings));
    } catch (_) {

    }
  }
}
