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

     static Future<dynamic> registerUser(name, email, password, fcmToken, country) async {
       try{
         final response = await DioClient().dio.post('/auth/register', data:{
           'name': name,
           'email': email,
           'password': password,
           'fcmToken': fcmToken,
           'country': country
         });
         return response.statusCode;
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }

     }



     static Future<dynamic> loginUser(email, password) async {
       try{
          final response = await DioClient().dio.post('/auth/login', data:{
            'email': email,
            'password': password
          });
          print('token, ${response.data['token']}');
          print('token, ${response.data['refreshToken']}');
          box.write('user_token', response.data['token']);
          box.write('refresh_token', response.data['refreshToken']);
          return response.statusCode;
       } on DioException catch (e) {
         final errorMessage = DioExceptions.fromDioError(e).toString();
         throw errorMessage;
       }

     }

     static Future<dynamic> refreshToken(refreshToken) async {
       try{
         final response = await DioClient().dio.post('/auth/refresh-token', data:{
           'refreshToken': refreshToken,
         });
         print('token, ${response.data['token']}');
         print(response.data);
         print('token, ${response.data['refreshToken']}');
         box.write('user_token', response.data['token']);
         box.write('refresh_token', response.data['refreshToken']);
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
         return response.statusCode;
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