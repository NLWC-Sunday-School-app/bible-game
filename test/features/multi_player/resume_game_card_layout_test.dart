import 'dart:io';

import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/resumable_room.dart';
import 'package:bible_game/features/multi_player/view/home_screen.dart';
import 'package:bible_game/features/multi_player/widget/resume_game_card.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMultiplayerBloc extends MockBloc<MultiplayerEvent, MultiplayerState>
    implements MultiplayerBloc {}

final _room = ResumableRoom(
  details: RoomDetailsModel.fromJson({
    'id': 'room-1',
    'inviteCode': 'ABC123',
    'hostId': '1',
    'status': 'WAITING',
    'victoryCondition': {
      'type': 'LIGHTNING',
      'value': 15,
      'questionType': 'WHO_IS_WHO',
    },
    'players': [
      {'playerId': 'p-host', 'playerName': 'Tobi1'},
      {'playerId': 'p-guest', 'playerName': 'tobilove'},
    ],
  }),
  isHost: true,
  myPlayerId: 'p-host',
);

void main() {
  setUpAll(() async {
    final loader = FontLoader('Mikado');
    for (final f in ['MikadoBlack', 'MikadoBold', 'MikadoRegular']) {
      final bytes = File('assets/fonts/mikado/$f.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  });

  setUpAll(() => registerFallbackValue(const CheckActiveRoom()));

  Future<MockMultiplayerBloc> pumpTab(
      WidgetTester tester, MultiplayerState state) async {
    // A short Android phone: 360x640 with a 24dp status bar and a 48dp
    // navigation bar -- the tightest screen the Multiplayer tab has to fit.
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    const usableHeight = 640.0 - 24 - 48;

    final bloc = MockMultiplayerBloc();
    when(() => bloc.state).thenReturn(state);

    await tester.pumpWidget(BlocProvider<MultiplayerBloc>.value(
      value: bloc,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          theme: ThemeData(fontFamily: 'Mikado'),
          home: Scaffold(
            body: Builder(
              // The height the arcade screen gives this tab.
              builder: (context) => SizedBox(
                height: usableHeight - (70.h + 20.h + 72.h + 120.h),
                child: MultiplayerHomeBody(bottomSpacing: 20.h),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    return bloc;
  }

  testWidgets('the tab still fits a short phone with the resume card showing',
      (tester) async {
    await pumpTab(
        tester, MultiplayerState.initial().copyWith(resumableRoom: _room));

    expect(tester.takeException(), isNull);
    expect(find.byType(ResumeGameCard), findsOneWidget);
    expect(find.text('Resume your game'), findsOneWidget);
    expect(find.textContaining('Code ABC123'), findsOneWidget);
    // Everything is reachable: the request card at the bottom can be
    // scrolled to even when the column is taller than the slot.
    await tester.scrollUntilVisible(find.text('Game Requests'), 50);
    expect(find.text('Game Requests'), findsOneWidget);
  });

  testWidgets('no card without a saved room', (tester) async {
    await pumpTab(tester, MultiplayerState.initial());

    expect(tester.takeException(), isNull);
    expect(find.byType(ResumeGameCard), findsNothing);
  });

  testWidgets('opening the tab checks for a saved room', (tester) async {
    final bloc = await pumpTab(tester, MultiplayerState.initial());

    verify(() => bloc.add(const CheckActiveRoom())).called(1);
  });

  testWidgets('leaving from the card asks first', (tester) async {
    final bloc = await pumpTab(
        tester, MultiplayerState.initial().copyWith(resumableRoom: _room));

    await tester.tap(find.byTooltip('Leave this game'));
    await tester.pumpAndSettle();
    expect(find.text('Leave this game?'), findsOneWidget);

    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const DiscardActiveRoom()));

    await tester.tap(find.byTooltip('Leave this game'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    verify(() => bloc.add(const DiscardActiveRoom())).called(1);
  });
}
