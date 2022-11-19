import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/question.dart';
import '../screens/quick_game/step_one.dart';
import '../widgets/modals/game_summary.dart';

class QuickGamesQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  QuickGameController quickGameController = Get.put(QuickGameController());
  final List<Question> _questions = questionsData
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            options: question['options'],
            answer: question['correct_option']
        ),
      )
      .toList();

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

  @override
  void onInit() {
    super.onInit();
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

  void checkAnswer(Question question, String answerSelected) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    selectedAnswer = answerSelected;
    if (_correctAnswer == selectedAnswer) {
      numOfCorrectAnswers++;
      pointsGained += 50;
    }
    animationController.stop();
    update();
    Future.delayed(const Duration(seconds: 2), () {
      goToNextQuestion();
    });
  }

  void goToNextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      animationController.reset();
      animationController.forward().whenComplete(goToNextQuestion);
    } else {
      animationController.stop();
      Get.dialog(
           GameSummaryModal(
            pointsGained: pointsGained.toString(),
             questionsGotten: '$numOfCorrectAnswers/${questions.length}',
             onTap: () => {
               Get.delete<QuickGamesQuestionController>(),
               Get.off(() => const QuickGameStepOneScreen(), transition: Transition.fadeIn)
             },
          ),
          barrierDismissible: false,
          barrierColor: const Color.fromRGBO(30, 30, 30, 0.95));
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
