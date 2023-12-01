import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/who_is_who/option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/wiw_game_question_controller.dart';
import '../../models/whoIsWho.dart';

class WiwQuestionContainer extends StatefulWidget {
  const WiwQuestionContainer({Key? key, required this.question})
      : super(key: key);
  final WhoIsWho question;

  @override
  State<WiwQuestionContainer> createState() => _WiwQuestionContainerState();
}

class _WiwQuestionContainerState extends State<WiwQuestionContainer> {
  final UserController userController = Get.put(UserController());
  final WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
  final player = AudioPlayer();
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF15499E), width: 1.w),
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF15499E),
                    offset: Offset(0, 10),
                    blurRadius: 0,
                    spreadRadius: -5,
                  ),
                  BoxShadow(
                    color: Color(0xFF15499E),
                    offset: Offset(0, -5),
                    blurRadius: 0,
                    spreadRadius: -3,
                  ),
                ]),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Text(
              widget.question.question,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.5.h,
                  fontFamily: 'Mikado',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp),
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          ...List.generate(
            widget.question.options.length,
            (index) => OptionButton(
              characterName: widget.question.options[index],
              selectOption: () =>{
                if(isClicked == false){
                  userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                  wiwGameQuestionController.checkAnswer(widget.question, widget.question.options[index])
                },
              },
            )
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/icons/new_close.png',
              width: 52.w,
            ),
          ),
          SizedBox(
            height: 40.h,
          )
        ],
      ),
    );
  }
}
