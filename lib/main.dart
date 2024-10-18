import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game_api/api/game_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/fantasy_league/repository/fantasy_league_repository.dart';
import 'package:bible_game/features/four_scriptures/repository/four_scriptures_repository.dart';
import 'package:bible_game/features/global_challenge/repository/global_challenge_repository.dart';
import 'package:bible_game/features/pilgrim_progress/repository/pilgrim_progress_repository.dart';
import 'package:bible_game/features/quick_game/repository/quick_game_repository.dart';
import 'package:bible_game/features/who_is_who/repository/wiw_repository.dart';
import 'package:bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:bible_game/shared/features/settings/sound_manager.dart';
import 'package:bible_game/shared/features/user/repository/user_repository.dart';
import 'package:bible_game_api/api/user_api.dart';
import 'package:bible_game/shared/utils/app_bloc_observer.dart';
import 'package:bible_game/shared/utils/awesome_notification.dart';
import 'package:bible_game/shared/utils/token_notifier.dart';
import 'app.dart';
import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/api/authentication_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  AwesomeNotifications().initialize('resource://drawable/notification_icon', [
    NotificationChannel(
      channelKey: 'game notifications',
      channelName: 'Game Notifications',
      channelDescription: 'Notification channel for notification',
      channelShowBadge: true,
      importance: NotificationImportance.Max,
    ),
  ]);
  await GetStorage.init();
  await AwesomeNotification.initializeRemoteNotifications(
    debug: true,);

  final String? userToken = await GetStorage().read('user_token');
  final ApiClient apiClient = ApiClient(
      baseUrl: 'https://plankton-app-ikxuv.ondigitalocean.app',
      token: userToken ?? '');
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
  final PilgrimProgressRepository pilgrimProgressRepository = PilgrimProgressRepository(gameAPI);
  final WhoIsWhoRepository whoIsWhoRepository = WhoIsWhoRepository(gameAPI);
  final GlobalChallengeRepository globalChallengeRepository = GlobalChallengeRepository(gameAPI);
  final FourScripturesOneWordRepository fourScripturesOneWordRepository = FourScripturesOneWordRepository(gameAPI);
  final FantasyLeagueRepository fantasyLeagueRepository = FantasyLeagueRepository(gameAPI);
  final SoundManager soundManager = SoundManager();
  runApp(App(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
    quickGameRepository: quickGameRepository,
    globalChallengeRepository: globalChallengeRepository,
    pilgrimProgressRepository:  pilgrimProgressRepository,
    fourScripturesOneWordRepository: fourScripturesOneWordRepository,
    fantasyLeagueRepository: fantasyLeagueRepository,
    whoIsWhoRepository : whoIsWhoRepository,
    tokenNotifier: tokenNotifier,
    soundManager: soundManager,
  ));
}
