
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
      }
    });
    return isDeviceConnected;
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result =  await (Connectivity().checkConnectivity());
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }
  }


  Future<bool> hasInternetConnection() async{
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }
}