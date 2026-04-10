
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnection {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  var isDeviceConnected = false;

  Future<bool> onConnectivityChanged() async {
    connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (result != connectivityResult.contains(ConnectivityResult.none)) {
        isDeviceConnected = !connectivityResult.contains(ConnectivityResult.none);
      }
    });
    return isDeviceConnected;
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await (Connectivity().checkConnectivity());
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status');
      return;
    }
  }

  Future<bool> hasInternetConnection() async {
    // On web, use connectivity_plus (checks navigator.onLine)
    final results = await Connectivity().checkConnectivity();
    if (kIsWeb) {
      return !results.contains(ConnectivityResult.none);
    }
    // On mobile, do a more thorough check
    try {
      // Dynamic import workaround: we rely on connectivity_plus result on mobile too
      // since InternetConnectionChecker is handled by ConnectivityBloc now
      return !results.contains(ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}