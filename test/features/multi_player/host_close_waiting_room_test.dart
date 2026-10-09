import 'dart:io';

import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bloc_test/bloc_test.dart';
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
    final loader = FontLoader('Mikado');
    for (final f in ['MikadoBlack', 'MikadoBold', 'MikadoRegular']) {
      final bytes = File('assets/fonts/mikado/$f.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
    registerFallbackValue(const CheckActiveRoom());
  });

  late MockWebsocketCubit websocket;
  late MockMultiplayerBloc multiplayer;

  /// Home, then the mode picker, then the host's waiting room on top -- the
  /// stack a host has right after creating a game.
  Future<void> openHostWaitingRoom(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    websocket = MockWebsocketCubit();
    when(() => websocket.state).thenReturn(WebsocketState.initial());
    when(() => websocket.clearCurrentRoom()).thenReturn(null);

    multiplayer = MockMultiplayerBloc();
    when(() => multiplayer.state).thenReturn(MultiplayerState.initial()
        .copyWith(
            createGameRoomResponse: CreateGameRoomModel.fromJson({
      'id': 'room-1',
      'inviteCode': 'WACUJXDT',
      'hostId': '1',
      'activePlayers': ['p-host'],
    })));
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
          routes: {
            AppRoutes.groupGameCategory: (context) => Scaffold(
                  body: TextButton(
                    onPressed: () => showHostWaitingModal(context,
                        selectedGroupGame: 'Lightning Mode',
                        inviteCode: 'WACUJXDT',
                        questionType: 'Who is Who',
                        noOfQuestion: 10),
                    child: const Text('open lobby'),
                  ),
                ),
          },
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.groupGameCategory),
              child: const Text('multiplayer tab'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('multiplayer tab'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open lobby'));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        final image = element.widget as Image;
        await precacheImage(image.image, element);
      }
    });
    await tester.pumpAndSettle();
    expect(find.byType(PlayersWaitingModal), findsOneWidget);
  }

  Finder closeIcon() => find.byWidgetPredicate((w) =>
      w is Image &&
      w.image is AssetImage &&
      (w.image as AssetImage).assetName == IconImageRoutes.redCircleClose);

  testWidgets('closing asks before doing anything to the game', (tester) async {
    await openHostWaitingRoom(tester);

    await tester.tap(closeIcon());
    await tester.pumpAndSettle();

    expect(find.text('Leave the waiting room?'), findsOneWidget);
    expect(find.textContaining('WACUJXDT'), findsWidgets);
    verifyNever(() => multiplayer.add(any(that: isA<LeaveRoom>())));
  });

  testWidgets('keeping it open leaves the room alone and returns to the tab',
      (tester) async {
    await openHostWaitingRoom(tester);

    await tester.tap(closeIcon());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it open'));
    await tester.pumpAndSettle();

    verifyNever(() => multiplayer.add(any(that: isA<LeaveRoom>())));
    verifyNever(() => multiplayer.add(any(that: isA<CreateGameRoom>())));
    verify(() => multiplayer.add(const CheckActiveRoom())).called(1);
    verify(() => websocket.clearCurrentRoom()).called(1);
    // Past the mode picker, back on the tab where the resume card is.
    expect(find.byType(PlayersWaitingModal), findsNothing);
    expect(find.text('open lobby'), findsNothing);
    expect(find.text('multiplayer tab'), findsOneWidget);
  });

  testWidgets('ending the game still leaves the room as before',
      (tester) async {
    await openHostWaitingRoom(tester);

    await tester.tap(closeIcon());
    await tester.pumpAndSettle();
    await tester.tap(find.text('End game'));
    await tester.pumpAndSettle();

    verify(() => multiplayer.add(LeaveRoom('p-host'))).called(1);
    verify(() => multiplayer.add(any(that: isA<CreateGameRoom>()))).called(1);
    expect(find.byType(PlayersWaitingModal), findsNothing);
    expect(find.text('open lobby'), findsOneWidget);
  });

  testWidgets('dismissing the question keeps the host in the waiting room',
      (tester) async {
    await openHostWaitingRoom(tester);

    await tester.tap(closeIcon());
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(PlayersWaitingModal), findsOneWidget);
    verifyNever(() => multiplayer.add(any(that: isA<LeaveRoom>())));
  });
}
