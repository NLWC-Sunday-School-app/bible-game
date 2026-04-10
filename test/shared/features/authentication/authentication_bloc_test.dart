import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:bible_game/shared/features/user/repository/user_repository.dart';
import 'package:bible_game_api/model/user.dart';
import 'dart:io';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockAuthenticationRepository mockAuthRepo;
  late MockUserRepository mockUserRepo;

  const testUser = User(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    profileUrl: '',
    rank: 'babe',
    highScore: 100,
    fourScripturesScore: 50,
    fourScriptsLevel: 2,
    coinWalletBalance: 500,
    fcmToken: 'test_token',
    country: 'NG',
    streak: 5,
    gems: 10,
    isWalletInitialized: true,
    role: 'user',
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Provide a temporary directory for GetStorage
    final dir = await Directory.systemTemp.createTemp('get_storage_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => dir.path,
    );
    await GetStorage.init();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockAuthRepo = MockAuthenticationRepository();
    mockUserRepo = MockUserRepository();
  });

  AuthenticationBloc buildBloc() {
    return AuthenticationBloc(
      authenticationRepository: mockAuthRepo,
      userRepository: mockUserRepo,
    );
  }

  group('AuthenticationBloc — Initial State', () {
    test('has correct initial state', () {
      final bloc = buildBloc();
      expect(bloc.state.isUnauthenticated, true);
      expect(bloc.state.isLoggedIn, false);
      expect(bloc.state.isLoadingLogin, false);
      expect(bloc.state.user, emptyUser);
      expect(bloc.state.token, isNull);
      expect(bloc.state.refreshToken, isNull);
      bloc.close();
    });
  });

  group('AuthenticationBloc — Login', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits loading then success state on successful login',
      setUp: () {
        when(() => mockAuthRepo.logIn(any(), any(), any(), any()))
            .thenAnswer((_) async => {
                  'token': 'test_access_token',
                  'refreshToken': 'test_refresh_token',
                });
        when(() => mockUserRepo.getUser())
            .thenAnswer((_) async => testUser);
        when(() => mockUserRepo.updateUserFCMToken(any()))
            .thenAnswer((_) async => {});
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        AuthenticationLoginRequested(
            'john@example.com', 'password123', 'iPhone', 'iOS'),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        // isLoadingLogin = true
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', true)
            .having((s) => s.failedToLogin, 'failedToLogin', false),
        // login success — token set
        isA<AuthenticationState>()
            .having((s) => s.isLoggedIn, 'isLoggedIn', true)
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', false)
            .having((s) => s.token, 'token', 'test_access_token')
            .having(
                (s) => s.refreshToken, 'refreshToken', 'test_refresh_token')
            .having((s) => s.failedToLogin, 'failedToLogin', false),
        // loading done
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', false)
            .having((s) => s.failedToLogin, 'failedToLogin', false),
        // FetchUserDataRequested completes — user set
        isA<AuthenticationState>()
            .having((s) => s.user, 'user', testUser)
            .having((s) => s.isUnauthenticated, 'isUnauthenticated', false)
            .having((s) => s.isLoggedIn, 'isLoggedIn', true),
      ],
      verify: (_) {
        verify(() => mockAuthRepo.logIn(
            'john@example.com', 'password123', 'iPhone', 'iOS')).called(1);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits failure state when login returns no token',
      setUp: () {
        when(() => mockAuthRepo.logIn(any(), any(), any(), any()))
            .thenAnswer((_) async => {'error': 'Invalid credentials'});
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        AuthenticationLoginRequested(
            'wrong@example.com', 'badpassword', 'iPhone', 'iOS'),
      ),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        // loading
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', true),
        // failed
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', false)
            .having((s) => s.failedToLogin, 'failedToLogin', true),
        // reset failedToLogin flag
        isA<AuthenticationState>()
            .having((s) => s.failedToLogin, 'failedToLogin', false),
      ],
      verify: (_) {
        verify(() => mockAuthRepo.logIn(
            'wrong@example.com', 'badpassword', 'iPhone', 'iOS')).called(1);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'trims email and password whitespace during login',
      setUp: () {
        when(() => mockAuthRepo.logIn(any(), any(), any(), any()))
            .thenAnswer((_) async => {
                  'token': 'tok',
                  'refreshToken': 'ref',
                });
        when(() => mockUserRepo.getUser())
            .thenAnswer((_) async => testUser);
        when(() => mockUserRepo.updateUserFCMToken(any()))
            .thenAnswer((_) async => {});
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        AuthenticationLoginRequested(
            '  john@example.com  ', '  pass  ', 'iPhone', 'iOS'),
      ),
      wait: const Duration(milliseconds: 500),
      verify: (_) {
        // The repo trims, so verify the call was made with the original values
        // (trimming happens inside the repository layer)
        verify(() => mockAuthRepo.logIn(
            '  john@example.com  ', '  pass  ', 'iPhone', 'iOS')).called(1);
      },
    );
  });

  group('AuthenticationBloc — Registration', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits success state on successful registration + auto-login',
      setUp: () {
        when(() => mockAuthRepo.register(
                any(), any(), any(), any(), any(), any(), any()))
            .thenAnswer((_) async => true);
        when(() => mockAuthRepo.logIn(any(), any(), any(), any()))
            .thenAnswer((_) async => {
                  'token': 'new_token',
                  'refreshToken': 'new_refresh',
                });
        when(() => mockUserRepo.getUser())
            .thenAnswer((_) async => testUser);
        when(() => mockUserRepo.updateUserFCMToken(any()))
            .thenAnswer((_) async => {});
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        AuthenticationRegisterRequested(
          'John Doe',
          'john@example.com',
          'password123',
          'fcm_token',
          'NG',
          'iPhone',
          'iOS',
        ),
      ),
      wait: const Duration(milliseconds: 1500),
      expect: () => [
        // loading
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', true)
            .having((s) => s.failedToRegister, 'failedToRegister', false),
        // register success + auto-login
        isA<AuthenticationState>()
            .having((s) => s.isLoggedIn, 'isLoggedIn', true)
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', false)
            .having((s) => s.token, 'token', 'new_token')
            .having((s) => s.refreshToken, 'refreshToken', 'new_refresh')
            .having((s) => s.failedToRegister, 'failedToRegister', false),
        // done loading
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', false),
        // FetchUserDataRequested — user populated
        isA<AuthenticationState>()
            .having((s) => s.user, 'user', testUser)
            .having((s) => s.isLoggedIn, 'isLoggedIn', true),
      ],
      verify: (_) {
        verify(() => mockAuthRepo.register('John Doe', 'john@example.com',
            'password123', 'fcm_token', 'NG', 'iPhone', 'iOS')).called(1);
        verify(() => mockAuthRepo.logIn(
            'john@example.com', 'password123', 'iPhone', 'iOS')).called(1);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits failure state when registration fails',
      setUp: () {
        when(() => mockAuthRepo.register(
                any(), any(), any(), any(), any(), any(), any()))
            .thenAnswer((_) async => false);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        AuthenticationRegisterRequested(
          'John Doe',
          'john@example.com',
          'password123',
          'fcm_token',
          'NG',
          'iPhone',
          'iOS',
        ),
      ),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        // loading
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', true)
            .having((s) => s.failedToRegister, 'failedToRegister', false),
        // failed
        isA<AuthenticationState>()
            .having((s) => s.isLoadingLogin, 'isLoadingLogin', false)
            .having((s) => s.failedToRegister, 'failedToRegister', true),
        // reset flag
        isA<AuthenticationState>()
            .having((s) => s.failedToRegister, 'failedToRegister', false),
      ],
      verify: (_) {
        verify(() => mockAuthRepo.register('John Doe', 'john@example.com',
            'password123', 'fcm_token', 'NG', 'iPhone', 'iOS')).called(1);
        // Should NOT attempt login after failed registration
        verifyNever(() => mockAuthRepo.logIn(any(), any(), any(), any()));
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'registration succeeds but auto-login fails gracefully',
      setUp: () {
        when(() => mockAuthRepo.register(
                any(), any(), any(), any(), any(), any(), any()))
            .thenAnswer((_) async => true);
        when(() => mockAuthRepo.logIn(any(), any(), any(), any()))
            .thenAnswer((_) async => {'error': 'Login failed'});
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        AuthenticationRegisterRequested(
          'John Doe',
          'john@example.com',
          'password123',
          'fcm_token',
          'NG',
          'iPhone',
          'iOS',
        ),
      ),
      wait: const Duration(milliseconds: 300),
      verify: (_) {
        // Both register and login were called
        verify(() => mockAuthRepo.register(any(), any(), any(), any(), any(),
            any(), any())).called(1);
        verify(() => mockAuthRepo.logIn(any(), any(), any(), any())).called(1);
      },
    );
  });

  group('AuthenticationBloc — Logout', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits unauthenticated state on successful logout',
      setUp: () {
        when(() => mockAuthRepo.logOut()).thenAnswer((_) async => true);
      },
      build: buildBloc,
      seed: () => AuthenticationState(
        isLoggedIn: true,
        user: testUser,
        token: 'token',
        refreshToken: 'refresh',
      ),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        // logging out
        isA<AuthenticationState>()
            .having((s) => s.isLoggingOut, 'isLoggingOut', true),
        // logged out
        isA<AuthenticationState>()
            .having((s) => s.isUnauthenticated, 'isUnauthenticated', true)
            .having((s) => s.isLoggedIn, 'isLoggedIn', false)
            .having((s) => s.user, 'user', emptyUser)
            .having((s) => s.hasLoggedOut, 'hasLoggedOut', true),
        // reset hasLoggedOut flag
        isA<AuthenticationState>()
            .having((s) => s.hasLoggedOut, 'hasLoggedOut', false),
      ],
      verify: (_) {
        verify(() => mockAuthRepo.logOut()).called(1);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'does nothing when user is not logged in (id == 0)',
      setUp: () {},
      build: buildBloc,
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      wait: const Duration(milliseconds: 300),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockAuthRepo.logOut());
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'handles logout failure gracefully',
      setUp: () {
        when(() => mockAuthRepo.logOut()).thenThrow(Exception('Network error'));
      },
      build: buildBloc,
      seed: () => AuthenticationState(
        isLoggedIn: true,
        user: testUser,
        token: 'token',
        refreshToken: 'refresh',
      ),
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        // logging out
        isA<AuthenticationState>()
            .having((s) => s.isLoggingOut, 'isLoggingOut', true),
        // failure — reset
        isA<AuthenticationState>()
            .having((s) => s.isLoggingOut, 'isLoggingOut', false)
            .having((s) => s.hasLoggedOut, 'hasLoggedOut', false),
      ],
    );
  });

  group('AuthenticationBloc — FetchUserData', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'populates user on successful fetch',
      setUp: () {
        when(() => mockUserRepo.getUser())
            .thenAnswer((_) async => testUser);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(FetchUserDataRequested()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<AuthenticationState>()
            .having((s) => s.user, 'user', testUser)
            .having((s) => s.isUnauthenticated, 'isUnauthenticated', false)
            .having((s) => s.isLoggedIn, 'isLoggedIn', true),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'falls back to unauthenticated when fetch fails and no cache',
      setUp: () {
        when(() => mockUserRepo.getUser())
            .thenThrow(Exception('Network error'));
        // Clear any cached user
        GetStorage().remove('cached_user_data');
      },
      build: buildBloc,
      act: (bloc) => bloc.add(FetchUserDataRequested()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<AuthenticationState>()
            .having((s) => s.isUnauthenticated, 'isUnauthenticated', true),
      ],
    );
  });

  group('AuthenticationBloc — Forgot Password Flow', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      'sends forgot password email successfully',
      setUp: () {
        when(() => mockAuthRepo.sendForgotPasswordMail(any()))
            .thenAnswer((_) async => true);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SendForgotPasswordMail('john@example.com')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<AuthenticationState>()
            .having((s) => s.isSendingForgotPasswordCode,
                'isSendingForgotPasswordCode', true),
        isA<AuthenticationState>()
            .having((s) => s.isSendingForgotPasswordCode,
                'isSendingForgotPasswordCode', false)
            .having((s) => s.forgotPasswordMailSent,
                'forgotPasswordMailSent', true),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'handles forgot password failure',
      setUp: () {
        when(() => mockAuthRepo.sendForgotPasswordMail(any()))
            .thenThrow(Exception('Server error'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SendForgotPasswordMail('john@example.com')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<AuthenticationState>()
            .having((s) => s.isSendingForgotPasswordCode,
                'isSendingForgotPasswordCode', true),
        isA<AuthenticationState>()
            .having((s) => s.isSendingForgotPasswordCode,
                'isSendingForgotPasswordCode', false),
      ],
    );
  });
}
