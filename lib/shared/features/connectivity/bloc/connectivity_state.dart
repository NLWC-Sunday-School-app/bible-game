part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  final bool isOnline;
  final int pendingSyncCount;
  final bool isSyncing;

  const ConnectivityState({
    this.isOnline = true,
    this.pendingSyncCount = 0,
    this.isSyncing = false,
  });

  ConnectivityState copyWith({
    bool? isOnline,
    int? pendingSyncCount,
    bool? isSyncing,
  }) {
    return ConnectivityState(
      isOnline: isOnline ?? this.isOnline,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  @override
  List<Object?> get props => [isOnline, pendingSyncCount, isSyncing];
}
