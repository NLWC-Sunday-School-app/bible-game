
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/fourScripturesOneWord.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:get/get.dart';

import '../screens/four_scriptures_one_word/question_screen.dart';

class FourScripturesOneWordController extends GetxController {
  var fourScripturesQuestions = <FourScripturesOneWordQuestion>[].obs;
  var isFetchingQuestions = false.obs;
  UserController userController = Get.put(UserController());
  var gameLevel = 0.obs;
  var totalNoOfQuestions = 0.obs;

  getFourScripturesOneWordQuestions() async{
     try{
       isFetchingQuestions(true);
       var questions = await GameService.getFourScripturesOneWordQuestions(userController.myUser['fourScriptsLevel']);
       fourScripturesQuestions.value = questions;
       isFetchingQuestions(false);
       Get.to(() => const FourScriptureQuestionScreen());
     }catch(e){
       print(e);
     }
  }

  updateGameLevel() async{
   gameLevel.value = gameLevel.value + 1;
    try{
      await GameService.updateUserFourScriptureOneWordLevel(userController.myUser['id'], gameLevel);
      //await userController.getUserData();
    }catch(e){

    }
  }

  getTotalNoOfQuestions() async{
    try{
     var response = await GameService.getTotalNoOfQuestionsInFourScriptures();
     totalNoOfQuestions.value = response;
    }catch(e){

    }
  }

  @override
  void onInit() {
    super.onInit();
    gameLevel.value = userController.myUser['fourScriptsLevel'];
    getTotalNoOfQuestions();
  }
}