import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:bible_game/features/four_scriptures/view/tablet_view/four_scripture_question_screen_tablet_view.dart';
import 'package:bible_game/features/global_challenge/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/features/home/view/tablet_view/profile_screen_tablet_view.dart';
import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/lightning_mode/repository/lightning_mode_repository.dart';
import 'package:bible_game/features/lightning_mode/view/lightning_mode_question_screen.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/repository/multiplayer_repository.dart';
import 'package:bible_game/features/multi_player/view/group_game_category.dart';
import 'package:bible_game/features/multi_player/view/home_screen.dart';
import 'package:bible_game/features/multiplayer/view/home_screen.dart';
import 'package:bible_game/features/pilgrim_progress/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/pilgrim_progress/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/features/quick_game/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/quick_game/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/features/who_is_who/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/who_is_who/view/tablet_view/question_screen_tablet_view.dart';
import 'package:bible_game/navigation/widget/tablet_view_widget/bottom%20_tab_navigation_tablet_view.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
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
import 'package:bible_game/shared/features/settings/sound_manager.dart';
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
import 'features/global_challenge/view/question_screen.dart';
import 'features/multi_player/view/question_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;

import 'navigation/cubit/navigation_cubit.dart';

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
        required this.multiplayerRepository,
        required this.lightningModeRepository,
      });

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
  final MultiplayerRepository multiplayerRepository;
  final LightningModeRepository lightningModeRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {



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
          BlocProvider<MultiplayerBloc>(
            create: (context) => MultiplayerBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              multiplayerRepository: widget.multiplayerRepository,
            ),
          ),
          BlocProvider<LightningModeBloc>(
            create: (context) => LightningModeBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              lightningModeRepository: widget.lightningModeRepository,
              multiplayerBloc: BlocProvider.of<MultiplayerBloc>(context),
              settingsBloc: BlocProvider.of<SettingsBloc>(context),
            ),
          ),
          BlocProvider<WebsocketCubit>(
            create: (context) => WebsocketCubit(
              multiplayerBloc:BlocProvider.of<MultiplayerBloc>(context),
            ),
          ),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
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

            AppRoutes.multiplayer: (context) => MultiplayerHomeScreen(),
            AppRoutes.groupGameCategory: (context) => GroupGameCategory(),
            AppRoutes.lightningModeQuestionScreen: (context) => LightningModeQuestionScreen()
          },
          home: isTablet?SplashScreenTabletView():SplashScreen(),
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
    getFcmToken();
    if (Platform.isIOS) {
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'game notifications');
    }
  }
}
