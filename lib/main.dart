import 'package:bible_game/screens/authentication/login.dart';
import 'package:bible_game/screens/authentication/signup.dart';
import 'package:bible_game/screens/onboarding/know_scriptures.dart';
import 'package:bible_game/screens/onboarding/meditate.dart';
import 'package:bible_game/screens/onboarding/memorize.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/question_screen.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:bible_game/screens/tab_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder:() => GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily:  'Quicksand',
            primaryColor: const Color.fromRGBO(118, 99, 229, 1),
          ),
          home: const MemorizeScreen(),
          routes: {
            MeditateScreen.routeName: (context) => const MeditateScreen(),
            MemorizeScreen.routeName: (context) => const MemorizeScreen(),
            KnowScripturesScreen.routeName: (context) => const KnowScripturesScreen(),
            SignUpScreen.routeName: (context) =>  const SignUpScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            TabMainScreen.routeName: (context) => const TabMainScreen(),
            QuickGameStepOneScreen.routeName: (context) => const QuickGameStepOneScreen(),
            QuickGameStepTwoScreen.routeName: (context) => const QuickGameStepTwoScreen(),
            QuestionScreen.routeName:(context) => const QuestionScreen(),
            PilgrimProgressHomeScreen.routeName:(context) => const PilgrimProgressHomeScreen()
          },
        ),
      ),
    );
  }
}

