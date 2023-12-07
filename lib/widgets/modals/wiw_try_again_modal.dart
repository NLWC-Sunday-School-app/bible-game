import 'package:bible_game/controllers/wiw_game_question_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WiwTryAgainModal extends StatelessWidget {
  const WiwTryAgainModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
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
              image: AssetImage('assets/images/aesthetics/try_again_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              InkWell(
                onTap: (){
                  Get.back();
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 40.w),
                  child: Align(
                    child: Image.asset(
                      'assets/images/icons/close_red_white.png',
                      width: 50.w,
                    ),
                    alignment: Alignment.topRight,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.w, color: const Color(0xFFCC2C39)),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 180.w,
                    child: Column(
                      children: [
                        Text(
                          'You earned',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFFCC2C39),
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
                              '0',
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFCC2C39)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.w, color: const Color(0xFFCC2C39)),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r))),
                    width: 120.w,
                    child: Text(
                      'Bonus point: +0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFCC2C39),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.w,
                  ),
                  SizedBox(
                    width: 100.w,
                    child: Row(
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
                            Text(
                              '${wiwGameQuestionController.numOfCorrectAnswers}/20',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'Mikado',
                                  color: const Color(0xFF0155AF),
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'answers',
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
                  SizedBox(
                    height: 35.h,
                  ),
                   InkWell(
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                    child: Container(
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
                        'Play Again',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
