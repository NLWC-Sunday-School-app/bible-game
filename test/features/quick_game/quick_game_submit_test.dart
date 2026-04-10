import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:bible_game/features/quick_game/repository/quick_game_repository.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/settings/sound_manager.dart';
import 'package:bible_game_api/model/user.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockQuickGameRepository extends Mock implements QuickGameRepository {}

class MockConnectivityBloc extends Mock implements ConnectivityBloc {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockSettingsBloc extends Mock implements SettingsBloc {}

class MockSoundManager extends Mock implements SoundManager {}

void main() {
  late MockQuickGameRepository mockRepo;
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

    mockRepo = MockQuickGameRepository();
    mockConnectivityBloc = MockConnectivityBloc();
    mockAuthBloc = MockAuthenticationBloc();
    mockSettingsBloc = MockSettingsBloc();
    mockSoundManager = MockSoundManager();

    when(() => mockAuthBloc.state).thenReturn(
      const AuthenticationState(user: testUser),
    );

    when(() => mockConnectivityBloc.state).thenReturn(
      const ConnectivityState(isOnline: true),
    );
    when(() => mockConnectivityBloc.submitOrEnqueue(any()))
        .thenAnswer((_) async => false);

    when(() => mockSettingsBloc.soundManager).thenReturn(mockSoundManager);
  });

  group('QuickGameBloc — ConnectivityBloc Integration', () {
    test('ConnectivityBloc is optional — bloc works without it', () async {
      // Create bloc without ConnectivityBloc
      final bloc = QuickGameBloc(
        quickGameRepository: mockRepo,
        authenticationBloc: mockAuthBloc,
        settingsBloc: mockSettingsBloc,
      );

      // Silently ignores submission (original behavior)
      when(() => mockRepo.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenThrow('Network error');

      bloc.add(SubmitQuickGameScore());
      await Future.delayed(const Duration(milliseconds: 300));

      // Without ConnectivityBloc, enqueue is never called
      verifyNever(() => mockConnectivityBloc.submitOrEnqueue(any()));

      await bloc.close();
    });

    test('enqueues to ConnectivityBloc when sendGameData throws', () async {
      when(() => mockRepo.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenThrow('Network error');

      final bloc = QuickGameBloc(
        quickGameRepository: mockRepo,
        authenticationBloc: mockAuthBloc,
        settingsBloc: mockSettingsBloc,
        connectivityBloc: mockConnectivityBloc,
      );

      bloc.add(SubmitQuickGameScore());
      await Future.delayed(const Duration(milliseconds: 300));

      // Verify fallback enqueue was called
      final captured =
          verify(() => mockConnectivityBloc.submitOrEnqueue(captureAny()))
              .captured;

      expect(captured.isNotEmpty, true);
      final playLog = captured.first as Map<String, dynamic>;
      expect(playLog['game_mode'], 'QUICK_GAME');
      expect(playLog['player_id'], 42);
      expect(playLog['player_rank'], 'babe');
      expect(playLog['deviceName'], 'TestDevice');
      expect(playLog['deviceOs'], 'TestOS');

      await bloc.close();
    });

    test('does not enqueue when sendGameData succeeds', () async {
      when(() => mockRepo.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenAnswer((_) async {});

      final bloc = QuickGameBloc(
        quickGameRepository: mockRepo,
        authenticationBloc: mockAuthBloc,
        settingsBloc: mockSettingsBloc,
        connectivityBloc: mockConnectivityBloc,
      );

      bloc.add(SubmitQuickGameScore());
      await Future.delayed(const Duration(milliseconds: 300));

      // Should NOT fall through to enqueue
      verifyNever(() => mockConnectivityBloc.submitOrEnqueue(any()));

      await bloc.close();
    });
  });
}
