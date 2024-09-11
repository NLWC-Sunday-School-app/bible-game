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
    on<SubmitQuickGameScore>(_onSubmitQuickGameScore);
    on<ClearQuickGameData>(_onClearQuickGameData);
    on<FindQuickGameTopics>(_onFindQuickGameTopics);
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
    try {
      final authenticationState = _authenticationBloc.state;
      final response = await _quickGameRepository.sendGameData(
        'QUICK_GAME',
        state.coinsGained!,
        state.coinsGained!,
        state.totalBonusCoinsGained!,
        (state.totalTimeSpent! ~/ state.quickGameQuestions!.length),
        authenticationState.user.rank,
        state.noOfCorrectAnswers,
        authenticationState.user.id,
        null,
        5,
      );

    } catch (_) {

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
    emit(state.copyWith(selectedGameTopics: selectedTopics, hasReachedMaximumTopicSelection: false));
  }

  void _onOptionSelected(OptionSelected event, Emitter<QuickGameState> emit) {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;
    if(!state.hasAnswered){
      int coinsGained = state.coinsGained ?? 0;
      int totalBonusCoinsGained = state.totalBonusCoinsGained ?? 0;
      int noOfCorrectAnswers = state.noOfCorrectAnswers;
      final pointsPerQuestion = int.parse(settingsState.gamePlaySettings['base_score_pilgrim_progress']);
      final durationPerQuestion = int.parse(settingsState.gamePlaySettings['normal_game_speed']);
      final halfOfTotalPointPerQuestion = pointsPerQuestion / 2;
      final totalTimeSpent = state.totalTimeSpent!  + (durationPerQuestion - event.remainingTime);
      final isCorrect = event.gameQuestion.answer == event.gameQuestion.options[event.selectedOptionIndex];
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
          noOfCorrectAnswers: noOfCorrectAnswers
      ));
      Future.delayed(Duration(seconds: 1), (){
        add(MoveToNextPage());
      });

    }

  }

  void _onMoveToNextPage(MoveToNextPage event, Emitter<QuickGameState> emit) {
    emit(state.copyWith(hasAnswered: false,));
    if ((state.quickGameQuestions?.length ?? 0) >
          (state.selectedOptionIndex ?? 0) + 1) {
        emit(state.copyWith(
          selectedOptionIndex: null,
          isCorrectAnswer: null,
          correctAnswer: null,

        ));
      }
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
