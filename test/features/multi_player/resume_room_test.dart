import 'dart:io';

import 'package:bible_game/features/multi_player/active_room_store.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/repository/multiplayer_repository.dart';
import 'package:bible_game/features/multi_player/resumable_room.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockMultiplayerRepository extends Mock implements MultiplayerRepository {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

const _boxName = 'resume_room_test';

const _host = User(
  id: 1,
  name: 'Tobi1',
  email: 'tobi@example.com',
  profileUrl: '',
  rank: 'babe',
  highScore: 0,
  fourScripturesScore: 0,
  fourScriptsLevel: 1,
  coinWalletBalance: 0,
  fcmToken: '',
  country: 'NG',
  streak: 0,
  gems: 0,
  isWalletInitialized: true,
  role: 'user',
);

const _guest = User(
  id: 2,
  name: 'tobilove',
  email: 'love@example.com',
  profileUrl: '',
  rank: 'babe',
  highScore: 0,
  fourScripturesScore: 0,
  fourScriptsLevel: 1,
  coinWalletBalance: 0,
  fcmToken: '',
  country: 'NG',
  streak: 0,
  gems: 0,
  isWalletInitialized: true,
  role: 'user',
);

RoomDetailsModel _details({
  String status = 'WAITING',
  String hostId = '1',
  List<Map<String, String>> players = const [
    {'playerId': 'p-host', 'playerName': 'Tobi1'},
    {'playerId': 'p-guest', 'playerName': 'tobilove'},
  ],
}) {
  return RoomDetailsModel.fromJson({
    'id': 'room-1',
    'inviteCode': 'ABC123',
    'hostId': hostId,
    'gameMode': 'MULTIPLAYER_GROUP',
    'status': status,
    'victoryCondition': {
      'type': 'LIGHTNING',
      'value': 15,
      'questionType': 'WHO_IS_WHO',
    },
    'secondsPerQuestion': 8,
    'totalQuestions': 0,
    'players': players,
  });
}

