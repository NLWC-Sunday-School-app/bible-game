import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/widgets/games/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../widgets/custom_icons/my_flutter_app_icons.dart';
import '../../widgets/modals/nativity_info.dart';

class TabGamesScreen extends StatefulWidget {
  const TabGamesScreen({Key? key}) : super(key: key);

  @override
  State<TabGamesScreen> createState() => _TabGamesScreenState();
}

class _TabGamesScreenState extends State<TabGamesScreen> {
  GlobalGamesController globalGamesController = Get.put(GlobalGamesController());
  UserController userController = Get.put(UserController());
  bool selectedGlobalChallenge = true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF214B86),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/aesthetics/pattern_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: Get.height < 680
                  ? 130.h
                  : (Get.height > 680 && Get.height < 800)
                      ? 150.h
                      : 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF366ABC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFF3DB3E),
                      offset: Offset(0, 10),
                      blurRadius: 0,
                      spreadRadius: -3),
                  BoxShadow(
                      color: Color(0xFFEF798A),
                      offset: Offset(0, 8),
                      blurRadius: 0,
                      spreadRadius: -4),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: StrokeText(
                        text: 'Arcade',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mikado',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                        ),
                        strokeColor: const Color(0xFF05477B),
                        strokeWidth: 5,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              height: 65.h,
              decoration: BoxDecoration(
                  color: const Color(0xFF92C1F8),
                borderRadius: BorderRadius.all(Radius.circular(4.r))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap:(){
                        userController.soundIsOff.isFalse
                            ? userController.playGameSound()
                            : null;
                        setState(() {
                          selectedGlobalChallenge = true;
                        });
                        globalGamesController.getGlobalGamesWithoutLoader();
                      },
                      child: Container(
                        width: 165.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: selectedGlobalChallenge ? const AssetImage("assets/images/aesthetics/selected_arcade_tab_bg.png") : const AssetImage("assets/images/aesthetics/unselected_arcade_tab_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        color: const Color(0xFF1E242A),
                          borderRadius: BorderRadius.all(Radius.circular(12.r))
                        ),
                        child: Text('Global Challenge',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          color: selectedGlobalChallenge ? const Color(0xFFFFFAD3) : const Color(0xFFD5D5D5),
                          fontFamily: 'Mikado',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        userController.soundIsOff.isFalse
                            ? userController.playGameSound()
                            : null;
                        setState(() {
                          selectedGlobalChallenge = false;
                        });
                      },
                      child: Container(
                        width: 165.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: !selectedGlobalChallenge ? const AssetImage("assets/images/aesthetics/selected_arcade_tab_bg.png") : const AssetImage("assets/images/aesthetics/unselected_arcade_tab_bg.png"),
                              fit: BoxFit.cover,
                            ),
                            color: const Color(0xFF1E242A),
                            borderRadius: BorderRadius.all(Radius.circular(12.r))
                        ),
                        child:
                        Text(
                          'Multiplayer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !selectedGlobalChallenge ? const Color(0xFFFFFAD3) : const Color(0xFFD5D5D5),
                            fontFamily: 'Mikado',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900
                        ),),
                      ),
                    )
                  ],
              ),
            ),
            selectedGlobalChallenge ?
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                height: Get.height - (160.h + 120.h + 75.h),
                child: Obx(
                  () => SizedBox(
                    child: globalGamesController.isFetchingGames.isFalse
                        ? ListView.builder(
                          padding: EdgeInsets.only(top: 20.h),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GameCard(
                                imageUrl: globalGamesController
                                    .globalGames[index].imageUrl,
                                title: globalGamesController
                                    .globalGames[index].title,
                                text: globalGamesController
                                    .globalGames[index].description,
                                gameIsLive: globalGamesController
                                    .globalGames[index].gameIsActive,
                                campaignTag: globalGamesController
                                    .globalGames[index].campaignTag,
                              );
                            },
                            itemCount: globalGamesController.globalGames.length,
                          )
                        : Container(
                            margin: EdgeInsets.only(
                              top: 100.h,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                )) :
                Container(
                  margin: EdgeInsets.only(top: 100.h),
                  child: Image.asset('assets/images/aesthetics/multiplayer_coming_soon.png', width: 300.w,),
                )
          ],
        ),
      ),
    );
  }
}
