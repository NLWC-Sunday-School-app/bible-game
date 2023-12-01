
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/controllers/wiw_game_controller.dart';
import 'package:bible_game/models/games.dart';
import 'package:bible_game/models/whoIsWho.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
  late Animation animation;
  late AnimationController animationController;
  late AnimationController blinkingAnimationController;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;
  late String _correctAnswer;
  var numOfCorrectAnswers = 0.obs;
  var pointsGained = 0.obs;
  var totalPointsGained = 0.obs;
  String get correctAnswer => _correctAnswer;
  late String selectedAnswer;



  goToNextQuestion(){
    _pageController?.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  endWiwGame(){

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
    animationController = AnimationController(
        duration: Duration(minutes: gameDuration), vsync: this);
    blinkingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    blinkingAnimationController.repeat(reverse: true);

    animation = Tween<double>(begin: 1, end: 0).animate(animationController)
      ..addListener(() {
        update();
      });
    animationController.forward().whenComplete(endWiwGame);
  }

  @override
  void onClose() {
    super.onClose();
    _pageController?.dispose();
  }
}