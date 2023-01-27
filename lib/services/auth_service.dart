import 'dart:convert';

import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
     static var baseUrl = BaseUrlService.baseUrl;
     static Map<String, String> header = {'Content-Type': 'application/json', 'accept': 'application/json'};
     static GetStorage box = GetStorage();
     
     
     static Future<int> registerUser(name, email, password, fcmToken) async {
           var response = await http.post(Uri.parse('$baseUrl/auth/register'),
            headers: header, body: jsonEncode({'name': name, 'email': email, 'password': password, 'fcmToken': fcmToken}));
           if(response.statusCode == 200){
            return 200;
           }else if(response.statusCode == 400){
             return 400;
           }else{
             return 500;
           }

     }

     static Future<int> loginUser(email, password) async {
          var response = await http.post(Uri.parse('$baseUrl/auth/login'),
           headers: header, body:  jsonEncode({'email': email, 'password': password}));
          if(response.statusCode == 200){
            final data = json.decode(response.body) as Map<String, dynamic>;
            await box.write('user_token', data['token']);
            print(data['token']);
            var isTempLoggedIn = GetStorage().read('isTempLoggedIn') ?? false ;
            await UserService.getUserDataByToken( data['token']);
            if(isTempLoggedIn){
               var userData = GetStorage().read('user_data');
               var gameData = GetStorage().read('tempProgressData');
               var userId = userData['id'];
               await GameService.sendGameDataByToken(
                 gameData['gameMode'],
                 gameData['totalScore'],
                 gameData['baseScore'],
                 gameData['bonusScore'],
                 gameData['averageTimeSpent'],
                 gameData['playerRank'],
                 gameData['noOfCorrectAnswers'],
                 userId,
                 gameData['userProgress'],
                  gameData['numberOfRounds'],
                 data['token'],
               );
               await UserService.getUserPilgrimProgressByToken(data['token']);
               print(GetStorage().read('user_data'));
               print(userId);
            }else{
              await UserService.getUserPilgrimProgressByToken(data['token']);
            }
            return 200;
          }else if(response.statusCode == 400){
             return 400;
          }else{
            return 500;
          }
     }

     static Future<int> loginOutUser() async {
       var response = await http.get(Uri.parse('$baseUrl/auth/logout'), headers: header);
        if(response.statusCode == 200){
           return 200;
        }else{
           return 400;
        }
     }


}