import 'package:bible_game/controllers/four_Scriptures_one_word_controller.dart';
import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/fourScripturesOneWord.dart';
import '../services/game_service.dart';

class FourScriptureQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  FourScripturesOneWordController fourScripturesOneWordController = Get.put(FourScripturesOneWordController());
  UserController userController = Get.put(UserController());
  QuickGameController quickGameController = Get.put(QuickGameController());
  late final List<FourScripturesOneWordQuestion> _questions;
  List<FourScripturesOneWordQuestion> get questions => _questions;
  PageController? _pageController;

  PageController? get pageController => _pageController;

  final bool _isAnswered = false;
  bool get isAnswered => _isAnswered;
  late String _correctAnswer;

  String get correctAnswer => _correctAnswer;
  late String selectedAnswer;
  final RxInt _questionNumber = 1.obs;
  final RxInt _questionAnswered = 0.obs;

  RxInt get questionNumber => _questionNumber;
  var numOfCorrectAnswers = 0.obs;
  var pointsGained = 0.obs;
  var totalPointsGained = 0.obs;


  @override
  void onInit() {
    super.onInit();
    _questions = fourScripturesOneWordController.fourScripturesQuestions;
    _pageController = PageController();
    totalPointsGained.value = userController.myUser['fourScriptScore'];
  }

  @override
  void onClose() {
    super.onClose();
    _pageController?.dispose();
  }

  goToNextQuestion(){
    _pageController?.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  updateGamePoint(){
   totalPointsGained.value = totalPointsGained.value + quickGameController.pointsPerQuestion;
   pointsGained.value = quickGameController.pointsPerQuestion;

  }


  sendGameData() async {
    await fourScripturesOneWordController.updateGameLevel();
    var response = await GameService.sendGameData(
        'FOUR_SCRIPTURES',
        pointsGained.value,
        0,
        0,
        0,
        userController.myUser['rank'],
        numOfCorrectAnswers.value,
        userController.myUser['id'],
        0,
        0
    );
  }
}
