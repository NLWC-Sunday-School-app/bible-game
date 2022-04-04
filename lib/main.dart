import 'package:bible_game/screens/authentication/login.dart';
import 'package:bible_game/screens/authentication/signup.dart';
import 'package:bible_game/screens/onboarding/know_scriptures.dart';
import 'package:bible_game/screens/onboarding/meditate.dart';
import 'package:bible_game/screens/onboarding/memorize.dart';
import 'package:flutter/material.dart';
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
        builder:() => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily:  'Quicksand',
            primarySwatch: Colors.blue,
            primaryColor: Colors.lightBlue[800],
          ),
          home: const MemorizeScreen(),
          routes: {
            MeditateScreen.routeName: (context) => const MeditateScreen(),
            MemorizeScreen.routeName: (context) => const MemorizeScreen(),
            KnowScripturesScreen.routeName: (context) => const KnowScripturesScreen(),
            SignUpScreen.routeName: (context) =>  const SignUpScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),

          },
        ),
      ),
    );
  }
}

