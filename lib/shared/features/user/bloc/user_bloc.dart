import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/pilgrim_progress_level_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<ToggleSound>(_onToggleSound);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleNotification>(_onToggleNotification);
    on<FetchAds>(_onFetchAds);
    on<FetchPilgrimProgressData>(_onFetchPilgrimProgressData);
    on<FetchGamePlaySettings>(_onFetchGamePlaySettings);
  }

  void _onToggleSound(ToggleSound event, Emitter<UserState> emit) {
    if (state is SoundOn) {
      emit(SoundOff());
    } else {
      emit(SoundOn());
    }
  }

  void _onToggleMusic(ToggleMusic event, Emitter<UserState> emit) {
    if (state is MusicOn) {
      emit(MusicOff());
    } else {
      emit(MusicOn());
    }
  }

  void _onToggleNotification(
      ToggleNotification event, Emitter<UserState> emit) {
    if (state is NotificationOn) {
      emit(NotificationOff());
    } else {
      emit(NotificationOn());
    }
  }

  Future<void> _onFetchAds(FetchAds event, Emitter<UserState> emit) async {
    emit(LoadingAds());
    try {
      final response = await _userRepository.getAds();
      emit(AdsDisplayed(response));
    } catch (_) {
      emit(LoadedAds());
    }
  }

  Future<void> _onFetchPilgrimProgressData(
      FetchPilgrimProgressData event, Emitter<UserState> emit) async {
    try {
      final response =
          await _userRepository.getUserPilgrimProgressData(event.userId);
      emit(PilgrimProgressData(response));
    } catch (_) {}
  }

  Future<void> _onFetchGamePlaySettings(FetchGamePlaySettings event, Emitter<UserState> emit) async{
      try{
        final response = await _userRepository.getUserGamePlaySettings();
        emit(GamePlaySettings(response));
      }catch(_){

      }
  }
}
