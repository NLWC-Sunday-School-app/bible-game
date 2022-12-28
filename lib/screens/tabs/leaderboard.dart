import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/leaderboard_controller.dart';
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
                  Image.asset(
                    'assets/images/games_cloud.png',
                    width: 250.w,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 80),
              child: SizedBox(
                height: 100,
                child: Align(
                  alignment: Alignment.center ,
                  child: Column(
                    children: [
                      AutoSizeText(
                        '${Get.arguments}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            fontSize: 20.sp,
                            color: Colors.white),
                      ),
                      const AutoSizeText(
                        'Leaderboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 130.h),
            //   padding: EdgeInsets.only(left: 25.0.w, right: 25.0.w),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       prefixIcon: Padding(
            //         padding: EdgeInsets.only(left: 20.w, right: 10.w),
            //         child: const Icon(
            //             Icons.search), // myIcon is a 48px-wide widget.
            //       ),
            //       prefixIconColor: const Color.fromRGBO(160, 160, 160, 1),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(
            //             color: Color.fromRGBO(118, 99, 229, 1)),
            //         borderRadius: BorderRadius.circular(15.0.r),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(
            //             color: Color.fromRGBO(51, 97, 159, 0.2)),
            //         borderRadius: BorderRadius.circular(15.0.r),
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(15.0.r),
            //       ),
            //       filled: true,
            //       hintStyle: const TextStyle(
            //           color: Color.fromRGBO(160, 160, 160, 1),
            //           fontWeight: FontWeight.w500,
            //           fontSize: 14),
            //       hintText: "Search by username or name ",
            //       fillColor: const Color.fromRGBO(243, 242, 242, 1),
            //     ),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(
                top: 200.h,
              ),
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leaderboardController.leaderboardData.length >= 2 ? Obx(
                  () => LeaderBoardBaseChampions(
                      playerName: leaderboardController.leaderboardData[1].playerName,
                      playerPoint: leaderboardController.leaderboardData[1].playerScore,
                      avatarUrl: 'https://api.multiavatar.com/88.svg',
                      playerPosition: leaderboardController.leaderboardData[1].playerPosition,
                    ),
                  ): const SizedBox(),
                  leaderboardController.leaderboardData.isNotEmpty ? Obx( ()=> LeaderBoardChampion(
                      playerName: leaderboardController.leaderboardData[0].playerName,
                      playerPoint: leaderboardController.leaderboardData[0].playerScore,
                      avatarUrl:  'https://api.multiavatar.com/${leaderboardController.leaderboardData[0].playerId}.svg',
                      playerPosition: leaderboardController.leaderboardData[0].playerPosition,
                    ),
                  ): const SizedBox(),
                  leaderboardController.leaderboardData.length >= 3 ? Obx(
                    () => LeaderBoardBaseChampions(
                      playerName:  leaderboardController.leaderboardData[0].playerName,
                      playerPoint: leaderboardController.leaderboardData[2].playerScore,
                      avatarUrl: 'https://api.multiavatar.com/${leaderboardController.leaderboardData[2].playerId}.svg',
                      playerPosition: leaderboardController.leaderboardData[2].playerPosition,
                    ),
                  ): const SizedBox(),
                ],
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
                   LeaderBoardCard(playerPosition: leaderboardController.leaderboardFormattedData[index].playerPosition, playerPoint: leaderboardController.leaderboardFormattedData[index].playerScore, playerName: leaderboardController.leaderboardFormattedData[index].playerName, playerId:leaderboardController.leaderboardFormattedData[index].playerId, avatarUrl:  'https://api.multiavatar.com/${leaderboardController.leaderboardFormattedData[index].playerId}.svg',);
              })

            ): const SizedBox(),

           leaderboardController.leaderboardData.isEmpty ? Container(
              margin: EdgeInsets.only(top: 500.h, left: 100),
              child: Column(
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
