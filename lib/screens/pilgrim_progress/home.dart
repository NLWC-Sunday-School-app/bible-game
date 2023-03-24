import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/pilgrim_progress_question_screen.dart';
import 'package:bible_game/screens/pilgrim_progress/widgets/PligrimProgressLevelMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import '../../widgets/modals/pilgrim_progress_welcome_modal.dart';

class PilgrimProgressHomeScreen extends StatefulWidget {
  const PilgrimProgressHomeScreen({Key? key}) : super(key: key);
  static String routeName = "/pilgrim-progress-home-screen";

  @override
  State<PilgrimProgressHomeScreen> createState() =>
      _PilgrimProgressHomeScreenState();
}

class _PilgrimProgressHomeScreenState extends State<PilgrimProgressHomeScreen> {
  final PilgrimProgressController pilgrimProgressController = Get.put(PilgrimProgressController());
  final UserController userController = Get.put(UserController());

  getUpdatedGameData(){
    Timer(const Duration(seconds: 0), () {
      pilgrimProgressController.setPilgrimData();
    });

  }

  displayPilgrimProgressWelcomeModal() {
    var firstTime = GetStorage().read('pilgrim_progress_first_time') ?? true;

    if (firstTime) {
      Timer(const Duration(seconds: 1), () {
        Get.dialog(const PilgrimProgressWelcomeModal());
      });
      GetStorage().write('pilgrim_progress_first_time', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,###');
    return Scaffold(
      backgroundColor: const Color(0xFF548CD7),
      body: SizedBox(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(bottom: Get.height < 680 ? 20.h : 30.h),
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
                                userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                                Get.back()
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 24.w,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  'pilgrim progress',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    letterSpacing: 1,
                                    fontFamily: 'Neuland',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                const Text(
                                  'Journey through the bible, Grow your \nknowledge as you progress ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //buildPilgrimProgressInfoCard(),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                    margin: EdgeInsets.only(top: 250.h),
                    child: Column(
                        children: [
                          Obx(
                            () => PilgrimProgressLevelMenu(
                              menuImage: 'assets/images/pilgrim_levels/babe.png',
                              menuNumber: '',
                              textSpan: RichText(
                                  text: TextSpan(
                                      text:
                                          'Begin your bible adventure! Get up \nto',
                                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), fontFamily: 'QuickSand', height: 1.5),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text:' ${formatter.format(pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value)} points',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    const TextSpan(
                                      text: ' to finish this level.',
                                    ),
                                  ])),
                              menuLabel: 'Babe',
                              totalPointsGained: pilgrimProgressController
                                  .totalPointsGainedInBabe.value,
                              totalPointsAvailable: pilgrimProgressController
                                  .totalPointsAvailableInBabe.value,
                              isLocked: pilgrimProgressController
                                  .babeLevelIsLocked.isTrue,
                              menuProgressValue: pilgrimProgressController
                                  .babeProgressLevelValue.value,
                              boxShadowColor: 0xFFE4E0DD,
                              onTap: () => {
                                userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                                if (pilgrimProgressController
                                    .babeLevelIsLocked.isFalse)
                                  {
                                    pilgrimProgressController
                                        .setSelectedLevel('babe')
                                  }
                              },
                            ),
                          ),
                          PilgrimProgressLevelMenu(
                            menuImage: 'assets/images/pilgrim_levels/child.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text:
                                        'Go further in your journey! Get up \nto',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D),fontFamily: 'QuickSand', height: 1.5),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text:' ${formatter.format(pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value)} points',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const TextSpan(
                                    text: ' to grow from here.',
                                  ),
                                ])),
                            menuLabel: 'Child',
                            totalPointsGained: pilgrimProgressController
                                .totalPointsGainedInChild.value,
                            totalPointsAvailable: pilgrimProgressController
                                .totalPointsAvailableInChild.value,
                            isLocked: pilgrimProgressController
                                .childLevelIsLocked.isTrue,
                            menuProgressValue: pilgrimProgressController
                                .childProgressLevelValue.value,
                            boxShadowColor: 0xFFFCCB90,
                            onTap: () => {
                              userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                              if (pilgrimProgressController
                                  .childLevelIsLocked.isFalse)
                                {
                                  pilgrimProgressController
                                      .setSelectedLevel('child')
                                }
                            },
                          ),
                          PilgrimProgressLevelMenu(
                            menuImage:
                                'assets/images/pilgrim_levels/young_believer.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text:
                                        'You are growing! Almost there! Get \n',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), fontFamily: 'QuickSand', height: 1.5),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text:' ${formatter.format(pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value)} points',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const TextSpan(
                                    text: ' to get to charity.',
                                  ),
                                ])),
                            menuLabel: 'young believer',
                            totalPointsGained: pilgrimProgressController
                                .totalPointsGainedInYb.value,
                            totalPointsAvailable: pilgrimProgressController
                                .totalPointsAvailableInYb.value,
                            isLocked: pilgrimProgressController
                                .youngBelieversLevelIsLocked.isTrue,
                            menuProgressValue: pilgrimProgressController
                                .youngBelieverProgressLevelValue.value,
                            boxShadowColor: 0xFFC7DAE1,
                            onTap: () => {
                              userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                              if (pilgrimProgressController
                                  .youngBelieversLevelIsLocked.isFalse)
                                {
                                  pilgrimProgressController
                                      .setSelectedLevel('young believer')
                                }
                            },
                          ),
                          PilgrimProgressLevelMenu(
                            menuImage:
                                'assets/images/pilgrim_levels/charity.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text:
                                        'Charity is round the corner! Get up \nto',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), fontFamily: 'QuickSand', height: 1.5),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text:' ${formatter.format(pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value)} points',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const TextSpan(
                                    text: ' to get to Father.',
                                  ),
                                ])),
                            menuLabel: 'charity',
                            totalPointsGained: pilgrimProgressController
                                .totalPointsGainedInCharity.value,
                            totalPointsAvailable: pilgrimProgressController
                                .totalPointsAvailableInCharity.value,
                            isLocked: pilgrimProgressController
                                .charityLevelIsLocked.isTrue,
                            menuProgressValue: pilgrimProgressController
                                .charityProgressLevelValue.value,
                            boxShadowColor: 0xFF92D6EE,
                            onTap: () => {
                              userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                              if (pilgrimProgressController
                                  .charityLevelIsLocked.isFalse)
                                {
                                  pilgrimProgressController
                                      .setSelectedLevel('charity')
                                }
                            },
                          ),
                          PilgrimProgressLevelMenu(
                            menuImage:
                                'assets/images/pilgrim_levels/father.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text:
                                        'Grown beyond this world! Get up to \n',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), fontFamily: 'QuickSand', height: 1.5),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text:' ${formatter.format(pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value)} points',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const TextSpan(
                                    text: ' to become an Elder.',
                                  ),
                                ])),
                            menuLabel: 'father',
                            totalPointsGained: pilgrimProgressController
                                .totalPointsGainedInFather.value,
                            totalPointsAvailable: pilgrimProgressController
                                .totalPointsAvailableInFather.value,
                            isLocked: pilgrimProgressController
                                .fatherLevelIsLocked.isTrue,
                            menuProgressValue: pilgrimProgressController
                                .fatherProgressLevelValue.value,
                            boxShadowColor: 0xFFF9ACBB,
                            onTap: () => {
                              userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                              if (pilgrimProgressController
                                  .fatherLevelIsLocked.isFalse)
                                {
                                  pilgrimProgressController
                                      .setSelectedLevel('father')
                                }
                            },
                          ),
                          PilgrimProgressLevelMenu(
                            menuImage: 'assets/images/pilgrim_levels/elder.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text: 'Welcome to the peak! Test how \nskillful',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D),fontFamily: 'QuickSand', height: 1.5),
                                    children: const <TextSpan>[
                                  TextSpan(
                                    text: '  & knowledgeable \nyou’ve become',
                                  ),
                                ])),
                            menuLabel: 'elder',
                            totalPointsGained: pilgrimProgressController
                                .totalPointsGainedInElder.value,
                            totalPointsAvailable: pilgrimProgressController
                                .totalPointsAvailableInFather.value,
                            isLocked: pilgrimProgressController
                                .elderLevelIsLocked.isTrue,
                            menuProgressValue: pilgrimProgressController
                                .elderProgressLevelValue.value,
                            boxShadowColor: 0xFFA2EAE0,
                            onTap: () => {
                              userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                              if (pilgrimProgressController
                                  .elderLevelIsLocked.isFalse)
                                {
                                  pilgrimProgressController
                                      .setSelectedLevel('elder')
                                }
                            },
                          ),
                        ],
                      ),

                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Padding buildPilgrimProgressInfoCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.0.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 23.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Pilgrim Progress',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(124, 110, 203, 1),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AutoSizeText(
                    'Make a journey through the bible',
                    style:
                        TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                  ),
                  AutoSizeText(
                    'learning deeper when you progress',
                    style:
                        TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                ],
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.r), bottom: Radius.circular(18.r)),
                child: SvgPicture.asset(
                  'assets/images/pilgrim_progress.svg',
                  width: 150.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    displayPilgrimProgressWelcomeModal();
    getUpdatedGameData();
  }
}
