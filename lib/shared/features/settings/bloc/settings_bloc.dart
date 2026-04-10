import 'package:bible_game_api/model/game_ads.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    on<FetchAds>(_onFetchAds);
    on<UpdateSoundState>(_onUpdateSoundState);
  }

  void _onToggleSound(ToggleSound event, Emitter<SettingsState> emit)async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newState = state.copyWith(isSoundOn: !state.isSoundOn);
    await prefs.setBool('isSoundOn', !state.isSoundOn);
    emit(newState);
    soundManager.updateSettings(newState);
  }

  void _onToggleMusic(ToggleMusic event, Emitter<SettingsState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final newState = state.copyWith(isMusicOn: !state.isMusicOn);
    await prefs.setBool('isMusicOn', !state.isMusicOn);
    emit(newState);
    soundManager.updateSettings(newState);
  }

  void _onToggleNotification(
      ToggleNotification event, Emitter<SettingsState> emit) {
    final newState = state.copyWith(isNotificationOn: !state.isNotificationOn);
    emit(newState);
  }

  Future<void> _onFetchAds(FetchAds event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoadingAds: true));
    try {
      final response = await _userRepository.getAds();
      emit(state.copyWith(isLoadingAds: false, adContent: response));
    } catch (_) {
      emit(state.copyWith(isLoadingAds: false));
    }
  }

  Future<void> _onFetchGamePlaySettings(
      FetchGamePlaySettings event, Emitter<SettingsState> emit) async {
    try {
      final gamePlaySettings = await _userRepository.getUserGamePlaySettings();
      emit(state.copyWith(gamePlaySettings: gamePlaySettings));
    } catch (_) {

    }
  }

  void _onUpdateSoundState(UpdateSoundState event, Emitter<SettingsState> emit)async{
      final newState = state.copyWith(isMusicOn: event.isMusicOn, isSoundOn: event.isSoundOn);
      emit(newState);
      soundManager.updateSettings(newState);
  }
}
