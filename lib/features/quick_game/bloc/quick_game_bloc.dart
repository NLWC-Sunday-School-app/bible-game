import 'dart:math';

import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/quick_game_topic.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../repository/quick_game_repository.dart';

part 'quick_game_event.dart';

part 'quick_game_state.dart';

class QuickGameBloc extends Bloc<QuickGameEvent, QuickGameState> {
  final QuickGameRepository _quickGameRepository;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;

  ConnectivityBloc? _connectivityBloc;

  QuickGameBloc(
      {required AuthenticationBloc authenticationBloc,
      required QuickGameRepository quickGameRepository,
      required SettingsBloc settingsBloc,
      ConnectivityBloc? connectivityBloc})
      : _quickGameRepository = quickGameRepository,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        _connectivityBloc = connectivityBloc,
        super(QuickGameState()) {
    on<FetchQuickGameTopics>(_onFetchQuickGameTopics);
    on<FetchQuickGameQuestions>(_onFetchQuickGameQuestions);
    on<SelectQuickGameTopic>(_onSelectQuickGameTopic);
    on<OptionSelected>(_onOptionSelected);
    on<MoveToNextPage>(_onMoveToNextPage);
    on<SubmitQuickGameScore>(_onSubmitQuickGameScore);
    on<ClearQuickGameData>(_onClearQuickGameData);
    on<FindQuickGameTopics>(_onFindQuickGameTopics);
    on<UseFiftyFifty>(_onUseFiftyFifty);
  }

