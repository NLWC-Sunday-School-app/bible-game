part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

/// Fired by the InternetConnectionChecker stream listener.
class ConnectivityChanged extends ConnectivityEvent {
  final bool isOnline;

  const ConnectivityChanged({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}

/// Triggered on reconnection or manual retry to drain the sync queue.
class SyncOfflineData extends ConnectivityEvent {}

/// Fired after all queued items have been successfully submitted.
class SyncCompleted extends ConnectivityEvent {}

/// Fired when a sync attempt fails (will retry on next reconnection).
class SyncFailed extends ConnectivityEvent {}
