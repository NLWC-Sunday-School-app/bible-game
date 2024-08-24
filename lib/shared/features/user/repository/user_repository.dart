import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/pilgrim_progress_level_data.dart';

class UserRepository {
  final UserAPI userAPI;

  UserRepository(this.userAPI);

  Future<User> getUser() async {
    return await userAPI.fetchUserData();
  }

  Future<bool> updateUserProfile(id, newUsername) async {
    return await userAPI.updateProfile(id, newUsername);
  }



  Future<dynamic> updateUserFCMToken(token) async {
    return await userAPI.updateFCMToken(token);
  }


  Future<bool> initializeUserWallet() async {
    return await userAPI.initializeWallet();
  }

  Future<Map<String, dynamic>> getUserGamePlaySettings() async {
    return await userAPI.getGamePlaySettings();
  }

  Future<List<GameAds>> getAds() async {
    return await userAPI.getAds();
  }

  Future<dynamic> getUserCountryStatus() async {
    return await userAPI.getCountryStatus();
  }

  Future<dynamic> updateUserCountry(country) async {
    return await userAPI.updateCountry(country);
  }

  Future<Map<String, dynamic>> getUserYearlyRecap(userId) async {
    return await userAPI.getYearRecap(userId);
  }

  Future<List<Leaderboard>>getGlobalLeaderBoard(bool isLoggedIn) async{
    return await userAPI.getGlobalLeaderBoard(isLoggedIn);
  }

  Future<List<Leaderboard>>getCountryLeaderBoard(countryName) async{
    return await userAPI.getCountryLeaderBoard(countryName);
  }

  Future<Map<String, dynamic>> getStreakDetails(userId) async {
    return await userAPI.getStreakDetails(userId);
  }

  Future<void>  purchaseGem (userId, quantity) async{
    return await userAPI.purchaseGem(userId, quantity);
  }

  Future<void>  restoreStreak (userId) async{
    return await userAPI.restoreStreak(userId);
  }

  Future<void> onboardCollaborator (userId) async{
    return await userAPI.onboardCollaborator(userId);
  }

  Future<void> updateCountry (country) async{
    return await userAPI.updateCountry(country);
  }

}
