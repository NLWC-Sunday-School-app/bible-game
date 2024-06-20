import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:the_bible_game/shared/features/user/repository/user_repository.dart';
import 'package:bible_game_api/api/user_api.dart';
import 'package:the_bible_game/shared/utils/token_notifier.dart';
import 'app.dart';
import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/api/authentication_api.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('userToken');

  final ApiClient apiClient = ApiClient(baseUrl: 'https://plankton-app-ikxuv.ondigitalocean.app', token: token ?? '');
  final TokenNotifier tokenNotifier = TokenNotifier();

  tokenNotifier.addListener(() {
    final newToken = tokenNotifier.value;
    if (newToken != null) {
      apiClient.updateToken(newToken);
    }
  });

  final UserAPI userAPI = UserAPI(apiClient);
  final AuthenticationAPI authenticationAPI = AuthenticationAPI(apiClient);
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(authenticationAPI);
  final UserRepository userRepository = UserRepository(userAPI);
  runApp(App(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
    tokenNotifier: tokenNotifier,
  ));
}
