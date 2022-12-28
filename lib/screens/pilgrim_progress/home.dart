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


class PilgrimProgressHomeScreen extends StatelessWidget {
  const PilgrimProgressHomeScreen({Key? key}) : super(key: key);
  static String routeName = "/pilgrim-progress-home-screen";

  @override
  Widget build(BuildContext context) {
    final PilgrimProgressController _pilgrimProgressController = Get.put(PilgrimProgressController());
    final assetsAudioPlayer = AssetsAudioPlayer();
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
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.15,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            assetsAudioPlayer.open( Audio("assets/audios/click.mp3"),),
                           Get.back()
                          },
                          onDoubleTap: () =>{
                            assetsAudioPlayer.open( Audio("assets/audios/click.mp3"),),
                            Get.back()
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 22.0, top: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 24.w,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                const AutoSizeText(
                                  'Back home',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/images/pilgrim_progress_cloud.png',
                          width: 200.w,
                        ),
                      ],
                    ),
                  ),
                  buildPilgrimProgressInfoCard(),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Stack(
                    children: [
                      Positioned(
                        top: 280,
                        child: Image.asset(
                          'assets/images/pilgrim_left_cloud.png',
                          width: 180.w,
                        ),
                      ),
                      Positioned(
                        top: 150,
                        right: 0,
                        child: Image.asset(
                          'assets/images/pilgrim_right_cloud.png',
                          width: 180.w,
                        ),
                      ),
                      SizedBox(
                        child: Obx(
                          () => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      if (_pilgrimProgressController.babeLevelIsLocked.isFalse){
                                         _pilgrimProgressController.setSelectedLevel('babe')
                                        }
                                    },
                                    child: PilgrimProgressLevelMenu(
                                      menuImage:
                                          'assets/images/pilgrim_levels/babe.png',
                                      menuNumber: '01',
                                      menuLabel: 'Babe',
                                      isLocked: _pilgrimProgressController
                                          .babeLevelIsLocked.value,
                                      menuProgressValue:
                                          _pilgrimProgressController
                                              .babeProgressLevelValue.value,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      if (_pilgrimProgressController.childLevelIsLocked.isFalse){
                                        _pilgrimProgressController.setSelectedLevel('child')
                                        }
                                    },
                                    child: PilgrimProgressLevelMenu(
                                      menuImage: _pilgrimProgressController
                                              .childLevelIsLocked.isTrue
                                          ? 'assets/images/pilgrim_levels/child_locked.png'
                                          : 'assets/images/pilgrim_levels/child.png',
                                      menuNumber: '02',
                                      menuLabel: 'Child',
                                      isLocked: _pilgrimProgressController
                                          .childLevelIsLocked.isTrue,
                                      menuProgressValue:
                                          _pilgrimProgressController
                                              .childProgressLevelValue.value,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: ()=>{
                                      if(_pilgrimProgressController.youngBelieversLevelIsLocked.isFalse) {
                                        _pilgrimProgressController.setSelectedLevel('young believer')
                                      }
                                    },
                                    child: PilgrimProgressLevelMenu(
                                      menuImage: _pilgrimProgressController
                                              .youngBelieversLevelIsLocked.isTrue
                                          ? 'assets/images/pilgrim_levels/young_believer_locked.png'
                                          : 'assets/images/pilgrim_levels/young_believer.png',
                                      menuNumber: '03',
                                      menuLabel: 'Young Believer',
                                      isLocked: _pilgrimProgressController
                                          .youngBelieversLevelIsLocked.isTrue,
                                      menuProgressValue: _pilgrimProgressController
                                          .youngBelieverProgressLevelValue.value,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()=>{
                                      if(_pilgrimProgressController.charityLevelIsLocked.isFalse) {
                                        _pilgrimProgressController.setSelectedLevel('charity')
                                      }
                                    },
                                    child: PilgrimProgressLevelMenu(
                                      menuImage: _pilgrimProgressController
                                              .charityLevelIsLocked.isTrue
                                          ? 'assets/images/pilgrim_levels/charity_locked.png'
                                          : 'assets/images/pilgrim_levels/charity.png',
                                      menuNumber: '04',
                                      menuLabel: 'Charity',
                                      isLocked: _pilgrimProgressController
                                          .charityLevelIsLocked.isTrue ,
                                      menuProgressValue: _pilgrimProgressController
                                          .charityProgressLevelValue.value,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: ()=>{
                                      if(_pilgrimProgressController.fatherLevelIsLocked.isFalse) {
                                        _pilgrimProgressController.setSelectedLevel('father')
                                      }
                                    },
                                    child: PilgrimProgressLevelMenu(
                                      menuImage: _pilgrimProgressController
                                              .fatherLevelIsLocked.isTrue
                                          ? 'assets/images/pilgrim_levels/father_locked.png'
                                          : 'assets/images/pilgrim_levels/father.png',
                                      menuNumber: '05',
                                      menuLabel: 'Father',
                                      isLocked: _pilgrimProgressController
                                          .fatherLevelIsLocked.isTrue,
                                      menuProgressValue: _pilgrimProgressController
                                          .fatherProgressLevelValue.value,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()=>{
                                      if(_pilgrimProgressController.elderLevelIsLocked.isFalse) {
                                        _pilgrimProgressController.setSelectedLevel('elder')
                                      }
                                    },
                                    child: PilgrimProgressLevelMenu(
                                      menuImage: _pilgrimProgressController
                                              .elderLevelIsLocked.isTrue
                                          ? 'assets/images/pilgrim_levels/elder_locked.png'
                                          : 'assets/images/pilgrim_levels/elder.png',
                                      menuNumber: '06',
                                      menuLabel: 'Elder',
                                      isLocked: _pilgrimProgressController
                                          .elderLevelIsLocked.isTrue,
                                      menuProgressValue: _pilgrimProgressController
                                          .elderProgressLevelValue.value,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ),
                    ],
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
                  const AutoSizeText(
                    'Pilgrim Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(124, 110, 203, 1),
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
}
