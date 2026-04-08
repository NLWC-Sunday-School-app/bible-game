import 'dart:math';
import 'package:bible_game/shared/data/story_arcs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';

part 'story_mode_event.dart';
part 'story_mode_state.dart';

class StoryModeBloc extends Bloc<StoryModeEvent, StoryModeState> {
  final SettingsBloc _settingsBloc;

  static const int _pointsPerQuestion = 100;
  static const int _durationPerQuestion = 30;
  // 50/50 is free in story mode (1 per chapter)

  StoryModeBloc({required SettingsBloc settingsBloc})
      : _settingsBloc = settingsBloc,
        super(const StoryModeState()) {
    on<LoadStoryArcs>(_onLoadStoryArcs);
    on<SelectStory>(_onSelectStory);
    on<SelectChapter>(_onSelectChapter);
    on<AdvanceNarrative>(_onAdvanceNarrative);
    on<AnswerStoryQuestion>(_onAnswerQuestion);
    on<UseFiftyFifty>(_onUseFiftyFifty);
    on<TimerExpired>(_onTimerExpired);
    on<MoveToNextStoryQuestion>(_onMoveToNext);
    on<CompleteChapter>(_onCompleteChapter);
    on<ResetStoryGame>(_onReset);
  }

  // ---------------------------------------------------------------------------
  // Load
  // ---------------------------------------------------------------------------

