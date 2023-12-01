
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../controllers/wiw_game_question_controller.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    Key? key,
    required this.selectOption, required this.characterName,
  }) : super(key: key);

  final String characterName;
  final VoidCallback selectOption;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WiwGameQuestionController>(
        init: WiwGameQuestionController(),
        builder: (controller) {
          Color getTheRightColor() {
            if (controller.isAnswered) {
              if (characterName == controller.correctAnswer) {
                return const Color.fromRGBO(220, 245, 164, 1);
              } else if (characterName == controller.selectedAnswer &&
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
              width: double.infinity,
              decoration: BoxDecoration(
                  color: getTheRightColor(),
                  borderRadius: BorderRadius.all(Radius.circular(8.r))),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              margin: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    characterName,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Mikado',
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
