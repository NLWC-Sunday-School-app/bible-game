import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/awesome_notification_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/onboarding/splash_screen.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/pilgrim_progress/new_level.dart';
import 'package:bible_game/screens/quick_game/question_screen.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version/new_version.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:upgrader/upgrader.dart';
import '../utilities/network_connection.dart';
import '../widgets/modals/app_update_modal.dart';
import '../widgets/modals/network_modal.dart';


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
  late StreamSubscription<InternetConnectionStatus> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
   // networkConnection.onConnectivityChanged();
    checkInternet();
    playBackgroundMusic();
    getFcmToken();
    checkForUpdateAppVersion();

    if(GetPlatform.isIOS){
      AwesomeNotifications().requestPermissionToSendNotifications(channelKey: 'game notifications');
    }
  }


  @override
  void dispose(){
    userController.player.dispose();
    networkConnection.connectivitySubscription.cancel();
    connectivitySubscription.cancel();
    super.dispose();
  }

  getFcmToken() async{
    var firebaseAppToken = await AwesomeNotificationsFcm().requestFirebaseAppToken();
    print('fb token: $firebaseAppToken');
  }

  checkForUpdateAppVersion() async {
    final newVersion = NewVersionPlus();
    final status = await newVersion.getVersionStatus();
    final localVersion = status?.localVersion;
    final storeVersion = status?.storeVersion;
    final appCanUpdate = status?.canUpdate;
    if (appCanUpdate == true) {
      Get.dialog(const AppUpdateModal(), barrierDismissible: false);
    }
  }

  Future<void> playBackgroundMusic() async{
     var pauseMusic = box.read('pauseGameMusic') ?? false;
      if(pauseMusic == false){
        userController.backgroundMusicPlayer.play();
      }
 }

  Future<void> playGameSound() async{
   var pauseGameSound = box.read('pauseGameSound') ?? false;
   if(pauseGameSound == false){
     await userController.player2.play();
   }
 }


 checkInternet() async{
   connectivitySubscription = InternetConnectionChecker().onStatusChange.listen((status) {
     switch (status) {
       case InternetConnectionStatus.connected:
         print('Data connection is available.');
         break;
       case InternetConnectionStatus.disconnected:
         print('You are disconnected from the internet.');
         Get.dialog(const NoNetworkModal(), barrierDismissible: false);
         break;
     }
   });


 }



  @override
  Widget build(BuildContext context) {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: false,
        builder:(BuildContext context,child) => UpgradeAlert(
          upgrader: Upgrader(dialogStyle: GetPlatform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
              showLater: false,
              showIgnore: false
          ),
          child: GetMaterialApp(
            title: 'Bible Game',
            theme: ThemeData(
              fontFamily:  'Quicksand',
              primaryColor: const Color.fromRGBO(118, 99, 229, 1),
            ),
            home: const SplashScreen(),
            routes: {
              TabMainScreen.routeName: (context) => const TabMainScreen(),
              QuickGameStepOneScreen.routeName: (context) => const QuickGameStepOneScreen(),
              QuickGameStepTwoScreen.routeName: (context) => const QuickGameStepTwoScreen(),
              QuickGameQuestionScreen.routeName:(context) => const   QuickGameQuestionScreen(),
              PilgrimProgressHomeScreen.routeName:(context) => const PilgrimProgressHomeScreen(),

            },
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        var pauseMusic = box.read('pauseGameMusic') ?? false;
        if(pauseMusic == false){
          userController.backgroundMusicPlayer.play();
        }
        break;
      case AppLifecycleState.paused:
         userController.backgroundMusicPlayer.stop();
        break;
      case AppLifecycleState.inactive:
        userController.backgroundMusicPlayer.stop();
        break;
      default:
        break;
    }
  }
}

