import 'dart:async';
import 'package:bible_game_api/api/game_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:bible_game/shared/utils/offline_sync_queue.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final GameAPI _gameAPI;
  final OfflineSyncQueue _syncQueue;
  late final StreamSubscription<InternetConnectionStatus> _subscription;

  ConnectivityBloc({
    required GameAPI gameAPI,
    required OfflineSyncQueue syncQueue,
  })  : _gameAPI = gameAPI,
        _syncQueue = syncQueue,
        super(const ConnectivityState()) {
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<SyncOfflineData>(_onSyncOfflineData);
    on<SyncCompleted>(_onSyncCompleted);
    on<SyncFailed>(_onSyncFailed);

    // Subscribe to connectivity changes
    _subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      add(ConnectivityChanged(
        isOnline: status == InternetConnectionStatus.connected,
      ));
    });

    // Check initial connectivity and pending queue
    _initAsync();
  }

  Future<void> _initAsync() async {
    final isOnline = await InternetConnectionChecker().hasConnection;
    add(ConnectivityChanged(isOnline: isOnline));
  }

  Future<void> _onConnectivityChanged(
      ConnectivityChanged event, Emitter<ConnectivityState> emit) async {
    final wasOffline = !state.isOnline;
    final pendingCount = await _syncQueue.pendingCount;

    emit(state.copyWith(
      isOnline: event.isOnline,
      pendingSyncCount: pendingCount,
    ));

    // Auto-sync when transitioning from offline → online
    if (wasOffline && event.isOnline && pendingCount > 0) {
      add(SyncOfflineData());
    }
  }

  Future<void> _onSyncOfflineData(
      SyncOfflineData event, Emitter<ConnectivityState> emit) async {
    if (state.isSyncing) return;

    emit(state.copyWith(isSyncing: true));

    final entries = await _syncQueue.peekAll();
    for (final entry in entries) {
      try {
        await _gameAPI.sendGameData(
          entry['game_mode'],
          entry['total_score'],
          entry['base_score'],
          entry['bonus_score'],
          entry['average_time_spent'],
          entry['player_rank'],
          entry['number_of_correct_answers'],
          entry['player_id'],
          entry['user_progress'],
          entry['number_of_rounds'],
          entry['deviceName'],
          entry['deviceOs'],
        );
        await _syncQueue.dequeue();
      } catch (_) {
        // Stop on first failure — will retry on next connectivity change
        add(SyncFailed());
        return;
      }
    }

    add(SyncCompleted());
  }

  void _onSyncCompleted(
      SyncCompleted event, Emitter<ConnectivityState> emit) {
    emit(state.copyWith(
      isSyncing: false,
      pendingSyncCount: 0,
    ));
  }

  void _onSyncFailed(
      SyncFailed event, Emitter<ConnectivityState> emit) {
    emit(state.copyWith(isSyncing: false));
  }

  /// Convenience method for blocs to enqueue or submit a play log.
  /// Returns true if submitted directly, false if enqueued.
  Future<bool> submitOrEnqueue(Map<String, dynamic> playLog) async {
    if (state.isOnline) {
      try {
        await _gameAPI.sendGameData(
          playLog['game_mode'],
          playLog['total_score'],
          playLog['base_score'],
          playLog['bonus_score'],
          playLog['average_time_spent'],
          playLog['player_rank'],
          playLog['number_of_correct_answers'],
          playLog['player_id'],
          playLog['user_progress'],
          playLog['number_of_rounds'],
          playLog['deviceName'],
          playLog['deviceOs'],
        );
        return true;
      } catch (_) {
        // Network failed even though we thought we were online — enqueue
        await _syncQueue.enqueue(playLog);
        // Refresh pending count via event
        add(ConnectivityChanged(isOnline: state.isOnline));
        return false;
      }
    } else {
      await _syncQueue.enqueue(playLog);
      // Refresh pending count via event
      add(ConnectivityChanged(isOnline: state.isOnline));
      return false;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
