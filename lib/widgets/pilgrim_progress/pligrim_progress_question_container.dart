import 'package:bible_game/controllers/pilgrim_progress_question_controller.dart';
import 'package:bible_game/models/question.dart';
import 'package:bible_game/widgets/pilgrim_progress/question_points.dart';
import 'package:bible_game/widgets/pilgrim_progress/question_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../game_button.dart';
import '../pilgrim_progress/option_button.dart';

class PilgrimProgressQuestionContainer extends StatelessWidget {
  final Question question;

  const PilgrimProgressQuestionContainer({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PilgrimProgressQuestionController pilgrimProgressQuestionController = Get.put(PilgrimProgressQuestionController());
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      // padding: EdgeInsets.only(left: 22.w, right: 45.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 22.w, right: 45.w),
            child: Text(
              'What verse was this found?',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14.sp),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 22.w, right: 45.w),
            child: Text(
              question.question,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40.h),
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [QuestionTimer(), QuestionPoints()],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  ...List.generate(
                    question.options.length,
                        (index) => OptionButton(
                      bibleVerse: question.options[index],
                      selectOption: () =>
                          pilgrimProgressQuestionController.checkAnswer(question, question.options[index]),
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  GestureDetector(
                    onTap: () => {

                    },
                    child: const GameButton(buttonText: 'NEXT QUESTION', buttonActive: true,),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
