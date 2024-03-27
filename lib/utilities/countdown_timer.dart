import 'dart:async';
import 'package:flutter/material.dart';

class CountdownManager {
  static void startCountdown({
    required DateTime targetDate,
    required Function(Duration) onUpdate,
    required VoidCallback onFinish,
  }) {
    Duration remainingTime = targetDate.difference(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingTime = targetDate.difference(DateTime.now());
      onUpdate(remainingTime);

      if (remainingTime <= Duration.zero) {
        timer.cancel();
        onFinish();
      }
    });
  }
}
