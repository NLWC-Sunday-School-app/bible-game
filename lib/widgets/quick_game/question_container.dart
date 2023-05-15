import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/question.dart';
import 'package:bible_game/widgets/quick_game/question_points.dart';
import 'package:bible_game/widgets/quick_game/question_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../controllers/quick_game_question_controller.dart';
import '../game_button.dart';
import '../modals/game_summary.dart';
import '../modals/quit_modal.dart';
import 'option_button.dart';

class QuestionContainer extends StatefulWidget {
  final Question question;

  const QuestionContainer({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  final QuickGamesQuestionController _questionController = Get.put(QuickGamesQuestionController());
  UserController userController = Get.put(UserController());
  final player = AudioPlayer();
  bool isClicked = false;

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height:  Get.width >= 500 ? 350.h : Get.height >= 800 ? 350.h : 350.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient:  const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:  [
                Color.fromRGBO(84, 140, 215, 1),
                Color.fromRGBO(50, 177,242, 1),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/question_screen_cloud.png',
                width: 350.w,
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(top: 45.h),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w),
                      child: GestureDetector(
                        onTap: () => {
                          userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                        Get.dialog(const QuitModal(), barrierDismissible: false,)
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 24.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Question ${_questionController.questionNumber.value} of ${_questionController.questions.length}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            fontSize: 16.sp,
                            color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        userController.soundIsOff.isFalse ? userController.playGameSound() : null;
                      _questionController.goToNextQuestion();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.r)
                        ),
                        child: Text('Skip', style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF459DE3)
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height < 680 ? 30 : 40 ,),
            Padding(
              padding: EdgeInsets.only(left: 22.w, right: 45.w),
              child: Text(
                widget.question.instruction,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: Get.height > 900 ? 16.sp : 14.sp
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 22.w, right: 45.w),
              child: Text(
                '"${widget.question.question}"',
                style: TextStyle(
                  fontSize: Get.height > 900 ? 16.sp : 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 305.h),
          child: Column(
            children: [
              // Text(Get.height.toString()),
              Container(
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
                        widget.question.options.length,
                            (index) => OptionButton(
                          bibleVerse: widget.question.options[index],
                          selectOption: () =>
                          {
                            if(isClicked == false){
                              userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                              _questionController.checkAnswer(widget.question, widget.question.options[index])
                            },
                             setState(() {
                               isClicked = true;
                             }),
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
         ConfettiWidget(
              confettiController: _questionController.confettiController,
              shouldLoop: false,
              blastDirectionality: BlastDirectionality.explosive,
         ),
      ],
    );
  }
}
