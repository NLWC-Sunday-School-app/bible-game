import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/pilgrim_progress_question_screen.dart';
import 'package:bible_game/screens/pilgrim_progress/widgets/PligrimProgressLevelMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  displayPilgrimProgressWelcomeModal() {
    var firstTime = GetStorage().read('pilgrim_progress_first_time') ?? true;

    if (firstTime) {
      Timer(const Duration(seconds: 3), () {
        Get.dialog(const PilgrimProgressWelcomeModal());
      });
      GetStorage().write('pilgrim_progress_first_time', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PilgrimProgressController _pilgrimProgressController =
        Get.put(PilgrimProgressController());
    final player = AudioPlayer();
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
                                player.setAsset('assets/audios/click.mp3'),
                                player.play(),
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
                    child: Obx(
                      () => Column(
                        children: [
                          PilgrimProgressLevelMenu(
                            menuImage: 'assets/images/pilgrim_levels/babe.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text:
                                        'Begin your bible adventure! Get up \nto',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), fontFamily: 'QuickSand', height: 1.5),
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: ' 15,000points',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' to finish this level.',
                                  ),
                                ])),
                            menuLabel: 'Babe',
                            totalPointsGained: _pilgrimProgressController
                                .totalPointsGainedInBabe.value,
                            totalPointsAvailable: _pilgrimProgressController
                                .totalPointsAvailableInBabe.value,
                            isLocked: _pilgrimProgressController
                                .babeLevelIsLocked.isTrue,
                            menuProgressValue: _pilgrimProgressController
                                .babeProgressLevelValue.value,
                            boxShadowColor: 0xFFE4E0DD,
                            onTap: () => {
                              if (_pilgrimProgressController
                                  .babeLevelIsLocked.isFalse)
                                {
                                  _pilgrimProgressController
                                      .setSelectedLevel('babe')
                                }
                            },
                          ),
                          PilgrimProgressLevelMenu(
                            menuImage: 'assets/images/pilgrim_levels/child.png',
                            menuNumber: '',
                            textSpan: RichText(
                                text: TextSpan(
                                    text:
                                        'Go further in your journey! Get up \nto',
                                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D),fontFamily: 'QuickSand', height: 1.5),
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: ' 15,000points',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' to grow from here.',
                                  ),
                                ])),
                            menuLabel: 'Child',
                            totalPointsGained: _pilgrimProgressController
                                .totalPointsGainedInChild.value,
                            totalPointsAvailable: _pilgrimProgressController
                                .totalPointsAvailableInChild.value,
                            isLocked: _pilgrimProgressController
                                .childLevelIsLocked.isTrue,
                            menuProgressValue: _pilgrimProgressController
                                .childProgressLevelValue.value,
                            boxShadowColor: 0xFFFCCB90,
                            onTap: () => {
                              if (_pilgrimProgressController
                                  .childLevelIsLocked.isFalse)
                                {
                                  _pilgrimProgressController
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
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: '15,000points',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' to get to charity.',
                                  ),
                                ])),
                            menuLabel: 'young believer',
                            totalPointsGained: _pilgrimProgressController
                                .totalPointsGainedInYb.value,
                            totalPointsAvailable: _pilgrimProgressController
                                .totalPointsAvailableInYb.value,
                            isLocked: _pilgrimProgressController
                                .youngBelieversLevelIsLocked.isTrue,
                            menuProgressValue: _pilgrimProgressController
                                .youngBelieverProgressLevelValue.value,
                            boxShadowColor: 0xFFC7DAE1,
                            onTap: () => {
                              if (_pilgrimProgressController
                                  .youngBelieversLevelIsLocked.isFalse)
                                {
                                  _pilgrimProgressController
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
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: ' 15,000points',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' to get to Father.',
                                  ),
                                ])),
                            menuLabel: 'charity',
                            totalPointsGained: _pilgrimProgressController
                                .totalPointsGainedInCharity.value,
                            totalPointsAvailable: _pilgrimProgressController
                                .totalPointsAvailableInCharity.value,
                            isLocked: _pilgrimProgressController
                                .charityLevelIsLocked.isTrue,
                            menuProgressValue: _pilgrimProgressController
                                .charityProgressLevelValue.value,
                            boxShadowColor: 0xFF92D6EE,
                            onTap: () => {
                              if (_pilgrimProgressController
                                  .charityLevelIsLocked.isFalse)
                                {
                                  _pilgrimProgressController
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
                                    children: const <TextSpan>[
                                  TextSpan(
                                      text: '15,000points',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' to become an Elder.',
                                  ),
                                ])),
                            menuLabel: 'father',
                            totalPointsGained: _pilgrimProgressController
                                .totalPointsGainedInFather.value,
                            totalPointsAvailable: _pilgrimProgressController
                                .totalPointsAvailableInFather.value,
                            isLocked: _pilgrimProgressController
                                .fatherLevelIsLocked.isTrue,
                            menuProgressValue: _pilgrimProgressController
                                .fatherProgressLevelValue.value,
                            boxShadowColor: 0xFFF9ACBB,
                            onTap: () => {
                              if (_pilgrimProgressController
                                  .fatherLevelIsLocked.isFalse)
                                {
                                  _pilgrimProgressController
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
                            totalPointsGained: _pilgrimProgressController
                                .totalPointsGainedInElder.value,
                            totalPointsAvailable: _pilgrimProgressController
                                .totalPointsAvailableInFather.value,
                            isLocked: _pilgrimProgressController
                                .elderLevelIsLocked.isTrue,
                            menuProgressValue: _pilgrimProgressController
                                .elderProgressLevelValue.value,
                            boxShadowColor: 0xFFA2EAE0,
                            onTap: () => {
                              if (_pilgrimProgressController
                                  .elderLevelIsLocked.isFalse)
                                {
                                  _pilgrimProgressController
                                      .setSelectedLevel('elder')
                                }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Stack(
                  //   children: [
                  //     Positioned(
                  //       top: 280.h,
                  //       child: Image.asset(
                  //         'assets/images/pilgrim_left_cloud.png',
                  //         width: 180.w,
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 150.h,
                  //       right: 0,
                  //       child: Image.asset(
                  //         'assets/images/pilgrim_right_cloud.png',
                  //         width: 180.w,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       child: Obx(
                  //         () => Column(
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //               children: [
                  //                 GestureDetector(
                  //                   onTap: () => {
                  //                     if (_pilgrimProgressController.babeLevelIsLocked.isFalse){
                  //                        _pilgrimProgressController.setSelectedLevel('babe')
                  //                       }
                  //                   },
                  //                   child: PilgrimProgressLevelMenu(
                  //                     menuImage:
                  //                         'assets/images/pilgrim_levels/babe.png',
                  //                     menuNumber: '01',
                  //                     menuLabel: 'Babe',
                  //                     isLocked: _pilgrimProgressController
                  //                         .babeLevelIsLocked.value,
                  //                     menuProgressValue:
                  //                         _pilgrimProgressController
                  //                             .babeProgressLevelValue.value,
                  //                   ),
                  //                 ),
                  //                 GestureDetector(
                  //                   onTap: () => {
                  //                     if (_pilgrimProgressController.childLevelIsLocked.isFalse){
                  //                       _pilgrimProgressController.setSelectedLevel('child')
                  //                       }
                  //                   },
                  //                   child: PilgrimProgressLevelMenu(
                  //                     menuImage: _pilgrimProgressController
                  //                             .childLevelIsLocked.isTrue
                  //                         ? 'assets/images/pilgrim_levels/child_locked.png'
                  //                         : 'assets/images/pilgrim_levels/child.png',
                  //                     menuNumber: '02',
                  //                     menuLabel: 'Child',
                  //                     isLocked: _pilgrimProgressController
                  //                         .childLevelIsLocked.isTrue,
                  //                     menuProgressValue:
                  //                         _pilgrimProgressController
                  //                             .childProgressLevelValue.value,
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: constraints.maxHeight * 0.03,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //               children: [
                  //                 GestureDetector(
                  //                   onTap: ()=>{
                  //                     if(_pilgrimProgressController.youngBelieversLevelIsLocked.isFalse) {
                  //                       _pilgrimProgressController.setSelectedLevel('young believer')
                  //                     }
                  //                   },
                  //                   child: PilgrimProgressLevelMenu(
                  //                     menuImage: _pilgrimProgressController
                  //                             .youngBelieversLevelIsLocked.isTrue
                  //                         ? 'assets/images/pilgrim_levels/young_believer_locked.png'
                  //                         : 'assets/images/pilgrim_levels/young_believer.png',
                  //                     menuNumber: '03',
                  //                     menuLabel: 'Young Believer',
                  //                     isLocked: _pilgrimProgressController
                  //                         .youngBelieversLevelIsLocked.isTrue,
                  //                     menuProgressValue: _pilgrimProgressController
                  //                         .youngBelieverProgressLevelValue.value,
                  //                   ),
                  //                 ),
                  //                 GestureDetector(
                  //                   onTap: ()=>{
                  //                     if(_pilgrimProgressController.charityLevelIsLocked.isFalse) {
                  //                       _pilgrimProgressController.setSelectedLevel('charity')
                  //                     }
                  //                   },
                  //                   child: PilgrimProgressLevelMenu(
                  //                     menuImage: _pilgrimProgressController
                  //                             .charityLevelIsLocked.isTrue
                  //                         ? 'assets/images/pilgrim_levels/charity_locked.png'
                  //                         : 'assets/images/pilgrim_levels/charity.png',
                  //                     menuNumber: '04',
                  //                     menuLabel: 'Charity',
                  //                     isLocked: _pilgrimProgressController
                  //                         .charityLevelIsLocked.isTrue ,
                  //                     menuProgressValue: _pilgrimProgressController
                  //                         .charityProgressLevelValue.value,
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: constraints.maxHeight * 0.03,
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //               children: [
                  //                 GestureDetector(
                  //                   onTap: ()=>{
                  //                     if(_pilgrimProgressController.fatherLevelIsLocked.isFalse) {
                  //                       _pilgrimProgressController.setSelectedLevel('father')
                  //                     }
                  //                   },
                  //                   child: PilgrimProgressLevelMenu(
                  //                     menuImage: _pilgrimProgressController
                  //                             .fatherLevelIsLocked.isTrue
                  //                         ? 'assets/images/pilgrim_levels/father_locked.png'
                  //                         : 'assets/images/pilgrim_levels/father.png',
                  //                     menuNumber: '05',
                  //                     menuLabel: 'Father',
                  //                     isLocked: _pilgrimProgressController
                  //                         .fatherLevelIsLocked.isTrue,
                  //                     menuProgressValue: _pilgrimProgressController
                  //                         .fatherProgressLevelValue.value,
                  //                   ),
                  //                 ),
                  //                 GestureDetector(
                  //                   onTap: ()=>{
                  //                     if(_pilgrimProgressController.elderLevelIsLocked.isFalse) {
                  //                       _pilgrimProgressController.setSelectedLevel('elder')
                  //                     }
                  //                   },
                  //                   child: PilgrimProgressLevelMenu(
                  //                     menuImage: _pilgrimProgressController
                  //                             .elderLevelIsLocked.isTrue
                  //                         ? 'assets/images/pilgrim_levels/elder_locked.png'
                  //                         : 'assets/images/pilgrim_levels/elder.png',
                  //                     menuNumber: '06',
                  //                     menuLabel: 'Elder',
                  //                     isLocked: _pilgrimProgressController
                  //                         .elderLevelIsLocked.isTrue,
                  //                     menuProgressValue: _pilgrimProgressController
                  //                         .elderProgressLevelValue.value,
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //             const SizedBox(height: 20,)
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
  }
}
