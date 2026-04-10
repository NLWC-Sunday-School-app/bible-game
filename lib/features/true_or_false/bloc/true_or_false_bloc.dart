import 'dart:math';
import 'package:bible_game/shared/data/true_or_false_questions.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';

part 'true_or_false_event.dart';
part 'true_or_false_state.dart';

class TrueOrFalseBloc extends Bloc<TrueOrFalseEvent, TrueOrFalseState> {
  final SettingsBloc _settingsBloc;
  final ConnectivityBloc _connectivityBloc;
  final AuthenticationBloc _authenticationBloc;

  static const int _basePoints = 100;
  static const int _timeBonusMultiplier = 3;
  static const int _questionsPerGame = 20;

  TrueOrFalseBloc({
    required SettingsBloc settingsBloc,
    required ConnectivityBloc connectivityBloc,
    required AuthenticationBloc authenticationBloc,
  })  : _settingsBloc = settingsBloc,
        _connectivityBloc = connectivityBloc,
        _authenticationBloc = authenticationBloc,
        super(const TrueOrFalseState()) {
    on<LoadTrueOrFalseData>(_onLoadData);
    on<StartTrueOrFalseGame>(_onStartGame);
    on<AnswerTrueOrFalse>(_onAnswer);
    on<TrueOrFalseTimerExpired>(_onTimerExpired);
    on<NextTrueOrFalseQuestion>(_onNextQuestion);
    on<CompleteTrueOrFalseGame>(_onCompleteGame);
    on<ResetTrueOrFalseGame>(_onReset);
  }

  // ---------------------------------------------------------------------------
  // Load
  // ---------------------------------------------------------------------------

  Future<void> _onLoadData(
      LoadTrueOrFalseData event, Emitter<TrueOrFalseState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = TrueOrFalseQuestionsData.questions;

    final highScore = prefs.getInt('tof_high_score') ?? 0;
    final gamesPlayed = prefs.getInt('tof_games_played') ?? 0;
    final bestStreak = prefs.getInt('tof_best_streak') ?? 0;

    emit(state.copyWith(
      allQuestions: questions,
      isLoaded: true,
      highScore: highScore,
      totalGamesPlayed: gamesPlayed,
      bestStreak: bestStreak,
    ));
  }

  // ---------------------------------------------------------------------------
  // Start game
  // ---------------------------------------------------------------------------

  void _onStartGame(
      StartTrueOrFalseGame event, Emitter<TrueOrFalseState> emit) {
    final totalQuestions = state.allQuestions.length;
    final indices = List<int>.generate(totalQuestions, (i) => i)..shuffle();
    final sessionIndices =
        indices.take(min(_questionsPerGame, totalQuestions)).toList();

    emit(state.copyWith(
      currentSessionIndices: sessionIndices,
      currentQuestionIndex: 0,
      correctAnswers: 0,
      hasAnswered: false,
      isCorrect: null,
      selectedAnswer: null,
      gameCompleted: false,
      gameInProgress: true,
      coinsGained: 0,
      currentStreak: 0,
      highestStreakThisGame: 0,
      answerHistory: const [],
    ));
  }

  // ---------------------------------------------------------------------------
  // Answer
  // ---------------------------------------------------------------------------

  void _onAnswer(
      AnswerTrueOrFalse event, Emitter<TrueOrFalseState> emit) {
    if (state.hasAnswered) return;

    final questionIdx =
        state.currentSessionIndices[state.currentQuestionIndex];
    final question = state.allQuestions[questionIdx];
    final correctAnswer = question['isTrue'] as bool;
    final isCorrect = event.selectedAnswer == correctAnswer;

    int coinsGained = state.coinsGained;
    int currentStreak = state.currentStreak;
    int highestStreakThisGame = state.highestStreakThisGame;

    final soundManager = _settingsBloc.soundManager;

    if (isCorrect) {
      final timeBonus = event.remainingTime * _timeBonusMultiplier;
      currentStreak = state.currentStreak + 1;
      highestStreakThisGame = max(currentStreak, state.highestStreakThisGame);

      // Streak multiplier: capped at 2x
      final multiplier = min(1.0 + (currentStreak - 1) * 0.1, 2.0);
      final rawGain = _basePoints + timeBonus;
      coinsGained = state.coinsGained + (rawGain * multiplier).round();

      soundManager.playCorrectAnswerSound();
    } else {
      currentStreak = 0;
      soundManager.playWrongAnswerSound();
    }

    final history = List<Map<String, dynamic>>.from(state.answerHistory)
      ..add({
        'questionIndex': questionIdx,
        'userAnswer': event.selectedAnswer,
        'isCorrect': isCorrect,
      });

    emit(state.copyWith(
      hasAnswered: true,
      isCorrect: isCorrect,
      selectedAnswer: event.selectedAnswer,
      correctAnswers:
          isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
      coinsGained: coinsGained,
      currentStreak: currentStreak,
      highestStreakThisGame: highestStreakThisGame,
      answerHistory: history,
    ));

    // Auto-advance after a short delay so users can see correct/wrong feedback
    Future.delayed(const Duration(milliseconds: 1500), () {
      add(NextTrueOrFalseQuestion());
    });
  }

