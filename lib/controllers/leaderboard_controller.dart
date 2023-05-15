
import 'package:bible_game/models/leaderboard.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/game_service.dart';

class LeaderboardController extends GetxController{

  final leaderboardData = <Leaderboard>[].obs;
  final leaderboardFormattedData = <Leaderboard>[].obs;
  var isLoading = false.obs;
  GetStorage box = GetStorage();


  setLeaderboardData(id) async {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    try {
      isLoading(true);
      leaderboardData.value = <Leaderboard>[].obs;
      leaderboardFormattedData.value = <Leaderboard>[].obs;
      var leaderboardList = isLoggedIn ? await GameService.getGameLeaderBoard(id) : await GameService.getGameLeaderBoardWithoutToken(id);
      leaderboardData.value = leaderboardList;
      leaderboardFormattedData.value = List.from(leaderboardList);
      leaderboardFormattedData.removeRange(0, 3);
      isLoading(false);
    } catch (e) {
      print(e);
      isLoading(false);
    }
  }

  setFourScripturesLeaderboardData() async {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    try {
      isLoading(true);
      var leaderboardList = isLoggedIn ? await GameService.getFourScriptureGameLeaderBoard('FOUR_SCRIPTURES') : await GameService.getFourScriptureGameLeaderBoardWithoutToken('FOUR_SCRIPTURES');
      leaderboardData.value = leaderboardList;
      leaderboardFormattedData.value = List.from(leaderboardList);
      leaderboardFormattedData.removeRange(0, 3);
      isLoading(false);
    } catch (e) {
      print(e);
      isLoading(false);
    }
  }

}