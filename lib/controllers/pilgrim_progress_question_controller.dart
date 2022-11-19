import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/question.dart';
import '../widgets/modals/game_summary.dart';

class PilgrimProgressQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  final PilgrimProgressController pilgrimProgressController = Get.put(PilgrimProgressController());
  final List<Question> _questions = pilgrimQuestionsData
      .map(
        (question) => Question(
        id: question['id'],
        question: question['question'],
        options: question['options'],
        answer: question['correct_option']
        ),
  ).toList();

  List<Question> get questions => _questions;
  PageController? _pageController;

  PageController? get pageController => _pageController;
  late Animation animation;
  late AnimationController animationController;
  late AnimationController blinkingAnimationController;
  var durationPerQuestion ;
  var totalPoints = 1000;
  bool _isAnswered = false;

  bool get isAnswered => _isAnswered;
  late String _correctAnswer;

  String get correctAnswer => _correctAnswer;
  late  String selectedAnswer;
  final RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => _questionNumber;
  var numOfCorrectAnswers = 0.obs;
  var pointsGained = 0.obs;

  @override
  void onInit() {
    super.onInit();
    durationPerQuestion = pilgrimProgressController.durationPerQuestion;
    _pageController = PageController();
    animationController = AnimationController(duration: Duration(seconds: durationPerQuestion), vsync: this);
    blinkingAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
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
      _pageController?.nextPage(duration: const Duration(milliseconds: 250),
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
              Get.off(() => const PilgrimProgressHomeScreen(), transition: Transition.fadeIn)
            },
          ),
          barrierDismissible: false,
          barrierColor: const Color.fromRGBO(30, 30, 30, 0.95));
          updateGameProgress();
          print(pilgrimProgressController.selectedLevel);
    }
  }

  updateGameProgress(){
    var score = pointsGained / totalPoints;
    switch(pilgrimProgressController.selectedLevel.value){
      case 'babe':
        pilgrimProgressController.babeProgressLevelValue.value += score;
        pilgrimProgressController.babeProgressLevelValue.value >= 0.75 ? pilgrimProgressController.childLevelIsLocked.value = false : pilgrimProgressController.childLevelIsLocked.value = true;
        break;
      case 'child':
        pilgrimProgressController.childProgressLevelValue.value += score;
        pilgrimProgressController.childProgressLevelValue.value >= 0.75 ? pilgrimProgressController.youngBelieversLevelIsLocked.value = false : pilgrimProgressController.youngBelieversLevelIsLocked.value = true;
        break;
      case 'young believer':
        pilgrimProgressController.youngBelieverProgressLevelValue.value += score;
        pilgrimProgressController.youngBelieverProgressLevelValue.value >= 0.75 ? pilgrimProgressController.charityLevelIsLocked.value = false : pilgrimProgressController.charityLevelIsLocked.value = true;
        break;
      case 'charity':
        pilgrimProgressController.charityProgressLevelValue.value += score;
        pilgrimProgressController.charityProgressLevelValue.value >= 0.75 ? pilgrimProgressController.fatherLevelIsLocked.value = false : pilgrimProgressController.fatherLevelIsLocked.value = true;
        break;
      case 'father':
        pilgrimProgressController.fatherProgressLevelValue.value += score;
        pilgrimProgressController.fatherProgressLevelValue.value >= 0.75 ? pilgrimProgressController.elderLevelIsLocked.value = false : pilgrimProgressController.elderLevelIsLocked.value = true;
        break;
      case 'elder':
        pilgrimProgressController.elderProgressLevelValue.value += score;
        break;

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
