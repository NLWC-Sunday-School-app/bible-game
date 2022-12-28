import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/pilgrim_progress_question_controller.dart';
import '../../controllers/quick_game_question_controller.dart';
import 'package:get/get.dart';

class QuestionPoints extends StatelessWidget {
  const QuestionPoints({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PilgrimProgressQuestionController _questionController = Get.put(PilgrimProgressQuestionController());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 45.w, vertical: 15.h),
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
      child: Column(
        children: [
          Text(
            'Points',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(229, 150, 75, 1)),
          ),
          Obx(
                () =>
            // only show
            AnimatedDigitWidget(
              value: _questionController.pointsGained.value,
              textStyle: TextStyle(
                fontSize: 25.sp,
                fontFamily: 'Neuland',
                color: const Color.fromRGBO(229, 150, 75, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

