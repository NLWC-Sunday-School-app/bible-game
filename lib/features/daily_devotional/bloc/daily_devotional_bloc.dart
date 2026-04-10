import 'package:bible_game/shared/data/daily_devotionals.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'daily_devotional_event.dart';
part 'daily_devotional_state.dart';

class DailyDevotionalBloc
    extends Bloc<DailyDevotionalEvent, DailyDevotionalState> {
  final ConnectivityBloc _connectivityBloc;
  final AuthenticationBloc _authenticationBloc;

  DailyDevotionalBloc({
    required ConnectivityBloc connectivityBloc,
    required AuthenticationBloc authenticationBloc,
  })  : _connectivityBloc = connectivityBloc,
        _authenticationBloc = authenticationBloc,
        super(const DailyDevotionalState()) {
    on<LoadDailyDevotional>(_onLoad);
    on<AnswerDevotional>(_onAnswer);
  }

  Future<void> _onLoad(
      LoadDailyDevotional event, Emitter<DailyDevotionalState> emit) async {
    final prefs = await SharedPreferences.getInstance();

    final today = _todayStr();
    final lastCompleted = prefs.getString('devotional_last_completed') ?? '';
    final hasCompletedToday = lastCompleted == today;

    final streak = prefs.getInt('devotional_streak') ?? 0;
    final bestStreak = prefs.getInt('devotional_best_streak') ?? 0;

    // Pick today's devotional using a deterministic scatter so consecutive
    // days pull from different books instead of sequential entries.
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = _scatteredIndex(dayOfYear, DailyDevotionals.devotionals.length);
    final data = DailyDevotionals.devotionals[index];

    emit(state.copyWith(
      passage: data['passage'] as String,
      passageText: data['passageText'] as String,
      reflection: data['reflection'] as String,
      question: data['question'] as String,
      options: List<String>.from(data['options'] as List),
      answer: data['answer'] as String,
      hasCompletedToday: hasCompletedToday,
      devotionalStreak: streak,
      bestStreak: bestStreak,
      isLoaded: true,
    ));
  }

  Future<void> _onAnswer(
      AnswerDevotional event, Emitter<DailyDevotionalState> emit) async {
    if (state.hasAnswered || state.hasCompletedToday) return;

    final isCorrect =
        state.options[event.selectedOptionIndex] == state.answer;

    final prefs = await SharedPreferences.getInstance();
    final today = _todayStr();
    final yesterday = _yesterdayStr();
    final lastCompleted = prefs.getString('devotional_last_completed') ?? '';

    // Streak logic
    int streak = prefs.getInt('devotional_streak') ?? 0;
    if (lastCompleted == yesterday) {
      streak++;
    } else if (lastCompleted != today) {
      streak = 1;
    }
    int bestStreak = prefs.getInt('devotional_best_streak') ?? 0;
    if (streak > bestStreak) bestStreak = streak;

    await prefs.setString('devotional_last_completed', today);
    await prefs.setInt('devotional_streak', streak);
    await prefs.setInt('devotional_best_streak', bestStreak);

    emit(state.copyWith(
      hasAnswered: true,
      isCorrect: isCorrect,
      selectedOptionIndex: event.selectedOptionIndex,
      hasCompletedToday: true,
      devotionalStreak: streak,
      bestStreak: bestStreak,
    ));

    // Submit play log to keep global BG Streak alive (no coins awarded)
    final authState = _authenticationBloc.state;
    final deviceName = prefs.getString('deviceName');
    final deviceOs = prefs.getString('deviceOs');

    final playLog = {
      'game_mode': 'DAILY_DEVOTIONAL',
      'total_score': 0,
      'base_score': 0,
      'bonus_score': 0,
      'average_time_spent': 0,
      'player_rank': authState.user.rank,
      'number_of_correct_answers': isCorrect ? 1 : 0,
      'player_id': authState.user.id,
      'user_progress': null,
      'number_of_rounds': 1,
      'deviceName': deviceName,
      'deviceOs': deviceOs,
    };

    await _connectivityBloc.submitOrEnqueue(playLog);
  }

  /// Maps a sequential day number to a scattered index so that adjacent days
  /// land on devotionals far apart in the list (different books).
  /// Uses a simple multiplicative hash: (day * prime) mod length.
  /// The prime 137 is coprime with 291 (291 = 3×97), guaranteeing every
  /// index is hit exactly once over a full 291-day cycle.
  int _scatteredIndex(int dayOfYear, int length) {
    const prime = 137;
    return (dayOfYear * prime) % length;
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _yesterdayStr() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
  }
}
