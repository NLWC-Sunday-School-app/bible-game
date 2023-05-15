

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/leaderboard_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/question.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/widgets/modals/pilgrim_progress_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/pilgrim_progress/pilgrim_progress_question_screen.dart';

class PilgrimProgressController extends GetxController {
  var babeProgressLevelValue = 0.0.obs;
  var childProgressLevelValue = 0.0.obs;
  var youngBelieverProgressLevelValue = 0.0.obs;
  var charityProgressLevelValue = 0.0.obs;
  var fatherProgressLevelValue = 0.0.obs;
  var elderProgressLevelValue = 0.0.obs;
  var gameQuestions = <Question>[].obs;
  var modalTitle = 'Preparing your questions...'.obs;
  var selectedLevel = ''.obs;
  var gameIsReady = false.obs;
  var durationPerQuestion = 0;
  var pointsPerQuestion = 0;
  var fullBonusLowerRange = 0;
  var partialBonusLowerRange = 0;
  var partialBonusPoint = 0;
  var pilgrimProgressGameLoading = false.obs;
  var babeLevelIsLocked = false.obs;
  var childLevelIsLocked = true.obs;
  var youngBelieversLevelIsLocked = true.obs;
  var charityLevelIsLocked = true.obs;
  var fatherLevelIsLocked = true.obs;
  var elderLevelIsLocked = true.obs;
  var noOfRoundsLeftInBabe = 0.obs;
  var noOfRoundsLeftInChild = 0.obs;
  var noOfRoundsLeftInYb = 0.obs;
  var noOfRoundsLeftInCharity = 0.obs;
  var noOfRoundsLeftInFather = 0.obs;
  var noOfRoundsLeftInElder = 0.obs;
  var totalPointsAvailableMilkLevels = 0.obs;
  var totalPointsAvailableMeatLevels = 0.obs;
  var totalPointsAvailableStrongMeatLevels = 0.obs;
  var totalPointsAvailableInBabe = 0.obs;
  var totalPointsAvailableInChild = 0.obs;
  var totalPointsAvailableInYb = 0.obs;
  var totalPointsAvailableInCharity = 0.obs;
  var totalPointsAvailableInFather = 0.obs;
  var totalPointsAvailableInElder = 0.obs;
  var totalPointsAvailableInPilgrimProgress = 0.obs;
  var totalPointsGainedInBabe = 0.obs;
  var totalPointsGainedInChild = 0.obs;
  var totalPointsGainedInYb = 0.obs;
  var totalPointsGainedInCharity = 0.obs;
  var totalPointsGainedInFather = 0.obs;
  var totalPointsGainedInElder = 0.obs;
  var passOnFirstTrialScore = 0.obs;

  final UserController _userController = Get.put(UserController());

  GetStorage box = GetStorage();

  setSelectedLevel(level) {
    var gameSettings = GetStorage().read('game_settings');
    selectedLevel.value = level;
    durationPerQuestion = int.parse(gameSettings['pilgrim_progress_game_time']);
    getSelectedLevelQuestions(level);
  }

  getLevelId(level){
    switch(level){
      case 'babe':
        return 1;
      case 'child':
        return 2;
      case 'young believer':
        return 3;
      case 'charity':
        return 4;
      case 'father':
        return 5;
      case 'elder':
        return 6;
    }
  }


  getSelectedLevelQuestions(level) async {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    try{
      pilgrimProgressGameLoading(true);
      gameIsReady(false);
      modalTitle.value ='before you play!';
      var levelId = getLevelId(level);
      GetStorage().write('pilgrimProgressLevelId', levelId);
      GetStorage().write('pilgrimProgressSelectedLevel', level);
      var noOfRoundLeft = isLoggedIn ? getNumberOfRoundsLeftPerLevel(level) : getNoOfTrialsPerLevel(level);
      Get.dialog(PilgrimProgressModal(noOfRoundLeft: noOfRoundLeft, totalAvailablePoints: getLevelTotalPoints(level), noOfRoundPerLevel: getNoOfTrialsPerLevel(level),),);
      gameQuestions.value = isLoggedIn ? await GameService.getGameQuestions('PILGRIM_PROGRESS', level, null) : await GameService.getGameQuestionsWithoutToken('PILGRIM_PROGRESS', level, null);
      modalTitle.value = 'ready when you are!';
      pilgrimProgressGameLoading(false);
      gameIsReady(true);
    }catch(e){
      print(e);
    }
  }

  getNumberOfRoundsLeftPerLevel(level){
    switch(level){
      case 'babe':
        return noOfRoundsLeftInBabe.value;
      case 'child':
        return noOfRoundsLeftInChild.value;
      case 'young believer':
        return noOfRoundsLeftInYb.value;
      case 'charity':
        return noOfRoundsLeftInCharity.value;
      case 'father':
        return noOfRoundsLeftInFather.value;
      case 'elder':
        return noOfRoundsLeftInElder.value;
    }
  }

  getNoOfTrialsPerLevel(level){
    switch(level){
      case 'babe':
        return 5;
      case 'child':
        return 4;
      case 'young believer':
        return 3;
      case 'charity':
        return 2;
      case 'father':
        return 2;
      case 'elder':
        return 2;
    }
  }

