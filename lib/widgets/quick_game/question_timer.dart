import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../controllers/quick_game_question_controller.dart';

class QuestionTimer extends StatelessWidget {
  const QuestionTimer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      width: 150.w,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1,
            color: const Color.fromRGBO(229, 150, 75, 1)),
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(229, 150, 75, 1),
            offset: Offset(0, 1),
            blurRadius: 1,
          )
        ],
      ),
      child: GetBuilder<QuickGamesQuestionController>(
        init: QuickGamesQuestionController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              AutoSizeText(
                'Time',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(118, 99, 229, 1)),
              ),
              (controller.animation.value * controller.durationPerQuestion).round()  < 5 ?
              FadeTransition(
                opacity: controller.blinkingAnimationController,
                child: AutoSizeText(
                  "00:${(controller.animation.value * controller.durationPerQuestion).round() < 10 ? '0' : ''}${(controller.animation.value * controller.durationPerQuestion).round()}",
                  style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(131, 8, 8, 1)),
                ),
              ):
              AutoSizeText(
                "00:${(controller.animation.value * controller.durationPerQuestion).round() < 10 ? '0' : ''}${(controller.animation.value * controller.durationPerQuestion).round()}",
                style: TextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(118, 99, 229, 1)),
              ),
            ],
          );
        }
      ),
    );
  }
}

