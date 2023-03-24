import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:bible_game/widgets/games/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import '../../widgets/custom_icons/my_flutter_app_icons.dart';
import '../../widgets/modals/nativity_info.dart';

class TabGamesScreen extends StatelessWidget {
  const TabGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalGamesController globalGamesController = Get.put(GlobalGamesController());

    return Scaffold(
      backgroundColor: const Color(0xFF214B86),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 25.h),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C4781),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Get.width < 900 ? Image.asset(
                        'assets/images/games_cloud.png',
                        width:  240.w ,
                      ) : Image.asset(
                        'assets/images/games_cloud.png',

                      ) ,
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 80.h),
                  child: Column(
                    children: [
                      Text('${Get.width}'),
                      Text(
                        'Games',
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            fontSize: 20.sp,
                            color: Colors.white),
                      ),
                      Text(
                        'Enjoy well tailored games for different \nseasons! Check here for new games',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
    );
  }
}
