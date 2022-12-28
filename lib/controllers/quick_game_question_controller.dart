import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../models/question.dart';
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

  RxInt get questionNumber => _questionNumber;
  var numOfCorrectAnswers = 0.obs;
  var pointsGained = 0.obs;
  var bonusPoint = 0.obs;
  var totalPointsGained = 0.obs;
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
    _pageController?.dispose();
  }

  void updateTheQuestionNumber(int index) {
    _questionNumber.value = index + 1;
  }

  void allocateBonusPoint(answeredTime) {
    if (answeredTime >= quickGameController.fullBonusLowerRange ||
        answeredTime <= quickGameController.durationPerQuestion) {
      bonusPoint += quickGameController.pointsPerQuestion;
    } else if (answeredTime >= quickGameController.partialBonusLowerRange ||
        answeredTime < quickGameController.fullBonusLowerRange) {
      bonusPoint += quickGameController.partialBonusPoint.toInt();
    } else {}
  }

  void checkAnswer(Question question, String answerSelected) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    selectedAnswer = answerSelected;
    var answeredTime = (animation.value * durationPerQuestion).round();
    totalTimeSpent +=
        durationPerQuestion - (animation.value * durationPerQuestion).round();
    if (_correctAnswer == selectedAnswer) {
      player.setAsset('assets/audios/success.mp3');
      player.setVolume(0.4);
      player.play();
      confettiController.play();
      numOfCorrectAnswers++;
      pointsGained.value =
          pointsGained.value + quickGameController.pointsPerQuestion;
      allocateBonusPoint(answeredTime);
      totalPointsGained.value = pointsGained.value + bonusPoint.value;
    }else{
      player.setAsset('assets/audios/wrong_answer.wav');
      player.play();
      confettiController.stop();
    }
    animationController.stop();
    update();
    Future.delayed(const Duration(seconds: 2), () {
     goToNextQuestion();
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
        totalPointsGained.value,
        pointsGained.value,
        bonusPoint.value,
        averageTimeSpent,
        userController.myUser['rank'],
        numOfCorrectAnswers.value,
        userController.myUser['id'],
        null
    );
  }

  updateTempPlayerData(){
    if(totalPointsGained.value > userController.tempPlayerPoint.value ){
      userController.tempPlayerPoint.value = totalPointsGained.value;
    }
  }

  void goToNextQuestion() async {
    if (_questionNumber.value != _questions.length) {
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
          pointsGained: totalPointsGained.toString(),
          questionsGotten: '$numOfCorrectAnswers/${questions.length}',
          bonusPointsGained: bonusPoint.toString(),
          averageTimeSpent:
              (totalTimeSpent.value ~/ questions.length).toString(),
          onTap: () => {
            player.setAsset('assets/audios/click.mp3'),
            player.play(),
            Get.delete<QuickGamesQuestionController>(),
            Get.delete<QuickGameController>(),
            Get.back(),
            Get.off(() => const QuickGameStepTwoScreen(),
                transition: Transition.fadeIn),
            Get.back(),
            Get.back(),
          },
        ),
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(30, 30, 30, 0.95),
      );
      var averageTimeSpent = (totalTimeSpent.value ~/ questions.length).toInt();
      authController.isLoggedIn.isTrue ? sendGameData(averageTimeSpent) : updateTempPlayerData();
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
