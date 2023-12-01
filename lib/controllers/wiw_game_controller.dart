
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/whoIsWhoLevel.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../models/whoIsWho.dart';
import '../screens/who_is_who/question_screen.dart';

class WiwGameController extends GetxController with SingleGetTickerProviderMixin{

  dynamic levelDuration = 0;
  var pointPerQuestion = 50;
  dynamic gameQuestions = <WhoIsWho>[].obs;
  var gameLevels = <WhoIsWhoGameLevel>[].obs;
  var isLoadingGameLevel = false.obs;
  var gameDuration = 0.obs;
  GetStorage box = GetStorage();
  final player = AudioPlayer();
  UserController userController = Get.put(UserController());

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  getQuestions() async {
    try {
      gameQuestions = await GameService.getWhoIsWhoQuestions();
      Get.to(() => const WhoIsWhoQuestionScreen());
    } catch (e) {

    }
  }

  getGameLevels() async {
    try{
       isLoadingGameLevel(true);
       gameLevels.value = await GameService.getWhoIsWhoLevels();
       isLoadingGameLevel(false);
    }catch(e){

    }
  }
}