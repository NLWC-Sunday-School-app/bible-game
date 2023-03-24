import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/leaderboard_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/widgets/LeaderBoardBaseChampions.dart';
import 'package:bible_game/widgets/LeaderBoardChampion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widgets/LeaderBoardCard.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LeaderboardController leaderboardController = Get.put(LeaderboardController());
    UserController userController = Get.put(UserController());
    ScrollController scrollController = ScrollController(
      initialScrollOffset: 3.0,
      keepScrollOffset: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 200.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF548CD7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 Get.width > 900 ? Image.asset(
                    'assets/images/games_cloud.png',
                    // width: 250.w,
                  ) : Image.asset(
                   'assets/images/games_cloud.png',
                   width: 250.w,
                 ) ,
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0.w),
                    child: GestureDetector(
                      onTap: () => {
                        userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                        Get.back()
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 24.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AutoSizeText(
                            '${Get.arguments} \n Leaderboard',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Neuland',
                                letterSpacing: 1,
                                fontSize: 20.sp,
                                color: Colors.white),
                          ),
                  SizedBox(width: 50.w,),
                  const Spacer()
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: Get.width > 900 ? 140.h : 200.h,
              ),
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: Obx(
              ()=> Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leaderboardController.leaderboardData.length >= 2 ? Obx(
                    () => LeaderBoardBaseChampions(
                        playerName: leaderboardController.leaderboardData[1].playerName,
                        playerPoint: leaderboardController.leaderboardData[1].playerScore,
                        avatarUrl: 'https://api.multiavatar.com/${leaderboardController.leaderboardData[1].playerId}.svg?apikey=${BaseUrlService().avatarApiKey}',
                        playerPosition: leaderboardController.leaderboardData[1].playerPosition,
                      ),
                    ): const SizedBox(),
                    leaderboardController.leaderboardData.isNotEmpty ? Obx( ()=> LeaderBoardChampion(
                        playerName: leaderboardController.leaderboardData[0].playerName,
                        playerPoint: leaderboardController.leaderboardData[0].playerScore,
                        avatarUrl:  'https://api.multiavatar.com/${leaderboardController.leaderboardData[0].playerId}.svg?apikey=${BaseUrlService().avatarApiKey}',
                        playerPosition: leaderboardController.leaderboardData[0].playerPosition,
                      ),
                    ): const SizedBox(),
                    leaderboardController.leaderboardData.length >= 3 ? Obx(
                      () => LeaderBoardBaseChampions(
                        playerName:  leaderboardController.leaderboardData[2].playerName,
                        playerPoint: leaderboardController.leaderboardData[2].playerScore,
                        avatarUrl: 'https://api.multiavatar.com/${leaderboardController.leaderboardData[2].playerId}.svg?apikey=${BaseUrlService().avatarApiKey}',
                        playerPosition: leaderboardController.leaderboardData[2].playerPosition,
                      ),
                    ): const SizedBox(),
                  ],
                ),
              ),
            ),
            leaderboardController.leaderboardData.length > 3 ? Container(
              margin: EdgeInsets.only(top: Get.width >= 600 ? 500.h : 450.h, left: 15.0.w, right: 15.0.w),
              child:
              ListView.builder(
                  controller: scrollController,
                  itemCount: leaderboardController.leaderboardFormattedData.length,
                  itemBuilder: (context, index) {
                 return
                   LeaderBoardCard(playerPosition: leaderboardController.leaderboardFormattedData[index].playerPosition, playerPoint: leaderboardController.leaderboardFormattedData[index].playerScore, playerName: leaderboardController.leaderboardFormattedData[index].playerName, playerId:leaderboardController.leaderboardFormattedData[index].playerId, avatarUrl:  'https://api.multiavatar.com/${leaderboardController.leaderboardFormattedData[index].playerId}.svg?apikey=${BaseUrlService().avatarApiKey}',);
              })

            ): const SizedBox(),

           leaderboardController.leaderboardData.isEmpty ? Container(
             // color: Colors.red,
              width: double.infinity,
              margin: EdgeInsets.only(top: 300.h),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icons/empty_leaderboard_icon.png', width: 50,),
                  const SizedBox(height: 20,),
                  const Text('No rankings to display yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFC3BBBB)),)
                ],
              ),
            ) : const SizedBox()

          ],
        ),
    );
  }
}
