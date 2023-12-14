import 'dart:convert';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/leaderboard.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/ads.dart';
import '../models/tags.dart';
import 'package:get/get.dart';
import '../utilities/dio_client.dart';
import '../utilities/dio_exceptions.dart';
import 'base_url_service.dart';

class UserService {

  static GetStorage box = GetStorage();

 static final UserController _userController =  Get.put(UserController());

  static Future<void> getUserData() async{
    try{
       final response = await DioClient().dio.get('/auth/user');
       _userController.myUser.value = response.data;
       print('userd data ${response.data}');
       box.write('user_data', response.data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> updateProfile(id, newUsername) async {
    try{
      final response = await DioClient().dio.patch('/users/$id/username?newName=$newUsername');
      return response.statusCode;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> updatePlayerRank(id, newRank) async {
    try{
      final response = await DioClient().dio.patch('/users/$id/rank?newRank=$newRank');
      return response.statusCode;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> updateUserFcmToken(token) async {
    try{
      final response = await DioClient().dio.patch('/users/fcm-token?newToken=$token');
      return response.statusCode;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // static Future<void> getUserDataByToken(token) async {
  //   var response = await http.get(Uri.parse('$baseUrl/auth/user'),
  //     headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $token'},
  //   );
  //   if(response.statusCode == 500){
  //       AuthController().logoutUser();
  //   }
  //   var encodedResponseData = json.decode(response.body) as Map<String, dynamic>;
  //   _userController.myUser.value = encodedResponseData;
  //   box.write('user_data', encodedResponseData);
  // }

  static Future<List<Tags>> getScriptureTags() async{
     try{
       final response = await DioClient().dio.get('/tag');
       final tags = (response.data as List)
             .map((e) => Tags.fromJson(e))
             .toList();
       return tags;
     }on DioException catch (e) {
       final errorMessage = DioExceptions.fromDioError(e).toString();
       throw errorMessage;
     }
  }

  static Future<void> getUserPilgrimProgress() async{
    try{
       final response = await DioClient().dio.get('/user/progress/${_userController.myUser['id']}');
       _userController.userPilgrimProgress.value = response.data;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<void> initializeWallet() async{
    try{
      final response = await DioClient().dio.get('/store/wallet/initialize');
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  // static Future<void> getUserPilgrimProgressByToken(token) async{
  //   // var response = await http.get(Uri.parse('$baseUrl/user/progress/${_userController.myUser['id']}'), headers: {'Content-Type': 'application/json',
  //   // 'accept': 'application/json', 'Authorization': 'Bearer $token'},);
  //   // _userController.userPilgrimProgress.value = json.decode(response.body);
  //   // print('progress by token: ${response.body}');
  //   try{
  //      final response = await DioClient().dio.get('/user/progress/${_userController.myUser['id']}');
  //   }on DioException catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     throw errorMessage;
  //   }
  // }

  static Future<void> getUserGameSettings() async{
    try{
       final response = await DioClient().dio.get('/games/play/settings');
       _userController.userGameSettings.value = response.data;
       box.write('game_settings', response.data);
       print('game setting: ${response.data}');
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // static Future<void> getUserGameSettingsByToken(token) async {
  //   var response = await http.get(Uri.parse('$baseUrl/games/play/settings'), headers:  BaseUrlService().headers);
  //   _userController.userGameSettings.value = json.decode(response.body);
  // }

  static Future<List<Ads>> getAds() async {
     try{
        final response = await DioClient().dio.get('/ads');
        final ads = (response.data as List)
             .map((e) => Ads.fromJson(e))
             .toList();
        return ads;
     }on DioException catch (e) {
       final errorMessage = DioExceptions.fromDioError(e).toString();
       throw errorMessage;
     }
  }

  static Future<List<Leaderboard>> getLeaderboardData(id) async {
    try{
       final response = await DioClient().dio.get('/playlog/leaderboards/$id');
       final leaderBoard = (response.data as List)
             .map((e) => Leaderboard.fromJson(e))
              .toList();
       return leaderBoard;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<dynamic> getUserCountryStatus() async{
    try{
      final response = await DioClient().dio.get('/users/country-check');
       return response.data;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> updateCountry(country) async{
    try{
      final response = await DioClient().dio.patch('/users/country?country=$country');
      return response.data;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }


}

