import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../screens/pilgrim_progress/pilgrim_progress_question_screen.dart';
import '../game_button.dart';

class PilgrimProgressModal extends StatelessWidget {
  const PilgrimProgressModal({Key? key, required this.noOfRoundLeft, required this.totalAvailablePoints, required this.noOfRoundPerLevel})
      : super(key: key);
  final int noOfRoundLeft;
  final int totalAvailablePoints;
  final int noOfRoundPerLevel;


  @override
  Widget build(BuildContext context) {
    PilgrimProgressController pilgrimProgressController = Get.put(PilgrimProgressController());
    UserController userController = Get.put(UserController());
    var formatter = NumberFormat('#,##,###');
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 570.h,
        child: Center(
          child: Column(
            children: [
              Container(
                width: Get.width >= 500 ? 400.w : 300.w,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(152, 152, 152, 1)
                          .withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Obx(
                  () => AutoSizeText(
                    pilgrimProgressController.modalTitle.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      //color:  const Color(0xFF548CD7),
                      fontFamily: 'neuland',
                      letterSpacing: 1,
                      height: 1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const Text(''),
              Container(
                width: Get.width >= 500 ? 400.w : 300.w,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(152, 152, 152, 1)
                          .withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    noOfRoundLeft == noOfRoundPerLevel ? SizedBox(
                      height: 15.h,
                    ) : const SizedBox(),
                    noOfRoundLeft < noOfRoundPerLevel ? Container(
                      padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE7E2FF),
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.r))),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'You have',
                                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), height: 1.5),
                                children: <TextSpan>[
                                  TextSpan(text: ' $noOfRoundLeft/5 trials', style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF22210D))),
                                  TextSpan(text: '  left, \nGod speed Sojourner!', style:TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D))),
                                ]
                            ),
                          ),
                          const Spacer(),
                          Image.asset('assets/images/icons/hour_glass.png', width: 50.w,)

                        ],
                      ),
                    ) : const SizedBox(),
                    noOfRoundLeft < 5 ? SizedBox(
                      height: 12.h,
                    ): const SizedBox() ,
                    Container(
                      padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF8E193),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.r))),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Get ',
                              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), height: 1.5),
                              children: <TextSpan>[
                                TextSpan(text: '${formatter.format(pilgrimProgressController.passOnFirstTrialScore.value)} points', style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF22210D))),
                                TextSpan(text: ' in one game \nplay to unlock new level!', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D)),)
                              ]
                            ),
                          ),
                          const Spacer(),
                          Image.asset('assets/images/icons/blue_star.png', width: 60,)

                        ],
                      ),
                    ),
                    noOfRoundLeft < 5 ? SizedBox(
                      height: 12.h,
                    ): const SizedBox() ,

                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF9ACBB),
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.r))),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Or Get ',
                                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), height: 1.5),
                                children: <TextSpan>[
                                  TextSpan(text: '${formatter.format(totalAvailablePoints)} points', style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF22210D))),
                                  TextSpan(text: ' in $noOfRoundPerLevel \ntrials to unlock new level!', style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D)),)
                                ]
                            ),
                          ),
                          const Spacer(),
                          Image.asset('assets/images/icons/blue_star.png', width: 60.w,)

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE7E2FF),
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.r))),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Your points will be deleted \nif you don’t complete level\n',
                                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), height: 1.5),
                                children: <TextSpan>[
                                  TextSpan(text: ' after $noOfRoundPerLevel trials.', style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF22210D))),
                                ]
                            ),
                          ),
                          const Spacer(),
                         Image.asset('assets/images/icons/hour_glass.png', width: 50.w,)

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    noOfRoundLeft == 5 ? Container(
                      padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE7E2FF),
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.r))),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Bonus points are awarded \nbased on',
                                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF22210D), height: 1.5),
                                children: <TextSpan>[
                                  TextSpan(text: ' speed!', style:TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF22210D))),
                                ]
                            ),
                          ),
                          const Spacer(),
                          Image.asset('assets/images/icons/rocket.png', width: 50.w,)
                        ],
                      ),
                    ) : const SizedBox(),
                    SizedBox(
                      height: 30.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        userController.soundIsOff.isFalse ? userController.playGameSound() : null;
                        if (pilgrimProgressController.gameIsReady.isTrue) {
                          Get.back();
                          Get.to(() => const PilgrimProgressQuestionScreen(),
                              transition: Transition.rightToLeftWithFade);
                        }
                      },
                      child: Obx(() => GameButton(
                            buttonText: 'PLAY NOW',
                            buttonActive:
                                pilgrimProgressController.gameIsReady.value,
                          )),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