  int getLevelTotalPoints(level){
    switch(level){
      case 'babe':
        return totalPointsAvailableInBabe.value;
      case 'child':
        return totalPointsAvailableInChild.value;
      case 'young believer':
        return totalPointsAvailableInYb.value;
      case 'charity':
        return totalPointsAvailableInCharity.value;
      case 'father':
        return totalPointsAvailableInFather.value;
      case 'elder':
        return totalPointsAvailableInElder.value;
      default:
        return 0;
    }
  }

  String getPointToUnlockNewLevel(level){
    var gameSettings = box.read('game_settings');
    switch(level){
      case 'babe':
        return (totalPointsAvailableMilkLevels * ((double.parse(gameSettings['percentage_pass_milk_levels']))/100)).toInt().toString();
      case 'child':
        return (totalPointsAvailableMilkLevels * ((double.parse(gameSettings['percentage_pass_milk_levels']))/100)).toInt().toString();
      case 'young believer':
        return (totalPointsAvailableMeatLevels * ((double.parse(gameSettings['percentage_pass_meat_levels']))/100)).toInt().toString();
      case 'charity':
        return (totalPointsAvailableMeatLevels * ((double.parse(gameSettings['percentage_pass_meat_levels']))/100)).toInt().toString();
      case 'father':
        return (totalPointsAvailableStrongMeatLevels * ((double.parse(gameSettings['percentage_pass_strong_meat_levels']))/100)).toInt().toString();
      case 'elder':
        return (totalPointsAvailableStrongMeatLevels * ((double.parse(gameSettings['percentage_pass_strong_meat_levels']))/100)).toInt().toString();
      default:
        return '0';
    }
  }

  getPlayersPoint(level){
    switch(level){
      case 'babe':
        return totalPointsGainedInBabe.toString();
      case 'child':
        return totalPointsGainedInChild.toString();
      case 'young believer':
        return totalPointsGainedInYb.toString();
      case 'charity':
        return totalPointsGainedInCharity.toString();
      case 'father':
        return totalPointsGainedInFather.toString();
      case 'elder':
        return totalPointsGainedInElder.toString();
      default:
        return '0';
    }
  }

  updatePilgrimProgressScore(){
    var gameSettings = box.read('game_settings');
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    if(isLoggedIn){
      var levelId = getLevelId(_userController.myUser['rank']);
      babeProgressLevelValue.value = _userController.userPilgrimProgress[0]['progress'];
      childProgressLevelValue.value = _userController.userPilgrimProgress[1]['progress'];
      babeProgressLevelValue.value >=  1.0 || levelId > 1 ? childLevelIsLocked.value = false : childLevelIsLocked.value = true;
      youngBelieverProgressLevelValue.value = _userController.userPilgrimProgress[2]['progress'];
      childProgressLevelValue.value >= 1.0 ||  levelId > 2 ? youngBelieversLevelIsLocked.value = false : youngBelieversLevelIsLocked.value = true;
      charityProgressLevelValue.value = _userController.userPilgrimProgress[3]['progress'];
      youngBelieverProgressLevelValue.value >= 1.0 || levelId > 3 ? charityLevelIsLocked.value = false : charityLevelIsLocked.value = true;
      fatherProgressLevelValue.value = _userController.userPilgrimProgress[4]['progress'];
      charityProgressLevelValue.value >= 1.0 ||  levelId > 4 ? fatherLevelIsLocked.value = false: fatherLevelIsLocked.value = true;
      elderProgressLevelValue.value = _userController.userPilgrimProgress[5]['progress'];
      fatherProgressLevelValue.value >= 1.0 || levelId > 5 ? elderLevelIsLocked.value = false : elderLevelIsLocked.value = true;
      pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
      totalPointsGainedInBabe.value = (_userController.userPilgrimProgress[0]['progress'] * int.parse(gameSettings['babe_to_child_total'])).toInt();
      totalPointsGainedInChild.value = (_userController.userPilgrimProgress[1]['progress'] * int.parse(gameSettings['child_to_young_believer_total'])).toInt();
      totalPointsGainedInYb.value = (_userController.userPilgrimProgress[2]['progress'] * int.parse(gameSettings['young_believer_to_charity_total'])).toInt();
      totalPointsGainedInCharity.value = (_userController.userPilgrimProgress[3]['progress'] * int.parse(gameSettings['charity_to_father_total'])).toInt();
      totalPointsGainedInFather.value = (_userController.userPilgrimProgress[4]['progress'] * int.parse(gameSettings['father_to_elder_total'])).toInt();
      totalPointsGainedInElder.value = (_userController.userPilgrimProgress[5]['progress'] * int.parse(gameSettings['father_to_elder_total'])).toInt();
      noOfRoundsLeftInBabe.value = (_userController.userPilgrimProgress[0]['numberOfRounds']).toInt();
      noOfRoundsLeftInChild.value = (_userController.userPilgrimProgress[1]['numberOfRounds']).toInt();
      noOfRoundsLeftInYb.value = (_userController.userPilgrimProgress[2]['numberOfRounds']).toInt();
      noOfRoundsLeftInCharity.value = (_userController.userPilgrimProgress[3]['numberOfRounds']).toInt();
      noOfRoundsLeftInFather.value = (_userController.userPilgrimProgress[4]['numberOfRounds']).toInt();
      noOfRoundsLeftInElder.value = (_userController.userPilgrimProgress[5]['numberOfRounds']).toInt();

    }else{
      pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
      babeProgressLevelValue.value >= 1.0 ? childLevelIsLocked.value = false : childLevelIsLocked.value = true;
    }

  }

