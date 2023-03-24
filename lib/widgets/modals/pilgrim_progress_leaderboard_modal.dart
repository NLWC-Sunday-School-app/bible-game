import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:bible_game/controllers/leaderboard_controller.dart';
import 'package:bible_game/models/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../games/game_leaderboard_card.dart';


class PilgrimProgressLeaderboardModal extends StatefulWidget {
 
  const PilgrimProgressLeaderboardModal({Key? key,})
      : super(key: key);

  @override
  State<PilgrimProgressLeaderboardModal> createState() => _PilgrimProgressLeaderboardModalState();
}

class _PilgrimProgressLeaderboardModalState extends State<PilgrimProgressLeaderboardModal> {
  final LeaderboardController leaderboardController = Get.put(LeaderboardController());
  var levelId;
  @override
  void initState() {
    super.initState();
    setState(() => {
    levelId = GetStorage().read('pilgrimProgressLevelId')
    });
    leaderboardController.setLeaderboardData(levelId);
   
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
              '${GetStorage().read('pilgrimProgressSelectedLevel')} \nLeaderboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'Neuland',
                  color: const Color(0xFF224C86)),
            ),
            SizedBox(
              height: 20.h,
            ),

            SizedBox(
              height: 10.h,
            ),

            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 400.h,
              child: Obx(
                    () => leaderboardController.isLoading.isFalse
                    ? leaderboardController.leaderboardData.isNotEmpty
                    ? ListView.builder(
                  itemBuilder: (context, index) {
                    return GamesLeaderBoardCard(
                      playerPosition: leaderboardController
                          .leaderboardData[index]
                          .playerPosition,
                      playerName: leaderboardController
                          .leaderboardData[index].playerName,
                      playerPoint: leaderboardController
                          .leaderboardData[index].playerScore,
                      playerId: leaderboardController
                          .leaderboardData[index].playerId,
                      avatarUrl:
                      'https://api.multiavatar.com/${leaderboardController.leaderboardData[index].playerId}.svg',
                    );
                  },
                  itemCount: leaderboardController
                      .leaderboardData.length,
                )
                    : Container(
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
                    height: 30.w,
                    width: 30.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
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
