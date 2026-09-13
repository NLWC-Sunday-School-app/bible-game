import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bible_game_api/api/game_api.dart';
import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, debugPrint;
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
import 'package:bible_game/shared/utils/offline_sync_queue.dart';
import 'package:bible_game_api/api/user_api.dart';
import 'package:bible_game/shared/utils/app_bloc_observer.dart';
import 'package:bible_game/shared/utils/awesome_notification.dart';
import 'package:bible_game/shared/utils/devotional_notification.dart';
import 'package:bible_game/shared/utils/hourly_verse_notification.dart';
import 'package:bible_game/shared/utils/token_notifier.dart';
import 'package:bible_game/features/multi_player/repository/multiplayer_repository.dart';
import 'package:bible_game/features/lightning_mode/repository/lightning_mode_repository.dart';
import 'app.dart';
import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/api/multiplayer_api.dart';
import 'package:bible_game_api/api/authentication_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debug only: the observer prints every event, transition and change, and
  // the larger states (PilgrimProgressState has 33 props, QuickGameState 30)
  // stringify into kilobytes on each emit. That is pure overhead in release,
  // and keeps anything a state or event happens to carry out of device logs.
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  // Notifications and Firebase are mobile-only (not supported on web)
  if (!kIsWeb) {
    AwesomeNotifications().initialize('resource://drawable/notification_icon', [
      NotificationChannel(
        channelKey: 'game notifications',
        channelName: 'Game Notifications',
        channelDescription: 'Notification channel for notification',
        channelShowBadge: true,
        importance: NotificationImportance.Max,
      ),

      DevotionalNotification.channel,

      HourlyVerseNotification.channel,

    ]);

    // Reset the app badge count whenever the app starts
    AwesomeNotifications().resetGlobalBadge();

    unawaited(_scheduleLocalNotifications());
  }

  // GetStorage uses path_provider internally. On iOS hot restart the Pigeon
  // channel can be momentarily unavailable — retry once if it fails.
  try {
    await GetStorage.init();
  } catch (_) {
    await Future.delayed(const Duration(milliseconds: 400));
    await GetStorage.init();
  }

  final String? userToken = await GetStorage().read('user_token');
  final ApiClient apiClient = ApiClient(
      baseUrl: 'https://api.biblegame.nlwc.church',
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
  final MultiplayerAPI multiplayerAPI = MultiplayerAPI(apiClient);
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(authenticationAPI);
  final UserRepository userRepository = UserRepository(userAPI);
  final QuickGameRepository quickGameRepository = QuickGameRepository(gameAPI);
  final PilgrimProgressRepository pilgrimProgressRepository = PilgrimProgressRepository(gameAPI);
  final WhoIsWhoRepository whoIsWhoRepository = WhoIsWhoRepository(gameAPI);
  final GlobalChallengeRepository globalChallengeRepository = GlobalChallengeRepository(gameAPI);
  final FourScripturesOneWordRepository fourScripturesOneWordRepository = FourScripturesOneWordRepository(gameAPI);
  final FantasyLeagueRepository fantasyLeagueRepository = FantasyLeagueRepository(gameAPI);
  final MultiplayerRepository multiplayerRepository = MultiplayerRepository(multiplayerAPI, gameAPI);
  final LightningModeRepository lightningModeRepository = LightningModeRepository(multiplayerAPI);
  final SoundManager soundManager = SoundManager();
  final OfflineSyncQueue offlineSyncQueue = OfflineSyncQueue();
  // Firebase/FCM deliberately does NOT gate the first frame. It awaits
  // Firebase.initializeApp() plus FCM registration, and on a cold device --
  // Play Services still starting, no network -- that can stall for minutes,
  // stranding the user on the native launch screen with no way forward.
  // Started after runApp instead; getFirebaseMessagingToken() awaits the same
  // future, so login still gets a token.
  if (!kIsWeb) {
    unawaited(AwesomeNotification.initializeRemoteNotifications(
      debug: kDebugMode,
    ).catchError((e) => debugPrint('⚠️ Remote notifications unavailable: $e')));
  }

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
    gameAPI: gameAPI,
    offlineSyncQueue: offlineSyncQueue,
    multiplayerRepository: multiplayerRepository,
    lightningModeRepository: lightningModeRepository,
    apiBaseUrl: apiClient.baseUrl,
  ));
}

/// Scheduling throws INSUFFICIENT_PERMISSIONS until the user grants the
/// notification permission, which is requested from the widget tree well after
/// this runs. These are fire-and-forget, so without a catch every cold start
/// logged an unhandled PlatformException.
Future<void> _scheduleLocalNotifications() async {
  try {
    // Daily devotional at 8 AM, plus the hourly lock screen verses.
    await DevotionalNotification.scheduleDailyReminder();
    await HourlyVerseNotification.scheduleHourlyVerses();

    // Debug builds fire one verse 10s after launch so the lock screen can be
    // checked without waiting for the top of the hour. Stripped from release.
    if (kDebugMode) {
      await HourlyVerseNotification.showTestVerseNow();
    }
  } catch (e) {
    debugPrint('⚠️ Notification scheduling skipped: $e');
  }
}
