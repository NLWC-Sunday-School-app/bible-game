import 'dart:convert';

import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/leaderboard.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/ads.dart';
import '../models/tags.dart';
import '../models/user.dart';
import 'package:get/get.dart';
import 'base_url_service.dart';

class UserService {
  static var baseUrl = BaseUrlService.baseUrl;
  static GetStorage box = GetStorage();
  static dynamic token = GetStorage().read('user_token');
  static  Map<String, String> headers = {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $token'};
  static  Map<String, String> tokenLessHeader = {'Content-Type': 'application/json', 'accept': 'application/json'};
 static final UserController _userController =  Get.put(UserController());

  static Future<void> getUserData() async{
     var response = await http.get(Uri.parse('$baseUrl/auth/user'),
       headers: headers,
     );
      var encodedResponseData = json.decode(response.body) as Map<String, dynamic>;
     _userController.myUser.value = encodedResponseData;
     box.write('user_data', encodedResponseData);
  }

  static Future<void> getUserDataByToken(token) async {
    var response = await http.get(Uri.parse('$baseUrl/auth/user'),
      headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    var encodedResponseData = json.decode(response.body) as Map<String, dynamic>;
    _userController.myUser.value = encodedResponseData;
    box.write('user_data', encodedResponseData);

  }

  static Future<List<Tags>> getScriptureTags() async{
     var response = await http.get(Uri.parse('$baseUrl/tag'), headers: headers);
     return tagsFromJson(response.body);
  }

  static Future<void> getUserPilgrimProgress() async {
      var response = await http.get(Uri.parse('$baseUrl/user/progress/${_userController.myUser['id']}'), headers: headers);
      if(response.statusCode == 200){
        _userController.userPilgrimProgress.value = json.decode(response.body);
        print( _userController.userPilgrimProgress);
      }

      if(response.statusCode == 400){
        print('error');
         print(response);
      }
  }

  static Future<void> getUserPilgrimProgressByToken(token) async {
    var response = await http.get(Uri.parse('$baseUrl/user/progress/${_userController.myUser['id']}'), headers: {'Content-Type': 'application/json',
    'accept': 'application/json', 'Authorization': 'Bearer $token'},);
    _userController.userPilgrimProgress.value = json.decode(response.body);
    print(_userController.userPilgrimProgress.value);
  }

  static Future<void> getUserGameSettings() async{
    var response = await http.get(Uri.parse('$baseUrl/games/play/settings'), headers: headers);
   var decodedData = json.decode(response.body);
    _userController.userGameSettings.value = decodedData;
    box.write('game_settings', decodedData);
    print( box.read('game_settings'));
  }

  static Future<void> getUserGameSettingsByToken(token) async {
    var response = await http.get(Uri.parse('$baseUrl/games/play/settings'), headers: headers);
    _userController.userGameSettings.value = json.decode(response.body);
  }

  static Future<List<Ads>> getAds() async {
    var response = await http.get(Uri.parse('$baseUrl/ads'), headers: headers);
    return adsFromJson(response.body);
  }

  static Future<List<Leaderboard>> getLeaderboardData(id) async {
    var response = await http.get(Uri.parse('$baseUrl/playlog/leaderboards/$id'), headers: headers);
    return leaderBoardFromJson(response.body);
  }

}

