import 'dart:async';
import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/pilgrim_progress_level_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../repository/pilgrim_progress_repository.dart';

part 'pilgrim_progress_event.dart';

part 'pilgrim_progress_state.dart';

class PilgrimProgressBloc
    extends Bloc<PilgrimProgressEvent, PilgrimProgressState> {
  final PilgrimProgressRepository _pilgrimProgressRepository;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;

  PilgrimProgressBloc(
      {required AuthenticationBloc authenticationBloc,
      required PilgrimProgressRepository pilgrimProgressRepository,
      required SettingsBloc settingsBloc})
      : _pilgrimProgressRepository = pilgrimProgressRepository,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        super(PilgrimProgressState()) {
    on<FetchPilgrimProgressLevelData>(_onFetchUserPilgrimProgressLevelData);
    on<SetPilgrimProgressData>(_onSetPilgrimProgressData);
    on<FetchPilgrimProgressQuestions>(_onFetchPilgrimProgressQuestions);
    on<OptionSelected>(_onOptionSelected);
    on<MoveToNextPage>(_onMoveToNextPage);
    on<CalculateGameScore>(_onCalculateGameScore);
    on<SubmitPilgrimProgressScore>(_onSubmitPilgrimProgressScore);
    on<ClearPilgrimProgressData>(_onClearPilgrimProgressData);
    on<UpdateUserRank>(_onUpdateUserRank);
  }

  getUserLevelId(level) {
    switch (level) {
      case 'babe':
        return 1;
      case 'child':
        return 2;
      case 'young believer':
        return 3;
      case 'charity':
        return 4;
      case 'father':
        return 5;
      case 'elder':
        return 6;
    }
  }

  getLevelIndex(level) {
    switch (level) {
      case 'babe':
        return 0;
      case 'child':
        return 1;
      case 'young believer':
        return 2;
      case 'charity':
        return 3;
      case 'father':
        return 4;
      case 'elder':
        return 5;
    }
  }

  getNoOfTrialsPerLevel(level) {
    switch (level) {
      case 'babe':
        return 5;
      case 'child':
        return 4;
      case 'young believer':
        return 3;
      case 'charity':
        return 2;
      case 'father':
        return 2;
      case 'elder':
        return 2;
    }
  }

  Future<void> _onFetchUserPilgrimProgressLevelData(
    FetchPilgrimProgressLevelData event,
    Emitter<PilgrimProgressState> emit,
  ) async {
    try {
      final authenticationState = _authenticationBloc.state;

      final pilgrimProgressLevelData = await _pilgrimProgressRepository
          .getUserPilgrimProgress(authenticationState.user!.id);

      emit(state.copyWith(pilgrimProgressLevelData: pilgrimProgressLevelData));
      Future.delayed(Duration(seconds: 2), (){
        add(SetPilgrimProgressData());
      });
    } catch (_) {}
  }

  void _onSetPilgrimProgressData(
      SetPilgrimProgressData event, Emitter<PilgrimProgressState> emit) {
    final settingState = _settingsBloc.state;
    final userLevelId = getUserLevelId(_authenticationBloc.state.user.rank);

    final passPointOnFirstTrial =
        int.parse(settingState.gamePlaySettings['pass_on_first_trial_score']);
    final totalPointsGainedInBabe =
        (state.pilgrimProgressLevelData[0].progress! *
                int.parse(settingState.gamePlaySettings['babe_to_child_total']))
            .toInt();
    final totalPointsGainedInChild = (state
                .pilgrimProgressLevelData[1].progress! *
            int.parse(
                settingState.gamePlaySettings['child_to_young_believer_total']))
        .toInt();
    final totalPointsGainedInYB = (state.pilgrimProgressLevelData[2].progress! *
            int.parse(settingState
                .gamePlaySettings['young_believer_to_charity_total']))
        .toInt();
    final totalPointsGainedInCharity = (state
                .pilgrimProgressLevelData[3].progress! *
            int.parse(settingState.gamePlaySettings['charity_to_father_total']))
        .toInt();
    final totalPointsGainedInFather = (state
                .pilgrimProgressLevelData[4].progress! *
            int.parse(settingState.gamePlaySettings['father_to_elder_total']))
        .toInt();
    final totalPointsGainedInElder = (state
                .pilgrimProgressLevelData[5].progress! *
            int.parse(settingState.gamePlaySettings['father_to_elder_total']))
        .toInt();


    final childLevelIsLocked =
        state.pilgrimProgressLevelData[0].progress! < 1 && userLevelId == 1;
    final youngBelieverLevelIsLocked =
        state.pilgrimProgressLevelData[1].progress! < 1 && userLevelId <= 2;
    final charityLevelIsLocked =
        state.pilgrimProgressLevelData[2].progress! < 1 && userLevelId <= 3;
    final fatherLevelIsLocked =
        state.pilgrimProgressLevelData[3].progress! < 1 && userLevelId <= 4;
    final elderLevelIsLocked =
        state.pilgrimProgressLevelData[4].progress! < 1 && userLevelId <= 5;

    emit(state.copyWith(
        totalPointsGainedInBabe: totalPointsGainedInBabe,
        totalPointsGainedInChild: totalPointsGainedInChild,
        totalPointsGainedInYb: totalPointsGainedInYB,
        totalPointsGainedInCharity: totalPointsGainedInCharity,
        totalPointsGainedInFather: totalPointsGainedInFather,
        totalPointsGainedInElder: totalPointsGainedInElder,
        childLevelIsLocked: childLevelIsLocked,
        youngBelieversLevelIsLocked: youngBelieverLevelIsLocked,
        charityLevelIsLocked: charityLevelIsLocked,
        fatherLevelIsLocked: fatherLevelIsLocked,
        elderLevelIsLocked: elderLevelIsLocked,
        passOnFirstTrialScore: passPointOnFirstTrial));
  }

  Future<void> _onFetchPilgrimProgressQuestions(
    FetchPilgrimProgressQuestions event,
    Emitter<PilgrimProgressState> emit,
  ) async {
    try {
      final settingsState = _settingsBloc.state;
      final List<int> trialsPerLevel = [5, 4, 3, 2, 2, 2];
      final List<int> totalCoinsAvailableInAllLevel = [
        int.parse(settingsState.gamePlaySettings['babe_to_child_total']),
        int.parse(
            settingsState.gamePlaySettings['child_to_young_believer_total']),
        int.parse(
            settingsState.gamePlaySettings['young_believer_to_charity_total']),
        int.parse(settingsState.gamePlaySettings['charity_to_father_total']),
        int.parse(settingsState.gamePlaySettings['father_to_elder_total']),
        int.parse(settingsState.gamePlaySettings['father_to_elder_total'])
      ];
      final selectedLevel = event.selectedLevel;
      final userRank = _authenticationBloc.state.user.rank;
      final questions = await _pilgrimProgressRepository
          .getPilgrimProgressQuestions('PILGRIM_PROGRESS', selectedLevel, null);
      final roundsLeftForSelectedLevel = state
          .pilgrimProgressLevelData[getLevelIndex(selectedLevel)]
          .numberOfRounds;
      final noOfTrialForSelectedLevel =
          trialsPerLevel[getLevelIndex(selectedLevel)];
      final totalCoinsAvailableForSelectedLevel =
          totalCoinsAvailableInAllLevel[getLevelIndex(selectedLevel)];

      emit(state.copyWith(
        pilgrimProgressQuestions: questions,
        pilgrimProgressQuestionLoaded: true,
        roundsLeftForSelectedLevel: roundsLeftForSelectedLevel,
        noOfTrialForSelectedLevel: noOfTrialForSelectedLevel,
        totalCoinsAvailableForSelectedLevel:
            totalCoinsAvailableForSelectedLevel,
        selectedGameLevel: selectedLevel,
      ));
      emit(state.copyWith(pilgrimProgressQuestionLoaded: false));
    } catch (_) {
      emit(state.copyWith(pilgrimProgressQuestionLoaded: false));
    }
  }

  void _onOptionSelected(
      OptionSelected event, Emitter<PilgrimProgressState> emit) {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;
    if(!state.hasAnswered){
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
        coinsGained = state.coinsGained +
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

  }

  void _onMoveToNextPage(
      MoveToNextPage event, Emitter<PilgrimProgressState> emit) {
    if ((state.pilgrimProgressQuestions?.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
        selectedOptionIndex: null,
        isCorrectAnswer: null,
        correctAnswer: null,
        hasAnswered: false,
      ));
    }
  }

  Future<void> _onCalculateGameScore(
      CalculateGameScore event, Emitter<PilgrimProgressState> emit) async {
    final userRank = _authenticationBloc.state.user!.rank;
    final settingsState = _settingsBloc.state;
    final authenticationState = _authenticationBloc.state;
    switch (state.selectedGameLevel) {
      case 'babe':
        final averageTimeSpent =
            (state.totalTimeSpent! ~/ state.pilgrimProgressQuestions!.length);
        final totalPointsGainedInBabe =
            (state.pilgrimProgressLevelData[0].progress! *
                    int.parse(
                        settingsState.gamePlaySettings['babe_to_child_total']))
                .toInt();
        var roundsLeft = state.pilgrimProgressLevelData[0].numberOfRounds ?? 0;
        var userProgress = state.pilgrimProgressLevelData[0].progress!;
        var childLevelIsLocked = state.childLevelIsLocked;
        userRank == 'babe' ? roundsLeft-- : null;
        var score =
            state.coinsGained / state.totalCoinsAvailableForSelectedLevel!;
        userProgress += score;
        var coinsGained = state.coinsGained;
        state.pilgrimProgressLevelData[0].numberOfRounds! >= 1.0 ||
                state.coinsGained >= state.passOnFirstTrialScore
            ? childLevelIsLocked = false
            : childLevelIsLocked = true;
        await _pilgrimProgressRepository.sendGameData(
          'PILGRIM_PROGRESS',
          state.coinsGained,
          state.coinsGained,
          state.totalBonusCoinsGained!,
          averageTimeSpent,
          'babe',
          state.noOfCorrectAnswers,
          authenticationState.user.id,
          roundsLeft >= 1
              ? (userProgress >= 1.0 ? 1.0 : userProgress.toStringAsFixed(5))
              : (totalPointsGainedInBabe + coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
                  ? userProgress.toStringAsFixed(5)
                  : 0,
          roundsLeft >= 1 &&
                  userRank == 'babe' &&
                  !(totalPointsGainedInBabe + state.coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
              ? roundsLeft
              : 5,
        );

        if (roundsLeft < 1 &&
            (totalPointsGainedInBabe + coinsGained <
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained < state.passOnFirstTrialScore)) {
          emit(state.copyWith(userHasToRetry: true));
          emit(state.copyWith(userHasToRetry: false));
        }
        if (userRank == 'babe' &&
            (totalPointsGainedInBabe + coinsGained >=
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained >= state.passOnFirstTrialScore)) {
          add(UpdateUserRank('child'));
          emit(state.copyWith(
              hasUnlockedNewRank: true,
              newRankUnlocked: 'Child',
              newRankBadgeSrc: ProductImageRoutes.childBadge));
        }
      case 'child':
        final averageTimeSpent =
            (state.totalTimeSpent! ~/ state.pilgrimProgressQuestions!.length);
        final totalPointsGainedInChild =
            (state.pilgrimProgressLevelData[1].progress! *
                    int.parse(settingsState
                        .gamePlaySettings['child_to_young_believer_total']))
                .toInt();
        var roundsLeft = state.pilgrimProgressLevelData[1].numberOfRounds ?? 0;
        var userProgress = state.pilgrimProgressLevelData[1].progress!;
        var youngBelieversLevelIsLocked = state.youngBelieversLevelIsLocked;
        userRank == 'child' ? roundsLeft-- : null;
        var score =
            state.coinsGained / state.totalCoinsAvailableForSelectedLevel!;
        userProgress += score;
        var coinsGained = state.coinsGained;
        state.pilgrimProgressLevelData[1].numberOfRounds! >= 1.0 ||
                state.coinsGained >= state.passOnFirstTrialScore
            ? youngBelieversLevelIsLocked = false
            : youngBelieversLevelIsLocked = true;
        await _pilgrimProgressRepository.sendGameData(
          'PILGRIM_PROGRESS',
          state.coinsGained,
          state.coinsGained,
          state.totalBonusCoinsGained!,
          averageTimeSpent,
          'child',
          state.noOfCorrectAnswers,
          authenticationState.user.id,
          roundsLeft >= 1
              ? (userProgress >= 1.0 ? 1.0 : userProgress.toStringAsFixed(5))
              : (totalPointsGainedInChild + coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
                  ? userProgress.toStringAsFixed(5)
                  : 0,
          roundsLeft >= 1 &&
                  userRank == 'child' &&
                  !(totalPointsGainedInChild + state.coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
              ? roundsLeft
              : 4,
        );

        if (roundsLeft < 1 &&
            (totalPointsGainedInChild + coinsGained <
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained < state.passOnFirstTrialScore)) {
          emit(state.copyWith(userHasToRetry: true));
          emit(state.copyWith(userHasToRetry: false));
        }
        if (userRank == 'child' &&
            (totalPointsGainedInChild + coinsGained >=
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained >= state.passOnFirstTrialScore)) {
          add(UpdateUserRank('young believer'));
          emit(state.copyWith(
            hasUnlockedNewRank: true,
            newRankUnlocked: 'Young believer',
            newRankBadgeSrc: ProductImageRoutes.youngBelieverBadge,
          ));
        }
      case 'young believer':
        final averageTimeSpent =
            (state.totalTimeSpent! ~/ state.pilgrimProgressQuestions!.length);
        final totalPointsGainedInYB =
            (state.pilgrimProgressLevelData[2].progress! *
                    int.parse(settingsState
                        .gamePlaySettings['child_to_young_believer_total']))
                .toInt();
        var roundsLeft = state.pilgrimProgressLevelData[2].numberOfRounds ?? 0;
        var userProgress = state.pilgrimProgressLevelData[2].progress!;
        var charityLevelIsLocked = state.charityLevelIsLocked;
        userRank == 'young believer' ? roundsLeft-- : null;
        var score =
            state.coinsGained / state.totalCoinsAvailableForSelectedLevel!;
        userProgress += score;
        var coinsGained = state.coinsGained;
        state.pilgrimProgressLevelData[1].numberOfRounds! >= 1.0 ||
                state.coinsGained >= state.passOnFirstTrialScore
            ? charityLevelIsLocked = false
            : charityLevelIsLocked = true;
        await _pilgrimProgressRepository.sendGameData(
          'PILGRIM_PROGRESS',
          state.coinsGained,
          state.coinsGained,
          state.totalBonusCoinsGained!,
          averageTimeSpent,
          'young believer',
          state.noOfCorrectAnswers,
          authenticationState.user.id,
          roundsLeft >= 1
              ? (userProgress >= 1.0 ? 1.0 : userProgress.toStringAsFixed(5))
              : (totalPointsGainedInYB + coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
                  ? userProgress.toStringAsFixed(5)
                  : 0,
          roundsLeft >= 1 &&
                  userRank == 'young believer' &&
                  !(totalPointsGainedInYB + state.coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
              ? roundsLeft
              : 3,
        );

        if (roundsLeft < 1 &&
            (totalPointsGainedInYB + coinsGained <
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained < state.passOnFirstTrialScore)) {
          emit(state.copyWith(userHasToRetry: true));
          emit(state.copyWith(userHasToRetry: false));
        }
        if (userRank == 'young believer' &&
            (totalPointsGainedInYB + coinsGained >=
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained >= state.passOnFirstTrialScore)) {
          add(UpdateUserRank('charity'));
          emit(state.copyWith(
            hasUnlockedNewRank: true,
            newRankUnlocked: 'charity',
            newRankBadgeSrc: ProductImageRoutes.charityBadge,
          ));
        }
      case 'charity':
        final averageTimeSpent =
            (state.totalTimeSpent! ~/ state.pilgrimProgressQuestions!.length);
        final totalPointsGainedInCharity =
            (state.pilgrimProgressLevelData[3].progress! *
                    int.parse(settingsState
                        .gamePlaySettings['young_believer_to_charity_total']))
                .toInt();
        var roundsLeft = state.pilgrimProgressLevelData[3].numberOfRounds ?? 0;
        var userProgress = state.pilgrimProgressLevelData[3].progress!;
        var fatherLevelIsLocked = state.fatherLevelIsLocked;
        userRank == 'charity' ? roundsLeft-- : null;
        var score =
            state.coinsGained / state.totalCoinsAvailableForSelectedLevel!;
        userProgress += score;
        var coinsGained = state.coinsGained;
        state.pilgrimProgressLevelData[3].numberOfRounds! >= 1.0 ||
                state.coinsGained >= state.passOnFirstTrialScore
            ? fatherLevelIsLocked = false
            : fatherLevelIsLocked = true;
        await _pilgrimProgressRepository.sendGameData(
          'PILGRIM_PROGRESS',
          state.coinsGained,
          state.coinsGained,
          state.totalBonusCoinsGained!,
          averageTimeSpent,
          'charity',
          state.noOfCorrectAnswers,
          authenticationState.user.id,
          roundsLeft >= 1
              ? (userProgress >= 1.0 ? 1.0 : userProgress.toStringAsFixed(5))
              : (totalPointsGainedInCharity + coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
                  ? userProgress.toStringAsFixed(5)
                  : 0,
          roundsLeft >= 1 &&
                  userRank == 'charity' &&
                  !(totalPointsGainedInCharity + state.coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
              ? roundsLeft
              : 2,
        );

        if (roundsLeft < 1 &&
            (totalPointsGainedInCharity + coinsGained <
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained < state.passOnFirstTrialScore)) {
          emit(state.copyWith(userHasToRetry: true));
          emit(state.copyWith(userHasToRetry: false));
        }
        if (userRank == 'charity' &&
            (totalPointsGainedInCharity + coinsGained >=
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained >= state.passOnFirstTrialScore)) {
          add(UpdateUserRank('father'));
          emit(state.copyWith(
            hasUnlockedNewRank: true,
            newRankUnlocked: 'father',
            newRankBadgeSrc: ProductImageRoutes.fatherBadge,
          ));
        }
      case 'father':
        final averageTimeSpent =
            (state.totalTimeSpent! ~/ state.pilgrimProgressQuestions!.length);
        final totalPointsGainedInFather = (state
                    .pilgrimProgressLevelData[4].progress! *
                int.parse(
                    settingsState.gamePlaySettings['charity_to_father_total']))
            .toInt();
        var roundsLeft = state.pilgrimProgressLevelData[4].numberOfRounds ?? 0;
        var userProgress = state.pilgrimProgressLevelData[4].progress!;
        var elderLevelIsLocked = state.elderLevelIsLocked;
        userRank == 'father' ? roundsLeft-- : null;
        var score =
            state.coinsGained / state.totalCoinsAvailableForSelectedLevel!;
        userProgress += score;
        var coinsGained = state.coinsGained;
        state.pilgrimProgressLevelData[1].numberOfRounds! >= 1.0 ||
                state.coinsGained >= state.passOnFirstTrialScore
            ? elderLevelIsLocked = false
            : elderLevelIsLocked = true;
        await _pilgrimProgressRepository.sendGameData(
          'PILGRIM_PROGRESS',
          state.coinsGained,
          state.coinsGained,
          state.totalBonusCoinsGained!,
          averageTimeSpent,
          'father',
          state.noOfCorrectAnswers,
          authenticationState.user.id,
          roundsLeft >= 1
              ? (userProgress >= 1.0 ? 1.0 : userProgress.toStringAsFixed(5))
              : (totalPointsGainedInFather + coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
                  ? userProgress.toStringAsFixed(5)
                  : 0,
          roundsLeft >= 1 &&
                  userRank == 'father' &&
                  !(totalPointsGainedInFather + state.coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
              ? roundsLeft
              : 2,
        );

        if (roundsLeft < 1 &&
            (totalPointsGainedInFather + coinsGained <
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained < state.passOnFirstTrialScore)) {
          emit(state.copyWith(userHasToRetry: true));
          emit(state.copyWith(userHasToRetry: false));
        }
        if (userRank == 'father' &&
            (totalPointsGainedInFather + coinsGained >=
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained >= state.passOnFirstTrialScore)) {
          add(UpdateUserRank('elder'));
          emit(state.copyWith(
            hasUnlockedNewRank: true,
            newRankUnlocked: 'elder',
            newRankBadgeSrc: ProductImageRoutes.elderBadge,
          ));
        }
      case 'elder':
        final averageTimeSpent =
            (state.totalTimeSpent! ~/ state.pilgrimProgressQuestions!.length);
        final totalPointsGainedInElder = (state
                    .pilgrimProgressLevelData[5].progress! *
                int.parse(
                    settingsState.gamePlaySettings['father_to_elder_total']))
            .toInt();
        var roundsLeft = state.pilgrimProgressLevelData[5].numberOfRounds ?? 0;
        var userProgress = state.pilgrimProgressLevelData[5].progress!;
        userRank == 'father' ? roundsLeft-- : null;
        var score =
            state.coinsGained / state.totalCoinsAvailableForSelectedLevel!;
        userProgress += score;
        var coinsGained = state.coinsGained;

        await _pilgrimProgressRepository.sendGameData(
          'PILGRIM_PROGRESS',
          state.coinsGained,
          state.coinsGained,
          state.totalBonusCoinsGained!,
          averageTimeSpent,
          'elder',
          state.noOfCorrectAnswers,
          authenticationState.user.id,
          roundsLeft >= 1
              ? (userProgress >= 1.0 ? 1.0 : userProgress.toStringAsFixed(5))
              : (totalPointsGainedInElder + coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
                  ? userProgress.toStringAsFixed(5)
                  : 0,
          roundsLeft >= 1 &&
                  userRank == 'elder' &&
                  !(totalPointsGainedInElder + state.coinsGained >=
                          state.totalCoinsAvailableForSelectedLevel! ||
                      coinsGained >= state.passOnFirstTrialScore)
              ? roundsLeft
              : 2,
        );

        if (roundsLeft < 1 &&
            (totalPointsGainedInElder + coinsGained <
                    state.totalCoinsAvailableForSelectedLevel! ||
                coinsGained < state.passOnFirstTrialScore)) {
          emit(state.copyWith(userHasToRetry: true));
          emit(state.copyWith(userHasToRetry: false));
        }
    }
  }

  Future<void> _onUpdateUserRank(
      UpdateUserRank event, Emitter<PilgrimProgressState> emit) async {
    try {
      final authenticationState = _authenticationBloc.state;
      final response = await _pilgrimProgressRepository.updateUserRank(
          _authenticationBloc.state.user.id, event.rank);
    } catch (_) {}
  }

  Future<void> _onSubmitPilgrimProgressScore(
    SubmitPilgrimProgressScore event,
    Emitter<PilgrimProgressState> emit,
  ) async {
    try {
      final authenticationState = _authenticationBloc.state;
      final response = await _pilgrimProgressRepository.sendGameData(
        'PILGRIM_PROGRESS',
        state.coinsGained,
        state.coinsGained,
        state.totalBonusCoinsGained!,
        state.totalTimeSpent,
        authenticationState.user!.rank,
        state.noOfCorrectAnswers,
        authenticationState.user!.id,
        null,
        5,
      );
    } catch (_) {}
  }

  void _onClearPilgrimProgressData(
    ClearPilgrimProgressData event,
    Emitter<PilgrimProgressState> emit,
  ) {
    emit(state.copyWith(
      pilgrimProgressQuestions: [],
      coinsGained: 0,
      noOfCorrectAnswers: 0,
      correctAnswer: null,
      totalTimeSpent: 0,
      totalBonusCoinsGained: 0,
      totalCorrectAnswers: 0,
      hasUnlockedNewRank: false,
      newRankBadgeSrc: null,
      userHasToRetry: false,
      newRankUnlocked: null,
    ));
  }
}