void main() {
  late GetStorage box;
  late ActiveRoomStore store;
  late MockMultiplayerRepository repository;
  late MockAuthenticationBloc auth;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('resume_room_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => dir.path,
    );
    await GetStorage.init(_boxName);
  });

  setUp(() async {
    box = GetStorage(_boxName);
    await box.erase();
    store = ActiveRoomStore(box);
    repository = MockMultiplayerRepository();
    auth = MockAuthenticationBloc();
    // Logged out as far as the bloc's session hooks go, so it does not start
    // invite polling; the user is still read for ids and names.
    whenListen(auth, const Stream<AuthenticationState>.empty(),
        initialState: const AuthenticationState(user: _host));
  });

  MultiplayerBloc buildBloc() => MultiplayerBloc(
        multiplayerRepository: repository,
        authenticationBloc: auth,
        activeRoomStore: store,
      );

  void signInAs(User user) {
    whenListen(auth, const Stream<AuthenticationState>.empty(),
        initialState: AuthenticationState(user: user));
  }

  group('ActiveRoomStore', () {
    test('returns the saved room to the user who saved it', () async {
      await store.save(
          roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p');
      final room = store.read('1');
      expect(room?.roomId, 'room-1');
      expect(room?.inviteCode, 'ABC123');
      expect(room?.playerId, 'p');
    });

    test('does not offer one account the room saved by another', () async {
      await store.save(roomId: 'room-1', inviteCode: 'ABC123', userId: '1');
      expect(store.read('2'), isNull);
    });

    test('drops a room saved longer ago than maxAge', () async {
      await box.write('active_multiplayer_room', {
        'roomId': 'room-1',
        'inviteCode': 'ABC123',
        'userId': '1',
        'savedAt': DateTime.now()
            .subtract(ActiveRoomStore.maxAge + const Duration(minutes: 1))
            .toIso8601String(),
      });
      expect(store.read('1'), isNull);
      expect(box.read('active_multiplayer_room'), isNull);
    });

    test('a clear for an older room leaves the newer one alone', () async {
      await store.save(roomId: 'room-2', inviteCode: 'XYZ789', userId: '1');
      await store.clear('room-1');
      expect(store.read('1')?.roomId, 'room-2');
    });

    test('records a player id only against the room it belongs to', () async {
      await store.save(roomId: 'room-1', inviteCode: 'ABC123', userId: '1');
      await store.rememberPlayerId('room-other', 'p-x');
      expect(store.read('1')?.playerId, isNull);
      await store.rememberPlayerId('room-1', 'p-guest');
      expect(store.read('1')?.playerId, 'p-guest');
    });
  });

  group('saving the room', () {
    blocTest<MultiplayerBloc, MultiplayerState>(
      'a configured room is saved with the host player from the create response',
      setUp: () {
        when(() => repository.createGameRoom(any())).thenAnswer((_) async =>
            CreateGameRoomModel.fromJson({
              'id': 'room-1',
              'inviteCode': 'ABC123',
              'hostId': '1',
              'activePlayers': ['p-host'],
            }));
        when(() => repository.configureGameRoom(
                any(), any(), any(), any(), any(), any(), any()))
            .thenAnswer((_) async => true);
        when(() => repository.getRoomDetails(any()))
            .thenAnswer((_) async => _details());
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(CreateGameRoom());
        await Future<void>.delayed(Duration.zero);
        bloc.add(ConfigureGameRoom(
            'LIGHTNING', 'WHO_IS_WHO', 15, 'BEST_OF_ROUNDS'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        final saved = store.read('1');
        expect(saved?.roomId, 'room-1');
        expect(saved?.inviteCode, 'ABC123');
        expect(saved?.playerId, 'p-host');
        // And the Multiplayer tab is told about it straight away.
        expect(bloc.state.resumableRoom?.isHost, isTrue);
        expect(bloc.state.resumableRoom?.myPlayerId, 'p-host');
      },
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'a room joined by code is saved, and leaving forgets it',
      setUp: () {
        signInAs(_guest);
        when(() => repository.joinRoom(any(), any())).thenAnswer((_) async =>
            CreateGameRoomModel.fromJson(
                {'id': 'room-1', 'inviteCode': 'ABC123', 'hostId': '1'}));
        when(() => repository.getRoomDetails(any()))
            .thenAnswer((_) async => _details());
        when(() => repository.leaveRoom(any(), any()))
            .thenAnswer((_) async => true);
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(JoinRoom('ABC123'));
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(store.read('2')?.roomId, 'room-1');
        bloc.add(LeaveRoom('p-guest'));
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(store.read('2'), isNull);
        expect(bloc.state.resumableRoom, isNull);
      },
    );
  });

  group('checking for a room to resume', () {
    blocTest<MultiplayerBloc, MultiplayerState>(
      'finds a guest by name when their player id was never recorded',
      setUp: () async {
        signInAs(_guest);
        await store.save(roomId: 'room-1', inviteCode: 'ABC123', userId: '2');
        when(() => repository.getRoomDetails('room-1'))
            .thenAnswer((_) async => _details());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        final room = bloc.state.resumableRoom!;
        expect(room.isHost, isFalse);
        expect(room.myPlayerId, 'p-guest');
        expect(store.read('2')?.playerId, 'p-guest');
      },
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'forgets a room the server no longer has',
      setUp: () async {
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p-host');
        when(() => repository.getRoomDetails('room-1')).thenThrow(
            "ApiException: 404 - {message: Oops! That room couldn't be found.}");
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.resumableRoom, isNull);
        expect(store.read('1'), isNull);
      },
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'keeps the saved room through a network failure',
      setUp: () async {
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p-host');
        when(() => repository.getRoomDetails('room-1'))
            .thenThrow('Connection timed out');
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (_) => expect(store.read('1')?.roomId, 'room-1'),
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'forgets a finished room this player was removed from',
      setUp: () async {
        signInAs(_guest);
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '2', playerId: 'p-guest');
        when(() => repository.getRoomDetails('room-1')).thenAnswer((_) async =>
            _details(status: 'FINISHED', players: const [
              {'playerId': 'p-host', 'playerName': 'Tobi1'},
            ]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const CheckActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.resumableRoom, isNull);
        expect(store.read('2'), isNull);
      },
    );
  });

  group('resuming', () {
    blocTest<MultiplayerBloc, MultiplayerState>(
      'a host goes back into their waiting room under the same code',
      setUp: () async {
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p-host');
        when(() => repository.getRoomDetails('room-1'))
            .thenAnswer((_) async => _details());
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ResumeActiveRoom()),
      wait: const Duration(milliseconds: 20),
      expect: () => [
        isA<MultiplayerState>().having((s) => s.isResumingRoom, 'resuming', true),
        isA<MultiplayerState>()
            .having((s) => s.hasResumedRoom, 'resumed', true)
            .having((s) => s.createGameRoomResponse.id, 'room', 'room-1')
            .having((s) => s.createGameRoomResponse.inviteCode, 'code', 'ABC123')
            .having((s) => s.createGameRoomResponse.hostId, 'host', '1')
            .having((s) => s.createGameRoomResponse.activePlayers.first,
                'host player first', 'p-host')
            .having((s) => s.createGameRoomResponse.victoryCondition?.type,
                'mode', 'LIGHTNING'),
        isA<MultiplayerState>().having((s) => s.hasResumedRoom, 'pulse', false),
      ],
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'a finished room is restarted for its host rather than replaced',
      setUp: () async {
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p-host');
        var restarted = false;
        when(() => repository.restartGame('room-1', 1)).thenAnswer((_) async {
          restarted = true;
          return true;
        });
        when(() => repository.getRoomDetails('room-1')).thenAnswer((_) async =>
            _details(status: restarted ? 'WAITING' : 'FINISHED'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ResumeActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        verify(() => repository.restartGame('room-1', 1)).called(1);
        verifyNever(() => repository.createGameRoom(any()));
        expect(bloc.state.resumableRoom?.details.isWaiting, isTrue);
        expect(bloc.state.createGameRoomResponse.inviteCode, 'ABC123');
      },
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'a round in progress cannot be joined halfway through',
      setUp: () async {
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p-host');
        when(() => repository.getRoomDetails('room-1'))
            .thenAnswer((_) async => _details(status: 'ACTIVE'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ResumeActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.hasResumedRoom, isFalse);
        expect(bloc.state.resumeError, contains('still being played'));
        // Still there to try again once the round ends.
        expect(store.read('1')?.roomId, 'room-1');
      },
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'a player no longer in an open room comes back in by its code',
      setUp: () async {
        signInAs(_guest);
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '2', playerId: 'p-old');
        var joined = false;
        when(() => repository.joinRoom('ABC123', 2)).thenAnswer((_) async {
          joined = true;
          return CreateGameRoomModel.fromJson(
              {'id': 'room-1', 'inviteCode': 'ABC123', 'hostId': '1'});
        });
        when(() => repository.getRoomDetails('room-1')).thenAnswer((_) async =>
            joined
                ? _details(players: const [
                    {'playerId': 'p-host', 'playerName': 'Tobi1'},
                    {'playerId': 'p-new', 'playerName': 'tobilove'},
                  ])
                : _details(players: const [
                    {'playerId': 'p-host', 'playerName': 'Tobi1'},
                  ]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ResumeActiveRoom()),
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        verify(() => repository.joinRoom('ABC123', 2)).called(1);
        expect(bloc.state.resumableRoom?.myPlayerId, 'p-new');
        expect(store.read('2')?.playerId, 'p-new');
      },
    );

    blocTest<MultiplayerBloc, MultiplayerState>(
      'leaving from the card removes our player and forgets the room',
      setUp: () async {
        await store.save(
            roomId: 'room-1', inviteCode: 'ABC123', userId: '1', playerId: 'p-host');
        when(() => repository.getRoomDetails('room-1'))
            .thenAnswer((_) async => _details());
        when(() => repository.leaveRoom(any(), any()))
            .thenAnswer((_) async => true);
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const CheckActiveRoom());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        bloc.add(const DiscardActiveRoom());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        verify(() => repository.leaveRoom('room-1', 'p-host')).called(1);
        expect(bloc.state.resumableRoom, isNull);
        expect(store.read('1'), isNull);
      },
    );
  });

  group('ResumableRoom', () {
    test('rebuilds the waiting room roster with our own row recognisable', () {
      final room = ResumableRoom(
          details: _details(), isHost: true, myPlayerId: 'p-host');
      final waiting = room.toWaitingRoom('1');

      expect(waiting.roomId, 'room-1');
      expect(waiting.players.map((p) => p.username), ['Tobi1', 'tobilove']);
      final me = waiting.players.firstWhere((p) => p.id == 'p-host');
      expect(me.userId, '1');
      expect(me.isHost, isTrue);
      expect(waiting.players.firstWhere((p) => p.id == 'p-guest').userId, isNull);
      expect(waiting.totalQuestions, '15');
      expect(waiting.gameMode, 'Who Is Who');
      expect(room.modeLabel, 'Lightning Mode');
    });
  });
}
