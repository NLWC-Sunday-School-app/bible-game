import 'package:bible_game/controllers/wiw_game_question_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
class ScoreCard extends StatelessWidget {
  const ScoreCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
    return  SizedBox(
      height: 180.h,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color(0xFF78C3FF), width: 2.w),
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF051C34),
                          offset: Offset(0, 10),
                          blurRadius: 0,
                          spreadRadius: -5,
                        ),
                      ]),
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 25.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/icons/coins.png',
                        width: 24.w,
                      ),
                      Obx(
                        () => Text(
                          wiwGameQuestionController.pointsGained.value.toString(),
                          style: TextStyle(
                            fontFamily: 'Mikado',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF3574E2),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6.r)),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/aesthetics/wiw_score_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                        child: Row(
                          children: [
                            Image.asset('assets/images/icons/timer.png', width: 20.w,),
                            SizedBox(width: 10.w,),
                           TimerCountdown(
                          format: CountDownTimerFormat.minutesSeconds,
                          endTime: DateTime.now().add(
                            Duration(
                              minutes: wiwGameQuestionController.gameDuration,
                            ),
                          ),
                          timeTextStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Mikado',
                            color: Colors.white
                          ),
                          colonsTextStyle: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Mikado',
                              color: Colors.white
                          ),
                          enableDescriptions: false,
                          spacerWidth: 0,
                          onEnd: () {
                            print("Timer finished");
                          }),
                          ],
                        ),
                      ),
                      Image.asset('assets/images/icons/mark.png', width: 24.w,),
                      Obx(
                        () => Text(wiwGameQuestionController.numOfCorrectAnswers.value.toString(), style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF3574E2),
                            fontFamily: 'Mikado'
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
