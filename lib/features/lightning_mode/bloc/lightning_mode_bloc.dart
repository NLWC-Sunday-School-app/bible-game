import 'package:bible_game/features/lightning_mode/repository/lightning_mode_repository.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../multi_player/bloc/multiplayer_bloc.dart';
import '../../multi_player/repository/multiplayer_repository.dart';
part 'lightning_mode_event.dart';
part 'lightning_mode_state.dart';

class LightningModeBloc extends Bloc<LightningModeEvent, LightningModeState> {
  final LightningModeRepository _lightningModeRepository;
  final MultiplayerBloc _multiplayerBloc;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;


  LightningModeBloc(
      {
        required LightningModeRepository lightningModeRepository,
        required MultiplayerBloc multiplayerBloc,
        required AuthenticationBloc authenticationBloc,
        required SettingsBloc settingsBloc
      })
      :
        _lightningModeRepository = lightningModeRepository,
        _multiplayerBloc = multiplayerBloc,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        super(LightningModeState.initial()) {
    on<StartGame>(_onStartGame);
    on<OptionSelected>(_onOptionSelected);
    on<MoveToNextPage>(_onMoveToNextPage);
  }

  Future<void> _onStartGame(
      StartGame event,
      Emitter<LightningModeState> emit) async {
    try {
      emit(state.copyWith(isLoadingStartGame: true, hasStartedGame: false));
      final response =
      await _lightningModeRepository.startGame(
          _multiplayerBloc.state.createGameRoomResponse.id,
          _authenticationBloc.state.user.id
      );
      emit(state.copyWith(startGameRoomModel: response,isLoadingStartGame: false, hasStartedGame: true));
    } catch (_) {
      emit(state.copyWith(isLoadingStartGame: false, hasStartedGame: false));
    }
  }

  void _onOptionSelected(
      OptionSelected event,
      Emitter<LightningModeState> emit)
  {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;
    if (!state.hasAnswered) {
      int coinsGained = state.coinsGained ?? 0;
      // int totalBonusCoinsGained = state.totalBonusCoinsGained ?? 0;
      int noOfCorrectAnswers = state.noOfCorrectAnswers;
      final pointsPerQuestion =
      int.parse(settingsState.gamePlaySettings['num_whoiswho_plays']);
      final isCorrect = event.gameQuestion.correctOption ==
          event.gameQuestion.options[event.selectedOptionIndex];
      if (isCorrect) {
        noOfCorrectAnswers++;
        soundManager.playCorrectAnswerSound();
        coinsGained = state.coinsGained! + pointsPerQuestion;
      } else {
        soundManager.playWrongAnswerSound();
      }
      emit(state.copyWith(
        hasAnswered: true,
        isCorrectAnswer: isCorrect,
        correctAnswer: event.gameQuestion.correctOption,
        selectedOptionIndex: event.selectedOptionIndex,
        coinsGained: coinsGained,
        noOfCorrectAnswers: noOfCorrectAnswers,
      ));
      Future.delayed(Duration(seconds: 1), () {
        add(MoveToNextPage());
      });
    }
  }

  void _onMoveToNextPage(
      MoveToNextPage event, Emitter<LightningModeState> emit) {
    print("START GAME RESPONSE: ${state.startGameRoomModel}");
    emit(state.copyWith(
      hasAnswered: false,
    ));

    if ((state.startGameRoomModel.questions!.data.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
          selectedOptionIndex: null,
          isCorrectAnswer: null,
          correctAnswer: null,
         ));
    }

  }

}
