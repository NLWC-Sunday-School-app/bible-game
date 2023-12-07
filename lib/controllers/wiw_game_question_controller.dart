
import 'dart:async';

import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/controllers/wiw_game_controller.dart';
import 'package:bible_game/models/games.dart';
import 'package:bible_game/models/whoIsWho.dart';
import 'package:bible_game/widgets/modals/wiw_success_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../widgets/modals/wiw_timeup_modal.dart';
import 'auth_controller.dart';

class WiwGameQuestionController extends GetxController  with SingleGetTickerProviderMixin {
  WiwGameController wiwGameController = Get.put(WiwGameController());
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  late final List<WhoIsWho> _questions;
  List<WhoIsWho> get questions => _questions;
  PageController? _pageController;
  PageController? get pageController => _pageController;

  var gameDuration;
  Timer? countdownTimer;
  late Rx<Duration> myDuration;
  final remainingMinutes = ''.obs;
  final remainingSeconds = ''.obs;
  final RxString _timeLeft = RxString('00:00');
  String get timeLeft => _timeLeft.value;



  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;
  late String _correctAnswer;
  var numOfCorrectAnswers = 0.obs;
  var pointsGained = 0.obs;
  var totalPointsGained = 0.obs;
  String get correctAnswer => _correctAnswer;
  late String selectedAnswer;



  String strDigits(int n) => n.toString().padLeft(2, '0');


  void startTimer() {
    print('started');

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());

  }


  void setCountDown() {
    const reduceSecondsBy = 1;
      final seconds = myDuration.value.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        if(numOfCorrectAnswers > 4){
          Get.dialog(const WiwSuccessModal());
        }else{
          Get.dialog(const WiwTimeUpModal());
        }
      } else {
        myDuration.value = Duration(seconds: seconds);
        final String twoDigitMinutes =  remainingMinutes.value = strDigits(myDuration.value.inMinutes.remainder(60));
        final String twoDigitSeconds = remainingSeconds.value = strDigits(myDuration.value.inSeconds.remainder(60));
        _timeLeft.value = '$twoDigitMinutes:$twoDigitSeconds';
      }
  }

  void stopTimer() {
    countdownTimer!.cancel();
  }

  void resetTimer() {
    stopTimer();
    myDuration.value = const Duration(minutes: 1);
    startTimer();
  }


  goToNextQuestion(){
    _pageController?.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }



  checkAnswer (WhoIsWho question, String answerSelected){
    _isAnswered = true;
    _correctAnswer = question.correctOption;
    selectedAnswer = answerSelected;
    if(_correctAnswer == selectedAnswer){
      userController.soundIsOff.isFalse ? userController.playCorrectAnswerSound() : null;
      numOfCorrectAnswers++;
      pointsGained.value = pointsGained.value +  wiwGameController.pointPerQuestion;
    }else{
      userController.soundIsOff.isFalse ? userController.playWrongAnswerSound() : null;
    }
    update();
    Future.delayed(const Duration(seconds: 1), () {
      goToNextQuestion();
    });
  }

  @override
  void onInit() {
    super.onInit();
    _questions = wiwGameController.gameQuestions;
    _pageController = PageController();
    gameDuration = wiwGameController.gameDuration.value;
    myDuration = Rx<Duration>(Duration(minutes: wiwGameController.gameDuration.value));
    startTimer();
  }

  @override
  void onClose() {
    super.onClose();
    _pageController?.dispose();
  }
}