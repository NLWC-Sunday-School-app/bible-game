import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/pilgrim_progress_question_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/question.dart';
import 'package:bible_game/widgets/pilgrim_progress/question_points.dart';
import 'package:bible_game/widgets/pilgrim_progress/question_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../game_button.dart';
import '../modals/quit_modal.dart';
import '../pilgrim_progress/option_button.dart';
import '../pilgrim_progress/score_card.dart';

class PilgrimProgressQuestionContainer extends StatefulWidget {
  final Question question;

  const PilgrimProgressQuestionContainer({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<PilgrimProgressQuestionContainer> createState() =>
      _PilgrimProgressQuestionContainerState();
}

class _PilgrimProgressQuestionContainerState
    extends State<PilgrimProgressQuestionContainer> {
  PilgrimProgressQuestionController pilgrimProgressQuestionController =
      Get.put(PilgrimProgressQuestionController());
  UserController userController = Get.put(UserController());
  final player = AudioPlayer();
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Stack(
        children: [
          Column(
            children: [
              const ScoreCard(),
              SizedBox(
                height: 20.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF15499E), width: 3.w),
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  '"${widget.question.instruction}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5.h,
                      fontFamily: 'Mikado',
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF15499E), width: 3.w),
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Text(
                  '"${widget.question.question}"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.3.h,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              ...List.generate(
                widget.question.options.length,
                    (index) => OptionButton(
                    bibleVerse: widget.question.options[index],
                    selectOption: () => {
                      if (isClicked == false)
                        {
                          userController.soundIsOff.isFalse
                              ? userController.playGameSound()
                              : null,
                          pilgrimProgressQuestionController
                              .checkAnswer(widget.question,
                              widget.question.options[index]),
                        },
                      setState(() {
                        isClicked = true;
                      }),
                    }),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      if (userController.soundIsOff.isFalse) {
                        userController.playGameSound();
                      }
                      Get.dialog(const QuitModal(), barrierDismissible: false);
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/images/icons/light_close.png',
                        width: 64.w,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      if (userController.soundIsOff.isFalse) {
                        userController.playGameSound();
                      }

                     !pilgrimProgressQuestionController.isAnswered ? pilgrimProgressQuestionController.goToNextQuestion() : null;
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/images/icons/skip.png',
                        width: 64.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),

          ConfettiWidget(
            confettiController:
                pilgrimProgressQuestionController.confettiController,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ],
      ),
    );
  }
}