  setPilgrimData(){
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    var gameSettings = box.read('game_settings');
    totalPointsAvailableInPilgrimProgress.value = int.parse(gameSettings['total_points_available_pilgrim_progress']).toInt();
    totalPointsAvailableInBabe.value = int.parse(gameSettings['babe_to_child_total']).toInt();
    totalPointsAvailableInChild.value =  int.parse(gameSettings['child_to_young_believer_total']).toInt();
    totalPointsAvailableInYb.value =  int.parse(gameSettings['young_believer_to_charity_total']).toInt();
    totalPointsAvailableInCharity.value = int.parse(gameSettings['charity_to_father_total']).toInt();
    totalPointsAvailableInFather.value = int.parse(gameSettings['father_to_elder_total']).toInt();
    totalPointsGainedInElder.value = int.parse(gameSettings['father_to_elder_total']).toInt();
    totalPointsAvailableInElder.value = int.parse(gameSettings['father_to_elder_total']).toInt();
    passOnFirstTrialScore.value = int.parse(gameSettings['pass_on_first_trial_score']);
    if(isLoggedIn){

      var levelId = getLevelId(_userController.myUser['rank']);

      babeProgressLevelValue.value = _userController.userPilgrimProgress[0]['progress'];
      childProgressLevelValue.value = _userController.userPilgrimProgress[1]['progress'];
      babeProgressLevelValue.value >=  1.0 || levelId > 1 ? childLevelIsLocked.value = false : childLevelIsLocked.value = true;
      youngBelieverProgressLevelValue.value = _userController.userPilgrimProgress[2]['progress'];
      childProgressLevelValue.value >= 1.0 ||  levelId > 2 ? youngBelieversLevelIsLocked.value = false : youngBelieversLevelIsLocked.value = true;
      charityProgressLevelValue.value = _userController.userPilgrimProgress[3]['progress'];
      youngBelieverProgressLevelValue.value >= 1.0 || levelId > 3 ? charityLevelIsLocked.value = false : charityLevelIsLocked.value = true;
      fatherProgressLevelValue.value = _userController.userPilgrimProgress[4]['progress'];
      charityProgressLevelValue.value >= 1.0 ||  levelId > 4 ? fatherLevelIsLocked.value = false: fatherLevelIsLocked.value = true;
      elderProgressLevelValue.value = _userController.userPilgrimProgress[5]['progress'];
      fatherProgressLevelValue.value >= 1.0 || levelId > 5 ? elderLevelIsLocked.value = false : elderLevelIsLocked.value = true;
      pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
      totalPointsGainedInBabe.value = (_userController.userPilgrimProgress[0]['progress'] * int.parse(gameSettings['babe_to_child_total'])).toInt();
      totalPointsGainedInChild.value = (_userController.userPilgrimProgress[1]['progress'] * int.parse(gameSettings['child_to_young_believer_total'])).toInt();
      totalPointsGainedInYb.value = (_userController.userPilgrimProgress[2]['progress'] * int.parse(gameSettings['young_believer_to_charity_total'])).toInt();
      totalPointsGainedInCharity.value = (_userController.userPilgrimProgress[3]['progress'] * int.parse(gameSettings['charity_to_father_total'])).toInt();
      totalPointsGainedInFather.value = (_userController.userPilgrimProgress[4]['progress'] * int.parse(gameSettings['father_to_elder_total'])).toInt();
      totalPointsGainedInElder.value = (_userController.userPilgrimProgress[5]['progress'] * int.parse(gameSettings['father_to_elder_total'])).toInt();
      noOfRoundsLeftInBabe.value = (_userController.userPilgrimProgress[0]['numberOfRounds']).toInt();
      noOfRoundsLeftInChild.value = (_userController.userPilgrimProgress[1]['numberOfRounds']).toInt();
      noOfRoundsLeftInYb.value = (_userController.userPilgrimProgress[2]['numberOfRounds']).toInt();
      noOfRoundsLeftInCharity.value = (_userController.userPilgrimProgress[3]['numberOfRounds']).toInt();
      noOfRoundsLeftInFather.value = (_userController.userPilgrimProgress[4]['numberOfRounds']).toInt();
      noOfRoundsLeftInElder.value = (_userController.userPilgrimProgress[5]['numberOfRounds']).toInt();

    }else{
      pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
      babeProgressLevelValue.value >= 1.0 ? childLevelIsLocked.value = false : childLevelIsLocked.value = true;
    }

  }

  @override
  void onInit() {
    super.onInit();
   setPilgrimData();
  }
}
