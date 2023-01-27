import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/nativity_question_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_question_controller.dart';
import 'package:bible_game/controllers/quick_game_question_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:bible_game/widgets/game_summary_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/leaderboard_controller.dart';
import '../../controllers/tabs_controller.dart';
import '../custom_icons/my_flutter_app_icons.dart';
import 'leaderboard_modal.dart';

class GameSummaryModal extends StatelessWidget {
  const GameSummaryModal(
      {Key? key,
      required this.pointsGained,
      required this.questionsGotten,
      required this.onTap,
      required this.bonusPointsGained,
      required this.averageTimeSpent, required this.isQuickGame,
      })
      : super(key: key);

  final String pointsGained;
  final String questionsGotten;
  final String bonusPointsGained;
  final String averageTimeSpent;
  final VoidCallback onTap;
  final bool isQuickGame;

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    UserController userController = Get.put(UserController());
    final TabsController tabsController = Get.put(TabsController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
            height: Get.width >= 500 ? 700.h : Get.height >= 800 ? 600.h : 650.h,
            width: Get.width >= 500 ? 500.h : 500.h,
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: Get.width >= 500 ? 550.h : Get.height >= 800 ? 450.h : 480.h,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/game_completed_layout.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 85.h,
                            ),
                            Image.asset(
                              'assets/images/icons/stars.png',
                              width: 200.w,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            AutoSizeText(
                              'Your score',
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w600),
                            ),
                            AutoSizeText(
                              pointsGained,
                              style: TextStyle(
                                  fontFamily: 'Neuland',
                                  fontSize: 48.sp,
                                  color: const Color(0xFF4A7DC2)),
                            ),
                            AutoSizeText(
                              'Bonus point: +$bonusPointsGained',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF548CD7),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'You answered:',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF323B63),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        questionsGotten,
                                        style: TextStyle(
                                          height: 1.5,
                                          fontSize: 20.sp,
                                          fontFamily: 'Neuland',
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF323B63),
                                        ),
                                      ),
                                      Text(
                                        'questions',
                                        style: TextStyle(
                                          height: 1.5,
                                          fontSize: 12.sp,
                                          color: const Color(0xFF323B63),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  const VerticalDivider(
                                    color: Color(0xFFDAEDF2),
                                    thickness: 1.5,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Avg. time spent',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF323B63),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        ': $averageTimeSpent sec',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1.5,
                                          fontFamily: 'Neuland',
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF323B63),
                                        ),
                                      ),
                                      Text(
                                        'per question',
                                        style: TextStyle(
                                          height: 1.5,
                                          fontSize: 12.sp,
                                          color: const Color(0xFF323B63),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.width >= 500 ? 20.h : Get.height >= 800 ? 15.h : 22.h,
                    ),
                  // isQuickGame ? const SizedBox() : const LeaderBoardModal()
                    const LeaderBoardModal()
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top:  Get.width >= 500 ? 450.h : Get.height >= 800 ? 380.h : 400.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GameSummaryActionButton(
                        icon: const Icon(
                          Icons.refresh_outlined,
                          color: Colors.white,
                        ),
                        size: 15.w,
                        shapeColor: const Color(0XFFFDC049),
                        onTap: onTap,
                      ),
                      GameSummaryActionButton(
                        icon: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 30.w,
                        ),
                        size: 20.w,
                        shapeColor: const Color(0xFF4075BB),
                        onTap: () async => {
                          if(userController.soundIsOff.isFalse){
                            player.setAsset('assets/audios/click.mp3'),
                            player.play(),
                          },
                          Get.delete<PilgrimProgressQuestionController>(),
                          Get.delete<QuickGamesQuestionController>(),
                          Get.delete<NativityQuestionController>(),
                          Get.delete<LeaderboardController>(),
                          await userController.getUserData(),
                          GetStorage().write('isTempLoggedIn', false),
                          Get.offAll(() => const TabMainScreen(),
                              transition: Transition.fadeIn)
                        },
                      ),
                      GameSummaryActionButton(
                        icon: const Icon(
                          MyFlutterApp.trophy,
                          color: Colors.white,
                        ),
                        size: 15.w,
                        shapeColor: const Color(0XFFFDC049),
                        onTap: () => {
                          if(userController.soundIsOff.isFalse){
                            player.setAsset('assets/audios/click.mp3'),
                            player.play(),
                          },
                          tabsController.selectPage(2),
                          Get.offAll(()=> const TabMainScreen()),
                        },
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
