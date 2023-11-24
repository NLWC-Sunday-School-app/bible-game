import 'dart:convert';

import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../controllers/pilgrim_progress_controller.dart';
import '../utilities/dio_client.dart';
import '../utilities/dio_exceptions.dart';

class AuthService {
     static GetStorage box = GetStorage();
     
     
     static Future<dynamic> registerUser(name, email, password, fcmToken) async {
       try{
          final response = await DioClient().dio.post('/auth/register', data: {
            'name': name,
            'email': email,
            'password': password,
            'fcmToken': fcmToken
          });
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }
     }



     static Future<dynamic> loginUser(email, password) async {
          // var response = await http.post(Uri.parse('$baseUrl/auth/login'),
          //  headers: BaseUrlService().headers, body:  jsonEncode({'email': email, 'password': password}));
          // var responseData = json.decode(response.body);
          // if(response.statusCode == 200){
          //   final data = json.decode(response.body) as Map<String, dynamic>;
          //   await box.write('user_token', data['token']);
          //   var isTempLoggedIn = GetStorage().read('isTempLoggedIn') ?? false ;
          //   await UserService.getUserDataByToken( data['token']);
          //   await UserService.getUserPilgrimProgressByToken(data['token']);
          //   if(isTempLoggedIn){
          //      var userData = GetStorage().read('user_data');
          //      var gameData = GetStorage().read('tempProgressData');
          //      var userId = userData['id'];
          //      await GameService.sendGameDataByToken(
          //        gameData['gameMode'],
          //        gameData['totalScore'],
          //        gameData['baseScore'],
          //        gameData['bonusScore'],
          //        gameData['averageTimeSpent'],
          //        gameData['playerRank'],
          //        gameData['noOfCorrectAnswers'],
          //        userId,
          //        gameData['userProgress'],
          //         gameData['numberOfRounds'],
          //        data['token'],
          //      );
          //
          //   }else{
          //     await UserService.getUserPilgrimProgressByToken(data['token']);
          //   }
          //   return 200;
          // }else{
          //   var data = json.decode(response.body);
          //
          //   return data['errors'][0];
          // }

       try{
          final response = await DioClient().dio.post('/auth/login', data:{
            'email': email,
            'password': password
          });
          return response.statusCode;
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }

     }

     static Future<dynamic>sendForgotPasswordMail(emailAddress) async {
       try{
         final response = await DioClient().dio.get('/auth/forgot-password?email=$emailAddress');
          return response.statusCode;
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }

     }

     static Future<dynamic>verifyOTP(code) async{
         var email = GetStorage().read('reset_email');
       try{
         final response = await DioClient().dio.post('/auth/verify-email-otp', data: {
           'code': code, 'email': email
         });
         return response.statusCode;
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }
     }

     static Future<dynamic>resetPassword(newPassword) async{
       var email = GetStorage().read('reset_email');
       try{
         final response = await DioClient().dio.post('/auth/reset-password', data: {
           'newPassword': newPassword,
           'email': email
         });
         return response.statusCode;
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }

     }

     static Future<dynamic> loginOutUser() async {
       try{
         final response = await DioClient().dio.get('/auth/logout');
         return response;
       }on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }
     }

     static Future<dynamic> deleteUserAccount(id)async {
       try{
          final response = await DioClient().dio.get('/users/$id');
          return response;
       }on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }
     }

}