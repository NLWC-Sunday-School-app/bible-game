import 'dart:async';
import 'package:bible_game/controllers/leaderboard_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/pilgrim_progress/new_level.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../models/question.dart';
import '../screens/pilgrim_progress/retry_level.dart';
import '../services/game_service.dart';
import '../widgets/modals/game_summary.dart';

class PilgrimProgressQuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  PilgrimProgressController pilgrimProgressController =
      Get.put(PilgrimProgressController());
  UserController userController = Get.put(UserController());
  final confettiController = ConfettiController();
  late final List<Question> _questions;

  List<Question> get questions => _questions;
  PageController? _pageController;

  PageController? get pageController => _pageController;
  late Animation animation;
  late AnimationController animationController;
  late AnimationController blinkingAnimationController;
  var durationPerQuestion;
  LeaderboardController leaderboardController = Get.put(LeaderboardController());

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
    _questions = pilgrimProgressController.gameQuestions;
    durationPerQuestion = pilgrimProgressController.durationPerQuestion;
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
  void dispose() {
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

  displayUnlockedNewLevelScreen(newLevel, newLevelBadgeUrl){
      Timer(const Duration(seconds: 1), (){
         Get.to(() => NewLevelScreen(newLevel: newLevel, newLevelBadge: newLevelBadgeUrl,));
      });
  }


  void checkAnswer(Question question, String answerSelected) {
    _isAnswered = true;
    _correctAnswer = question.answer;
    selectedAnswer = answerSelected;
    var halfOfTotalPointPerQuestion = pilgrimProgressController.pointsPerQuestion / 2;
    var answeredTime = (animation.value * durationPerQuestion).round();
    totalTimeSpent +=
        durationPerQuestion - (animation.value * durationPerQuestion).round();
    if (_correctAnswer == selectedAnswer) {
      userController.soundIsOff.isFalse ? userController.playCorrectAnswerSound() : null;
      confettiController.play();
      numOfCorrectAnswers++;
      dynamic timeBonusPoint = ((answeredTime/durationPerQuestion) * halfOfTotalPointPerQuestion);
      pointsGained.value = pointsGained.value + (halfOfTotalPointPerQuestion + timeBonusPoint).round();
      totalBonusPointsGained.value = (totalBonusPointsGained.value + timeBonusPoint).round();

    } else {
      userController.soundIsOff.isFalse ? userController.playWrongAnswerSound() : null;
      confettiController.stop();
    }
    animationController.stop();
    update();
    Future.delayed(const Duration(milliseconds: 2500), () {
      goToNextQuestion();
      _isAnswered = false;
    });
  }


  updateGameProgress(averageTimeSpent) async {
    var isLoggedIn = GetStorage().read('userLoggedIn') ?? false;
    if (isLoggedIn) {
      switch (pilgrimProgressController.selectedLevel.value) {
        case 'babe':
          userController.myUser['rank'] == 'babe' ? pilgrimProgressController.noOfRoundsLeftInBabe.value-- : null;
          var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.babeProgressLevelValue.value += score;
          pilgrimProgressController.babeProgressLevelValue.value >= 1.0 || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value ?  pilgrimProgressController.childLevelIsLocked.value = false : pilgrimProgressController.childLevelIsLocked.value = true;
          await GameService.sendGameData(
            'PILGRIM_PROGRESS',
            pointsGained.value,
            pointsGained.value,
            totalBonusPointsGained.value,
            averageTimeSpent,
            'babe',
            numOfCorrectAnswers.value,
            userController.myUser['id'],
            pilgrimProgressController.noOfRoundsLeftInBabe.value >= 1 ? pilgrimProgressController.babeProgressLevelValue.value >= 1.0 ? 1.0 : pilgrimProgressController.babeProgressLevelValue.value.toStringAsFixed(5) : (pilgrimProgressController.totalPointsGainedInBabe.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ?  pilgrimProgressController.babeProgressLevelValue.value.toStringAsFixed(5) :  0,
            pilgrimProgressController.noOfRoundsLeftInBabe.value >= 1 && userController.myUser['rank'] == 'babe' && !(pilgrimProgressController.totalPointsGainedInBabe.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.noOfRoundsLeftInBabe.value : 5
          );
          await leaderboardController.setLeaderboardData(1);
          if(pilgrimProgressController.noOfRoundsLeftInBabe.value < 1 && !(pilgrimProgressController.totalPointsGainedInBabe.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value)){
            Timer(const Duration(seconds: 2), (){
              Get.to(() => const RetryLevelScreen());
            });
          }
          if(userController.myUser['rank'] == 'babe' && (pilgrimProgressController.totalPointsGainedInBabe.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value)){
            await UserService.updatePlayerRank(userController.myUser['id'], 'child');
            await displayUnlockedNewLevelScreen('child', 'assets/images/badges/child_badge.png');
          }
          break;
        case 'child':
          userController.myUser['rank'] == 'child' ? pilgrimProgressController.noOfRoundsLeftInChild.value-- : null;
          var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.childProgressLevelValue.value += score;
          pilgrimProgressController.childProgressLevelValue.value >= 1.0 || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value ? pilgrimProgressController.youngBelieversLevelIsLocked.value = false : pilgrimProgressController.youngBelieversLevelIsLocked.value = true;
           GameService.sendGameData(
              'PILGRIM_PROGRESS',
              pointsGained.value,
              pointsGained.value,
             totalBonusPointsGained.value,
              averageTimeSpent,
              'child',
              numOfCorrectAnswers.value,
              userController.myUser['id'],
             pilgrimProgressController.noOfRoundsLeftInChild.value >= 1 ? pilgrimProgressController.childProgressLevelValue.value >= 1 ? 1.0 : pilgrimProgressController.childProgressLevelValue.value.toStringAsFixed(5) : (pilgrimProgressController.totalPointsGainedInChild.value + pointsGained.value>= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.childProgressLevelValue.value.toStringAsFixed(5) : 0,
             pilgrimProgressController.noOfRoundsLeftInChild.value >= 1 && userController.myUser['rank'] == 'child' && !(pilgrimProgressController.totalPointsGainedInChild.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.noOfRoundsLeftInChild.value : 4

           );
          await leaderboardController.setLeaderboardData(2);
          if(pilgrimProgressController.noOfRoundsLeftInChild.value < 1 && !(pilgrimProgressController.totalPointsGainedInChild.value + pointsGained.value>= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value)){
            Timer(const Duration(seconds: 2), (){
              Get.to(() => const RetryLevelScreen());
            });
          }
          if(userController.myUser['rank'] == 'child' && (pilgrimProgressController.totalPointsGainedInChild.value + pointsGained.value>= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value)){
            await UserService.updatePlayerRank(userController.myUser['id'], 'young believer');
            await displayUnlockedNewLevelScreen('young believer', 'assets/images/badges/yb_badge.png');
          }

          break;
        case 'young believer':
          userController.myUser['rank'] == 'young believer' ? pilgrimProgressController.noOfRoundsLeftInYb.value-- : null;
          var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.youngBelieverProgressLevelValue.value += score;
          pilgrimProgressController.youngBelieverProgressLevelValue.value >=  1.0 || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value ? pilgrimProgressController.charityLevelIsLocked.value = false : pilgrimProgressController.charityLevelIsLocked.value = true;
          await GameService.sendGameData(
              'PILGRIM_PROGRESS',
              pointsGained.value,
              pointsGained.value,
              totalBonusPointsGained.value,
              averageTimeSpent,
              'young believer',
              numOfCorrectAnswers.value,
              userController.myUser['id'],
              pilgrimProgressController.noOfRoundsLeftInYb.value >= 1 ? pilgrimProgressController.youngBelieverProgressLevelValue.value >= 1.0 ? 1.0 : pilgrimProgressController.youngBelieverProgressLevelValue.value.toStringAsFixed(5): (pilgrimProgressController.totalPointsGainedInYb.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.youngBelieverProgressLevelValue.value.toStringAsFixed(5) : 0 ,
              pilgrimProgressController.noOfRoundsLeftInYb.value >= 1 && userController.myUser['rank'] == 'young believer' && !(pilgrimProgressController.totalPointsGainedInYb.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.noOfRoundsLeftInYb.value : 3
          );
          await leaderboardController.setLeaderboardData(3);
          if(pilgrimProgressController.noOfRoundsLeftInYb.value < 1 && !(pilgrimProgressController.totalPointsGainedInYb.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value)){
            Timer(const Duration(seconds: 2), (){
              Get.to(() => const RetryLevelScreen());
            });
          }
          if(userController.myUser['rank'] == 'young believer' && (pilgrimProgressController.totalPointsGainedInYb.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value)){
            await UserService.updatePlayerRank(userController.myUser['id'], 'charity');
            await displayUnlockedNewLevelScreen('charity', 'assets/images/badges/charity_badge.png');
          }

          break;
        case 'charity':
          userController.myUser['rank'] == 'charity' ? pilgrimProgressController.noOfRoundsLeftInCharity.value-- : null;
          var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.charityProgressLevelValue.value += score;
          pilgrimProgressController.charityProgressLevelValue.value >= 1.0 || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value ? pilgrimProgressController.fatherLevelIsLocked.value = false : pilgrimProgressController.fatherLevelIsLocked.value = true;
          await GameService.sendGameData(
              'PILGRIM_PROGRESS',
              pointsGained.value,
              pointsGained.value,
              totalBonusPointsGained.value,
              averageTimeSpent,
              'charity',
              numOfCorrectAnswers.value,
              userController.myUser['id'],
              pilgrimProgressController.noOfRoundsLeftInCharity.value >= 1 ? pilgrimProgressController.charityProgressLevelValue.value >= 1.0 ? 1.0 : pilgrimProgressController.charityProgressLevelValue.value.toStringAsFixed(5): (pilgrimProgressController.totalPointsGainedInCharity.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.charityProgressLevelValue.value.toStringAsFixed(5) : 0 ,
              pilgrimProgressController.noOfRoundsLeftInCharity.value >= 1 && userController.myUser['rank'] == 'charity' && !(pilgrimProgressController.totalPointsGainedInCharity.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.noOfRoundsLeftInCharity.value : 2

          );
          await leaderboardController.setLeaderboardData(4);
          if(pilgrimProgressController.noOfRoundsLeftInCharity.value < 1 && !(pilgrimProgressController.totalPointsGainedInCharity.value  + pointsGained.value>= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value)){
            Timer(const Duration(seconds: 2), (){
              Get.to(() => const RetryLevelScreen());
            });
          }

          if(userController.myUser['rank'] == 'charity' && (pilgrimProgressController.totalPointsGainedInCharity.value  + pointsGained.value>= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value)){
            await UserService.updatePlayerRank(userController.myUser['id'], 'father');
            await displayUnlockedNewLevelScreen('father', 'assets/images/badges/father_badge.png');
          }

          break;
        case 'father':
          userController.myUser['rank'] == 'father' ? pilgrimProgressController.noOfRoundsLeftInFather.value-- : null;
          var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.fatherProgressLevelValue.value += score;
          pilgrimProgressController.fatherProgressLevelValue.value >= 1.0 || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value ? pilgrimProgressController.elderLevelIsLocked.value = false : pilgrimProgressController.elderLevelIsLocked.value = true;
          await GameService.sendGameData(
              'PILGRIM_PROGRESS',
              pointsGained.value,
              pointsGained.value,
              totalBonusPointsGained.value,
              averageTimeSpent,
              'father',
              numOfCorrectAnswers.value,
              userController.myUser['id'],
              pilgrimProgressController.noOfRoundsLeftInFather.value >= 1 ? pilgrimProgressController.fatherProgressLevelValue.value >= 1.0 ? 1.0 : pilgrimProgressController.fatherProgressLevelValue.value.toStringAsFixed(5): (pilgrimProgressController.totalPointsGainedInCharity.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.fatherProgressLevelValue.value.toStringAsFixed(5) : 0 ,
              pilgrimProgressController.noOfRoundsLeftInFather.value >= 1 && userController.myUser['rank'] == 'father' && !(pilgrimProgressController.totalPointsGainedInFather.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.noOfRoundsLeftInFather.value : 2
          );
          await leaderboardController.setLeaderboardData(5);
          if(pilgrimProgressController.noOfRoundsLeftInFather.value < 1 && !(pilgrimProgressController.totalPointsGainedInFather.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value)){
            Timer(const Duration(seconds: 2), (){
              Get.to(() => const RetryLevelScreen());
            });
          }
          if(userController.myUser['rank'] == 'father' && (pilgrimProgressController.totalPointsGainedInFather.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value)){
            await UserService.updatePlayerRank(userController.myUser['id'], 'elder');
            await displayUnlockedNewLevelScreen('elder', 'assets/images/badges/elder_badge.png');
          }

          break;
        case 'elder':
          userController.myUser['rank'] == 'elder' ? pilgrimProgressController.noOfRoundsLeftInElder.value-- : null;
          var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.elderProgressLevelValue.value += score;
          await GameService.sendGameData(
              'PILGRIM_PROGRESS',
              pointsGained.value,
              pointsGained.value,
              totalBonusPointsGained.value,
              averageTimeSpent,
              'elder',
              numOfCorrectAnswers.value,
              userController.myUser['id'],
              pilgrimProgressController.noOfRoundsLeftInElder.value >= 1 ? pilgrimProgressController.elderProgressLevelValue.value >= 1.0 ? 1.0 : pilgrimProgressController.elderProgressLevelValue.value.toStringAsFixed(5): (pilgrimProgressController.totalPointsGainedInCharity.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.elderProgressLevelValue.value.toStringAsFixed(5) : 0 ,
              pilgrimProgressController.noOfRoundsLeftInElder.value >= 1 && userController.myUser['rank'] == 'elder' && !(pilgrimProgressController.totalPointsGainedInElder.value + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained.value >= pilgrimProgressController.passOnFirstTrialScore.value) ? pilgrimProgressController.noOfRoundsLeftInElder.value : 2
          );
          await leaderboardController.setLeaderboardData(6);
          if(pilgrimProgressController.noOfRoundsLeftInElder.value < 1 && !(pilgrimProgressController.totalPointsGainedInElder.value  + pointsGained.value >= pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value || pointsGained >= pilgrimProgressController.passOnFirstTrialScore.value)){
            Timer(const Duration(seconds: 2), (){
              Get.to(() => const RetryLevelScreen());
            });
          }
          break;
      }
    } else{
      var score = pointsGained / int.parse(userController.userGameSettings['total_points_available_pilgrim_progress']);
          pilgrimProgressController.babeProgressLevelValue.value += score;
          var tempPilgrimProgressData = {
             'gameMode': 'PILGRIM_PROGRESS',
             'totalScore': pointsGained.value,
             'baseScore': pointsGained.value,
             'bonusScore': bonusPoint.value,
             'averageTimeSpent': averageTimeSpent,
             'playerRank': 'babe',
             'noOfCorrectAnswers': numOfCorrectAnswers.value,
             'numberOfRounds': 4,
             'userProgress': pilgrimProgressController.babeProgressLevelValue.value.toStringAsFixed(2),

          };
          GetStorage().write('isTempLoggedIn', true);
          GetStorage().write('tempProgressData', tempPilgrimProgressData);

    }
  }


  void goToNextQuestion() {
    _questionAnswered.value++;
    if (_questionAnswered.value != _questions.length) {
      _isAnswered = false;
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 250),
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
          isQuickGame: false,
          pointsGained: pointsGained.toString(),
          questionsGotten: '$numOfCorrectAnswers/${questions.length}',
          averageTimeSpent:
          (totalTimeSpent.value ~/ questions.length).toString(),
          onTap: () async => {
            userController.soundIsOff.isFalse ? userController.playGameSound() : null,
            resetGame(),
            Get.delete<PilgrimProgressQuestionController>(),
            Get.delete<LeaderboardController>(),
            GetStorage().write('isTempLoggedIn', false),
            Get.back(),
            Get.back(),
            Get.off(() => const PilgrimProgressHomeScreen(),  transition: Transition.fadeIn),
            await userController.getUserData(),
            await pilgrimProgressController.setPilgrimData()

          },
          bonusPointsGained: totalBonusPointsGained.toString(),
        ),
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(30, 30, 30, 0.75),
      );
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
