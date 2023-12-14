
import 'package:bible_game/models/leaderboard.dart';
import 'package:get/get.dart';

import '../models/games.dart';
import '../models/globalLeaderboard.dart';
import '../services/game_service.dart';

class GlobalGamesController extends GetxController{
   var globalGames = <GlobalGames>[].obs;
   var isFetchingGames = false.obs;
   var globalGamesLeaderBoard = <GlobalLeaderboard>[].obs;
   var isFetchingGamesLeaderboard = false.obs;

   getGlobalGames()async{
      try{
        isFetchingGames(true);
       var games =  await GameService.getGlobalGames();
        globalGames.value = games;
       isFetchingGames(false);
      }catch(e){

      }
   }
   getGlobalGamesWithoutLoader()async{
     try{
       var games =  await GameService.getGlobalGames();
       globalGames.value = games;
     }catch(e){

     }
   }

   getGlobalGameLeaderboard(campaignType) async{
     try{
       isFetchingGamesLeaderboard(true);
       var leaderBoard = await GameService.getGlobalGameLeaderBoard(campaignType);
       globalGamesLeaderBoard.value = leaderBoard;
       isFetchingGamesLeaderboard(false);
     }catch(e){
       print(e);
     }
   }

   @override
   void onInit() {
      super.onInit();
     getGlobalGames();
   }
}