import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  setLoggedInState(){
    AuthController authController = Get.put(AuthController());
    var isLoggedIn = GetStorage().read('userLoggedIn') ?? false;
    authController.isLoggedIn.value = isLoggedIn;
  }

  getUserData() async{
    AuthController authController = Get.put(AuthController());
    if(authController.isLoggedIn.isTrue){
      await UserService.getUserData();
      await UserService.getUserPilgrimProgress();
      print(GetStorage().read('user_token'));
  }
  }

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    // var isLoggedIn = box.read('userLoggedIn') ?? false;
    // AuthController authController = Get.put(AuthController());
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage( "assets/images/splash_screen.png"),
              fit: BoxFit.cover
            )
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: Get.height < 750 ? 450 : 500),
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: LinearPercentIndicator(
              lineHeight: 15.0,
              percent: 1,
              animation: true,
              animationDuration: 4500,
              barRadius: const Radius.circular(10),
              progressColor: const Color(0xFFFECF75),
              onAnimationEnd: () async =>{
                await UserService.getUserGameSettings(),
                await setLoggedInState(),
               await getUserData(),
               await Get.offAll(() => const TabMainScreen(), transition: Transition.leftToRight)
              }
            ),
          ),
        ),
      ],
    );
  }
}
