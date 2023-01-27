import 'package:bible_game/controllers/nativity_game_controller.dart';
import 'package:bible_game/screens/nativity/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class NativityLoader extends StatelessWidget {
  const NativityLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    NativityGameController nativityGameController =
        Get.put(NativityGameController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : 360.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nativity_loader_layout.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => nativityGameController.gameIsReady.isFalse
                  ? Image.asset('assets/images/icons/loader.gif')
                  : const SizedBox()),
              SizedBox(
                height: 20.h,
              ),
              Obx(
                () => Text(
                  nativityGameController.gameIsReady.isFalse
                      ? 'loading questions'
                      : 'Questions loaded',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: 'Neuland',
                      color: const Color(0xFF1861DE)),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(
               () => Text(
                  nativityGameController.gameIsReady.isFalse
                      ? 'Please be patient while we load the \nquestions'
                      : 'Are you ready? Tap ready to begin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Obx(
              () => nativityGameController.gameIsReady.isTrue
                    ? GestureDetector(
                        onTap: () => {
                          player.setAsset('assets/audios/click.mp3'),
                          player.play(),
                          Get.off(() => const NativityQuestionScreen())
                        },
                        child: Container(
                          width: 200.w,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF598DE7),
                                  Color(0xFF1861DE),
                                ],
                              ),
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ready!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Neuland',
                                    letterSpacing: 1,
                                    color: Colors.white,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              SvgPicture.asset(
                                'assets/images/icons/booster.svg',
                                width: 20.w,
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
