import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/awesome_notification_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/onboarding/splash_screen.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/quick_game/question_screen.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/widgets/modals/welcome_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import '../utilities/network_connection.dart';
import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'onboarding/know_scriptures.dart';
import 'onboarding/meditate.dart';
import 'onboarding/memorize.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  GetStorage box = GetStorage();
  UserController userController = Get.put(UserController());
  NetworkConnection networkConnection = Get.put(NetworkConnection());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    playBackgroundMusic();
    networkConnection.onConnectivityChanged();
    checkInternet();
    print(AwesomeNotificationController.getFirebaseMessagingToken());
  }


  @override
  void dispose() {
    userController.player.dispose();
    networkConnection.connectivitySubscription.cancel();
    super.dispose();
  }

 playBackgroundMusic() async{
   // var pauseMusic = box.read('pauseMusic') ?? true ;
      await userController.player.setAsset('assets/audios/background_music.mp3');
      await userController.player.setVolume(0.1);
      await userController.player.setLoopMode(LoopMode.all);
      await userController.player.play();


 }


 checkInternet() async{
   bool result = await InternetConnectionChecker().hasConnection;
   if(result == true) {
     print('YAY! Free cute dog pics!');
   } else {
     print('No internet :( Reason:');
   }
 }



  @override
  Widget build(BuildContext context) {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: false,
        builder:(BuildContext context,child) => GetMaterialApp(
          title: 'Bible Game',
          theme: ThemeData(
            fontFamily:  'Quicksand',
            primaryColor: const Color.fromRGBO(118, 99, 229, 1),
          ),
          // home: !isLoggedIn ? const LoginScreen() : const TabMainScreen(),
          home: const SplashScreen(),
          routes: {
            MeditateScreen.routeName: (context) => const MeditateScreen(),
            MemorizeScreen.routeName: (context) => const MemorizeScreen(),
            KnowScripturesScreen.routeName: (context) => const KnowScripturesScreen(),
            SignUpScreen.routeName: (context) =>  const SignUpScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            TabMainScreen.routeName: (context) => const TabMainScreen(),
            QuickGameStepOneScreen.routeName: (context) => const QuickGameStepOneScreen(),
            QuickGameStepTwoScreen.routeName: (context) => const QuickGameStepTwoScreen(),
            QuickGameQuestionScreen.routeName:(context) => const   QuickGameQuestionScreen(),
            PilgrimProgressHomeScreen.routeName:(context) => const PilgrimProgressHomeScreen()
          },
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        userController.player.play();
        break;
      case AppLifecycleState.paused:
         userController.player.stop();
        break;
      case AppLifecycleState.inactive:
        userController.player.stop();
        break;
      default:
        break;
    }
  }
}

