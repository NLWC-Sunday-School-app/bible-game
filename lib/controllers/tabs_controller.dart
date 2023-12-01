

import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/tabs/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

class TabsController extends GetxController{
   var selectedTabIndex = GetStorage().read('tabIndex');
   UserController userController = Get.put(UserController());
   final player = AudioPlayer();
   var homeTabIsSelected = true.obs;
   var storeTabIsSelected = false.obs;
   var leaderboardTabIsSelected = false.obs;
   var arcadeTabIsSelected = false.obs;
   var teamTabIsSelected = false.obs;

   selectHomeTab (){
     homeTabIsSelected.value = true;
     storeTabIsSelected.value = false;
     leaderboardTabIsSelected.value = false;
     arcadeTabIsSelected.value = false;
     teamTabIsSelected.value = false;
     // Get.to(() => const TabHomeScreen());
   }

   selectStoreTab (){
     homeTabIsSelected.value = false;
     storeTabIsSelected.value = true;
     leaderboardTabIsSelected.value = false;
     arcadeTabIsSelected.value = false;
     teamTabIsSelected.value = false;
     // Get.to(() => const TabHomeScreen());
   }

   selectLeaderboardTab (){
     homeTabIsSelected.value = false;
     storeTabIsSelected.value = false;
     leaderboardTabIsSelected.value = true;
     arcadeTabIsSelected.value = false;
     teamTabIsSelected.value = false;
     // Get.to(() => const TabHomeScreen());
   }

   selectTeamTab (){
     homeTabIsSelected.value = false;
     storeTabIsSelected.value = false;
     leaderboardTabIsSelected.value = false;
     arcadeTabIsSelected.value = false;
     teamTabIsSelected.value = true;
     // Get.to(() => const TabHomeScreen());
   }

   selectArcadeTab (){
     homeTabIsSelected.value = false;
     storeTabIsSelected.value = false;
     leaderboardTabIsSelected.value = false;
     arcadeTabIsSelected.value = true;
     teamTabIsSelected.value = false;
     // Get.to(() => const TabHomeScreen());
   }

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