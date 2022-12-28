import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/question.dart';
import 'package:bible_game/services/game_service.dart';
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
  var selectedLevel = ''.obs;
  var durationPerQuestion = 20;
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
  final UserController _userController = Get.put(UserController());
  GetStorage box = GetStorage();

  setSelectedLevel(level) {
    selectedLevel.value = level;
    var gameSettings = GetStorage().read('game_settings');
    switch (level) {
      case 'babe':
        durationPerQuestion = int.parse(gameSettings['normal_game_speed']);
        break;
      case 'child':
        durationPerQuestion = int.parse(gameSettings['normal_game_speed']);
        break;
      case 'young believer':
        durationPerQuestion = int.parse(gameSettings['intermediate_game_speed']);
        break;
      case 'charity':
        durationPerQuestion = int.parse(gameSettings['intermediate_game_speed']);
        break;
      case 'father':
        durationPerQuestion = int.parse(gameSettings['hard_game_speed']);
        break;
      case 'elder':
        durationPerQuestion =int.parse(gameSettings['hard_game_speed']);
        break;
      default:
        break;
    }
    getSelectedLevelQuestions(level);
  }

  getSelectedLevelQuestions(level) async {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    try{
      pilgrimProgressGameLoading(true);
      Get.dialog(Dialog(
        backgroundColor: Colors.transparent,

        child: Center(
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const AutoSizeText(
                'Preparing your questions...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              )),
        ),
      ));
      gameQuestions.value = isLoggedIn ? await GameService.getGameQuestions('PILGRIM_PROGRESS', level, null) : await GameService.getGameQuestionsWithoutToken('PILGRIM_PROGRESS', level, null);
      pilgrimProgressGameLoading(false);
      Get.back();
      Get.to(() => const PilgrimProgressQuestionScreen(),
          transition: Transition.rightToLeftWithFade);
    }catch(e){
      print(e);
    }
  }

  setPilgrimData(){
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    var gameSettings = box.read('game_settings');
    print(isLoggedIn);
    print(gameSettings);
    if(isLoggedIn){
      babeProgressLevelValue.value = _userController.userPilgrimProgress[0]['progress'];
      childProgressLevelValue.value = _userController.userPilgrimProgress[1]['progress'];
      babeProgressLevelValue.value >= (double.parse(gameSettings['percentage_pass_milk_levels']))/100 ? childLevelIsLocked.value = false : childLevelIsLocked.value = true;
      youngBelieverProgressLevelValue.value = _userController.userPilgrimProgress[2]['progress'];
      childProgressLevelValue.value > (double.parse(gameSettings['percentage_pass_milk_levels']))/100 ? youngBelieversLevelIsLocked.value = false : youngBelieversLevelIsLocked.value = true;
      charityProgressLevelValue.value = _userController.userPilgrimProgress[3]['progress'];
      youngBelieverProgressLevelValue.value >(double.parse(gameSettings['percentage_pass_meat_levels']))/100 ? charityLevelIsLocked.value = false : charityLevelIsLocked.value = true;
      fatherProgressLevelValue.value = _userController.userPilgrimProgress[4]['progress'];
      charityProgressLevelValue.value > (double.parse(gameSettings['percentage_pass_meat_levels']))/100 ? fatherLevelIsLocked.value = false: fatherLevelIsLocked.value = true;
      elderProgressLevelValue.value = _userController.userPilgrimProgress[5]['progress'];
      fatherProgressLevelValue.value > (double.parse(gameSettings['percentage_pass_strong_meat_levels']))/100 ? elderLevelIsLocked.value = false : elderLevelIsLocked.value = true;
      pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
      fullBonusLowerRange = (0.8 * durationPerQuestion).toInt() ;
      partialBonusLowerRange = (0.6 * durationPerQuestion).toInt() ;
      partialBonusPoint = (0.4 * pointsPerQuestion).toInt();
    }else{
      pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
      babeProgressLevelValue.value >= (double.parse(gameSettings['percentage_pass_milk_levels']))/100 ? childLevelIsLocked.value = false : childLevelIsLocked.value = true;
    }

  }

  @override
  void onInit() {
    super.onInit();
   setPilgrimData();
  }
}
