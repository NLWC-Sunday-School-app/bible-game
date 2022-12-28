
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../controllers/quick_game_question_controller.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    Key? key,
    required this.bibleVerse,
    required this.selectOption,
  }) : super(key: key);

  final String bibleVerse;
  final VoidCallback selectOption;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuickGamesQuestionController>(
        init: QuickGamesQuestionController(),
        builder: (controller) {
          Color getTheRightColor() {
            if (controller.isAnswered) {
              if (bibleVerse == controller.correctAnswer) {
                return const Color.fromRGBO(220, 245, 164, 1);
              } else if (bibleVerse == controller.selectedAnswer &&
                  controller.selectedAnswer != controller.correctAnswer) {
                return const Color.fromRGBO(255, 163, 163, 1);
              }
            }
            return const Color.fromRGBO(238, 238, 238, 1);
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == const Color.fromRGBO(255, 163, 163, 1)
                ? Icons.cancel_outlined
                : Icons.check_circle;
          }

          return InkWell(
            onTap: selectOption,
            child: Container(
              padding: EdgeInsets.only(
                  left: 25.w, right: 25.w, top: 20.h, bottom: 20.h),
              margin: EdgeInsets.only(bottom: 15.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: getTheRightColor(),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bibleVerse,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(39, 39, 39, 1)),
                  ),
                  getTheRightColor() == const Color.fromRGBO(238, 238, 238, 1)
                      ? Container()
                      : Icon(
                          getTheRightIcon(),
                          color: getTheRightIcon() == Icons.cancel_outlined
                              ? const Color.fromRGBO(131, 8, 8, 1)
                              : const Color.fromRGBO(116, 178, 16, 1),
                        ),
                ],
              ),
            ),
          );
        });
  }
}
