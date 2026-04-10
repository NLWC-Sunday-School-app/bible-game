import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/utils/offline_sync_queue.dart';
import 'package:bible_game_api/api/game_api.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockGameAPI extends Mock implements GameAPI {}

class MockOfflineSyncQueue extends Mock implements OfflineSyncQueue {}

void main() {
  late MockGameAPI mockGameAPI;
  late MockOfflineSyncQueue mockSyncQueue;

  setUp(() {
    mockGameAPI = MockGameAPI();
    mockSyncQueue = MockOfflineSyncQueue();

    // Default stubs
    when(() => mockSyncQueue.pendingCount).thenAnswer((_) async => 0);
    when(() => mockSyncQueue.peekAll()).thenAnswer((_) async => []);
    when(() => mockSyncQueue.enqueue(any())).thenAnswer((_) async {});
    when(() => mockSyncQueue.dequeue()).thenAnswer((_) async {});
  });

  Map<String, dynamic> _makePlayLog({
    String gameMode = 'TRUE_OR_FALSE',
    int totalScore = 1000,
  }) {
    return {
      'game_mode': gameMode,
      'total_score': totalScore,
      'base_score': totalScore,
      'bonus_score': 0,
      'average_time_spent': 0,
      'player_rank': 'babe',
      'number_of_correct_answers': 10,
      'player_id': 1,
      'user_progress': null,
      'number_of_rounds': 20,
      'deviceName': 'TestDevice',
      'deviceOs': 'TestOS',
    };
  }

  group('ConnectivityState', () {
    test('initial state is online with no pending items', () {
      expect(
        const ConnectivityState(),
        const ConnectivityState(
          isOnline: true,
          pendingSyncCount: 0,
          isSyncing: false,
        ),
      );
    });

    test('supports value equality', () {
      expect(
        const ConnectivityState(isOnline: true, pendingSyncCount: 0),
        const ConnectivityState(isOnline: true, pendingSyncCount: 0),
      );
    });

    test('copyWith creates correct copy', () {
      const state = ConnectivityState(
        isOnline: true,
        pendingSyncCount: 5,
        isSyncing: false,
      );

      final updated = state.copyWith(isOnline: false, isSyncing: true);

      expect(updated.isOnline, false);
      expect(updated.pendingSyncCount, 5); // unchanged
      expect(updated.isSyncing, true);
    });

    test('props are correct', () {
      const state = ConnectivityState(
        isOnline: true,
        pendingSyncCount: 2,
        isSyncing: false,
      );

      expect(state.props, [true, 2, false]);
    });
  });

  group('ConnectivityBloc — ConnectivityChanged', () {
    test('emits offline state when connectivity changes to offline', () async {
      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      // Wait for initial async check to settle
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const ConnectivityChanged(isOnline: false));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.isOnline, false);

      await bloc.close();
    });

    test('emits online state when connectivity changes to online', () async {
      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      // Go offline first
      bloc.add(const ConnectivityChanged(isOnline: false));
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.state.isOnline, false);

      // Come back online
      bloc.add(const ConnectivityChanged(isOnline: true));
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.state.isOnline, true);

      await bloc.close();
    });

    test(
        'triggers SyncOfflineData when transitioning offline -> online with pending items',
        () async {
      when(() => mockSyncQueue.pendingCount).thenAnswer((_) async => 3);
      when(() => mockSyncQueue.peekAll()).thenAnswer((_) async => [
            _makePlayLog(gameMode: 'A'),
            _makePlayLog(gameMode: 'B'),
            _makePlayLog(gameMode: 'C'),
          ]);
      when(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenAnswer((_) async {});

      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      // Force offline
      bloc.add(const ConnectivityChanged(isOnline: false));
      await Future.delayed(const Duration(milliseconds: 100));

      // Come back online — should auto-sync
      bloc.add(const ConnectivityChanged(isOnline: true));
      await Future.delayed(const Duration(milliseconds: 500));

      // Verify sync was attempted
      verify(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).called(greaterThanOrEqualTo(1));

      await bloc.close();
    });
  });

  group('ConnectivityBloc — SyncOfflineData', () {
    test('drains queue and calls sendGameData for each entry', () async {
      when(() => mockSyncQueue.peekAll()).thenAnswer((_) async => [
            _makePlayLog(gameMode: 'QUICK_GAME'),
            _makePlayLog(gameMode: 'TRUE_OR_FALSE'),
          ]);
      when(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenAnswer((_) async {});

      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(SyncOfflineData());
      await Future.delayed(const Duration(milliseconds: 500));

      verify(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).called(2);
      verify(() => mockSyncQueue.dequeue()).called(2);

      await bloc.close();
    });

    test('stops syncing on first failure', () async {
      when(() => mockSyncQueue.peekAll()).thenAnswer((_) async => [
            _makePlayLog(gameMode: 'FIRST'),
            _makePlayLog(gameMode: 'SECOND'),
          ]);

      var callCount = 0;
      when(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenAnswer((_) async {
        callCount++;
        if (callCount >= 2) throw 'Network error';
      });

      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(SyncOfflineData());
      await Future.delayed(const Duration(milliseconds: 500));

      // Only first entry dequeued, second failed
      verify(() => mockSyncQueue.dequeue()).called(1);
      expect(bloc.state.isSyncing, false);

      await bloc.close();
    });

    test('does not start syncing if already syncing', () async {
      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      // Manually set syncing state by triggering a slow sync
      when(() => mockSyncQueue.peekAll()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return [_makePlayLog()];
      });

      bloc.add(SyncOfflineData());
      await Future.delayed(const Duration(milliseconds: 50));

      // Now try again while first sync is running
      bloc.add(SyncOfflineData());
      await Future.delayed(const Duration(milliseconds: 100));

      // peekAll should only have been called once (second sync skipped)
      verify(() => mockSyncQueue.peekAll()).called(1);

      await bloc.close();
    });
  });

  group('ConnectivityBloc — submitOrEnqueue', () {
    test('submits directly when online and API succeeds', () async {
      when(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenAnswer((_) async {});

      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      final result = await bloc.submitOrEnqueue(_makePlayLog());

      expect(result, true);
      verifyNever(() => mockSyncQueue.enqueue(any()));

      await bloc.close();
    });

    test('enqueues when online but API fails', () async {
      when(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          )).thenThrow('Network error');

      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      final playLog = _makePlayLog();
      final result = await bloc.submitOrEnqueue(playLog);

      expect(result, false);
      verify(() => mockSyncQueue.enqueue(playLog)).called(1);

      await bloc.close();
    });

    test('enqueues directly when offline', () async {
      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      // Go offline
      bloc.add(const ConnectivityChanged(isOnline: false));
      await Future.delayed(const Duration(milliseconds: 100));

      final playLog = _makePlayLog();
      final result = await bloc.submitOrEnqueue(playLog);

      expect(result, false);
      verify(() => mockSyncQueue.enqueue(playLog)).called(1);
      // Should NOT try the API when offline
      verifyNever(() => mockGameAPI.sendGameData(
            any(), any(), any(), any(), any(), any(),
            any(), any(), any(), any(), any(), any(),
          ));

      await bloc.close();
    });
  });

  group('ConnectivityBloc — SyncCompleted / SyncFailed', () {
    test('SyncCompleted resets isSyncing and pendingSyncCount', () async {
      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(SyncCompleted());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.isSyncing, false);
      expect(bloc.state.pendingSyncCount, 0);

      await bloc.close();
    });

    test('SyncFailed resets isSyncing', () async {
      final bloc = ConnectivityBloc(
        gameAPI: mockGameAPI,
        syncQueue: mockSyncQueue,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(SyncFailed());
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.state.isSyncing, false);

      await bloc.close();
    });
  });
}