  // ---------------------------------------------------------------------------
  // Timer expired
  // ---------------------------------------------------------------------------

  void _onTimerExpired(
      TrueOrFalseTimerExpired event, Emitter<TrueOrFalseState> emit) {
    if (state.hasAnswered) return;

    _settingsBloc.soundManager.playWrongAnswerSound();

    final questionIdx =
        state.currentSessionIndices[state.currentQuestionIndex];
    final timedOutHistory = List<Map<String, dynamic>>.from(state.answerHistory)
      ..add({
        'questionIndex': questionIdx,
        'userAnswer': null, // timed out
        'isCorrect': false,
      });

    emit(state.copyWith(
      hasAnswered: true,
      isCorrect: false,
      currentStreak: 0,
      answerHistory: timedOutHistory,
    ));

    // Auto-advance after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      add(NextTrueOrFalseQuestion());
    });
  }

  // ---------------------------------------------------------------------------
  // Next question
  // ---------------------------------------------------------------------------

  void _onNextQuestion(
      NextTrueOrFalseQuestion event, Emitter<TrueOrFalseState> emit) {
    final nextIndex = state.currentQuestionIndex + 1;

    if (nextIndex >= state.currentSessionIndices.length) {
      add(CompleteTrueOrFalseGame());
    } else {
      emit(state.copyWith(
        currentQuestionIndex: nextIndex,
        hasAnswered: false,
        isCorrect: null,
        selectedAnswer: null,
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Complete game
  // ---------------------------------------------------------------------------

  Future<void> _onCompleteGame(
      CompleteTrueOrFalseGame event, Emitter<TrueOrFalseState> emit) async {
    final prefs = await SharedPreferences.getInstance();

    final newGamesPlayed = state.totalGamesPlayed + 1;
    await prefs.setInt('tof_games_played', newGamesPlayed);

    int highScore = state.highScore;
    if (state.coinsGained > highScore) {
      highScore = state.coinsGained;
      await prefs.setInt('tof_high_score', highScore);
    }

    int bestStreak = state.bestStreak;
    if (state.highestStreakThisGame > bestStreak) {
      bestStreak = state.highestStreakThisGame;
      await prefs.setInt('tof_best_streak', bestStreak);
    }

    _settingsBloc.soundManager.playAchievementSound();

    // Submit score to server or enqueue for offline sync
    final authState = _authenticationBloc.state;
    final deviceName = prefs.getString('deviceName');
    final deviceOs = prefs.getString('deviceOs');

    final playLog = {
      'game_mode': 'TRUE_OR_FALSE',
      'total_score': state.coinsGained,
      'base_score': state.coinsGained,
      'bonus_score': 0,
      'average_time_spent': 0,
      'player_rank': authState.user.rank,
      'number_of_correct_answers': state.correctAnswers,
      'player_id': authState.user.id,
      'user_progress': null,
      'number_of_rounds': _questionsPerGame,
      'deviceName': deviceName,
      'deviceOs': deviceOs,
    };

    final submitted = await _connectivityBloc.submitOrEnqueue(playLog);

    emit(state.copyWith(
      gameCompleted: true,
      gameInProgress: false,
      highScore: highScore,
      totalGamesPlayed: newGamesPlayed,
      bestStreak: bestStreak,
      scoreSubmitted: submitted,
    ));
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  void _onReset(
      ResetTrueOrFalseGame event, Emitter<TrueOrFalseState> emit) {
    emit(state.copyWith(
      currentSessionIndices: const [],
      currentQuestionIndex: 0,
      correctAnswers: 0,
      hasAnswered: false,
      isCorrect: null,
      selectedAnswer: null,
      gameCompleted: false,
      gameInProgress: false,
      coinsGained: 0,
      currentStreak: 0,
      highestStreakThisGame: 0,
      answerHistory: const [],
    ));
  }
}
