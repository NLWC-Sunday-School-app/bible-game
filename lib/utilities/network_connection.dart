import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../widgets/modals/network_modal.dart';

class NetworkConnection extends GetxController {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  var isDeviceConnected = false;

  Future<void> onConnectivityChanged() async {
    connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      print(connectivityResult);
      print(result);
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected) {
          Get.dialog(const NoNetworkModal(), barrierDismissible: false);
        }
      } else {
       // Get.dialog(const NoNetworkModal(), barrierDismissible: false);
      }
    });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }
  }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   setState(() {
  //     _connectionStatus = result;
  //   });
  // }

 Future<bool> hasInternetConnection() async{
    bool result = await InternetConnectionChecker().hasConnection;
     return result;
  }

}
