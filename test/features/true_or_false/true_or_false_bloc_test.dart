import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/true_or_false/bloc/true_or_false_bloc.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/settings/sound_manager.dart';
import 'package:bible_game_api/model/user.dart';
import 'package:bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:bible_game/shared/features/user/repository/user_repository.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockConnectivityBloc extends Mock implements ConnectivityBloc {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockSoundManager extends Mock implements SoundManager {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockConnectivityBloc mockConnectivityBloc;
  late MockAuthenticationBloc mockAuthBloc;
  late MockSettingsBloc mockSettingsBloc;
  late MockSoundManager mockSoundManager;

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
    SharedPreferences.setMockInitialValues({
      'deviceName': 'TestDevice',
      'deviceOs': 'TestOS',
    });

    mockConnectivityBloc = MockConnectivityBloc();
    mockAuthBloc = MockAuthenticationBloc();
    mockSettingsBloc = MockSettingsBloc();
    mockSoundManager = MockSoundManager();

    // Stub AuthenticationBloc state
    when(() => mockAuthBloc.state).thenReturn(
      const AuthenticationState(user: testUser),
    );

    // Stub ConnectivityBloc
    when(() => mockConnectivityBloc.state).thenReturn(
      const ConnectivityState(isOnline: true),
    );
    when(() => mockConnectivityBloc.submitOrEnqueue(any()))
        .thenAnswer((_) async => true);

    // Stub SettingsBloc
    when(() => mockSettingsBloc.soundManager).thenReturn(mockSoundManager);
    when(() => mockSoundManager.playCorrectAnswerSound()).thenReturn(null);
    when(() => mockSoundManager.playWrongAnswerSound()).thenReturn(null);
    when(() => mockSoundManager.playAchievementSound()).thenReturn(null);
  });

  TrueOrFalseBloc _createBloc() {
    return TrueOrFalseBloc(
      settingsBloc: mockSettingsBloc,
      connectivityBloc: mockConnectivityBloc,
      authenticationBloc: mockAuthBloc,
    );
  }

  group('TrueOrFalseBloc — Score Submission', () {
    test('submits play log to ConnectivityBloc on game complete', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
        'tof_high_score': 0,
        'tof_games_played': 0,
        'tof_best_streak': 0,
      });

      final bloc = _createBloc();

      // Load data first
      bloc.add(LoadTrueOrFalseData());
      await Future.delayed(const Duration(milliseconds: 100));

      // Start a game
      bloc.add(StartTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 100));

      // Complete the game
      bloc.add(CompleteTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 200));

      // Verify submitOrEnqueue was called with correct game mode
      final captured =
          verify(() => mockConnectivityBloc.submitOrEnqueue(captureAny()))
              .captured;

      expect(captured.isNotEmpty, true);
      final playLog = captured.first as Map<String, dynamic>;
      expect(playLog['game_mode'], 'TRUE_OR_FALSE');
      expect(playLog['player_id'], 42);
      expect(playLog['player_rank'], 'babe');
      expect(playLog['deviceName'], 'TestDevice');
      expect(playLog['deviceOs'], 'TestOS');

      await bloc.close();
    });

    test('sets scoreSubmitted to true when online submission succeeds',
        () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
        'tof_high_score': 0,
        'tof_games_played': 0,
        'tof_best_streak': 0,
      });

      when(() => mockConnectivityBloc.submitOrEnqueue(any()))
          .thenAnswer((_) async => true);

      final bloc = _createBloc();
      bloc.add(LoadTrueOrFalseData());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(StartTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(CompleteTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state.scoreSubmitted, true);
      expect(bloc.state.gameCompleted, true);

      await bloc.close();
    });

    test('sets scoreSubmitted to false when offline (enqueued)', () async {
      SharedPreferences.setMockInitialValues({
        'deviceName': 'TestDevice',
        'deviceOs': 'TestOS',
        'tof_high_score': 0,
        'tof_games_played': 0,
        'tof_best_streak': 0,
      });

      when(() => mockConnectivityBloc.submitOrEnqueue(any()))
          .thenAnswer((_) async => false);

      final bloc = _createBloc();
      bloc.add(LoadTrueOrFalseData());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(StartTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(CompleteTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state.scoreSubmitted, false);
      expect(bloc.state.gameCompleted, true);

      await bloc.close();
    });
  });

  group('TrueOrFalseBloc — Reset', () {
    test('reset clears scoreSubmitted', () async {
      SharedPreferences.setMockInitialValues({});

      final bloc = _createBloc();
      bloc.add(ResetTrueOrFalseGame());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.scoreSubmitted, false);
      expect(bloc.state.gameInProgress, false);
      expect(bloc.state.gameCompleted, false);

      await bloc.close();
    });
  });
}
