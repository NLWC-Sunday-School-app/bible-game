/// Stub file for web builds — InternetConnectionChecker is not used on web,
/// but its types are referenced in connectivity_bloc.dart's conditional import.
/// On web, the kIsWeb guard prevents any of these from being called.

enum InternetConnectionStatus { connected, disconnected }

class InternetConnectionChecker {
  Stream<InternetConnectionStatus> get onStatusChange =>
      Stream.value(InternetConnectionStatus.connected);

  Future<bool> get hasConnection async => true;

  factory InternetConnectionChecker() => InternetConnectionChecker._();
  InternetConnectionChecker._();
}
