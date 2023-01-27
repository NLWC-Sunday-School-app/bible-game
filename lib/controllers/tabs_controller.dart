

import 'package:bible_game/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

class TabsController extends GetxController{
   var selectedTabIndex = GetStorage().read('tabIndex');
   UserController userController = Get.put(UserController());
   final player = AudioPlayer();

   void selectPage(int index){
     if(userController.soundIsOff.isFalse){
       player.setAsset('assets/audios/select_tab.mp3');
       player.play();
     }
     GetStorage().write('tabIndex', index);
     selectedTabIndex = index;
   }

   @override
   void dispose() {
     super.dispose();
     player.dispose();
   }
}