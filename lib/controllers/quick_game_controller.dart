import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../widgets/quick_game_modal.dart';

class QuickGameController extends GetxController {

  var normalIsActive = true.obs;
  var intermediateIsActive = false.obs;
  var hardIsActive = false.obs;
  var durationPerQuestion = 20;
  var modalTitle = 'Preparing your questions...'.obs;
  var gameIsReady = false.obs;

  void selectNormalLevel() {
    normalIsActive(true);
    intermediateIsActive(false);
    hardIsActive(false);
    durationPerQuestion = 20;
  }

  void selectIntermediateLevel() {
    normalIsActive(false);
    intermediateIsActive(true);
    hardIsActive(false);
    durationPerQuestion = 10;
  }

  void selectHardLevel() {
    normalIsActive(false);
    intermediateIsActive(false);
    hardIsActive(true);
    durationPerQuestion = 5;
  }

  prepareQuestions() {
    Timer(const Duration(seconds: 3), () {
      modalTitle.value = 'All set to go 🥳😃';
      gameIsReady(true);
    });
  }

  startGame() {
    showDialogModal();
    prepareQuestions();
  }

  showDialogModal() {
    Get.dialog(const QuickGameModal(),
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(30, 30, 30, 0.9));
  }

}
