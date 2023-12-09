import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:bible_game/widgets/games/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../widgets/custom_icons/my_flutter_app_icons.dart';
import '../../widgets/modals/nativity_info.dart';

class TabGamesScreen extends StatelessWidget {
  const TabGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalGamesController globalGamesController = Get.put(GlobalGamesController());

    return Scaffold(
      backgroundColor: const Color(0xFF214B86),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/aesthetics/pattern_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.height < 680
                    ? 130
                    : (Get.height > 680 && Get.height < 800)
                    ? 150
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
                      Row(
                        children: [
                          Expanded(
                            child:  Center(
                              child: StrokeText(
                                text: 'Arcade',
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Mikado',
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: const Color(0xFF05477B) ,
                                strokeWidth: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Obx(
                    () => SizedBox(
                      child: globalGamesController.isFetchingGames.isFalse
                          ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
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
                                      campaignTag: globalGamesController.globalGames[index].campaignTag,

                                  );
                                },
                                itemCount: globalGamesController.globalGames.length,
                              )

                          : Container(
                              margin: EdgeInsets.only(
                                top: 150.h,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