  Future<void> _onFetchQuickGameTopics(
    FetchQuickGameTopics event,
    Emitter<QuickGameState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoadingGameTopics: true));
      final topics = await _quickGameRepository.getQuickGameTopics();
      emit(state.copyWith(quickGameTopics: topics, isLoadingGameTopics: false));
    } catch (_) {
      emit(state.copyWith(isLoadingGameTopics: false));
    }
  }

  Future<void> _onSubmitQuickGameScore(
     SubmitQuickGameScore event,
      Emitter<QuickGameState> emit,
      ) async {
    final authenticationState = _authenticationBloc.state;
    final prefs = await SharedPreferences.getInstance();
    final deviceName = prefs.getString('deviceName');
    final deviceOs = prefs.getString('deviceOs');

    final questions = state.quickGameQuestions ?? [];
    final avgTime = questions.isNotEmpty
        ? (state.totalTimeSpent ?? 0) ~/ questions.length
        : 0;
    final totalScore = state.coinsGained ?? 0;
    final bonusScore = state.totalBonusCoinsGained ?? 0;

    try {
      await _quickGameRepository.sendGameData(
        'QUICK_GAME',
        totalScore,
        totalScore,
        bonusScore,
        avgTime,
        authenticationState.user.rank,
        state.noOfCorrectAnswers,
        authenticationState.user.id,
        null,
        5,
        deviceName,
        deviceOs,
      );
    } catch (_) {
      // Network failed — enqueue for offline sync
      if (_connectivityBloc != null) {
        final playLog = {
          'game_mode': 'QUICK_GAME',
          'total_score': totalScore,
          'base_score': totalScore,
          'bonus_score': bonusScore,
          'average_time_spent': avgTime,
          'player_rank': authenticationState.user.rank,
          'number_of_correct_answers': state.noOfCorrectAnswers,
          'player_id': authenticationState.user.id,
          'user_progress': null,
          'number_of_rounds': 5,
          'deviceName': deviceName,
          'deviceOs': deviceOs,
        };
        await _connectivityBloc!.submitOrEnqueue(playLog);
      }
    }
  }



  List<String> quickGameTopicsToTags(List<QuickGameTopic> topics) {
    return topics.map((topic) => topic.tag).toList();
  }

  Future<void> _onFetchQuickGameQuestions(
    FetchQuickGameQuestions event,
    Emitter<QuickGameState> emit,
  ) async {
    try {
      List<String> selectedTopics =
          quickGameTopicsToTags(state.selectedGameTopics!);
      final userRank = _authenticationBloc.state.user.rank;
      emit(state.copyWith(isLoadingGameQuestions: true));
      final questions = await _quickGameRepository.getQuickGameQuestions(
          'QUICK_GAME', userRank, selectedTopics);
      emit(state.copyWith(
        quickGameQuestions: questions,
        quickGameQuestionLoaded: true,
        isLoadingGameQuestions: false,
      ));
      emit(state.copyWith(quickGameQuestionLoaded: false));
    } catch (_) {
      emit(state.copyWith(
          isLoadingGameQuestions: false, quickGameQuestionLoaded: false));
    }
  }

  void _onSelectQuickGameTopic(
      SelectQuickGameTopic event, Emitter<QuickGameState> emit) {
    List<QuickGameTopic> selectedTopics =
        List.from(state.selectedGameTopics as Iterable);

    bool reachedMax = false;
    if (selectedTopics.contains(event.topic)) {
      selectedTopics.remove(event.topic);
    } else {
      if (selectedTopics.length < 4) {
        selectedTopics.add(event.topic);
      } else {
        reachedMax = true;
      }
    }
    emit(state.copyWith(
      selectedGameTopics: selectedTopics,
      hasReachedMaximumTopicSelection: reachedMax,
    ));
  }

  void _onOptionSelected(OptionSelected event, Emitter<QuickGameState> emit) {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;
    if (!state.hasAnswered) {
      int coinsGained = state.coinsGained ?? 0;
      int totalBonusCoinsGained = state.totalBonusCoinsGained ?? 0;
      int noOfCorrectAnswers = state.noOfCorrectAnswers;
      int currentStreak = state.currentStreak;
      int bestStreak = state.bestStreak;
      final pointsPerQuestion = int.parse(settingsState.gamePlaySettings['base_score_pilgrim_progress']);
      final durationPerQuestion = int.parse(settingsState.gamePlaySettings['normal_game_speed']);
      final halfOfTotalPointPerQuestion = pointsPerQuestion / 2;
      final totalTimeSpent = state.totalTimeSpent! + (durationPerQuestion - event.remainingTime);
      final isCorrect = event.gameQuestion.answer == event.gameQuestion.options[event.selectedOptionIndex];
      if (isCorrect) {
        noOfCorrectAnswers++;
        currentStreak++;
        if (currentStreak > bestStreak) bestStreak = currentStreak;
        soundManager.playCorrectAnswerSound();
        // Apply streak multiplier to time bonus (capped at 2x)
        final streakMultiplier = currentStreak >= 3
            ? (1.0 + (currentStreak * 0.1)).clamp(1.0, 2.0)
            : 1.0;
        dynamic timeBonusPoint = (event.remainingTime / durationPerQuestion) *
            halfOfTotalPointPerQuestion *
            streakMultiplier;
        coinsGained = state.coinsGained! +
            (halfOfTotalPointPerQuestion + timeBonusPoint).round();
        totalBonusCoinsGained =
            (state.totalBonusCoinsGained! + timeBonusPoint).round();
      } else {
        currentStreak = 0;
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
        noOfCorrectAnswers: noOfCorrectAnswers,
        currentStreak: currentStreak,
        bestStreak: bestStreak,
      ));
    }
  }

  void _onMoveToNextPage(MoveToNextPage event, Emitter<QuickGameState> emit) {
    emit(state.copyWith(
      hasAnswered: false,
      eliminatedOptionIndices: [],
      fiftyFiftyUsed: false,
    ));
    if ((state.quickGameQuestions?.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
        selectedOptionIndex: null,
        isCorrectAnswer: null,
        correctAnswer: null,
      ));
    }
  }

  void _onUseFiftyFifty(UseFiftyFifty event, Emitter<QuickGameState> emit) {
    if (state.fiftyFiftyUsed || state.hasAnswered) return;

    final options = event.gameQuestion.options;
    final correctAnswer = event.gameQuestion.answer;
    final wrongIndices = <int>[];
    for (int i = 0; i < options.length; i++) {
      if (options[i] != correctAnswer) wrongIndices.add(i);
    }
    wrongIndices.shuffle(Random());
    final toEliminate = wrongIndices.take(2).toList();

    _settingsBloc.soundManager.playClickSound();

    emit(state.copyWith(
      fiftyFiftyUsed: true,
      eliminatedOptionIndices: toEliminate,
    ));
  }

  Future<void> _onFindQuickGameTopics(
      FindQuickGameTopics event, Emitter<QuickGameState> emit) async {
    try {
      emit(state.copyWith(isLoadingGameTopics: true));
      final topics = await _quickGameRepository.findQuickGameTopics(event.code);
      emit(state.copyWith(quickGameTopics: topics, isLoadingGameTopics: false));
    } catch (_) {
      emit(state.copyWith(isLoadingGameTopics: false));
    }
  }


  void _onClearQuickGameData(
    ClearQuickGameData event,
    Emitter<QuickGameState> emit,
  ) {
    emit(QuickGameState());
  }
}
