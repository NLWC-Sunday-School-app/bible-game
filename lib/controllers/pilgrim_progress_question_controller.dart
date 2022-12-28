import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../models/question.dart';
import '../services/game_service.dart';
import '../widgets/modals/game_summary.dart';

class PilgrimProgressQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  PilgrimProgressController pilgrimProgressController = Get.put(PilgrimProgressController());
  UserController userController = Get.put(UserController());
  final confettiController = ConfettiController();
  late final List<Question> _questions;

  List<Question> get questions => _questions;
  PageController? _pageController;

  PageController? get pageController => _pageController;
  late Animation animation;
  late AnimationController animationController;
  late AnimationController blinkingAnimationController;
  var durationPerQuestion ;
  bool _isAnswered = false;

  bool get isAnswered => _isAnswered;
  late String _correctAnswer;

  String get correctAnswer => _correctAnswer;
  late  String selectedAnswer;
  final RxInt _questionNumber = 1.obs;
  final RxInt _questionAnswered = 0.obs;

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
    print(pilgrimProgressController.gameQuestions);
    _questions = pilgrimProgressController.gameQuestions;
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
  void dispose(){
    super.dispose();
    _pageController?.dispose();
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

  void allocateBonusPoint(answeredTime){
    if(answeredTime >= pilgrimProgressController.fullBonusLowerRange || answeredTime <= pilgrimProgressController.durationPerQuestion){
      bonusPoint += pilgrimProgressController.pointsPerQuestion;
    }else if(answeredTime >= pilgrimProgressController.partialBonusLowerRange || answeredTime < pilgrimProgressController.fullBonusLowerRange){
      bonusPoint += pilgrimProgressController.partialBonusPoint.toInt();
    }else{

    }
  }

  void checkAnswer(Question question, String answerSelected) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    selectedAnswer = answerSelected;
    _questionAnswered.value++;
    var answeredTime = (animation.value * durationPerQuestion).round();
    totalTimeSpent += durationPerQuestion - (animation.value * durationPerQuestion).round();
    if (_correctAnswer == selectedAnswer) {
      player.setAsset('assets/audios/success.mp3');
      player.setVolume(0.4);
      player.play();
      confettiController.play();
      numOfCorrectAnswers++;
      pointsGained += pilgrimProgressController.pointsPerQuestion;
      allocateBonusPoint(answeredTime);
      totalPointsGained.value = pointsGained.value + bonusPoint.value;
    }else{
      player.setAsset('assets/audios/wrong_answer.wav');
      player.play();
      confettiController.stop();
    }
    animationController.stop();
    update();
    Future.delayed(const Duration(milliseconds: 2500), () {
     goToNextQuestion();
    });
  }

  void goToNextQuestion() {
    if (_questionAnswered.value != _questions.length) {
      _isAnswered = false;
      _pageController?.nextPage(duration: const Duration(milliseconds: 250),
       curve: Curves.ease,
      );
      animationController.reset();
      animationController.forward().whenComplete(goToNextQuestion);
    } else {
      animationController.stop();
      var averageTimeSpent = (totalTimeSpent.value ~/ questions.length).toInt();
      updateGameProgress(averageTimeSpent);
      Get.dialog(
          GameSummaryModal(
            pointsGained:  totalPointsGained.toString(),
            questionsGotten: '$numOfCorrectAnswers/${questions.length}',
            averageTimeSpent: (totalTimeSpent.value ~/ questions.length).toString(),
            onTap: () => {
              player.setAsset('assets/audios/click.mp3'),
              player.play(),
              resetGame(),
              Get.delete<PilgrimProgressQuestionController>(),
              Get.back(),
              Get.off(() => const PilgrimProgressHomeScreen(), transition: Transition.fadeIn)
            }, bonusPointsGained: bonusPoint.toString(),
          ),
          barrierDismissible: false,
          barrierColor: const Color.fromRGBO(30, 30, 30, 0.95));

    }
  }

  updateGameProgress(averageTimeSpent) async{
    var percentageToPassMilkLevels = double.parse(userController.userGameSettings['percentage_pass_milk_levels']) / 100 ;
    var percentageToPassMeatLevels = double.parse(userController.userGameSettings['percentage_pass_meat_levels']) / 100;
    var percentageToStrongMeatLevels = double.parse(userController.userGameSettings['percentage_pass_strong_meat_levels']) / 100;
    var isLoggedIn = GetStorage().read('userLoggedIn') ?? false;
   if(isLoggedIn){
     switch(pilgrimProgressController.selectedLevel.value){
       case 'babe':
         var score = totalPointsGained / int.parse(userController.userGameSettings['total_points_available_milk_levels']);
         pilgrimProgressController.babeProgressLevelValue.value += score;
         pilgrimProgressController.babeProgressLevelValue.value >= percentageToPassMilkLevels ? pilgrimProgressController.childLevelIsLocked.value = false : pilgrimProgressController.childLevelIsLocked.value = true;
         await GameService.sendGameData('PILGRIM_PROGRESS', totalPointsGained.value, pointsGained.value, bonusPoint.value, averageTimeSpent,
             'babe', numOfCorrectAnswers.value,  userController.myUser['id'], pilgrimProgressController.babeProgressLevelValue.value);
         break;
       case 'child':
         var score = totalPointsGained / int.parse(userController.userGameSettings['total_points_available_milk_levels']);
         pilgrimProgressController.childProgressLevelValue.value += score;
         pilgrimProgressController.childProgressLevelValue.value >= percentageToPassMilkLevels ? pilgrimProgressController.youngBelieversLevelIsLocked.value = false : pilgrimProgressController.youngBelieversLevelIsLocked.value = true;
         await GameService.sendGameData('PILGRIM_PROGRESS', totalPointsGained.value, pointsGained.value, bonusPoint.value, averageTimeSpent,
             'child', numOfCorrectAnswers.value,  userController.myUser['id'], pilgrimProgressController.childProgressLevelValue.value);
         break;
       case 'young believer':
         var score = totalPointsGained / int.parse(userController.userGameSettings['total_points_available_meat_levels']);
         pilgrimProgressController.youngBelieverProgressLevelValue.value += score;
         pilgrimProgressController.youngBelieverProgressLevelValue.value >= percentageToPassMeatLevels ? pilgrimProgressController.charityLevelIsLocked.value = false : pilgrimProgressController.charityLevelIsLocked.value = true;
         await GameService.sendGameData('PILGRIM_PROGRESS', totalPointsGained.value, pointsGained.value, bonusPoint.value, averageTimeSpent,
             'young believer', numOfCorrectAnswers.value,  userController.myUser['id'], pilgrimProgressController.youngBelieverProgressLevelValue.value);
         break;
       case 'charity':
         var score = totalPointsGained / int.parse(userController.userGameSettings['total_points_available_meat_levels']);
         pilgrimProgressController.charityProgressLevelValue.value += score;
         pilgrimProgressController.charityProgressLevelValue.value >= percentageToPassMeatLevels ? pilgrimProgressController.fatherLevelIsLocked.value = false : pilgrimProgressController.fatherLevelIsLocked.value = true;
         await GameService.sendGameData('PILGRIM_PROGRESS', totalPointsGained.value, pointsGained.value, bonusPoint.value, averageTimeSpent,
             'charity', numOfCorrectAnswers.value,  userController.myUser['id'], pilgrimProgressController.charityProgressLevelValue.value);
         break;
       case 'father':
         var score = totalPointsGained / int.parse(userController.userGameSettings['total_points_available_strong_meat_levels']);
         pilgrimProgressController.fatherProgressLevelValue.value += score;
         pilgrimProgressController.fatherProgressLevelValue.value >= percentageToStrongMeatLevels ? pilgrimProgressController.elderLevelIsLocked.value = false : pilgrimProgressController.elderLevelIsLocked.value = true;
         await GameService.sendGameData('PILGRIM_PROGRESS', totalPointsGained.value, pointsGained.value, bonusPoint.value, averageTimeSpent,
             'father', numOfCorrectAnswers.value,  userController.myUser['id'], pilgrimProgressController.fatherProgressLevelValue.value);
         break;
       case 'elder':
         var score = totalPointsGained / int.parse(userController.userGameSettings['total_points_available_strong_meat_levels']);
         pilgrimProgressController.elderProgressLevelValue.value += score;
         await GameService.sendGameData('PILGRIM_PROGRESS', totalPointsGained.value, pointsGained.value, bonusPoint.value, averageTimeSpent,
             'elder', numOfCorrectAnswers.value,  userController.myUser['id'], pilgrimProgressController.elderProgressLevelValue.value);
         break;

     }
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
