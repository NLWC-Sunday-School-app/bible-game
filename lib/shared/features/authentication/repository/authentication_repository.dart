import 'package:bible_game_api/api/authentication_api.dart';

class AuthenticationRepository {
  final AuthenticationAPI authenticationAPI;

  AuthenticationRepository(this.authenticationAPI);

  Future<bool> register(String name, String email, String password,
      String fcmToken, String country) async {
    return await authenticationAPI.register(
      name,
      email,
      password,
      fcmToken,
      country,
    );
  }

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    return await authenticationAPI.login(email.trim(), password.trim());
  }

  Future<bool> refreshToken(refreshToken) async {
    return await authenticationAPI.refreshToken(refreshToken);
  }

  Future<bool> verifyOTP(code, email) async {
    return await authenticationAPI.verifyOTP(code, email);
  }

  Future<bool> logOut() async {
    return await authenticationAPI.logout();
  }

  Future<dynamic> sendForgotPasswordMail(email) async{
     return await authenticationAPI.sendForgotPasswordMail(email);
  }

  Future<dynamic> resetPassword(newPassword, email) async {
    return await authenticationAPI.resetPassword(newPassword, email);
  }


}