  Future<void> _onLoadStoryArcs(
      LoadStoryArcs event, Emitter<StoryModeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final arcs = StoryArcsData.arcs;
    final progress = <String, Map<String, int>>{};

    for (final arc in arcs) {
      final arcId = arc['id'] as String;
      final chapters = arc['chapters'] as List;
      progress[arcId] = {};
      for (final chapter in chapters) {
        final chapterId = chapter['id'] as String;
        final key = 'story_${arcId}_chapter_${chapterId}_stars';
        progress[arcId]![chapterId] = prefs.getInt(key) ?? 0;
      }
    }

    emit(state.copyWith(arcs: arcs, chapterProgress: progress, isLoaded: true));
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void _onSelectStory(SelectStory event, Emitter<StoryModeState> emit) {
    emit(state.copyWith(selectedArcId: event.arcId));
  }

  void _onSelectChapter(SelectChapter event, Emitter<StoryModeState> emit) {
    emit(state.copyWith(
      selectedChapterId: event.chapterId,
      currentQuestionIndex: 0,
      correctAnswers: 0,
      hasAnswered: false,
      isCorrect: null,
      selectedOptionIndex: -1,
      chapterCompleted: false,
      showingNarrative: true,
      // Reset all gameplay state
      coinsGained: 0,
      currentStreak: 0,
      highestStreak: 0,
      fiftyFiftyUsed: false,
      eliminatedOptions: const [],
      starsEarned: 0,
      currentNarrativeIndex: 0,
      narrativeComplete: false,
      totalTimeSpent: 0,
    ));
  }

  // ---------------------------------------------------------------------------
  // Narrative
  // ---------------------------------------------------------------------------

  void _onAdvanceNarrative(
      AdvanceNarrative event, Emitter<StoryModeState> emit) {
    final chapter = _currentChapter(state);
    if (chapter == null) return;

    final narratives = chapter['narratives'] as List? ?? [];
    final nextIndex = state.currentNarrativeIndex + 1;

    if (narratives.isEmpty || nextIndex >= narratives.length) {
      emit(state.copyWith(narrativeComplete: true));
    } else {
      emit(state.copyWith(currentNarrativeIndex: nextIndex));
    }
  }

  // ---------------------------------------------------------------------------
  // Answer
  // ---------------------------------------------------------------------------

  void _onAnswerQuestion(
      AnswerStoryQuestion event, Emitter<StoryModeState> emit) {
    if (state.hasAnswered) return;
    final chapter = _currentChapter(state);
    if (chapter == null) return;

    final questions = chapter['questions'] as List<Map<String, dynamic>>;
    final q = questions[state.currentQuestionIndex];
    final options = q['options'] as List;
    final isCorrect =
        options[event.selectedOptionIndex] == q['answer'];

    int coinsGained = state.coinsGained;
    int currentStreak = state.currentStreak;
    int highestStreak = state.highestStreak;
    int totalTimeSpent = state.totalTimeSpent + (_durationPerQuestion - event.remainingTime);

    final soundManager = _settingsBloc.soundManager;

    if (isCorrect) {
      // Coin calculation
      const halfBase = _pointsPerQuestion / 2; // 50
      final timeBonusPoint = event.remainingTime > 0
          ? (event.remainingTime / _durationPerQuestion) * halfBase
          : 0.0;
      final rawGain = (halfBase + timeBonusPoint).round();

      // Streak multiplier: capped at 2×
      currentStreak = state.currentStreak + 1;
      highestStreak = max(currentStreak, state.highestStreak);
      final multiplier = min(1.0 + state.currentStreak * 0.1, 2.0);
      coinsGained = state.coinsGained + (rawGain * multiplier).round();

      soundManager.playCorrectAnswerSound();
    } else {
      currentStreak = 0;
      soundManager.playWrongAnswerSound();
    }

    final updatedResults = List<bool>.from(state.answerResults)..add(isCorrect);

    emit(state.copyWith(
      hasAnswered: true,
      isCorrect: isCorrect,
      selectedOptionIndex: event.selectedOptionIndex,
      correctAnswers: isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
      coinsGained: coinsGained,
      currentStreak: currentStreak,
      highestStreak: highestStreak,
      totalTimeSpent: totalTimeSpent,
      answerResults: updatedResults,
    ));

    // Auto-advance after a short delay so users can see correct/wrong feedback
    Future.delayed(const Duration(milliseconds: 1500), () {
      add(MoveToNextStoryQuestion());
    });
  }

  // ---------------------------------------------------------------------------
  // 50/50 power-up
  // ---------------------------------------------------------------------------

  void _onUseFiftyFifty(UseFiftyFifty event, Emitter<StoryModeState> emit) {
    if (state.fiftyFiftyUsed) return;
    if (state.hasAnswered) return;

    final chapter = _currentChapter(state);
    if (chapter == null) return;

    final questions = chapter['questions'] as List<Map<String, dynamic>>;
    final q = questions[state.currentQuestionIndex];
    final options = q['options'] as List;
    final answer = q['answer'];

    // Collect indices of wrong options that haven't already been eliminated
    final wrongIndices = <int>[];
    for (int i = 0; i < options.length; i++) {
      if (options[i] != answer && !state.eliminatedOptions.contains(i)) {
        wrongIndices.add(i);
      }
    }

    wrongIndices.shuffle();
    final toEliminate = wrongIndices.take(2).toList();
    final updated = List<int>.from(state.eliminatedOptions)..addAll(toEliminate);

    _settingsBloc.soundManager.playClickSound();

    emit(state.copyWith(
      fiftyFiftyUsed: true,
      eliminatedOptions: updated,
    ));
  }

  // ---------------------------------------------------------------------------
  // Timer expired
  // ---------------------------------------------------------------------------

  void _onTimerExpired(TimerExpired event, Emitter<StoryModeState> emit) {
    if (state.hasAnswered) return;

    _settingsBloc.soundManager.playWrongAnswerSound();

    final updatedResults = List<bool>.from(state.answerResults)..add(false);

    emit(state.copyWith(
      hasAnswered: true,
      isCorrect: false,
      currentStreak: 0,
      totalTimeSpent: state.totalTimeSpent + _durationPerQuestion,
      answerResults: updatedResults,
    ));

    // Auto-advance after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      add(MoveToNextStoryQuestion());
    });
  }

  // ---------------------------------------------------------------------------
  // Move to next question
  // ---------------------------------------------------------------------------

  void _onMoveToNext(
      MoveToNextStoryQuestion event, Emitter<StoryModeState> emit) {
    final chapter = _currentChapter(state);
    if (chapter == null) return;
    final questions = chapter['questions'] as List;
    final nextIndex = state.currentQuestionIndex + 1;

    if (nextIndex >= questions.length) {
      add(CompleteChapter());
    } else {
      emit(state.copyWith(
        currentQuestionIndex: nextIndex,
        hasAnswered: false,
        isCorrect: null,
        selectedOptionIndex: -1,
        eliminatedOptions: const [],
        // fiftyFiftyUsed is NOT reset — 1 free use per chapter
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Complete chapter
  // ---------------------------------------------------------------------------

  Future<void> _onCompleteChapter(
      CompleteChapter event, Emitter<StoryModeState> emit) async {
    final chapter = _currentChapter(state);
    if (chapter == null) return;

    final questions = chapter['questions'] as List;
    final total = questions.length;
    final correct = state.correctAnswers;
    final pct = total > 0 ? correct / total : 0.0;

    final int newStars;
    if (correct == total) {
      newStars = 3;
    } else if (pct >= 0.8) {
      newStars = 2;
    } else if (pct >= 0.6) {
      newStars = 1;
    } else {
      newStars = 0;
    }

    final arcId = state.selectedArcId;
    final chapterId = state.selectedChapterId;
    final previousStars =
        state.chapterProgress[arcId]?[chapterId] ?? 0;

    final newProgress =
        Map<String, Map<String, int>>.from(state.chapterProgress);
    newProgress[arcId] =
        Map<String, int>.from(newProgress[arcId] ?? {});

    // Only persist if this is a new personal best
    if (newStars > previousStars) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'story_${arcId}_chapter_${chapterId}_stars';
      await prefs.setInt(key, newStars);
      newProgress[arcId]![chapterId] = newStars;
    }

    if (newStars == 3) {
      _settingsBloc.soundManager.playAchievementSound();
    }

    emit(state.copyWith(
      chapterCompleted: true,
      starsEarned: newStars,
      chapterProgress: newProgress,
    ));
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  void _onReset(ResetStoryGame event, Emitter<StoryModeState> emit) {
    emit(state.copyWith(
      selectedChapterId: '',
      currentQuestionIndex: 0,
      correctAnswers: 0,
      hasAnswered: false,
      isCorrect: null,
      selectedOptionIndex: -1,
      chapterCompleted: false,
      showingNarrative: false,
      coinsGained: 0,
      currentStreak: 0,
      highestStreak: 0,
      fiftyFiftyUsed: false,
      eliminatedOptions: const [],
      starsEarned: 0,
      currentNarrativeIndex: 0,
      narrativeComplete: false,
      totalTimeSpent: 0,
    ));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic>? _currentChapter(StoryModeState s) {
    if (s.selectedArcId.isEmpty || s.selectedChapterId.isEmpty) return null;
    final arc = s.arcs.firstWhere(
      (a) => a['id'] == s.selectedArcId,
      orElse: () => {},
    );
    if (arc.isEmpty) return null;
    final chapters = arc['chapters'] as List;
    try {
      return chapters.firstWhere(
        (c) => (c as Map<String, dynamic>)['id'] == s.selectedChapterId,
      ) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
