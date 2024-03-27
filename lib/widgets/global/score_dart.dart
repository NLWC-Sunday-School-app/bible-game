
import 'package:bible_game/controllers/global_question_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_question_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ScoreCard extends StatelessWidget {
  const ScoreCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 150.h,
      child: GetBuilder<GlobalQuestionController>(
          init: GlobalQuestionController(),
          builder: (_questionController) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
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
                        padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Image.asset(
                                'assets/images/icons/coins.png',
                                width: 24.w,
                              ),
                            ),
                            Obx(
                                  () => Text(
                                _questionController.pointsGained.toString(),
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
                                  image: AssetImage(
                                      "assets/images/aesthetics/wiw_score_bg.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 10.h),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/icons/timer.png',
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                    child: (_questionController.animation.value *
                                        _questionController
                                            .durationPerQuestion)
                                        .round() <
                                        5
                                        ?  Text(
                                      "00:${(_questionController.animation.value * _questionController.durationPerQuestion).round() < 10 ? '0' : ''}${(_questionController.animation.value * _questionController.durationPerQuestion).round()}",
                                      style: TextStyle(
                                          fontSize: 24.sp,
                                          fontFamily: 'Mikado',
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFFFF5E6B)),
                                    )

                                        : Text(
                                      "00:${(_questionController.animation.value * _questionController.durationPerQuestion).round() < 10 ? '0' : ''}${(_questionController.animation.value * _questionController.durationPerQuestion).round()}",
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontFamily: 'Mikado',
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              'assets/images/icons/flag.png',
                              width: 24.w,
                            ),
                            Obx(
                                  () => Text(
                                '${_questionController.questionNumber.value.toString()}/${_questionController.questions.length}',
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF3574E2),
                                    fontFamily: 'Mikado'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
      ),
    );
  }
}


