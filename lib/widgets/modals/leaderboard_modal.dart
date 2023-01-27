import 'package:bible_game/widgets/modals/create_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/leaderboard_controller.dart';
import '../../controllers/pilgrim_progress_question_controller.dart';
import '../../controllers/quick_game_question_controller.dart';
import '../../screens/tabs/tab_main_screen.dart';

class LeaderBoardModal extends StatelessWidget {
  const LeaderBoardModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LeaderboardController leaderboardController = Get.put(LeaderboardController());
    var isLoggedIn = GetStorage().read('userLoggedIn') ?? false;
    final player = AudioPlayer();
    return  isLoggedIn ? Obx(
      () => SizedBox(
        height: Get.width >= 500 ? 130.h : Get.height >= 800 ? 100.h : 120.h,
        width: Get.width >= 500 ? 420.h : Get.height >= 800 ? 300.h : 350.h,
        child:  leaderboardController.leaderboardData.isNotEmpty ? Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/leaderboard_layout.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Text(
                'LEADERBOARD',
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  fontFamily: 'Neuland',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SvgPicture.network(
                        'https://api.multiavatar.com/${leaderboardController.leaderboardData[0].playerId}.svg',
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Text(
                            leaderboardController.leaderboardData[0].playerName,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Neuland',
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '${leaderboardController.leaderboardData[0].playerScore} Points',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5.w,),
                              Container(
                                padding:EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF7D64D),
                                    borderRadius: BorderRadius.circular(10.r)
                                ),
                                child: Text(
                                  '${leaderboardController.leaderboardData[0].playerPosition}st',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 10.w,),
                  leaderboardController.leaderboardData.length >= 2 ?  Row(
                    children: [
                      SvgPicture.network(
                        'https://api.multiavatar.com/${leaderboardController.leaderboardData[1].playerId}.svg',
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Text(
                            leaderboardController.leaderboardData[1].playerName,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: 'Neuland',
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Text(
                                '${leaderboardController.leaderboardData[1].playerScore} Points',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 5.w,),
                              Container(
                                padding:EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF7D64D),
                                    borderRadius: BorderRadius.circular(10.r)
                                ),
                                child: Text(
                                  '${leaderboardController.leaderboardData[1].playerPosition}${leaderboardController.leaderboardData[1].playerPosition != 1 ? 'nd' : 'st'}',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ) : const SizedBox()
                ],
              )
            ],
          ),
        ): const SizedBox(),
      ),
    ): SizedBox(
      height: Get.width >= 500 ? 130.h : Get.height >= 800 ? 100.h : 120.h,
      width: Get.width >= 500 ? 420.h : Get.height >= 800 ? 300.h : 350.h,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/leaderboard_layout.png',),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
           children: [
             SizedBox(
               height: 10.h,
             ),
             Text(
               'Create a profile to save \nyour progress',
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: 12.sp,
                 height: 1.2,
                 fontFamily: 'Neuland',
                 fontWeight: FontWeight.w500,
                 color: Colors.white,
               ),
             ),
             SizedBox(height: 20.h,),
             GestureDetector(
               onTap: () =>{
                 player.setAsset('assets/audios/click.mp3'),
                 player.play(),
                 Get.delete<PilgrimProgressQuestionController>(),
                 Get.delete<QuickGamesQuestionController>(),
                 Get.delete<LeaderboardController>(),
                 Get.offAll(() => const TabMainScreen()),
                 Get.dialog(const CreateProfileModal(), barrierDismissible: false)
               },
               child: Container(
                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20.r)
                 ),
                 child: Text('create a profile',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                   fontSize: 12.sp,
                   height: 1.5,
                   fontFamily: 'Neuland',
                   fontWeight: FontWeight.w500,
                   color: const Color(0xFF3A75C2),
                 ),),
               ),
             )
           ],
        ),
      ),
    );
  }
}
