import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:bible_game/features/four_scriptures/view/tablet_view/four_scripture_question_screen_tablet_view.dart';
import 'package:bible_game/features/global_challenge/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/features/home/view/tablet_view/profile_screen_tablet_view.dart';
import 'package:bible_game/features/pilgrim_progress/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/pilgrim_progress/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/features/quick_game/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/quick_game/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/features/who_is_who/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/who_is_who/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/navigation/widget/tablet_view_widget/bottom%20_tab_navigation_tablet_view.dart';
import 'package:bible_game/shared/screens/tablet_view/question_loading_screen_tablet_view.dart';
import 'package:bible_game/shared/screens/tablet_view/splash_screen_tablet_view.dart';
import 'package:bible_game/shared/utils/web_socket.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/arcade/view/arcade_screen.dart';
import 'package:bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:bible_game/features/fantasy_league/repository/fantasy_league_repository.dart';
import 'package:bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:bible_game/features/fantasy_league/view/my_league.dart';
import 'package:bible_game/features/fantasy_league/widget/my_leagues.dart';
import 'package:bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:bible_game/features/four_scriptures/repository/four_scriptures_repository.dart';
import 'package:bible_game/features/four_scriptures/view/four_scripture_question_screen.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/global_challenge/repository/global_challenge_repository.dart';
import 'package:bible_game/features/home/view/home_screen.dart';
import 'package:bible_game/features/home/view/profile_screen.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/repository/pilgrim_progress_repository.dart';
import 'package:bible_game/features/pilgrim_progress/view/home_screen.dart';
import 'package:bible_game/features/pilgrim_progress/view/question_screen.dart';
import 'package:bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:bible_game/features/quick_game/repository/quick_game_repository.dart';
import 'package:bible_game/features/quick_game/view/home_screen.dart';
import 'package:bible_game/features/quick_game/view/question_screen.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/repository/wiw_repository.dart';
import 'package:bible_game/features/who_is_who/view/home_screen.dart';
import 'package:bible_game/features/who_is_who/view/question_screen.dart';
import 'package:bible_game/navigation/widget/bottom%20_tab_navigation.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game_api/api/game_api.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/settings/sound_manager.dart';
import 'package:bible_game/shared/utils/offline_sync_queue.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/features/user/model/user.dart';
import 'package:bible_game/shared/features/user/repository/user_repository.dart';
import 'package:bible_game/shared/screens/question_loading_screen.dart';
import 'package:bible_game/shared/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/utils/token_notifier.dart';
import 'package:provider/provider.dart';
import 'package:bible_game/shared/widgets/modal/network_modal.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:upgrader/upgrader.dart';
import 'features/daily_devotional/bloc/daily_devotional_bloc.dart';
import 'features/daily_devotional/view/devotional_screen.dart';
import 'features/story_mode/bloc/story_mode_bloc.dart';
import 'features/story_mode/view/chapter_map_screen.dart';
import 'features/story_mode/view/story_question_screen.dart';
import 'features/story_mode/view/story_selection_screen.dart';
import 'features/true_or_false/bloc/true_or_false_bloc.dart';
import 'features/true_or_false/view/true_or_false_home_screen.dart';
import 'features/true_or_false/view/true_or_false_question_screen.dart';
import 'features/global_challenge/view/question_screen.dart';
import 'features/multi_player/view/question_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'navigation/cubit/navigation_cubit.dart';
import 'shared/features/localization/app_localization.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatefulWidget {
  const App(
      {super.key,
      required this.authenticationRepository,
      required this.userRepository,
      required this.quickGameRepository,
      required this.tokenNotifier,
      required this.soundManager,
      required this.pilgrimProgressRepository,
      required this.fourScripturesOneWordRepository,
      required this.whoIsWhoRepository,
      required this.globalChallengeRepository,
      required this.fantasyLeagueRepository,
      required this.gameAPI,
      required this.offlineSyncQueue});

  final SoundManager soundManager;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final QuickGameRepository quickGameRepository;
  final PilgrimProgressRepository pilgrimProgressRepository;
  final FourScripturesOneWordRepository fourScripturesOneWordRepository;
  final WhoIsWhoRepository whoIsWhoRepository;
  final GlobalChallengeRepository globalChallengeRepository;
  final FantasyLeagueRepository fantasyLeagueRepository;
  final GameAPI gameAPI;
  final OfflineSyncQueue offlineSyncQueue;
  final TokenNotifier tokenNotifier;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Locale _locale = const Locale('en');

  Future<void> _loadSavedLocale() async {
    final locale =
        await AppLocalization.resolveLocale(WidgetsBinding.instance.platformDispatcher.locales);
    if (mounted) {
      setState(() => _locale = locale);
    }
  }

  void _changeLocale(Locale newLocale) {
    setState(() => _locale = newLocale);
    AppLocalization.setLocale(newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return ScreenUtilInit(
      designSize: isTablet?const Size(834, 1194):const Size(375, 812),
      // useInheritedMediaQuery: true,
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationCubit()),
          BlocProvider<ConnectivityBloc>(
            create: (_) => ConnectivityBloc(
              gameAPI: widget.gameAPI,
              syncQueue: widget.offlineSyncQueue,
            ),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: widget.authenticationRepository,
              userRepository: widget.userRepository,
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: widget.userRepository,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(widget.soundManager,
                userRepository: widget.userRepository),
          ),
          BlocProvider<QuickGameBloc>(
            create: (context) => QuickGameBloc(
                quickGameRepository: widget.quickGameRepository,
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context)),
          ),
          BlocProvider<PilgrimProgressBloc>(
            create: (context) => PilgrimProgressBloc(
                pilgrimProgressRepository: widget.pilgrimProgressRepository,
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context)),
          ),
          BlocProvider<WhoIsWhoBloc>(
            create: (context) => WhoIsWhoBloc(
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                whoIsWhoRepository: widget.whoIsWhoRepository),
          ),
          BlocProvider<FourScripturesOneWordBloc>(
            create: (context) => FourScripturesOneWordBloc(
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                fourScripturesOneWordRepository:
                    widget.fourScripturesOneWordRepository,
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context)),
          ),
          BlocProvider<GlobalChallengeBloc>(
            create: (context) => GlobalChallengeBloc(
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                globalChallengeRepository: widget.globalChallengeRepository,
                connectivityBloc: BlocProvider.of<ConnectivityBloc>(context)),
          ),
          BlocProvider<FantasyLeagueBloc>(
            create: (context) => FantasyLeagueBloc(
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                fantasyLeagueRepository: widget.fantasyLeagueRepository),
          ),
          BlocProvider<DailyDevotionalBloc>(
            create: (context) => DailyDevotionalBloc(
              connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            )..add(LoadDailyDevotional()),
          ),
          BlocProvider<StoryModeBloc>(
            create: (context) => StoryModeBloc(
              settingsBloc: BlocProvider.of<SettingsBloc>(context),
              connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
            )..add(LoadStoryArcs()),
          ),
          BlocProvider<TrueOrFalseBloc>(
            create: (context) => TrueOrFalseBloc(
              settingsBloc: BlocProvider.of<SettingsBloc>(context),
              connectivityBloc: BlocProvider.of<ConnectivityBloc>(context),
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            )..add(LoadTrueOrFalseData()),
          ),
          ChangeNotifierProvider(create: (_) => widget.tokenNotifier),
        ],
        child: _LocaleProvider(
          changeLocale: _changeLocale,
          child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          locale: _locale,
          supportedLocales: AppLocalization.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return _locale;
          },
          theme: ThemeData(
            fontFamily: 'Mikado',
            useMaterial3: false,
          ),
          initialRoute: '/',
          routes: {
            AppRoutes.splashScreen: (context) => isTablet?SplashScreenTabletView():SplashScreen(),
            AppRoutes.home: (context) => isTablet?BottomTabNavigationTabletView():BottomTabNavigation(),
            AppRoutes.quickGameHomeScreen: (context) => isTablet?QuickGameHomeScreenTabletView():QuickGameHomeScreen(),
            AppRoutes.questionLoadingScreen: (context) =>
            isTablet?QuestionLoadingScreenTabletView():QuestionLoadingScreen(),
            AppRoutes.quickGameQuestionScreen: (context) =>
            isTablet?
            QuickGameQuestionScreenTabletView(
              authenticationBloc:
              BlocProvider.of<AuthenticationBloc>(context),
              quickGameRepository: widget.quickGameRepository,
            )
                :
            QuickGameQuestionScreen(
              authenticationBloc:
              BlocProvider.of<AuthenticationBloc>(context),
              quickGameRepository: widget.quickGameRepository,
            ),
            AppRoutes.multiplayerQuestionScreen: (context) =>
                MultiplayerQuestionScreen(),
            AppRoutes.whoIsWhoHomeScreen: (context) => isTablet?WhoIsWhoHomeScreenTabletView():WhoIsWhoHomeScreen(),
            AppRoutes.whoIsWhoQuestionScreen: (context) =>
            isTablet?WhoIsWhoQuestionScreenTabletView():WhoIsWhoQuestionScreen(),

            AppRoutes.pilgrimProgressHomeScreen: (context) =>
            isTablet?PilgrimProgressHomeScreenTabletView():PilgrimProgressHomeScreen(),
            AppRoutes.pilgrimProgressQuestionScreen: (context) =>
            isTablet?
            PilgrimQuestionScreenTabletView(
              authenticationBloc:
              BlocProvider.of<AuthenticationBloc>(context),
              pilgrimProgressRepository: widget.pilgrimProgressRepository,
            ):PilgrimQuestionScreen(
              authenticationBloc:
              BlocProvider.of<AuthenticationBloc>(context),
              pilgrimProgressRepository: widget.pilgrimProgressRepository,
            ),
            AppRoutes.fourScriptureQuestionScreen: (context) =>
            isTablet?FourScriptureQuestionScreenTabletView():FourScriptureQuestionScreen(),
            AppRoutes.profileScreen: (context) => isTablet?ProfileScreenTabletView():ProfileScreen(),
            AppRoutes.globalChallengeQuestionScreen: (context) =>
            isTablet? GlobalQuestionScreenTabletView(
              globalChallengeRepository: widget.globalChallengeRepository,
            ):GlobalQuestionScreen(
              globalChallengeRepository: widget.globalChallengeRepository,
            ),
            AppRoutes.arcadeScreen: (context) => ArcadeScreen(),
            AppRoutes.fantasyBibleLeagueHomeScreen: (context) =>
                BottomTabNavigation(),
            AppRoutes.myLeagueScreen: (context) => MyLeagueScreen(),
            AppRoutes.dailyDevotionalScreen: (context) =>
                const DailyDevotionalScreen(),
            AppRoutes.storySelectionScreen: (context) =>
                const StorySelectionScreen(),
            AppRoutes.chapterMapScreen: (context) =>
                const ChapterMapScreen(),
            AppRoutes.storyQuestionScreen: (context) =>
                const StoryQuestionScreen(),
            AppRoutes.trueOrFalseHomeScreen: (context) =>
                const TrueOrFalseHomeScreen(),
            AppRoutes.trueOrFalseQuestionScreen: (context) =>
                const TrueOrFalseQuestionScreen(),
          },
          home: isTablet?SplashScreenTabletView():SplashScreen(),
        ),
        ),
      ),
    );
  }

  getFcmToken() async {
    var firebaseAppToken =
    await AwesomeNotificationsFcm().requestFirebaseAppToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcmToken', firebaseAppToken);
    print('fb token: $firebaseAppToken');
    // await prefs.remove('user_token');
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    getFcmToken();
    if (Platform.isIOS) {
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'game notifications');
    }

    // Listen for notification taps — reset badge when user opens a notification
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
    );

    // Reset badge whenever the app is opened
    AwesomeNotifications().resetGlobalBadge();
  }

  /// Called when user taps a notification
  @pragma("vm:entry-point")
  static Future<void> _onActionReceived(ReceivedAction receivedAction) async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  /// Called when a notification is displayed — keeps badge at 0
  @pragma("vm:entry-point")
  static Future<void> _onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    // Immediately reset badge so it doesn't accumulate
    await AwesomeNotifications().resetGlobalBadge();
  }
}

// ---------------------------------------------------------------------------
// InheritedWidget so any descendant can change the app locale
// ---------------------------------------------------------------------------

class _LocaleProvider extends InheritedWidget {
  final void Function(Locale) changeLocale;

  const _LocaleProvider({
    required this.changeLocale,
    required super.child,
  });

  static _LocaleProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LocaleProvider>()!;
  }

  @override
  bool updateShouldNotify(_LocaleProvider old) => false;
}

/// Helper to change the app language from anywhere.
void changeAppLocale(BuildContext context, Locale newLocale) {
  _LocaleProvider.of(context).changeLocale(newLocale);
}
