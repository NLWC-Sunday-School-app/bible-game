import 'package:bible_game_api/api/game_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/features/quick_game/repository/quick_game_repository.dart';
import 'package:the_bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:the_bible_game/shared/features/settings/sound_manager.dart';
import 'package:the_bible_game/shared/features/user/repository/user_repository.dart';
import 'package:bible_game_api/api/user_api.dart';
import 'package:the_bible_game/shared/utils/app_bloc_observer.dart';
import 'package:the_bible_game/shared/utils/token_notifier.dart';
import 'app.dart';
import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/api/authentication_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('userToken');

  final ApiClient apiClient = ApiClient(
      baseUrl: 'https://plankton-app-ikxuv.ondigitalocean.app',
      token: token ?? '');
  final TokenNotifier tokenNotifier = TokenNotifier();

  tokenNotifier.addListener(() {
    final newToken = tokenNotifier.value;
    if (newToken != null) {
      apiClient.updateToken(newToken);
    }
  });

  final UserAPI userAPI = UserAPI(apiClient);
  final AuthenticationAPI authenticationAPI = AuthenticationAPI(apiClient);
  final GameAPI gameAPI = GameAPI(apiClient);
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(authenticationAPI);
  final UserRepository userRepository = UserRepository(userAPI);
  final QuickGameRepository quickGameRepository = QuickGameRepository(gameAPI);
  final SoundManager soundManager = SoundManager();
  runApp(App(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
    quickGameRepository: quickGameRepository,
    tokenNotifier: tokenNotifier,
    soundManager: soundManager,
  ));
}
