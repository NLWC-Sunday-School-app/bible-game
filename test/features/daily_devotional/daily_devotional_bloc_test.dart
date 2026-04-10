import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/daily_devotional/bloc/daily_devotional_bloc.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game_api/model/user.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockConnectivityBloc extends Mock implements ConnectivityBloc {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  late MockConnectivityBloc mockConnectivityBloc;
  late MockAuthenticationBloc mockAuthBloc;

  const testUser = User(
    id: 42,
    name: 'Test User',
    email: 'test@test.com',
    profileUrl: '',
    rank: 'babe',
    highScore: 0,
    fourScripturesScore: 0,
    fourScriptsLevel: 0,
    coinWalletBalance: 500,
    fcmToken: '',
    country: 'NG',
    streak: 5,
    gems: 10,
    isWalletInitialized: true,
    role: 'user',
  );

  setUp(() {
    mockConnectivityBloc = MockConnectivityBloc();
    mockAuthBloc = MockAuthenticationBloc();

    when(() => mockAuthBloc.state).thenReturn(
      const AuthenticationState(user: testUser),
    );

    when(() => mockConnectivityBloc.state).thenReturn(
      const ConnectivityState(isOnline: true),
    );
    when(() => mockConnectivityBloc.submitOrEnqueue(any()))
        .thenAnswer((_) async => true);
  });

  DailyDevotionalBloc _createBloc() {
    return DailyDevotionalBloc(
      connectivityBloc: mockConnectivityBloc,
      authenticationBloc: mockAuthBloc,
    );
  }

  group('DailyDevotionalBloc — Play Log for Global Streak', () {
    test('submits play log when devotional question is answered', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
      });

      final bloc = _createBloc();

      // Load devotional data
      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      // Answer the devotional question (index 0)
      bloc.add(const AnswerDevotional(selectedOptionIndex: 0));
      await Future.delayed(const Duration(milliseconds: 200));

      // Verify a play log was submitted
      final captured =
          verify(() => mockConnectivityBloc.submitOrEnqueue(captureAny()))
              .captured;

      expect(captured.isNotEmpty, true);
      final playLog = captured.first as Map<String, dynamic>;

      // Devotional play log should have:
      expect(playLog['game_mode'], 'DAILY_DEVOTIONAL');
      expect(playLog['total_score'], 0); // no coins for devotional
      expect(playLog['base_score'], 0);
      expect(playLog['bonus_score'], 0);
      expect(playLog['player_id'], 42);
      expect(playLog['player_rank'], 'babe');
      expect(playLog['number_of_rounds'], 1);
      expect(playLog['deviceName'], 'TestDevice');

      await bloc.close();
    });

    test('play log has correct_answers=1 when answer is correct', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
      });

      final bloc = _createBloc();

      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      // Find the correct answer index
      final correctAnswer = bloc.state.answer;
      final correctIndex =
          bloc.state.options.indexWhere((o) => o == correctAnswer);

      if (correctIndex >= 0) {
        bloc.add(AnswerDevotional(selectedOptionIndex: correctIndex));
        await Future.delayed(const Duration(milliseconds: 200));

        final captured =
            verify(() => mockConnectivityBloc.submitOrEnqueue(captureAny()))
                .captured;
        final playLog = captured.first as Map<String, dynamic>;

        expect(playLog['number_of_correct_answers'], 1);
      }

      await bloc.close();
    });

    test('play log has correct_answers=0 when answer is wrong', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
      });

      final bloc = _createBloc();

      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      // Find a wrong answer index
      final correctAnswer = bloc.state.answer;
      final wrongIndex =
          bloc.state.options.indexWhere((o) => o != correctAnswer);

      if (wrongIndex >= 0) {
        bloc.add(AnswerDevotional(selectedOptionIndex: wrongIndex));
        await Future.delayed(const Duration(milliseconds: 200));

        final captured =
            verify(() => mockConnectivityBloc.submitOrEnqueue(captureAny()))
                .captured;
        final playLog = captured.first as Map<String, dynamic>;

        expect(playLog['number_of_correct_answers'], 0);
      }

      await bloc.close();
    });

    test('does not submit play log if already answered today', () async {
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
        'devotional_last_completed': todayStr,
        'devotional_streak': 3,
        'devotional_best_streak': 5,
      });

      final bloc = _createBloc();

      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      // Already completed today
      expect(bloc.state.hasCompletedToday, true);

      // Try answering again
      bloc.add(const AnswerDevotional(selectedOptionIndex: 0));
      await Future.delayed(const Duration(milliseconds: 200));

      // Should NOT have submitted any play log
      verifyNever(() => mockConnectivityBloc.submitOrEnqueue(any()));

      await bloc.close();
    });

    test('enqueues play log when offline', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
      });

      // Simulate offline — submitOrEnqueue returns false
      when(() => mockConnectivityBloc.submitOrEnqueue(any()))
          .thenAnswer((_) async => false);

      final bloc = _createBloc();

      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const AnswerDevotional(selectedOptionIndex: 0));
      await Future.delayed(const Duration(milliseconds: 200));

      // submitOrEnqueue was still called (it handles the enqueue internally)
      verify(() => mockConnectivityBloc.submitOrEnqueue(any())).called(1);

      await bloc.close();
    });
  });

  group('DailyDevotionalBloc — Streak Tracking', () {
    test('streak increments when answered on consecutive days', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr =
          '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
        'devotional_last_completed': yesterdayStr,
        'devotional_streak': 3,
        'devotional_best_streak': 5,
      });

      final bloc = _createBloc();

      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const AnswerDevotional(selectedOptionIndex: 0));
      await Future.delayed(const Duration(milliseconds: 200));

      // Streak should have incremented from 3 to 4
      expect(bloc.state.devotionalStreak, 4);

      await bloc.close();
    });

    test('streak resets to 1 when gap in days', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
        'devotional_last_completed': '2024-01-01', // old date
        'devotional_streak': 10,
        'devotional_best_streak': 15,
      });

      final bloc = _createBloc();

      bloc.add(LoadDailyDevotional());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const AnswerDevotional(selectedOptionIndex: 0));
      await Future.delayed(const Duration(milliseconds: 200));

      // Streak resets to 1
      expect(bloc.state.devotionalStreak, 1);

      await bloc.close();
    });
  });
}
