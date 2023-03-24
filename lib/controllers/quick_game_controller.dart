import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/tags_pill_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../models/question.dart';
import '../services/game_service.dart';
import '../widgets/modals/quick_game_modal.dart';

class QuickGameController extends GetxController {

  var normalIsActive = true.obs;
  var intermediateIsActive = false.obs;
  var hardIsActive = false.obs;
  var durationPerQuestion = 0;
  var modalTitle = 'Preparing your questions...'.obs;
  var gameIsReady = false.obs;
  var gameQuestions = <Question>[].obs;
  var pointsPerQuestion = 0;
  var fullBonusLowerRange = 0;
  var partialBonusLowerRange = 0;
  var partialBonusPoint = 0;
  UserController userController = Get.put(UserController());
  TagsPillController tagsPillController = Get.put(TagsPillController());
  GetStorage box = GetStorage();
  final player = AudioPlayer();

  void selectNormalLevel() {
    userController.soundIsOff.isFalse ? userController.playGameSound() : null;
    normalIsActive(true);
    intermediateIsActive(false);
    hardIsActive(false);
    durationPerQuestion = int.parse(box.read('game_settings')['normal_game_speed']);
  }

  void selectIntermediateLevel() {
    userController.soundIsOff.isFalse ? userController.playGameSound() : null;
    normalIsActive(false);
    intermediateIsActive(true);
    hardIsActive(false);
    durationPerQuestion = int.parse(box.read('game_settings')['intermediate_game_speed']);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  void selectHardLevel() {
    userController.soundIsOff.isFalse ? userController.playGameSound() : null;
    normalIsActive(false);
    intermediateIsActive(false);
    hardIsActive(true);
    durationPerQuestion =  int.parse(box.read('game_settings')['hard_game_speed']);
  }

  prepareQuestions() async {
   try{
     var isLoggedIn = box.read('userLoggedIn') ?? false;
     gameQuestions.value = isLoggedIn ? await GameService.getGameQuestions('QUICK_GAME', userController.myUser['rank'], tagsPillController.selectedPill) :
     await GameService.getGameQuestionsWithoutToken('QUICK_GAME', userController.myUser['rank'], tagsPillController.selectedPill);
     modalTitle.value = 'All set to go 🥳😃';
     gameIsReady(true);
   } catch(e) {
     print(e);
     gameIsReady(false);
   }

   }

  startGame() {
    userController.soundIsOff.isFalse ? userController.playGameSound() : null;
    showDialogModal();
    prepareQuestions();
  }

  showDialogModal() {
    Get.dialog(const QuickGameModal(),
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(30, 30, 30, 0.9));
  }

  setGameSettings(){
    var gameSettings = box.read('game_settings');
    durationPerQuestion = int.parse(gameSettings['normal_game_speed']);
    pointsPerQuestion = int.parse(gameSettings['base_score_pilgrim_progress']);
    fullBonusLowerRange = (0.8 * durationPerQuestion).toInt() ;
    partialBonusLowerRange = (0.6 * durationPerQuestion).toInt() ;
    partialBonusPoint = (0.4 * pointsPerQuestion).toInt();
  }

  @override
  void onInit() {
    super.onInit();
    setGameSettings();
  }
}
