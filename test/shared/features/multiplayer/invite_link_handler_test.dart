import 'dart:async';
import 'dart:io';

import 'package:bible_game/app.dart' show navigatorKey;
import 'package:bible_game/features/arcade/cubit/arcade_tab_cubit.dart';
import 'package:bible_game/features/multi_player/active_room_store.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/join_gameplay_modal.dart';
import 'package:bible_game/navigation/cubit/navigation_cubit.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/features/multiplayer/game_invite_watcher.dart';
import 'package:bible_game/shared/features/multiplayer/invite_link_handler.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockMultiplayerBloc extends MockBloc<MultiplayerEvent, MultiplayerState>
    implements MultiplayerBloc {}

class MockWebsocketCubit extends MockCubit<WebsocketState>
    implements WebsocketCubit {}

const _boxName = 'invite_link_handler_test';

const _me = User(
  id: 7,
  name: 'JohnO',
  email: 'john@example.com',
  profileUrl: '',
  rank: 'babe',
  highScore: 0,
  fourScripturesScore: 0,
  fourScriptsLevel: 1,
  coinWalletBalance: 0,
  fcmToken: '',
  country: 'Angola',
  streak: 0,
  gems: 0,
  isWalletInitialized: true,
  role: 'user',
);

void main() {
  late StreamController<Uri> links;
  late StreamController<AuthenticationState> authChanges;
  late MockAuthenticationBloc auth;
  late MockMultiplayerBloc multiplayer;
  late ActiveRoomStore store;
  late NavigationCubit navigation;
  late ArcadeTabCubit arcadeTab;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('invite_link_handler');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => dir.path,
    );
    await GetStorage.init(_boxName);
    registerFallbackValue(const CheckActiveRoom());
  });

  setUp(() async {
    final box = GetStorage(_boxName);
    await box.erase();
    store = ActiveRoomStore(box);
    links = StreamController<Uri>();
    authChanges = StreamController<AuthenticationState>.broadcast();
    auth = MockAuthenticationBloc();
    whenListen(auth, authChanges.stream,
        initialState: const AuthenticationState(user: _me));
    multiplayer = MockMultiplayerBloc();
    when(() => multiplayer.state).thenReturn(MultiplayerState.initial());
    navigation = NavigationCubit();
    arcadeTab = ArcadeTabCubit();
  });

  tearDown(() async {
    await links.close();
    await authChanges.close();
  });

  void signedIn(bool value) {
    final state = AuthenticationState(isLoggedIn: value, user: _me);
    when(() => auth.state).thenReturn(state);
    authChanges.add(state);
  }

  /// The app's navigator and route observer, with the splash screen as the
  /// first route -- home arrives only when [goHome] is pressed, as it does
  /// once the real splash screen has decided where to go.
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final websocket = MockWebsocketCubit();
    when(() => websocket.state).thenReturn(WebsocketState.initial());
    when(() => websocket.connect()).thenReturn(null);

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(value: auth),
        BlocProvider<MultiplayerBloc>.value(value: multiplayer),
        BlocProvider<WebsocketCubit>.value(value: websocket),
        BlocProvider<NavigationCubit>.value(value: navigation),
        BlocProvider<ArcadeTabCubit>.value(value: arcadeTab),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          navigatorKey: navigatorKey,
          navigatorObservers: [CurrentRouteObserver()],
          builder: (context, child) => InviteLinkHandler(
            links: links.stream,
            activeRoomStore: store,
            child: child!,
          ),
          routes: {
            '/': (context) => Scaffold(
                  body: TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.home, (route) => false),
                    child: const Text('splash'),
                  ),
                ),
            AppRoutes.home: (context) => Scaffold(
                  body: TextButton(
                    onPressed: () => Navigator.pushNamed(
                        context, 'lightning_question_screen'),
                    child: const Text('home'),
                  ),
                ),
            'lightning_question_screen': (context) => Scaffold(
                  body: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('question'),
                  ),
                ),
          },
        ),
      ),
    ));
    await tester.pump();
  }

  Future<void> goHome(WidgetTester tester) async {
    await tester.tap(find.text('splash'));
    await tester.pumpAndSettle();
  }

  Future<void> receive(WidgetTester tester, String link) async {
    links.add(Uri.parse(link));
    await tester.pump();
    await tester.pumpAndSettle();
  }

  /// Lets the banner the handler may have shown time out.
  Future<void> drainBanners(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  testWidgets('a link that launched the app waits for home, then joins',
      (tester) async {
    signedIn(true);
    await pumpApp(tester);

    await receive(tester, 'https://api.biblegame.nlwc.church/join/P0YB07RE');
    expect(find.byType(JoinGamePlayModal), findsNothing,
        reason: 'still on the splash screen');

    await goHome(tester);

    expect(find.byType(JoinGamePlayModal), findsOneWidget);
    verify(() => multiplayer.add(JoinRoom('P0YB07RE'))).called(1);
    expect(navigation.state, isNot(equals(NavigationCubit().state)),
        reason: 'moved to the arcade tab');
    expect(arcadeTab.state, ArcadeTab.multiplayer);
  });

  testWidgets('a signed-out player is sent to sign in, then joined',
      (tester) async {
    signedIn(false);
    await pumpApp(tester);
    await goHome(tester);

    await receive(tester, 'biblegame://join/P0YB07RE');
    expect(find.byType(JoinGamePlayModal), findsNothing);
    expect(find.text('Sign in to join game P0YB07RE'), findsOneWidget);
    expect(arcadeTab.state, ArcadeTab.multiplayer);
    await drainBanners(tester);

    signedIn(true);
    await tester.pumpAndSettle();

    expect(find.byType(JoinGamePlayModal), findsOneWidget);
    verify(() => multiplayer.add(JoinRoom('P0YB07RE'))).called(1);
  });

  testWidgets('a link during a game waits until the game screen is left',
      (tester) async {
    signedIn(true);
    await pumpApp(tester);
    await goHome(tester);
    await tester.tap(find.text('home'));
    await tester.pumpAndSettle();

    await receive(tester, 'https://api.biblegame.nlwc.church/join/P0YB07RE');
    expect(find.byType(JoinGamePlayModal), findsNothing);
    expect(find.text('question'), findsOneWidget);

    await tester.tap(find.text('question'));
    await tester.pumpAndSettle();

    expect(find.byType(JoinGamePlayModal), findsOneWidget);
  });

  testWidgets("a link to the player's own game resumes it instead of joining",
      (tester) async {
    signedIn(true);
    await store.save(
        roomId: 'room-1', inviteCode: 'P0YB07RE', userId: '7', playerId: 'p');
    await pumpApp(tester);
    await goHome(tester);

    await receive(tester, 'https://api.biblegame.nlwc.church/join/p0yb07re');

    expect(find.byType(JoinGamePlayModal), findsNothing);
    verify(() => multiplayer.add(const ResumeActiveRoom())).called(1);
    verifyNever(() => multiplayer.add(any(that: isA<JoinRoom>())));
  });

  testWidgets('the same link twice in quick succession joins once',
      (tester) async {
    signedIn(true);
    await pumpApp(tester);
    await goHome(tester);

    await receive(tester, 'https://api.biblegame.nlwc.church/join/P0YB07RE');
    await receive(tester, 'https://api.biblegame.nlwc.church/join/P0YB07RE');

    verify(() => multiplayer.add(JoinRoom('P0YB07RE'))).called(1);
    expect(find.byType(JoinGamePlayModal), findsOneWidget);
  });

  testWidgets('links that are not invites are left alone', (tester) async {
    signedIn(true);
    await pumpApp(tester);
    await goHome(tester);

    await receive(tester, 'https://api.biblegame.nlwc.church/catalog');
    await receive(tester, 'https://example.com/join/P0YB07RE');

    expect(find.byType(JoinGamePlayModal), findsNothing);
    verifyNever(() => multiplayer.add(any()));
    expect(find.text('home'), findsOneWidget);
  });
}
