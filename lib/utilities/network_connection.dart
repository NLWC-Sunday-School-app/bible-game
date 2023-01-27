import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../widgets/modals/network_modal.dart';

class NetworkConnection extends GetxController {
  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  var isDeviceConnected = false;

  Future<void> onConnectivityChanged() async {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        print(isDeviceConnected);
        if (!isDeviceConnected) {
          Get.dialog(const NoNetworkModal(), barrierDismissible: false);
        }
      } else {
        //Get.dialog(const NoNetworkModal(), barrierDismissible: false);
      }
    });
  }

 Future<bool> hasInternetConnection() async{
    bool result = await InternetConnectionChecker().hasConnection;
     return result;
  }

}
