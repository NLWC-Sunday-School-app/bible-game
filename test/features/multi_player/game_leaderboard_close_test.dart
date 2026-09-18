import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/view/game_leaderboard_screen.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game_api/model/game_finished_event.dart';
import 'package:bloc_test/bloc_test.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWebsocketCubit extends MockCubit<WebsocketState>
    implements WebsocketCubit {}

class MockMultiplayerBloc extends MockBloc<MultiplayerEvent, MultiplayerState>
    implements MultiplayerBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockLightningModeBloc
    extends MockBloc<LightningModeEvent, LightningModeState>
    implements LightningModeBloc {}

void main() {
  setUpAll(() async {
    // The test font draws every glyph as a full square, far wider than
    // Mikado, which pushes the header off the edge on its own. Load the real
    // face so the layout is the one the phone has.
    final loader = FontLoader('Mikado');
    for (final f in ['MikadoBlack', 'MikadoBold', 'MikadoRegular']) {
      final bytes = File('assets/fonts/mikado/$f.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  });

  testWidgets('a tap on the close icon itself leaves the leaderboard',
      (tester) async {
    // iPhone 15 Pro Max, the device it was reported on.
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final websocket = MockWebsocketCubit();
    final finished = GameFinishedEvent.fromJson({
      'type': 'GAME_FINISHED',
      'roomId': 'room',
      'data': {
        'winner': 'Tobi1',
        'finalScores': {'p1': 100, 'p2': 0},
        'message': 'Tobi1 wins the Lightning Round!',
        'leaderboard': [
          {'playerId': 'p1', 'userId': '1', 'username': 'Tobi1', 'score': 100, 'rank': 1},
          {'playerId': 'p2', 'userId': '2', 'username': 'tobilove', 'score': 0, 'rank': 2},
        ],
      },
    });
    when(() => websocket.state).thenReturn(
        WebsocketState.initial().copyWith(gameFinishedEvent: finished));
    when(() => websocket.clearCurrentRoom()).thenReturn(null);

    final multiplayer = MockMultiplayerBloc();
    when(() => multiplayer.state).thenReturn(MultiplayerState.initial());
    final auth = MockAuthenticationBloc();
    when(() => auth.state).thenReturn(const AuthenticationState());
    final lightning = MockLightningModeBloc();
    when(() => lightning.state).thenReturn(LightningModeState.initial());

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<WebsocketCubit>.value(value: websocket),
        BlocProvider<MultiplayerBloc>.value(value: multiplayer),
        BlocProvider<AuthenticationBloc>.value(value: auth),
        BlocProvider<LightningModeBloc>.value(value: lightning),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          theme: ThemeData(fontFamily: 'Mikado'),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const GameLeaderboardScreen(
                    selectedGroupGame: 'Lightning Mode'),
              )),
              child: const Text('home'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('home'));
    await tester.pumpAndSettle();
    // Asset images decode off the fake clock; until they do, the icon is
    // zero-high and nothing can be tapped.
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        final image = element.widget as Image;
        await precacheImage(image.image, element);
      }
    });
    await tester.pumpAndSettle();
    expect(find.byType(GameLeaderboardScreen), findsOneWidget);

    final icon = find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == IconImageRoutes.redCircleClose);
    expect(icon, findsOneWidget);
    final centre = tester.getCenter(icon);

    // What does a finger on the middle of the icon actually land on?
    final hits = tester.hitTestOnBinding(centre).path
        .map((e) => e.target.runtimeType.toString())
        .take(8)
        .toList();
    debugPrint('icon rect ${tester.getRect(icon)}; hits: $hits');

    await tester.tapAt(centre);
    await tester.pumpAndSettle();
    expect(find.byType(GameLeaderboardScreen), findsNothing);
  });
}
