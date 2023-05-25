import 'dart:convert';

import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../controllers/pilgrim_progress_controller.dart';

class AuthService {
     static var baseUrl = BaseUrlService().baseUrl;
     static GetStorage box = GetStorage();
     
     
     static Future<dynamic> registerUser(name, email, password, fcmToken) async {
           var response = await http.post(Uri.parse('$baseUrl/auth/register'),
            headers: BaseUrlService().headers, body: jsonEncode({'name': name, 'email': email, 'password': password, 'fcmToken': fcmToken}));
           if(response.statusCode == 200){
            return 200;
           }else{
             var data = json.decode(response.body);
             return data['errors'][0];
           }
     }

     static Future<dynamic> loginUser(email, password) async {
          var response = await http.post(Uri.parse('$baseUrl/auth/login'),
           headers: BaseUrlService().headers, body:  jsonEncode({'email': email, 'password': password}));
          var responseData = json.decode(response.body);
          if(response.statusCode == 200){
            final data = json.decode(response.body) as Map<String, dynamic>;
            await box.write('user_token', data['token']);
            var isTempLoggedIn = GetStorage().read('isTempLoggedIn') ?? false ;
            await UserService.getUserDataByToken( data['token']);
            await UserService.getUserPilgrimProgressByToken(data['token']);
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

            }else{
              await UserService.getUserPilgrimProgressByToken(data['token']);
            }
            return 200;
          }else{
            var data = json.decode(response.body);

            return data['errors'][0];
          }
     }

     static Future<dynamic>sendForgotPasswordMail(emailAddress) async {
         GetStorage().write('reset_email', emailAddress);
         var response = await http.get(Uri.parse('$baseUrl/auth/forgot-password?email=$emailAddress'),
             headers: BaseUrlService().headers
         );
         if(response.statusCode == 200){
           return 200;
         }else{
           var data = json.decode(response.body);
           return data['errors'][0];
         }
     }

     static Future<dynamic>verifyOTP(code) async{
         var email = GetStorage().read('reset_email');
         var response = await http.post(Uri.parse('$baseUrl/auth/verify-email-otp'),
          headers: BaseUrlService().headers, body: jsonEncode({'code': code, 'email': email})
         );
           var data = json.decode(response.body);
           return data;
     }

     static Future<dynamic>resetPassword(newPassword) async{
       var email = GetStorage().read('reset_email');
       var response = await http.post(Uri.parse('$baseUrl/auth/reset-password'),
           headers: BaseUrlService().headers, body: jsonEncode({'newPassword': newPassword, 'email': email})
       );
       var data = json.decode(response.body);
       return data;
     }

     static Future<int> loginOutUser() async {
       var response = await http.get(Uri.parse('$baseUrl/auth/logout'),
           headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer ${box.read('user_token')}'});

        if(response.statusCode == 200){
           return 200;
        }else{
           return 400;
        }
     }

     static Future<int> deleteUserAccount(id)async {
       var response = await http.delete(Uri.parse('$baseUrl/users/$id'), headers: {'Content-Type': 'application/json', 'accept': 'application/json', 'Authorization': 'Bearer ${box.read('user_token')}'});
       if(response.statusCode == 200){
         print(response);
         return 200;
       }
       return 200;
     }

}