import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/utils/api_exception.dart';

class AuthenticationAPI {
  final ApiClient apiClient;

  AuthenticationAPI(this.apiClient);

  Future<bool> register(name, email, password, fcmToken, country) async {
    try {
      final response = await apiClient.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'fcmToken': fcmToken,
        'country': country
      });
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> login(email, password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<Map<String, dynamic>> refreshToken(refreshToken) async {
    try {
      final response = await apiClient.post('/auth/refresh-token', data: {
        'refreshToken': refreshToken,
      });
      return response.data;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<bool> verifyOTP(code, email) async {
    try {
      final response = await apiClient
          .post('/auth/verify-email-otp', data: {'code': code, 'email': email});
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<bool> sendForgotPasswordMail(emailAddress) async {
    try {
      final response =
          await apiClient.get('/auth/forgot-password?email=$emailAddress');
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }


  Future<bool> resetPassword(newPassword, email) async {
    try {
      final response = await apiClient.post('/auth/reset-password',
          data: {'newPassword': newPassword, 'email': email});
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await apiClient.get('/auth/logout');
      var test =  response.statusCode == 200;
      return test;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount(userId) async {

    try {
      final response = await apiClient.get('/users/$userId');
      print('');
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }
}
