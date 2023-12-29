import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/leaderboard_controller.dart';
import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../models/question.dart';
import '../screens/pilgrim_progress/new_level.dart';
import '../screens/quick_game/step_one.dart';
import '../screens/quick_game/step_two.dart';
import '../widgets/modals/game_summary.dart';

class QuickGamesQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  QuickGameController quickGameController = Get.put(QuickGameController());
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  final confettiController = ConfettiController();
  late final List<Question> _questions;

  List<Question> get questions => _questions;
  PageController? _pageController;

  PageController? get pageController => _pageController;
  late Animation animation;
  late AnimationController animationController;
  late AnimationController blinkingAnimationController;
  var durationPerQuestion;
  bool _isAnswered = false;

  bool get isAnswered => _isAnswered;
  late String _correctAnswer;

  String get correctAnswer => _correctAnswer;
  late String selectedAnswer;
  final RxInt _questionNumber = 1.obs;
  final RxInt _questionAnswered = 0.obs;

  RxInt get questionNumber => _questionNumber;
  var numOfCorrectAnswers = 0.obs;
  var pointsGained = 0.obs;
  var bonusPoint = 0.obs;
  var totalBonusPointsGained = 0.obs;
  var totalTimeSpent = 0.obs;
  final player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    _questions = quickGameController.gameQuestions;
    durationPerQuestion = quickGameController.durationPerQuestion;
    _pageController = PageController();
    animationController = AnimationController(
        duration: Duration(seconds: durationPerQuestion), vsync: this);
    blinkingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    blinkingAnimationController.repeat(reverse: true);

    animation = Tween<double>(begin: 1, end: 0).animate(animationController)
      ..addListener(() {
        update();
      });
    animationController.forward().whenComplete(goToNextQuestion);

  }



  @override
  void onClose() {
    super.onClose();
    animationController.reset();
    animationController.dispose();
    blinkingAnimationController.dispose();
   // confettiController.dispose();
    _pageController?.dispose();
  }

  void updateTheQuestionNumber(int index) {
    _questionNumber.value = index + 1;
  }


  void checkAnswer(Question question, String answerSelected) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    selectedAnswer = answerSelected;
    var halfOfTotalPointPerQuestion = quickGameController.pointsPerQuestion / 2;
    var answeredTime = (animation.value * durationPerQuestion).round();
    totalTimeSpent += durationPerQuestion - (animation.value * durationPerQuestion).round();
    if (_correctAnswer == selectedAnswer) {
      userController.soundIsOff.isFalse ? userController.playCorrectAnswerSound() : null;
      confettiController.play();
      numOfCorrectAnswers++;
      dynamic timeBonusPoint = ((answeredTime/durationPerQuestion) * halfOfTotalPointPerQuestion);
      pointsGained.value = pointsGained.value + (halfOfTotalPointPerQuestion + timeBonusPoint).round();
      totalBonusPointsGained.value = (totalBonusPointsGained.value + timeBonusPoint).round();

    }else{
      userController.soundIsOff.isFalse ? userController.playWrongAnswerSound() : null;
      confettiController.stop();
    }
    animationController.stop();
    update();
    Future.delayed(const Duration(seconds: 2), () {
    goToNextQuestion();
    _isAnswered = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  sendGameData(averageTimeSpent) async {
    var response = await GameService.sendGameData(
        'QUICK_GAME',
        pointsGained.value,
        pointsGained.value,
        bonusPoint.value,
        averageTimeSpent,
        userController.myUser['rank'],
        numOfCorrectAnswers.value,
        userController.myUser['id'],
        null,
       5
    );
  }

  updateTempPlayerData(averageTimeSpent){
    if(pointsGained.value > userController.tempPlayerPoint.value ){
      userController.tempPlayerPoint.value = pointsGained.value;
    }
    var tempQuickGameData = {
      'gameMode': 'QUICK_GAME',
      'totalScore': pointsGained.value,
      'baseScore': pointsGained.value,
      'bonusScore': bonusPoint.value,
      'averageTimeSpent': averageTimeSpent,
      'playerRank': 'babe',
      'noOfCorrectAnswers': numOfCorrectAnswers.value,
    };
    GetStorage().write('isTempLoggedIn', true);
    GetStorage().write('tempProgressData', tempQuickGameData);
  }

  void goToNextQuestion() async {
    _questionAnswered.value++;
    if (_questionAnswered.value != _questions.length) {
      _isAnswered = false;
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      animationController.reset();
      animationController.forward().whenComplete(goToNextQuestion);
      confettiController.stop();
    } else {
      animationController.stop();
      confettiController.stop();
      Get.dialog(
        GameSummaryModal(
          isQuickGame: true,
          pointsGained: pointsGained.toString(),
          questionsGotten: '$numOfCorrectAnswers/${questions.length}',
          bonusPointsGained: totalBonusPointsGained.toString(),
          averageTimeSpent:
              (totalTimeSpent.value ~/ questions.length).toString(),
          onTap: () async => {
            userController.soundIsOff.isFalse ? userController.playGameSound() : null,
            Get.delete<QuickGamesQuestionController>(),
            Get.delete<QuickGameController>(),
            Get.delete<LeaderboardController>(),
            Get.back(),
            GetStorage().write('isTempLoggedIn', false),
            Get.off(() => const QuickGameStepTwoScreen(),
                transition: Transition.fadeIn),
            await userController.getUserData(),
            Get.back(),
            Get.back(),
          },
        ),
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
      );
      var averageTimeSpent = (totalTimeSpent.value ~/ questions.length).toInt();
      authController.isLoggedIn.isTrue ? sendGameData(averageTimeSpent) : updateTempPlayerData(averageTimeSpent);

    }
  }

  resetGame() {
    _isAnswered = false;
    pointsGained = 0.obs;
    numOfCorrectAnswers = 0.obs;
    animationController.reset();
    questionNumber.value = 1;
  }
}
