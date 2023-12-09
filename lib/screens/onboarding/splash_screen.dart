import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/services/auth_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:get/get.dart';

import '../../controllers/tabs_controller.dart';
import '../../utilities/network_connection.dart';
import '../../widgets/modals/network_modal.dart';
import '../../widgets/modals/welcome_modal.dart';

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
    }
  }

  displayWelcomeModal(){
    var firstTime = GetStorage().read('first_time') ?? true;
    if(!firstTime){
      Get.dialog(const WelcomeModal());
      GetStorage().write('first_time', false);
    }
  }

  checkNetworkConnection() async{
    final TabsController tabsController = Get.put(TabsController());
    NetworkConnection networkConnection = Get.put(NetworkConnection());
    if(await networkConnection.hasInternetConnection() == true){
      var token = GetStorage().read('user_token');
      var refreshToken = GetStorage().read('refresh_token');
      bool tokenHasExpired = JwtDecoder.isExpired(token);
      if(tokenHasExpired){
         await AuthService.refreshToken(refreshToken);
         await UserService.getUserGameSettings();
         await setLoggedInState();
         await getUserData();
         tabsController.selectPage(0);
         await Get.offAll(() => const TabMainScreen());
      }else{
         await UserService.getUserGameSettings();
         await setLoggedInState();
         await getUserData();
         tabsController.selectPage(0);
        await Get.offAll(() => const TabMainScreen());
      }
    }else{
      Get.dialog(const NoNetworkModal(), barrierDismissible: false);
    }

  }

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    AuthController authController = Get.put(AuthController());
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage( "assets/images/aesthetics/splash_screen.png"),
              fit: BoxFit.cover
            )
          ),
        ),
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  UserService.getUserData();
                },
                child: Container(
                  margin: EdgeInsets.only(top: Get.height < 750 ? 450 : 700),
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: LinearPercentIndicator(
                    lineHeight: 15.h,
                    percent: 1,
                    animation: true,
                    animationDuration: 2500,
                    barRadius: const Radius.circular(10),
                    progressColor: const Color(0xFFFECF75),
                    onAnimationEnd: () =>{
                       checkNetworkConnection()
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
