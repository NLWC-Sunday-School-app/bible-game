import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../controllers/wiw_game_question_controller.dart';

class WiwQuitModal extends StatelessWidget {
  const WiwQuitModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 400.h
            : Get.height >= 800
                ? 350.h
                : 450.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/images/aesthetics/wiw_quit_modal_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 30.0.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/images/icons/blue_close.png',
                      width: 48.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: StrokeText(
                  text: '    If you quit the game \nyou will lose your coins',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mikado',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: const Color(0xFFA71313),
                  strokeWidth: 5,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'You’ve won some coins, if you quit \nnow, you will lose the gold',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40.h,
              ),
              InkWell(
                onTap: (){
                  Get.back();
                  Get.back();
                  wiwGameQuestionController.stopTimer();
                },
                child: Container(
                  width: 250.w,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                      color: const Color(0xFF548BD5),
                      image: const DecorationImage(
                        image: AssetImage(
                            "assets/images/aesthetics/quit_btn_bg.png"),
                        fit: BoxFit.cover,
                      ),
                      border:
                          Border.all(color: const Color(0xFFA71313), width: 2.w),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  child: Text(
                    'Sure, quit the game',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        letterSpacing: 1,
                        color: const Color(0xFFED0505),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
