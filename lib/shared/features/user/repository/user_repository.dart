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

  Future<bool> updatePlayerRank(id, newRank) async {
    return await userAPI.updatePlayerRank(id, newRank);
  }

  Future<dynamic> updateUserFCMToken(token) async {
    return await userAPI.updateFCMToken(token);
  }

  Future<List<PilgrimProgressLevelData>> getUserPilgrimProgressData(
      userId) async {
    return await userAPI.getUserPilgrimProgress(userId);
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
}
