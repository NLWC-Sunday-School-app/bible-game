import 'dart:math';

import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/who_is_who_level.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../repository/wiw_repository.dart';


part 'who_is_who_event.dart';

part 'who_is_who_state.dart';

class WhoIsWhoBloc extends Bloc<WhoIsWhoEvent, WhoIsWhoState> {
  final WhoIsWhoRepository _whoIsWhoRepository;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;

  WhoIsWhoBloc({required AuthenticationBloc authenticationBloc,
    required WhoIsWhoRepository whoIsWhoRepository,
    required SettingsBloc settingsBloc})
      : _whoIsWhoRepository = whoIsWhoRepository,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        super(WhoIsWhoState()) {
    on<FetchGameLevels>(_onFetchGameLevels);
    on<SetGameData>(_onSetGameData);
    on<FetchGameQuestions>(_onFetchGameQuestions);
    on<OptionSelected>(_onOptionSelected);
    on<MoveToNextPage>(_onMoveToNextPage);
    on<PurchaseExtraTime>(_onPurchaseExtraTime);
    on<ClearWhoIsWhoGameData>(_onClearWhoIsWhoGameData);
    on<SetUserCompletedLeveLState>(_onSetUserCompletedLeveLState);
    on<SubmitWhoIsWhoScore>(_onSubmitWhoIsWhoScore);
    on<SubmitSpecialLevelScore>(_onSubmitSpecialLevelScore);
  }

  Future<void> _onFetchGameLevels(FetchGameLevels event,
      Emitter<WhoIsWhoState> emit) async {
    try {
      emit(state.copyWith(isLoadingGameLevels: true));
      final levels = await _whoIsWhoRepository.getGameLevels();
      emit(state.copyWith(wiwGameLevels: levels, isLoadingGameLevels: false));
    } catch (e) {}
  }

  Future<void> _onFetchGameQuestions(FetchGameQuestions event,
      Emitter<WhoIsWhoState> emit) async {
    try {
      emit(state.copyWith(isLoadingGameQuestions: true));
      final questions = await _whoIsWhoRepository.getGameQuestions();
      emit(state.copyWith(
          wiwGameQuestions: questions,
          isLoadingGameQuestions: false,
          wiwGameQuestionsLoaded: true));
    } catch (e) {
      emit(state.copyWith(isLoadingGameQuestions: false));
    }
  }

  void _onSetGameData(SetGameData event, Emitter<WhoIsWhoState> emit) {
    emit(state.copyWith(
      gameDuration: event.gameDuration,
      selectedGameLevel: event.selectedGameLevel,
    ));
  }

  void _onSetUserCompletedLeveLState(SetUserCompletedLeveLState event,
      Emitter<WhoIsWhoState> emit) {
    emit(state.copyWith(
        completedSelectedLevel: event.hasCompletedSelectedLevel));
  }

  void _onOptionSelected(OptionSelected event, Emitter<WhoIsWhoState> emit) {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;
    if(!state.hasAnswered){
      int coinsGained = state.coinsGained ?? 0;
      int noOfQuestionsAnswered = state.noOfQuestionsAnswered!;
      int noOfCorrectAnswers = state.noOfCorrectAnswers!;
      final pointsPerQuestion =
      int.parse(settingsState.gamePlaySettings['num_whoiswho_plays']);
      final isCorrect = event.gameQuestion.answer ==
          event.gameQuestion.options[event.selectedOptionIndex];
      noOfQuestionsAnswered++;
      if (isCorrect) {
        noOfCorrectAnswers++;
        soundManager.playCorrectAnswerSound();
        coinsGained = state.coinsGained! + pointsPerQuestion;
      } else {
        soundManager.playWrongAnswerSound();
      }
      print(state.noOfCorrectAnswers);
      emit(state.copyWith(
        hasAnswered: true,
        isCorrectAnswer: isCorrect,
        correctAnswer: event.gameQuestion.answer,
        selectedOptionIndex: event.selectedOptionIndex,
        coinsGained: coinsGained,
        noOfCorrectAnswers: noOfCorrectAnswers,
        noOfQuestionsAnswered: noOfQuestionsAnswered,
      ));

      Future.delayed(Duration(seconds: 1), () {
        add(MoveToNextPage());
      });
    }
  }

  void _onMoveToNextPage(MoveToNextPage event, Emitter<WhoIsWhoState> emit) {
    emit(state.copyWith(
      hasAnswered: false,
    ));

    if ((state.wiwGameQuestions?.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
        selectedOptionIndex: null,
        isCorrectAnswer: null,
        correctAnswer: null,
      ));
    }
  }

    Future<void> _onPurchaseExtraTime(PurchaseExtraTime event,
        Emitter<WhoIsWhoState> emit) async {
      try {
        await _whoIsWhoRepository.purchaseExtraTime(
            event.userID, event.gameTimePurchasePrice);
      } catch (_) {}
    }

    Future<void> _onSubmitWhoIsWhoScore(SubmitWhoIsWhoScore event,
        Emitter<WhoIsWhoState> emit) async {
      try {
        final authenticationState = _authenticationBloc.state;
        await _whoIsWhoRepository.submitWhoIsWhoScore(
            state.coinsGained,
            authenticationState.user.id,
            state.selectedGameLevel,
            state.completedSelectedLevel);
      } catch (_) {}
    }

    Future<void> _onSubmitSpecialLevelScore(SubmitSpecialLevelScore event,
        Emitter<WhoIsWhoState> emit) async {
      try {
        final authenticationState = _authenticationBloc.state;
        await _whoIsWhoRepository.submitWhoIsWhoScore(
          event.reward,
          authenticationState.user.id,
          state.selectedGameLevel,
          true,
        );
      } catch (_) {}
    }

    void _onClearWhoIsWhoGameData(ClearWhoIsWhoGameData event,
        Emitter<WhoIsWhoState> emit,) {
      emit(WhoIsWhoState());
    }
  }
