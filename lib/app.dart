import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/features/arcade/view/arcade_screen.dart';
import 'package:the_bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:the_bible_game/features/fantasy_league/repository/fantasy_league_repository.dart';
import 'package:the_bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:the_bible_game/features/fantasy_league/view/my_league.dart';
import 'package:the_bible_game/features/fantasy_league/widget/my_leagues.dart';
import 'package:the_bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:the_bible_game/features/four_scriptures/repository/four_scriptures_repository.dart';
import 'package:the_bible_game/features/four_scriptures/view/four_scripture_question_screen.dart';
import 'package:the_bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:the_bible_game/features/global_challenge/repository/global_challenge_repository.dart';
import 'package:the_bible_game/features/home/view/home_screen.dart';
import 'package:the_bible_game/features/home/view/profile_screen.dart';
import 'package:the_bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:the_bible_game/features/pilgrim_progress/repository/pilgrim_progress_repository.dart';
import 'package:the_bible_game/features/pilgrim_progress/view/home_screen.dart';
import 'package:the_bible_game/features/pilgrim_progress/view/question_screen.dart';
import 'package:the_bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:the_bible_game/features/quick_game/repository/quick_game_repository.dart';
import 'package:the_bible_game/features/quick_game/view/home_screen.dart';
import 'package:the_bible_game/features/quick_game/view/question_screen.dart';
import 'package:the_bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:the_bible_game/features/who_is_who/repository/wiw_repository.dart';
import 'package:the_bible_game/features/who_is_who/view/home_screen.dart';
import 'package:the_bible_game/features/who_is_who/view/question_screen.dart';
import 'package:the_bible_game/navigation/widget/bottom%20_tab_navigation.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:the_bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:the_bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:the_bible_game/shared/features/settings/sound_manager.dart';
import 'package:the_bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:the_bible_game/shared/features/user/model/user.dart';
import 'package:the_bible_game/shared/features/user/repository/user_repository.dart';
import 'package:the_bible_game/shared/screens/question_loading_screen.dart';
import 'package:the_bible_game/shared/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/utils/token_notifier.dart';
import 'package:provider/provider.dart';
import 'package:the_bible_game/shared/widgets/modal/network_modal.dart';
import 'features/global_challenge/view/question_screen.dart';
import 'features/multi_player/view/question_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;

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
      required this.fantasyLeagueRepository});

  final SoundManager soundManager;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final QuickGameRepository quickGameRepository;
  final PilgrimProgressRepository pilgrimProgressRepository;
  final FourScripturesOneWordRepository fourScripturesOneWordRepository;
  final WhoIsWhoRepository whoIsWhoRepository;
  final GlobalChallengeRepository globalChallengeRepository;
  final FantasyLeagueRepository fantasyLeagueRepository;
  final TokenNotifier tokenNotifier;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // useInheritedMediaQuery: true,
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) => MultiBlocProvider(
        providers: [
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
                settingsBloc: BlocProvider.of<SettingsBloc>(context)),
          ),
          BlocProvider<PilgrimProgressBloc>(
            create: (context) => PilgrimProgressBloc(
                pilgrimProgressRepository: widget.pilgrimProgressRepository,
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                settingsBloc: BlocProvider.of<SettingsBloc>(context)),
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
                    widget.fourScripturesOneWordRepository),
          ),
          BlocProvider<GlobalChallengeBloc>(
            create: (context) => GlobalChallengeBloc(
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                globalChallengeRepository: widget.globalChallengeRepository),
          ),
          BlocProvider<FantasyLeagueBloc>(
            create: (context) => FantasyLeagueBloc(
                settingsBloc: BlocProvider.of<SettingsBloc>(context),
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context),
                fantasyLeagueRepository: widget.fantasyLeagueRepository),
          ),
          ChangeNotifierProvider(create: (_) => widget.tokenNotifier),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            fontFamily: 'Mikado',
            useMaterial3: false,
          ),
          initialRoute: '/',
          routes: {
            AppRoutes.splashScreen: (context) => SplashScreen(),
            AppRoutes.home: (context) => BottomTabNavigation(),
            AppRoutes.quickGameHomeScreen: (context) => QuickGameHomeScreen(),
            AppRoutes.questionLoadingScreen: (context) =>
                QuestionLoadingScreen(),
            AppRoutes.quickGameQuestionScreen: (context) =>
                QuickGameQuestionScreen(
                  authenticationBloc:
                      BlocProvider.of<AuthenticationBloc>(context),
                  quickGameRepository: widget.quickGameRepository,
                ),
            AppRoutes.multiplayerQuestionScreen: (context) =>
                MultiplayerQuestionScreen(),
            AppRoutes.whoIsWhoHomeScreen: (context) => WhoIsWhoHomeScreen(),
            AppRoutes.whoIsWhoQuestionScreen: (context) =>
                WhoIsWhoQuestionScreen(),
            AppRoutes.pilgrimProgressHomeScreen: (context) =>
                PilgrimProgressHomeScreen(),
            AppRoutes.pilgrimProgressQuestionScreen: (context) =>
                PilgrimQuestionScreen(
                  authenticationBloc:
                      BlocProvider.of<AuthenticationBloc>(context),
                  pilgrimProgressRepository: widget.pilgrimProgressRepository,
                ),
            AppRoutes.fourScriptureQuestionScreen: (context) =>
                FourScriptureQuestionScreen(),
            AppRoutes.profileScreen: (context) => ProfileScreen(),
            AppRoutes.globalChallengeQuestionScreen: (context) =>
                GlobalQuestionScreen(
                  globalChallengeRepository: widget.globalChallengeRepository,
                ),
            AppRoutes.arcadeScreen: (context) => ArcadeScreen(),
            AppRoutes.fantasyBibleLeagueHomeScreen: (context) => FantasyLeagueHomeScreen(),
            AppRoutes.myLeagueScreen: (context) => MyLeagueScreen(),
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }

  getFcmToken() async {
    var firebaseAppToken = await AwesomeNotificationsFcm().requestFirebaseAppToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('fcmToken', firebaseAppToken);
    print('fb token: $firebaseAppToken');
    // await prefs.remove('userToken');
  }



  @override
  void initState() {
    super.initState();
    getFcmToken();
    if (Platform.isIOS) {
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'game notifications');
    }
  }
}
