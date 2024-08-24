import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/global_game.dart';
import 'package:bible_game_api/model/global_leaderboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../repository/global_challenge_repository.dart';

part 'global_challenge_event.dart';

part 'global_challenge_state.dart';

class GlobalChallengeBloc
    extends Bloc<GlobalChallengeEvent, GlobalChallengeState> {
  final GlobalChallengeRepository _globalChallengeRepository;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;

  GlobalChallengeBloc(
      {required GlobalChallengeRepository globalChallengeRepository,
      required AuthenticationBloc authenticationBloc,
      required SettingsBloc settingsBloc})
      : _globalChallengeRepository = globalChallengeRepository,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        super(GlobalChallengeState()) {
    on<FetchGlobalChallengeGames>(_onFetchGlobalChallengeGames);
    on<UpdateGlobalChallengeGame>(_onUpdateGlobalChallengeGame);
    on<FetchGlobalChallengeQuestions>(_onFetchGlobalChallengeQuestions);
    on<OptionSelected>(_onOptionSelected);
    on<MoveToNextPage>(_onMoveToNextPage);
    on<SubmitGlobalChallengeScore>(_onSubmitQuickGameScore);
    on<FetchGlobalChallengeLeaderboard>(_onFetchGlobalChallengeLeaderboard);
    on<ClearGlobalChallengeGameData>(_onClearGlobalChallengeGameData);
  }

  Future<void> _onFetchGlobalChallengeGames(FetchGlobalChallengeGames event,
      Emitter<GlobalChallengeState> emit) async {
    try {
      emit(state.copyWith(isFetchingGames: true));
      final response =
          await _globalChallengeRepository.FetchGlobalChallengeGames();
      emit(state.copyWith(
          globalChallengeGames: response, isFetchingGames: false));
    } catch (_) {}
  }

  Future<void> _onUpdateGlobalChallengeGame(UpdateGlobalChallengeGame event,
      Emitter<GlobalChallengeState> emit) async {
    try {
      await _globalChallengeRepository.updateGlobalChallengeGame(
        event.id,
        event.title,
        event.description,
        event.image,
        event.campaignTag,
        event.isActive,
        event.isComingSoon,
        event.startDate,
        event.endDate,
      );
      add(FetchGlobalChallengeGames());
    } catch (_) {}
  }

  String gameType = '';

  Future<void> _onFetchGlobalChallengeQuestions(
    FetchGlobalChallengeQuestions event,
    Emitter<GlobalChallengeState> emit,
  ) async {
    try {
      final userRank = _authenticationBloc.state.user.rank;
      emit(state.copyWith(isLoadingGameQuestions: true));
      final questions = await _globalChallengeRepository.getQuickGameQuestions(
          event.campaignType, userRank, null);
      gameType = event.campaignType;
      emit(state.copyWith(
        globalChallengeQuestion: questions,
        globalGameQuestionLoaded: true,
        isLoadingGameQuestions: false,
      ));
    } catch (_) {
      emit(state.copyWith(
          isLoadingGameQuestions: false, globalGameQuestionLoaded: false));
    }
  }

  void _onOptionSelected(
      OptionSelected event, Emitter<GlobalChallengeState> emit) {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;

    int coinsGained = state.coinsGained ?? 0;
    int totalBonusCoinsGained = state.totalBonusCoinsGained ?? 0;
    int noOfCorrectAnswers = state.noOfCorrectAnswers;
    final pointsPerQuestion = int.parse(
        settingsState.gamePlaySettings['base_score_pilgrim_progress']);
    final durationPerQuestion =
        int.parse(settingsState.gamePlaySettings['normal_game_speed']);
    final halfOfTotalPointPerQuestion = pointsPerQuestion / 2;
    final totalTimeSpent =
        state.totalTimeSpent! + (durationPerQuestion - event.remainingTime);
    final isCorrect = event.gameQuestion.answer ==
        event.gameQuestion.options[event.selectedOptionIndex];
    if (isCorrect) {
      noOfCorrectAnswers++;
      soundManager.playCorrectAnswerSound();
      dynamic timeBonusPoint = (event.remainingTime / durationPerQuestion) *
          halfOfTotalPointPerQuestion;
      coinsGained = state.coinsGained! +
          (halfOfTotalPointPerQuestion + timeBonusPoint).round();
      totalBonusCoinsGained =
          (state.totalBonusCoinsGained! + timeBonusPoint).round();
    } else {
      soundManager.playWrongAnswerSound();
    }

    emit(state.copyWith(
        hasAnswered: true,
        isCorrectAnswer: isCorrect,
        correctAnswer: event.gameQuestion.answer,
        selectedOptionIndex: event.selectedOptionIndex,
        coinsGained: coinsGained,
        totalBonusCoinsGained: totalBonusCoinsGained,
        totalTimeSpent: totalTimeSpent,
        noOfCorrectAnswers: noOfCorrectAnswers));
    Future.delayed(Duration(seconds: 1), () {
      add(MoveToNextPage());
    });
  }

  Future<void> _onFetchGlobalChallengeLeaderboard(
      FetchGlobalChallengeLeaderboard event,
      Emitter<GlobalChallengeState> emit) async {
    try {
      emit(state.copyWith(isFetchingGlobalChallengeLeaderboard: true));
      final response =
          await _globalChallengeRepository.getGameLeaderBoard(event.gameType);
      emit(state.copyWith(
          globalChallengeLeaderboard: response,
          isFetchingGlobalChallengeLeaderboard: false));
    } catch (_) {}
  }

  Future<void> _onSubmitQuickGameScore(
    SubmitGlobalChallengeScore event,
    Emitter<GlobalChallengeState> emit,
  ) async {
    try {
      final authenticationState = _authenticationBloc.state;
      final response = await _globalChallengeRepository.sendGameData(
        gameType,
        state.coinsGained!,
        state.coinsGained!,
        state.totalBonusCoinsGained!,
        (state.totalTimeSpent! ~/ state.globalChallengeQuestions!.length),
        'babe',
        state.noOfCorrectAnswers,
        authenticationState.user.id,
        null,
        5,
      );
    } catch (_) {}
  }

  void _onMoveToNextPage(
      MoveToNextPage event, Emitter<GlobalChallengeState> emit) {
    if ((state.globalChallengeQuestions?.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
          selectedOptionIndex: null,
          isCorrectAnswer: null,
          correctAnswer: null,
          hasAnswered: false));
    }
  }

  void _onClearGlobalChallengeGameData(
    ClearGlobalChallengeGameData event,
    Emitter<GlobalChallengeState> emit,
  ) {
    emit(GlobalChallengeState());
  }
}
