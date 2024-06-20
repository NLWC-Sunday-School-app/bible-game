import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/model/pilgrim_progress_level_data.dart';
import 'package:bible_game_api/model/user.dart';
import 'package:bible_game_api/model/user_recap.dart';
import '../model/game_ads.dart';
import '../utils/api_exception.dart';

class UserAPI {
  final ApiClient apiClient;

  UserAPI(this.apiClient);

  Future<User> fetchUserData() async {
    try {
      final response = await apiClient.get('/auth/user');
      return User.fromJson(response.data);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> updateProfile(id, newUsername) async {
    try {
      final response = await apiClient
          .patch('/users/$id/username?newName=$newUsername', data: {});
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> updatePlayerRank(id, newRank) async {
    try {
      final response =
          await apiClient.patch('/users/$id/rank?newRank=$newRank', data: {});
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<dynamic> updateFCMToken(token) async {
    try {
      final response =
          await apiClient.patch('/users/fcm-token?newToken=$token', data: {});
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<PilgrimProgressLevelData>> getUserPilgrimProgress(userId) async {
    try {
      final response = await apiClient.get('/user/progress/$userId');
     final progressData =  (response.data as List).map((e) => PilgrimProgressLevelData.fromJson(e)).toList();
     return progressData;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> initializeWallet() async {
    try {
      final response = await apiClient.get('/store/wallet/initialize');
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getGamePlaySettings() async {
    try {
      final response = await apiClient.get('/games/play/settings');
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GameAds>> getAds() async {
    try {
      final response = await apiClient.get('/ads');
      final ads =
          (response.data as List).map((e) => GameAds.fromJson(e)).toList();
      return ads;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<dynamic> getCountryStatus() async {
    try {
      final response = await apiClient.get('/users/country-check');
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<dynamic> updateCountry(country) async {
    try {
      final response =
          await apiClient.patch('/users/country?country=$country', data: {});
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> getYearRecap(userId) async {
    try {
      final response = await apiClient.get('/users/recap?id=$userId');
       return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }
}
