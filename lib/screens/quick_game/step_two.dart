import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/widgets/game_button.dart';
import 'package:bible_game/widgets/quick_game/difficulty_level_meter.dart';
import 'package:bible_game/widgets/modals/quick_game_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class QuickGameStepTwoScreen extends StatefulWidget {
  const QuickGameStepTwoScreen({Key? key}) : super(key: key);
  static String routeName = "/quick-game-step-two-screen";

  @override
  State<QuickGameStepTwoScreen> createState() => _QuickGameStepTwoScreenState();
}

class _QuickGameStepTwoScreenState extends State<QuickGameStepTwoScreen> {
  QuickGameController quickGameController = Get.put(QuickGameController());
  UserController userController = Get.put(UserController());
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(
          () => Stack(
            children: [
              Container(
                padding: Get.width > 900 ? EdgeInsets.only(bottom: 120.h) : EdgeInsets.only(bottom: Get.height < 680 ? 60.h : 80.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF32B1F2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/cloud.png',
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 75.h),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            userController.soundIsOff.isFalse
                                ? userController.playGameSound()
                                : null,
                            Get.back()
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 24.w,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20.h,
                        ),
                        AutoSizeText(
                          'Start Quick Game in \n2 easy steps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.sp,
                              letterSpacing: 1,
                              color: Colors.white,
                              fontFamily: 'Neuland'),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: SvgPicture.asset(
                          'assets/images/quick_game_step_two.svg'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 260.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height > 900 ? 20.h : 30.h,
                    ),
                    Align(
                      child: AutoSizeText(
                        'Choose a difficulty level.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(91, 73, 191, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: quickGameController.selectNormalLevel,
                          child: DifficultyLevelMeter(
                            difficultyImage:
                                'assets/images/quick_game/normal_speed.svg',
                            dotColor: const Color.fromRGBO(155, 201, 14, 1),
                            isActive: quickGameController.normalIsActive.value,
                            difficultyLevel: 'Normal',
                            checkerImage:
                                'assets/images/quick_game/green_circle_check.svg',
                          ),
                        ),
                        GestureDetector(
                          onTap: quickGameController.selectIntermediateLevel,
                          child: DifficultyLevelMeter(
                            difficultyImage:
                                'assets/images/quick_game/intermediate_speed.svg',
                            dotColor: const Color.fromRGBO(237, 195, 86, 1),
                            isActive:
                                quickGameController.intermediateIsActive.value,
                            difficultyLevel: 'Intermediate',
                            checkerImage:
                                'assets/images/quick_game/orange_circle_check.svg',
                          ),
                        ),
                        GestureDetector(
                          onTap: quickGameController.selectHardLevel,
                          child: DifficultyLevelMeter(
                            difficultyImage:
                                'assets/images/quick_game/hard_speed.svg',
                            dotColor: const Color.fromRGBO(211, 98, 93, 1),
                            isActive: quickGameController.hardIsActive.value,
                            difficultyLevel: 'Hard',
                            checkerImage:
                                'assets/images/quick_game/wine_circle_check.svg',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150.h,
                    ),
                    GestureDetector(
                      onTap: () => {
                        quickGameController.startGame()
                      },
                      child: const GameButton(
                        buttonText: 'START GAME',
                        buttonActive: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
