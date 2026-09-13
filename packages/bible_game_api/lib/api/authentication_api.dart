import 'dart:convert';

import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/utils/api_exception.dart';

class AuthenticationAPI {
  final ApiClient apiClient;

  AuthenticationAPI(this.apiClient);

  /// Dio hands back whatever it managed to parse: a String when the body is
  /// not JSON, or is JSON served under a non-JSON content type. Returning that
  /// straight out of a Future<Map<String, dynamic>> throws
  /// "type 'String' is not a subtype of type 'Map<String, dynamic>'" before the
  /// caller ever sees the response.
  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        // Not JSON at all -- fall through and surface it as a message.
      }
      return {'message': data};
    }
    return {'message': data?.toString() ?? ''};
  }

  Future<bool> register(name, email, password, fcmToken, country, String deviceName, String deviceOs) async {
    try {
      final response = await apiClient.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'fcmToken': fcmToken,
        'country': country,
        'deviceName': deviceName,
        'deviceOs': deviceOs,
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } on ApiException catch (e) {
      ApiException.errorMessage = e.message['error'] ?? e.message['message'] ?? 'Registration failed';
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(email, password, deviceName, deviceOs) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'deviceName': deviceName,
          'deviceOs': deviceOs
        },
      );
      return _asMap(response.data);
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<Map<String, dynamic>> refreshToken(refreshToken) async {
    try {
      final response = await apiClient.post('/auth/refresh-token', data: {
        'refreshToken': refreshToken,
      });
      return _asMap(response.data);
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
      return response.statusCode == 200;
    } on ApiException catch (_) {
      return false;
    } finally {
      // The interceptor attaches the bearer token to EVERY request, including
      // /auth/login, and nothing ever cleared it. After logging out the token
      // is revoked server-side but kept being sent, so the next login went out
      // carrying a dead credential. Cleared even when the call fails: the user
      // asked to log out, so the local credential goes either way.
      apiClient.updateToken('');
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
