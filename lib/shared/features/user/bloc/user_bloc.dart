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
        super(UserState()) {
    on<FetchAds>(_onFetchAds);
    on<FetchPilgrimProgressData>(_onFetchPilgrimProgressData);

  }




  Future<void> _onFetchAds(FetchAds event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoadingAds: true));
    try {
      final response = await _userRepository.getAds();
      emit(state.copyWith(isLoadingAds: false, adContent: response));
    } catch (_) {
      emit(state.copyWith(isLoadingAds: false));
    }
  }

  Future<void> _onFetchPilgrimProgressData(
      FetchPilgrimProgressData event, Emitter<UserState> emit) async {
    try {
      final response =
          await _userRepository.getUserPilgrimProgressData(event.userId);
      emit(state.copyWith(pilgrimProgressDetails: response));
    } catch (_) {}
  }


}
