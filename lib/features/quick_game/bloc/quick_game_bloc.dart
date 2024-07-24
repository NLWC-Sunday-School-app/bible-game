import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/quick_game_topic.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../repository/quick_game_repository.dart';

part 'quick_game_event.dart';

part 'quick_game_state.dart';

class QuickGameBloc extends Bloc<QuickGameEvent, QuickGameState> {
  final QuickGameRepository _quickGameRepository;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;

  QuickGameBloc(
      {required AuthenticationBloc authenticationBloc,
      required QuickGameRepository quickGameRepository,
      required SettingsBloc settingsBloc})
      : _quickGameRepository = quickGameRepository,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        super(QuickGameState()) {
    on<FetchQuickGameTopics>(_onFetchQuickGameTopics);
    on<FetchQuickGameQuestions>(_onFetchQuickGameQuestions);
    on<SelectQuickGameTopic>(_onSelectQuickGameTopic);
    on<OptionSelected>(_onOptionSelected);
    on<MoveToNextPage>(_onMoveToNextPage);
    on<ClearQuickGameData>(_onClearQuickGameData);
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
      final userRank = _authenticationBloc.state.user!.rank;
      emit(state.copyWith(isLoadingGameQuestions: true));
      final questions = await _quickGameRepository.getQuickGameQuestions(
          'QUICK_GAME', userRank, selectedTopics);
      emit(state.copyWith(
        quickGameQuestions: questions,
        quickGameQuestionLoaded: true,
        isLoadingGameQuestions: false,
      ));
    } catch (_) {
      emit(state.copyWith(
          isLoadingGameQuestions: false, quickGameQuestionLoaded: false));
    }
  }

  void _onSelectQuickGameTopic(
      SelectQuickGameTopic event, Emitter<QuickGameState> emit) {
    List<QuickGameTopic> selectedTopics =
        List.from(state.selectedGameTopics as Iterable);

    if (selectedTopics.contains(event.topic)) {
      selectedTopics.remove(event.topic);
      emit(state.copyWith(hasReachedMaximumTopicSelection: false));
    } else {
      if (selectedTopics.length < 4) {
        selectedTopics.add(event.topic);
      } else {
        emit(state.copyWith(hasReachedMaximumTopicSelection: true));
      }
    }
    emit(state.copyWith(selectedGameTopics: selectedTopics));
  }

  void _onOptionSelected(OptionSelected event, Emitter<QuickGameState> emit) {
    final soundManager = _settingsBloc.soundManager;
    int coinsGained = state.coinsGained ?? 0;
    int totalBonusCoinsGained = state.totalBonusCoinsGained ?? 0;
    final isCorrect = event.gameQuestion.answer ==
        event.gameQuestion.options[event.selectedOptionIndex];

    final settingsState = _settingsBloc.state;
    final pointsPerQuestion = int.parse(
        settingsState.gamePlaySettings['base_score_pilgrim_progress']);
    final durationPerQuestion =
        int.parse(settingsState.gamePlaySettings['normal_game_speed']);
    final halfOfTotalPointPerQuestion = pointsPerQuestion / 2;
    if (isCorrect) {
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
        totalBonusCoinsGained: totalBonusCoinsGained));

    Future.delayed(Duration(seconds: 1), () {
      add(MoveToNextPage());
    });
  }

  void _onMoveToNextPage(MoveToNextPage event, Emitter<QuickGameState> emit) {
    if ((state.quickGameQuestions?.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
          selectedOptionIndex: null,
          isCorrectAnswer: null,
          correctAnswer: null,
          hasAnswered: false));
    } else {
      emit(state.copyWith(
        selectedOptionIndex: null,
        isCorrectAnswer: null,
        correctAnswer: null,
        hasAnswered: false,
      ));
    }
  }

  void _onClearQuickGameData(
    ClearQuickGameData event,
    Emitter<QuickGameState> emit,
  ) {
    emit(QuickGameState());
  }
}
