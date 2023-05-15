import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'game_leaderboard_card.dart';

class GamesBottomSheetModal extends StatefulWidget {
  final String campaignType;

  const GamesBottomSheetModal({Key? key, required this.campaignType})
      : super(key: key);

  @override
  State<GamesBottomSheetModal> createState() => _GamesBottomSheetModalState();
}

class _GamesBottomSheetModalState extends State<GamesBottomSheetModal> {
  final GlobalGamesController _globalGamesController =
      Get.put(GlobalGamesController());

  @override
  void initState() {
    super.initState();
    _globalGamesController.getGlobalGameLeaderboard(widget.campaignType);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 1.4,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            SvgPicture.asset(
              'assets/images/icons/bottom_handle.svg',
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              'Challenge Leaderboard',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'Neuland',
                  color: const Color(0xFF224C86)),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: const Color(0xFFB7FFBE),
                  borderRadius: BorderRadius.circular(24.r)),
              child: Text(
                'Live challenge is ongoing',
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Check out those taking the lead; Not joined? \nJoin the challenge to be a part of them!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 350.h,
              child: Obx(
                () => _globalGamesController.isFetchingGamesLeaderboard.isFalse
                    ? _globalGamesController.globalGamesLeaderBoard.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return GamesLeaderBoardCard(
                                playerPosition: _globalGamesController
                                    .globalGamesLeaderBoard[index]
                                    .playerPosition,
                                playerName: _globalGamesController
                                    .globalGamesLeaderBoard[index].playerName,
                                playerPoint: _globalGamesController
                                    .globalGamesLeaderBoard[index].playerScore,
                                playerId: _globalGamesController
                                    .globalGamesLeaderBoard[index].playerId,
                                avatarUrl:
                                    'https://api.multiavatar.com/${_globalGamesController.globalGamesLeaderBoard[index].playerId}.png',
                              );
                            },
                            itemCount: _globalGamesController
                                .globalGamesLeaderBoard.length,
                          )
                        : SizedBox(
                            // color: Colors.red,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/icons/empty_leaderboard_icon.png',
                                  width: 50,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'No rankings to display yet',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFC3BBBB)),
                                )
                              ],
                            ),
                          )
                    : Center(
                        child: SizedBox(
                          child: Center(
                            child: SizedBox(
                                child: Image.asset('assets/images/icons/loader.gif')
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
