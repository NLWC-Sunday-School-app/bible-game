import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/auth_controller.dart';
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
import '../screens/quick_game/step_one.dart';
import '../screens/quick_game/step_two.dart';
import '../screens/tabs/tab_main_screen.dart';
import '../widgets/modals/game_summary.dart';
import 'global_game_controller.dart';

class GlobalQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  GlobalGameController globalGameController = Get.put(GlobalGameController());
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
    _questions = globalGameController.gameQuestions;
    durationPerQuestion = globalGameController.durationPerQuestion;
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
    _pageController?.dispose();
  }

  void updateTheQuestionNumber(int index) {
    _questionNumber.value = index + 1;
  }

  void checkAnswer(Question question, String answerSelected) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    selectedAnswer = answerSelected;
    var halfOfTotalPointPerQuestion = globalGameController.pointsPerQuestion / 2;
    var answeredTime = (animation.value * durationPerQuestion).round();
    totalTimeSpent +=
        durationPerQuestion - (animation.value * durationPerQuestion).round();
    if (_correctAnswer == selectedAnswer) {
      userController.soundIsOff.isFalse ? userController
          .playCorrectAnswerSound() : null;
      confettiController.play();
      numOfCorrectAnswers++;
      dynamic timeBonusPoint = ((answeredTime / durationPerQuestion) *
          halfOfTotalPointPerQuestion);
      pointsGained.value = pointsGained.value +
          (halfOfTotalPointPerQuestion + timeBonusPoint).round();
      totalBonusPointsGained.value =
          (totalBonusPointsGained.value + timeBonusPoint).round();
    } else {
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
        globalGameController.gameType.value,
        pointsGained.value,
        pointsGained.value,
        bonusPoint.value,
        averageTimeSpent,
        'babe',
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
      'gameMode': globalGameController.gameType.value,
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
      GetStorage().write('PLAYED_${globalGameController.gameType.value}', true);
      Get.dialog(
        GameSummaryModal(
          isQuickGame: false,
          pointsGained: pointsGained.toString(),
          questionsGotten: '$numOfCorrectAnswers/${questions.length}',
          bonusPointsGained: bonusPoint.toString(),
          averageTimeSpent:
          (totalTimeSpent.value ~/ questions.length).toString(),
          onTap: () => {
            userController.soundIsOff.isFalse ? userController.playGameSound() : null,
            Get.delete<GlobalQuestionController>(),
            Get.delete<GlobalGameController>(),
            Get.back(),
            GetStorage().write('isTempLoggedIn', false),
            Get.offAll(() => const TabMainScreen(),
                transition: Transition.fadeIn)
          },
        ),
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(30, 30, 30, 0.75),
      );
      var averageTimeSpent = (totalTimeSpent.value ~/ questions.length).toInt();
      sendGameData(averageTimeSpent);

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
