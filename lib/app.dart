import 'package:flutter/material.dart';
import 'package:the_bible_game/features/four_scriptures/view/four_scripture_question_screen.dart';
import 'package:the_bible_game/features/home/view/home_screen.dart';
import 'package:the_bible_game/features/pilgrim_progress/view/home_screen.dart';
import 'package:the_bible_game/features/pilgrim_progress/view/question_screen.dart';
import 'package:the_bible_game/features/quick_game/view/home_screen.dart';
import 'package:the_bible_game/features/quick_game/view/question_screen.dart';
import 'package:the_bible_game/features/who_is_who/view/home_screen.dart';
import 'package:the_bible_game/features/who_is_who/view/question_screen.dart';
import 'package:the_bible_game/navigation/widget/bottom%20_tab_navigation.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:the_bible_game/shared/features/authentication/repository/authentication_repository.dart';
import 'package:the_bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:the_bible_game/shared/features/user/model/user.dart';
import 'package:the_bible_game/shared/features/user/repository/user_repository.dart';
import 'package:the_bible_game/shared/screens/question_loading_screen.dart';
import 'package:the_bible_game/shared/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/utils/token_notifier.dart';
import 'package:provider/provider.dart';
import 'features/multi_player/view/question_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authenticationRepository,
    required this.userRepository,
    required this.tokenNotifier,
  });

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final TokenNotifier tokenNotifier;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: false,
      builder: (BuildContext context, Widget? child) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userRepository: userRepository,
            ),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: userRepository
            ),
          ),
          ChangeNotifierProvider(create: (_) => tokenNotifier),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            fontFamily: 'Mikado',
          ),
          initialRoute: '/',
          routes: {
            AppRoutes.home: (context) => BottomTabNavigation(),
            AppRoutes.quickGameHomeScreen: (context) => QuickGameHomeScreen(),
            AppRoutes.questionLoadingScreen: (context) =>
                QuestionLoadingScreen(),
            AppRoutes.quickGameQuestionScreen: (context) =>
                QuickGameQuestionScreen(),
            AppRoutes.multiplayerQuestionScreen: (context) =>
                MultiplayerQuestionScreen(),
            AppRoutes.whoIsWhoHomeScreen: (context) => WhoIsWhoHomeScreen(),
            AppRoutes.whoIsWhoQuestionScreen: (context) =>
                WhoIsWhoQuestionScreen(),
            AppRoutes.pilgrimProgressHomeScreen: (context) =>
                PilgrimProgressHomeScreen(),
            AppRoutes.pilgrimProgressQuestionScreen: (context) =>
                PilgrimQuestionScreen(),
            AppRoutes.fourScriptureQuestionScreen: (context) =>
                FourScriptureQuestionScreen()
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
