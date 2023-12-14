import 'package:bible_game/controllers/wiw_game_controller.dart';
import 'package:bible_game/controllers/wiw_game_question_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class WiwSuccessModal extends StatelessWidget {
  const WiwSuccessModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
    WiwGameController wiwGameController = Get.put(WiwGameController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 400.h
            : Get.height >= 800
            ? 450.h
            : 500.h,
        width: Get.width >= 500 ? 400.h : 500.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aesthetics/success_modal_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              Image.asset(
                'assets/images/aesthetics/three_stars.png',
                width: 180.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.w, color: const Color(0xFF306DB6)),
                    borderRadius: BorderRadius.all(Radius.circular(8.r))),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                width: 180.w,
                child: Column(
                  children: [
                    Text(
                      'You earned',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF306DB6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icons/coins.png',
                          width: 30.w,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          wiwGameQuestionController.pointsGained.value.toString(),
                          style: TextStyle(
                              fontFamily: 'Mikado',
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF306DB6)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              SizedBox(
                width: 100.w,
                child:
                Row(
                  children: [
                    Image.asset(
                      'assets/images/icons/mark.png',
                      width: 24.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      children: [
                        Obx(
                          () => Text(
                            '${wiwGameQuestionController.numOfCorrectAnswers}/${wiwGameQuestionController.numOfCorrectAnswers > wiwGameController.passMark ? wiwGameQuestionController.numOfAnsweredQuestions.value : wiwGameController.passMark}',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'Mikado',
                                color: const Color(0xFF0155AF),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          'questions',
                          style: TextStyle(
                              fontFamily: 'Mikado',
                              fontSize: 13.sp,
                              color: const Color(0xFF0155AF)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: () {
                  Get.back();
                  Get.back();
                  wiwGameController.getGameLevels();
                },
                child:
                Container(
                  width: 240.w,
                  padding: EdgeInsets.symmetric(
                      vertical: 15.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xFF1E62D4), width: 3.w),
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/images/aesthetics/blue_btn_bg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
