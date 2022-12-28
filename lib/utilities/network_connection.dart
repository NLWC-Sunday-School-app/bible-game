import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
        if (!isDeviceConnected) {
          Get.snackbar(
            'No internet connection',
            'Check your network',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM
          );
        }
      } else {
        // Get.snackbar(
        //     'No internet connection',
        //     'Check your network',
        //     backgroundColor: Colors.red,
        //     colorText: Colors.white,
        //     duration: const Duration(seconds: 3),
        //     snackPosition: SnackPosition.BOTTOM
        // );
      }
    });
  }

}
